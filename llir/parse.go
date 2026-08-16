package llir

import (
	"fmt"
	"strconv"
	"strings"
)

// Parse parses a textual LLVM IR module (the clang -O1 subset).
func Parse(src string) (*Module, error) {
	p := &parser{m: &Module{Types: map[string]*Type{}}}
	lines := strings.Split(src, "\n")
	for i := 0; i < len(lines); i++ {
		text := stripComment(lines[i])
		if strings.TrimSpace(text) == "" {
			continue
		}
		// switch terminators span lines up to the closing ']'.
		if strings.HasPrefix(strings.TrimSpace(text), "switch") {
			for !strings.Contains(text, "]") && i+1 < len(lines) {
				i++
				text += " " + stripComment(lines[i])
			}
		}
		if err := p.line(text, i+1); err != nil {
			return nil, err
		}
	}
	if p.cur != nil {
		return nil, fmt.Errorf("unterminated function %q", p.cur.Name)
	}
	return p.m, nil
}

// stripComment removes a trailing ';' comment, respecting strings.
func stripComment(s string) string {
	inStr := false
	for i := 0; i < len(s); i++ {
		switch s[i] {
		case '"':
			inStr = !inStr
		case ';':
			if !inStr {
				return s[:i]
			}
		}
	}
	return s
}

// --- Lexer ---

type lexer struct {
	toks []string
	pos  int
	line int
}

func isIdentByte(c byte) bool {
	return c == '_' || c == '.' || c == '$' || c == '-' ||
		c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9'
}

func tokenize(s string, line int) *lexer {
	var toks []string
	i := 0
	for i < len(s) {
		c := s[i]
		switch {
		case c == ' ' || c == '\t' || c == '\r':
			i++
		case c == '"': // string
			j := i + 1
			for j < len(s) && s[j] != '"' {
				if s[j] == '\\' {
					j++
				}
				j++
			}
			toks = append(toks, s[i:min(j+1, len(s))])
			i = j + 1
		case c == 'c' && i+1 < len(s) && s[i+1] == '"': // c"..." bytes
			j := i + 2
			for j < len(s) && s[j] != '"' {
				if s[j] == '\\' {
					j++
				}
				j++
			}
			toks = append(toks, s[i:min(j+1, len(s))])
			i = j + 1
		case c == '%' || c == '@' || c == '!' || c == '#':
			j := i + 1
			if j < len(s) && s[j] == '"' {
				j++
				for j < len(s) && s[j] != '"' {
					j++
				}
				j++
			} else {
				for j < len(s) && isIdentByte(s[j]) {
					j++
				}
			}
			toks = append(toks, s[i:j])
			i = j
		case isIdentByte(c):
			j := i
			for j < len(s) && isIdentByte(s[j]) {
				j++
			}
			toks = append(toks, s[i:j])
			i = j
		default: // punctuation
			toks = append(toks, string(c))
			i++
		}
	}
	return &lexer{toks: toks, line: line}
}

func (lx *lexer) peek() string {
	if lx.pos < len(lx.toks) {
		return lx.toks[lx.pos]
	}
	return ""
}

func (lx *lexer) next() string {
	t := lx.peek()
	lx.pos++
	return t
}

func (lx *lexer) accept(s string) bool {
	if lx.peek() == s {
		lx.pos++
		return true
	}
	return false
}

func (lx *lexer) expect(s string) error {
	if !lx.accept(s) {
		return fmt.Errorf("line %d: expected %q, got %q", lx.line, s, lx.peek())
	}
	return nil
}

func (lx *lexer) errf(format string, args ...any) error {
	return fmt.Errorf("line %d: "+format, append([]any{lx.line}, args...)...)
}

// skipParens consumes a balanced (...) group if one starts here.
func (lx *lexer) skipParens() {
	if lx.peek() != "(" {
		return
	}
	depth := 0
	for lx.pos < len(lx.toks) {
		switch lx.next() {
		case "(":
			depth++
		case ")":
			depth--
			if depth == 0 {
				return
			}
		}
	}
}

