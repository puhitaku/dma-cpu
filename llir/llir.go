// Package llir parses the subset of textual LLVM IR (".ll") that clang
// emits for ILP32 C at -O1 with opaque pointers. It is the front half of
// the Phase 4 compiler (`dmacc`): clang lowers C to IR, dmacc lowers IR
// to dmaasm.
//
// Supported: i1..i32 integers, pointers, arrays, structs (incl. named
// types), globals with initializers, phi/select/switch, all integer
// binary ops, icmp, load/store/alloca/getelementptr, casts, calls, and
// the llvm.memcpy/memset/lifetime/assume intrinsic families. Anything
// outside the subset (i64, floats, vectors, varargs, dynamic alloca) is
// a parse or codegen error, not a miscompile.
package llir

import "fmt"

// TypeKind discriminates Type.
type TypeKind int

const (
	TInt TypeKind = iota
	TPtr
	TVoid
	TArray
	TStruct
	TLabel
)

// Type is an LLVM type in the supported subset.
type Type struct {
	Kind   TypeKind
	Bits   int     // TInt: 1, 8, 16, 32 (64 parses but is rejected in codegen sizing)
	N      int     // TArray: element count
	Elem   *Type   // TArray
	Fields []*Type // TStruct
	Packed bool    // TStruct: <{...}>
	Name   string  // TStruct: %struct.foo (informational)
}

func (t *Type) String() string {
	switch t.Kind {
	case TInt:
		return fmt.Sprintf("i%d", t.Bits)
	case TPtr:
		return "ptr"
	case TVoid:
		return "void"
	case TArray:
		return fmt.Sprintf("[%d x %s]", t.N, t.Elem)
	case TStruct:
		if t.Name != "" {
			return t.Name
		}
		return "{...}"
	}
	return "?"
}

// Size returns the byte size per the ILP32 C layout (arm eabi), and
// Align the alignment. Codegen rejects i64 before sizing matters.
func (t *Type) Size() int {
	switch t.Kind {
	case TInt:
		if t.Bits == 1 {
			return 1
		}
		return t.Bits / 8
	case TPtr:
		return 4
	case TArray:
		return t.N * t.Elem.Size()
	case TStruct:
		size := 0
		for _, f := range t.Fields {
			al := 1
			if !t.Packed {
				al = f.Align()
			}
			size = align(size, al)
			size += f.Size()
		}
		return align(size, t.Align())
	}
	return 0
}

func (t *Type) Align() int {
	switch t.Kind {
	case TInt:
		if t.Bits == 1 {
			return 1
		}
		return t.Bits / 8
	case TPtr:
		return 4
	case TArray:
		return t.Elem.Align()
	case TStruct:
		if t.Packed {
			return 1
		}
		al := 1
		for _, f := range t.Fields {
			if a := f.Align(); a > al {
				al = a
			}
		}
		return al
	}
	return 1
}

// FieldOffset returns the byte offset of struct field i.
func (t *Type) FieldOffset(i int) int {
	off := 0
	for j := 0; j <= i; j++ {
		al := 1
		if !t.Packed {
			al = t.Fields[j].Align()
		}
		off = align(off, al)
		if j == i {
			return off
		}
		off += t.Fields[j].Size()
	}
	return off
}

func align(v, a int) int { return (v + a - 1) &^ (a - 1) }

// ValueKind discriminates Value.
type ValueKind int

const (
	VLocal     ValueKind = iota // %name
	VGlobal                     // @name (+ constant byte offset)
	VConst                      // integer constant (also null/undef/poison as 0)
	VFunc                       // @name of a function used as a value
)

// Value is an operand.
type Value struct {
	Kind ValueKind
	Name string // VLocal/VGlobal/VFunc
	Int  uint64 // VConst (truncated to the operand type by codegen)
	Off  uint32 // VGlobal: folded constant-GEP byte offset
	Typ  *Type  // operand type as written
}

// Init is a global initializer tree.
type Init struct {
	Typ    *Type
	Zero   bool    // zeroinitializer / null / undef
	Int    uint64  // scalar
	Str    []byte  // c"..." (raw bytes, includes any NUL)
	Elems  []*Init // array/struct
	Sym    string  // address of a global/function
	SymOff uint32
}

// PhiEdge is one [value, predecessor] pair.
type PhiEdge struct {
	Val  *Value
	Pred string
}

// SwitchCase is one case of a switch terminator.
type SwitchCase struct {
	Val   uint64
	Label string
}

// Instr is one instruction. Fields are populated per Op.
type Instr struct {
	Line int
	Op   string // "add", "icmp", "br", "call", ...
	Res  string // result name without '%', or ""
	Typ  *Type  // result type; for store/icmp the operand type
	Args []*Value

	Pred   string       // icmp
	To     *Type        // casts
	Labels []string     // br: [dest] or [true, false]; switch: [default]
	Cases  []SwitchCase // switch
	Phi    []PhiEdge    // phi
	Callee string       // call
	AllocN int          // alloca: constant element count
}

// Block is a basic block.
type Block struct {
	Name   string
	Instrs []*Instr // terminator is the last entry
}

// Param is a function parameter.
type Param struct {
	Name string
	Typ  *Type
}

// Func is a function definition.
type Func struct {
	Name   string
	Ret    *Type
	Params []Param
	Blocks []*Block
}

// Global is a module-level variable.
type Global struct {
	Name  string
	Typ   *Type
	Init  *Init
	Const bool
}

// Module is a parsed .ll file.
type Module struct {
	Globals  []*Global
	Funcs    []*Func
	Declares []string // declared-only function names (incl. intrinsics)
	Types    map[string]*Type
}
