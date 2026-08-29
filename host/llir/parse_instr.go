package llir

import (
	"strconv"
	"strings"
)

var binOps = map[string]bool{
	"add": true, "sub": true, "mul": true, "udiv": true, "sdiv": true,
	"urem": true, "srem": true, "shl": true, "lshr": true, "ashr": true,
	"and": true, "or": true, "xor": true,
}

var castOps = map[string]bool{
	"zext": true, "sext": true, "trunc": true, "bitcast": true,
	"ptrtoint": true, "inttoptr": true,
}

var binFlags = map[string]bool{"nuw": true, "nsw": true, "exact": true, "disjoint": true, "nneg": true}

func (p *parser) instrLine(lx *lexer) error {
	ins := &Instr{Line: lx.line}
	if strings.HasPrefix(lx.peek(), "%") {
		ins.Res = strings.TrimPrefix(unquote(lx.next()), "%")
		if err := lx.expect("="); err != nil {
			return err
		}
	}
	op := lx.next()
	for op == "tail" || op == "musttail" || op == "notail" {
		op = lx.next()
	}
	ins.Op = op

	val := func(ty *Type) (*Value, error) { return p.parseValue(lx, ty) }
	addArg := func(ty *Type) error {
		v, err := val(ty)
		if err != nil {
			return err
		}
		ins.Args = append(ins.Args, v)
		return nil
	}

	switch {
	case binOps[op]:
		// The two wrap flags are KEPT (Instr.NSW/NUW) — the value-range
		// analysis reads them. The rest are still dropped: nothing asks
		// what `exact`, `disjoint` or `nneg` promise.
		for binFlags[lx.peek()] {
			switch lx.next() {
			case "nsw":
				ins.NSW = true
			case "nuw":
				ins.NUW = true
			}
		}
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty
		if err := addArg(ty); err != nil {
			return err
		}
		if err := lx.expect(","); err != nil {
			return err
		}
		if err := addArg(ty); err != nil {
			return err
		}

	case op == "icmp":
		lx.accept("samesign")
		ins.Pred = lx.next()
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty // operand type; result is i1
		if err := addArg(ty); err != nil {
			return err
		}
		if err := lx.expect(","); err != nil {
			return err
		}
		if err := addArg(ty); err != nil {
			return err
		}

	case op == "select":
		for lx.peek() == "fast" || lx.peek() == "nnan" || lx.peek() == "ninf" {
			lx.next()
		}
		cty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		if err := addArg(cty); err != nil {
			return err
		}
		for i := 0; i < 2; i++ {
			if err := lx.expect(","); err != nil {
				return err
			}
			ty, err := p.parseType(lx)
			if err != nil {
				return err
			}
			ins.Typ = ty
			if err := addArg(ty); err != nil {
				return err
			}
		}

	case op == "load":
		lx.accept("volatile")
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty
		if err := lx.expect(","); err != nil {
			return err
		}
		if _, err := p.parseType(lx); err != nil { // ptr
			return err
		}
		if err := addArg(&Type{Kind: TPtr}); err != nil {
			return err
		}
		// trailing align / metadata ignored

	case op == "store":
		lx.accept("volatile")
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty
		if err := addArg(ty); err != nil { // value
			return err
		}
		if err := lx.expect(","); err != nil {
			return err
		}
		if _, err := p.parseType(lx); err != nil { // ptr
			return err
		}
		if err := addArg(&Type{Kind: TPtr}); err != nil { // address
			return err
		}

	case op == "alloca":
		lx.accept("inalloca")
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty
		ins.AllocN = 1
		for lx.accept(",") {
			if lx.peek() == "align" || lx.peek() == "addrspace" || strings.HasPrefix(lx.peek(), "!") {
				break
			}
			ity, err := p.parseType(lx)
			if err != nil {
				return err
			}
			nv, err := val(ity)
			if err != nil {
				return err
			}
			if nv.Kind != VConst {
				return lx.errf("dynamic alloca is not supported")
			}
			ins.AllocN = int(int32(nv.Int))
		}

	case op == "getelementptr":
		for lx.peek() == "inbounds" || lx.peek() == "nuw" || lx.peek() == "nusw" {
			lx.next()
		}
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty // source element type
		if err := lx.expect(","); err != nil {
			return err
		}
		if _, err := p.parseType(lx); err != nil { // ptr
			return err
		}
		if err := addArg(&Type{Kind: TPtr}); err != nil { // base
			return err
		}
		for lx.accept(",") {
			if strings.HasPrefix(lx.peek(), "!") {
				break
			}
			ity, err := p.parseType(lx)
			if err != nil {
				return err
			}
			if err := addArg(ity); err != nil {
				return err
			}
		}

	case castOps[op]:
		for binFlags[lx.peek()] {
			lx.next()
		}
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		if err := addArg(ty); err != nil {
			return err
		}
		if err := lx.expect("to"); err != nil {
			return err
		}
		to, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ, ins.To = to, to

	case op == "insertvalue" || op == "extractvalue":
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty // aggregate type
		if err := addArg(ty); err != nil {
			return err
		}
		if op == "insertvalue" {
			if err := lx.expect(","); err != nil {
				return err
			}
			ety, err := p.parseType(lx)
			if err != nil {
				return err
			}
			if err := addArg(ety); err != nil {
				return err
			}
		}
		for lx.accept(",") {
			if strings.HasPrefix(lx.peek(), "!") {
				break
			}
			iv, err := p.parseValue(lx, &Type{Kind: TInt, Bits: 32})
			if err != nil {
				return err
			}
			ins.Args = append(ins.Args, iv)
		}

	case op == "freeze":
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty
		if err := addArg(ty); err != nil {
			return err
		}

	case op == "phi":
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty
		for {
			if err := lx.expect("["); err != nil {
				return err
			}
			v, err := val(ty)
			if err != nil {
				return err
			}
			if err := lx.expect(","); err != nil {
				return err
			}
			pred := strings.TrimPrefix(unquote(lx.next()), "%")
			if err := lx.expect("]"); err != nil {
				return err
			}
			ins.Phi = append(ins.Phi, PhiEdge{Val: v, Pred: pred})
			if !lx.accept(",") || lx.peek() != "[" {
				break
			}
		}

	case op == "call":
		ins.FixedArgs = -1
		for lx.peek() == "fast" || ccTokens[lx.peek()] {
			lx.next()
		}
		skipParamAttrs(lx)
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty
		if lx.peek() == "(" { // full function type (printed for varargs)
			lx.next()
			nfixed := 0
			for !lx.accept(")") {
				if lx.accept("...") {
					ins.FixedArgs = nfixed
					continue
				}
				if _, err := p.parseType(lx); err != nil {
					return err
				}
				nfixed++
				lx.accept(",")
			}
		}
		callee := lx.next()
		if strings.HasPrefix(callee, "@") {
			ins.Callee = strings.TrimPrefix(unquote(callee), "@")
		} else if strings.HasPrefix(callee, "%") {
			ins.CalleeVal = &Value{Kind: VLocal, Name: strings.TrimPrefix(unquote(callee), "%"), Typ: &Type{Kind: TPtr}}
		} else {
			return lx.errf("bad call target %q", callee)
		}
		if err := lx.expect("("); err != nil {
			return err
		}
		if !lx.accept(")") {
			for {
				aty, err := p.parseType(lx)
				if err != nil {
					return err
				}
				skipParamAttrs(lx)
				if err := addArg(aty); err != nil {
					return err
				}
				if !lx.accept(",") {
					break
				}
			}
			if err := lx.expect(")"); err != nil {
				return err
			}
		}

	case op == "br":
		if lx.accept("label") {
			ins.Labels = []string{strings.TrimPrefix(unquote(lx.next()), "%")}
			break
		}
		cty, err := p.parseType(lx) // i1
		if err != nil {
			return err
		}
		if err := addArg(cty); err != nil {
			return err
		}
		for i := 0; i < 2; i++ {
			if err := lx.expect(","); err != nil {
				return err
			}
			if err := lx.expect("label"); err != nil {
				return err
			}
			ins.Labels = append(ins.Labels, strings.TrimPrefix(unquote(lx.next()), "%"))
		}

	case op == "switch":
		ty, err := p.parseType(lx)
		if err != nil {
			return err
		}
		ins.Typ = ty
		if err := addArg(ty); err != nil {
			return err
		}
		if err := lx.expect(","); err != nil {
			return err
		}
		if err := lx.expect("label"); err != nil {
			return err
		}
		ins.Labels = []string{strings.TrimPrefix(unquote(lx.next()), "%")}
		if err := lx.expect("["); err != nil {
			return err
		}
		for !lx.accept("]") {
			cty, err := p.parseType(lx)
			if err != nil {
				return err
			}
			cv, err := val(cty)
			if err != nil {
				return err
			}
			if cv.Kind != VConst {
				return lx.errf("switch case must be constant")
			}
			if err := lx.expect(","); err != nil {
				return err
			}
			if err := lx.expect("label"); err != nil {
				return err
			}
			ins.Cases = append(ins.Cases, SwitchCase{Val: cv.Int, Label: strings.TrimPrefix(unquote(lx.next()), "%")})
		}

	case op == "ret":
		if !lx.accept("void") {
			ty, err := p.parseType(lx)
			if err != nil {
				return err
			}
			ins.Typ = ty
			if err := addArg(ty); err != nil {
				return err
			}
		}

	case op == "unreachable":
		// no operands

	default:
		return lx.errf("unsupported instruction %q", op)
	}

	// Track unnamed-value numbering for implicit entry labels.
	if ins.Res != "" && isNumeric(ins.Res) {
		if n, _ := strconv.Atoi(ins.Res); n >= p.nvals {
			p.nvals = n + 1
		}
	}
	p.blk.Instrs = append(p.blk.Instrs, ins)
	return nil
}