// --- Parser ---

type parser struct {
	m     *Module
	cur   *Func
	blk   *Block
	nvals int // unnamed-value counter within cur (params consumed first)
}

var skipTopPrefixes = []string{"target ", "source_filename", "attributes ", "!", "declare "}

func (p *parser) line(text string, line int) error {
	trimmed := strings.TrimSpace(text)
	lx := tokenize(trimmed, line)

	if p.cur == nil {
		switch {
		case strings.HasPrefix(trimmed, "declare"):
			// record the callee name for diagnostics
			for _, t := range lx.toks {
				if strings.HasPrefix(t, "@") {
					p.m.Declares = append(p.m.Declares, t[1:])
					break
				}
			}
			return nil
		case strings.HasPrefix(trimmed, "define"):
			return p.defineLine(lx)
		case strings.HasPrefix(trimmed, "@"):
			return p.globalLine(lx)
		case strings.HasPrefix(trimmed, "%"): // %name = type {...}
			return p.typeLine(lx)
		default:
			for _, pre := range skipTopPrefixes {
				if strings.HasPrefix(trimmed, pre) {
					return nil
				}
			}
			if strings.HasPrefix(trimmed, "$") { // comdat
				return nil
			}
			return fmt.Errorf("line %d: unrecognized top-level construct: %s", line, trimmed)
		}
	}

	// Inside a function.
	if trimmed == "}" {
		p.m.Funcs = append(p.m.Funcs, p.cur)
		p.cur, p.blk = nil, nil
		return nil
	}
	// Block label: "name:" possibly numeric.
	if idx := strings.Index(trimmed, ":"); idx > 0 && !strings.ContainsAny(trimmed[:idx], " \t") {
		p.blk = &Block{Name: trimmed[:idx]}
		p.cur.Blocks = append(p.cur.Blocks, p.blk)
		return nil
	}
	if p.blk == nil { // implicit entry block: next unnamed slot
		p.blk = &Block{Name: strconv.Itoa(p.nvals)}
		p.nvals++
		p.cur.Blocks = append(p.cur.Blocks, p.blk)
	}
	return p.instrLine(lx)
}

// --- Types ---

func (p *parser) typeLine(lx *lexer) error {
	name := lx.next() // %struct.foo
	if err := lx.expect("="); err != nil {
		return err
	}
	if err := lx.expect("type"); err != nil {
		return err
	}
	if lx.accept("opaque") {
		p.m.Types[name] = &Type{Kind: TStruct, Name: name}
		return nil
	}
	t, err := p.parseType(lx)
	if err != nil {
		return err
	}
	t.Name = name
	p.m.Types[name] = t
	return nil
}

func (p *parser) parseType(lx *lexer) (*Type, error) {
	t := lx.next()
	switch {
	case t == "void":
		return &Type{Kind: TVoid}, nil
	case t == "ptr":
		if lx.accept("addrspace") {
			lx.skipParens()
		}
		return &Type{Kind: TPtr}, nil
	case t == "label":
		return &Type{Kind: TLabel}, nil
	case len(t) > 1 && t[0] == 'i':
		bits, err := strconv.Atoi(t[1:])
		if err != nil {
			return nil, lx.errf("bad type %q", t)
		}
		return &Type{Kind: TInt, Bits: bits}, nil
	case t == "[":
		n, err := strconv.Atoi(lx.next())
		if err != nil {
			return nil, lx.errf("bad array count")
		}
		if err := lx.expect("x"); err != nil {
			return nil, err
		}
		elem, err := p.parseType(lx)
		if err != nil {
			return nil, err
		}
		if err := lx.expect("]"); err != nil {
			return nil, err
		}
		return &Type{Kind: TArray, N: n, Elem: elem}, nil
	case t == "{" || t == "<":
		packed := t == "<"
		if packed {
			if err := lx.expect("{"); err != nil {
				return nil, err
			}
		}
		st := &Type{Kind: TStruct, Packed: packed}
		if !lx.accept("}") {
			for {
				f, err := p.parseType(lx)
				if err != nil {
					return nil, err
				}
				st.Fields = append(st.Fields, f)
				if !lx.accept(",") {
					break
				}
			}
			if err := lx.expect("}"); err != nil {
				return nil, err
			}
		}
		if packed {
			if err := lx.expect(">"); err != nil {
				return nil, err
			}
		}
		return st, nil
	case strings.HasPrefix(t, "%"):
		td, ok := p.m.Types[t]
		if !ok {
			return nil, lx.errf("unknown named type %q", t)
		}
		return td, nil
	case t == "float" || t == "double" || t == "half" || t == "fp128":
		return nil, lx.errf("floating point is not supported by the DMA target")
	}
	return nil, lx.errf("unsupported type token %q", t)
}

