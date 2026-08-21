package llir

import "fmt"

// Merge links parsed modules into one, whole-program style: a symbol may
// be defined once and referenced anywhere; external (tentative) globals
// resolve to the definition or, if none exists, to zeroed storage.
// Internal-linkage symbols that collide across modules are renamed
// module-locally (the textual-IR equivalent of a local symbol table).
func Merge(mods ...*Module) (*Module, error) {
	if len(mods) == 1 {
		return mods[0], nil
	}
	// Pass 1: find internal-symbol collisions and rename them per module.
	defCount := map[string]int{}
	for _, m := range mods {
		for _, f := range m.Funcs {
			defCount[f.Name]++
		}
		for _, g := range m.Globals {
			if !g.External {
				defCount[g.Name]++
			}
		}
	}
	for i, m := range mods {
		ren := map[string]string{}
		for _, f := range m.Funcs {
			if f.Internal && defCount[f.Name] > 1 {
				ren[f.Name] = fmt.Sprintf("%s__m%d", f.Name, i)
			}
		}
		for _, g := range m.Globals {
			if g.Internal && !g.External && defCount[g.Name] > 1 {
				ren[g.Name] = fmt.Sprintf("%s__m%d", g.Name, i)
			}
		}
		if len(ren) > 0 {
			renameModule(m, ren)
		}
	}

	out := &Module{Types: map[string]*Type{}}
	funcs := map[string]*Func{}
	globals := map[string]int{} // name -> index in out.Globals
	for _, m := range mods {
		for k, v := range m.Types {
			if _, ok := out.Types[k]; !ok {
				out.Types[k] = v
			}
		}
		for _, f := range m.Funcs {
			if prev, ok := funcs[f.Name]; ok {
				return nil, fmt.Errorf("merge: function %q defined in more than one module (%d and %d params)",
					f.Name, len(prev.Params), len(f.Params))
			}
			funcs[f.Name] = f
			out.Funcs = append(out.Funcs, f)
		}
		for _, g := range m.Globals {
			idx, ok := globals[g.Name]
			if !ok {
				globals[g.Name] = len(out.Globals)
				out.Globals = append(out.Globals, g)
				continue
			}
			prev := out.Globals[idx]
			switch {
			case prev.External && !g.External:
				out.Globals[idx] = g // definition wins
			case !prev.External && !g.External:
				return nil, fmt.Errorf("merge: global %q defined in more than one module", g.Name)
			default: // both external, or prev already defined: keep prev
			}
		}
		out.Declares = append(out.Declares, m.Declares...)
		for a, t := range m.Aliases {
			if out.Aliases == nil {
				out.Aliases = map[string]string{}
			}
			if prev, ok := out.Aliases[a]; ok && prev != t {
				return nil, fmt.Errorf("merge: alias %q has conflicting targets %q and %q", a, prev, t)
			}
			out.Aliases[a] = t
		}
	}
	return out, nil
}

// renameModule rewrites every reference to the renamed symbols.
func renameModule(m *Module, ren map[string]string) {
	rv := func(v *Value) {
		if v != nil && (v.Kind == VGlobal || v.Kind == VFunc) {
			if n, ok := ren[v.Name]; ok {
				v.Name = n
			}
		}
	}
	ri := func(in *Init) {
		var walk func(in *Init)
		walk = func(in *Init) {
			if in == nil {
				return
			}
			if n, ok := ren[in.Sym]; ok {
				in.Sym = n
			}
			for _, e := range in.Elems {
				walk(e)
			}
		}
		walk(in)
	}
	for _, f := range m.Funcs {
		if n, ok := ren[f.Name]; ok {
			f.Name = n
		}
		for _, b := range f.Blocks {
			for _, ins := range b.Instrs {
				for _, a := range ins.Args {
					rv(a)
				}
				rv(ins.CalleeVal)
				for _, e := range ins.Phi {
					rv(e.Val)
				}
				if n, ok := ren[ins.Callee]; ok {
					ins.Callee = n
				}
			}
		}
	}
	for _, g := range m.Globals {
		if n, ok := ren[g.Name]; ok {
			g.Name = n
		}
		ri(g.Init)
	}
}