// --- Globals ---

var globalQualifiers = map[string]bool{
	"private": true, "internal": true, "external": true, "linkonce": true,
	"linkonce_odr": true, "weak": true, "weak_odr": true, "common": true,
	"appending": true, "dso_local": true, "dso_preemptable": true,
	"unnamed_addr": true, "local_unnamed_addr": true, "externally_initialized": true,
	"thread_local": true, "hidden": true, "protected": true, "default": true,
}

func (p *parser) globalLine(lx *lexer) error {
	name := strings.TrimPrefix(unquote(lx.next()), "@")
	if err := lx.expect("="); err != nil {
		return err
	}
	isConst := false
	for {
		t := lx.peek()
		if t == "global" || t == "constant" {
			isConst = t == "constant"
			lx.next()
			break
		}
		if t == "alias" || t == "ifunc" {
			return lx.errf("aliases are not supported")
		}
		if !globalQualifiers[t] {
			return lx.errf("unexpected global qualifier %q", t)
		}
		lx.next()
	}
	ty, err := p.parseType(lx)
	if err != nil {
		return err
	}
	g := &Global{Name: name, Typ: ty, Const: isConst}
	if lx.peek() != "" && lx.peek() != "," {
		init, err := p.parseInit(lx, ty)
		if err != nil {
			return err
		}
		g.Init = init
	} else {
		g.Init = &Init{Typ: ty, Zero: true} // external: treat as BSS
	}
	p.m.Globals = append(p.m.Globals, g)
	return nil
}

func (p *parser) parseInit(lx *lexer, ty *Type) (*Init, error) {
	t := lx.peek()
	switch {
	case t == "zeroinitializer" || t == "null" || t == "undef" || t == "poison" || t == "none":
		lx.next()
		return &Init{Typ: ty, Zero: true}, nil
	case strings.HasPrefix(t, "c\""):
		lx.next()
		b, err := unescapeBytes(t[2 : len(t)-1])
		if err != nil {
			return nil, lx.errf("%v", err)
		}
		return &Init{Typ: ty, Str: b}, nil
	case t == "[" || t == "{" || t == "<":
		lx.next()
		if t == "<" {
			if err := lx.expect("{"); err != nil {
				return nil, err
			}
		}
		closing := "]"
		if t != "[" {
			closing = "}"
		}
		var elems []*Init
		if !lx.accept(closing) {
			for {
				ety, err := p.parseType(lx)
				if err != nil {
					return nil, err
				}
				e, err := p.parseInit(lx, ety)
				if err != nil {
					return nil, err
				}
				elems = append(elems, e)
				if !lx.accept(",") {
					break
				}
			}
			if err := lx.expect(closing); err != nil {
				return nil, err
			}
		}
		if t == "<" {
			if err := lx.expect(">"); err != nil {
				return nil, err
			}
		}
		return &Init{Typ: ty, Elems: elems}, nil
	default:
		v, err := p.parseValue(lx, ty)
		if err != nil {
			return nil, err
		}
		switch v.Kind {
		case VConst:
			return &Init{Typ: ty, Int: v.Int}, nil
		case VGlobal, VFunc:
			return &Init{Typ: ty, Sym: v.Name, SymOff: v.Off}, nil
		}
		return nil, lx.errf("unsupported initializer")
	}
}

// --- Functions ---

var defineQualifiers = map[string]bool{
	"dso_local": true, "dso_preemptable": true, "internal": true,
	"private": true, "external": true, "linkonce": true, "linkonce_odr": true,
	"weak": true, "weak_odr": true, "hidden": true, "protected": true,
	"unnamed_addr": true, "local_unnamed_addr": true, "noundef": true,
	"zeroext": true, "signext": true, "inreg": true, "default": true,
}

func (p *parser) defineLine(lx *lexer) error {
	lx.next() // "define"
	// Skip qualifiers and return attributes up to the return type.
	for defineQualifiers[lx.peek()] || strings.HasPrefix(lx.peek(), "range") {
		lx.next()
		lx.skipParens()
	}
	ret, err := p.parseType(lx)
	if err != nil {
		return err
	}
	name := strings.TrimPrefix(unquote(lx.next()), "@")
	if err := lx.expect("("); err != nil {
		return err
	}
	f := &Func{Name: name, Ret: ret}
	p.nvals = 0
	if !lx.accept(")") {
		for {
			if lx.peek() == "." { // "..." varargs
				return lx.errf("varargs functions are not supported")
			}
			pt, err := p.parseType(lx)
			if err != nil {
				return err
			}
			skipParamAttrs(lx)
			pname := ""
			if strings.HasPrefix(lx.peek(), "%") {
				pname = strings.TrimPrefix(unquote(lx.next()), "%")
			} else {
				pname = strconv.Itoa(p.nvals)
			}
			if isNumeric(pname) {
				p.nvals++
			}
			f.Params = append(f.Params, Param{Name: pname, Typ: pt})
			if !lx.accept(",") {
				break
			}
		}
		if err := lx.expect(")"); err != nil {
			return err
		}
	}
	p.cur = f
	p.blk = nil
	return nil
}

// skipParamAttrs consumes parameter attributes, including forms that
// carry a bare number ("align 4") or a parenthesized payload.
func skipParamAttrs(lx *lexer) {
	for isParamAttr(lx.peek()) {
		t := lx.next()
		lx.skipParens()
		if t == "align" && isNumeric(lx.peek()) {
			lx.next()
		}
	}
}

func isParamAttr(t string) bool {
	switch t {
	case "noundef", "nonnull", "nocapture", "noalias", "nofree", "readonly",
		"writeonly", "readnone", "returned", "zeroext", "signext", "inreg",
		"dead_on_unwind", "writable", "captures", "initializes", "dead_on_return":
		return true
	}
	return strings.HasPrefix(t, "align") || strings.HasPrefix(t, "dereferenceable") ||
		strings.HasPrefix(t, "range") || strings.HasPrefix(t, "sret") ||
		strings.HasPrefix(t, "byval")
}

func isNumeric(s string) bool {
	if s == "" {
		return false
	}
	for _, c := range s {
		if c < '0' || c > '9' {
			return false
		}
	}
	return true
}

func unquote(s string) string {
	if i := strings.IndexByte(s, '"'); i >= 0 && strings.HasSuffix(s, "\"") {
		return s[:i] + s[i+1:len(s)-1]
	}
	return s
}

// --- Values ---

func (p *parser) parseValue(lx *lexer, ty *Type) (*Value, error) {
	t := lx.peek()
	switch {
	case strings.HasPrefix(t, "%"):
		lx.next()
		return &Value{Kind: VLocal, Name: strings.TrimPrefix(unquote(t), "%"), Typ: ty}, nil
	case strings.HasPrefix(t, "@"):
		lx.next()
		return &Value{Kind: VGlobal, Name: strings.TrimPrefix(unquote(t), "@"), Typ: ty}, nil
	case t == "true":
		lx.next()
		return &Value{Kind: VConst, Int: 1, Typ: ty}, nil
	case t == "false", t == "null", t == "undef", t == "poison", t == "none", t == "zeroinitializer":
		lx.next()
		return &Value{Kind: VConst, Int: 0, Typ: ty}, nil
	case t == "getelementptr":
		lx.next()
		return p.parseConstGEP(lx, ty)
	case t == "ptrtoint" || t == "bitcast" || t == "inttoptr":
		lx.next()
		if err := lx.expect("("); err != nil {
			return nil, err
		}
		ity, err := p.parseType(lx)
		if err != nil {
			return nil, err
		}
		v, err := p.parseValue(lx, ity)
		if err != nil {
			return nil, err
		}
		if err := lx.expect("to"); err != nil {
			return nil, err
		}
		if _, err := p.parseType(lx); err != nil {
			return nil, err
		}
		if err := lx.expect(")"); err != nil {
			return nil, err
		}
		v.Typ = ty
		return v, nil
	case isNumeric(t) || strings.HasPrefix(t, "-"):
		lx.next()
		n, err := strconv.ParseInt(t, 10, 64)
		if err != nil {
			// large unsigned i64 constants
			u, uerr := strconv.ParseUint(t, 10, 64)
			if uerr != nil {
				return nil, lx.errf("bad integer %q", t)
			}
			return &Value{Kind: VConst, Int: u, Typ: ty}, nil
		}
		return &Value{Kind: VConst, Int: uint64(n), Typ: ty}, nil
	}
	return nil, lx.errf("unsupported value token %q", t)
}

// parseConstGEP folds a constant getelementptr expression into
// global+offset. All indices must be constants.
func (p *parser) parseConstGEP(lx *lexer, ty *Type) (*Value, error) {
	for lx.peek() == "inbounds" || lx.peek() == "nuw" || lx.peek() == "nusw" {
		lx.next()
	}
	if err := lx.expect("("); err != nil {
		return nil, err
	}
	srcTy, err := p.parseType(lx)
	if err != nil {
		return nil, err
	}
	if err := lx.expect(","); err != nil {
		return nil, err
	}
	if _, err := p.parseType(lx); err != nil { // ptr
		return nil, err
	}
	base, err := p.parseValue(lx, &Type{Kind: TPtr})
	if err != nil {
		return nil, err
	}
	if base.Kind != VGlobal {
		return nil, lx.errf("constant GEP base must be a global")
	}
	off := int64(0)
	cur := srcTy
	first := true
	for lx.accept(",") {
		ity, err := p.parseType(lx)
		if err != nil {
			return nil, err
		}
		_ = ity
		iv, err := p.parseValue(lx, ity)
		if err != nil {
			return nil, err
		}
		if iv.Kind != VConst {
			return nil, lx.errf("constant GEP with non-constant index")
		}
		idx := int64(int32(iv.Int))
		if first {
			off += idx * int64(cur.Size())
			first = false
			continue
		}
		switch cur.Kind {
		case TArray:
			off += idx * int64(cur.Elem.Size())
			cur = cur.Elem
		case TStruct:
			off += int64(cur.FieldOffset(int(idx)))
			cur = cur.Fields[idx]
		default:
			return nil, lx.errf("constant GEP walks into scalar")
		}
	}
	if err := lx.expect(")"); err != nil {
		return nil, err
	}
	return &Value{Kind: VGlobal, Name: base.Name, Off: base.Off + uint32(off), Typ: ty}, nil
}

func unescapeBytes(s string) ([]byte, error) {
	var out []byte
	for i := 0; i < len(s); i++ {
		if s[i] != '\\' {
			out = append(out, s[i])
			continue
		}
		if i+1 < len(s) && s[i+1] == '\\' {
			out = append(out, '\\')
			i++
			continue
		}
		if i+3 > len(s) {
			return nil, fmt.Errorf("bad escape at end of string")
		}
		b, err := strconv.ParseUint(s[i+1:i+3], 16, 8)
		if err != nil {
			return nil, fmt.Errorf("bad hex escape %q", s[i:i+3])
		}
		out = append(out, byte(b))
		i += 2
	}
	return out, nil
}
