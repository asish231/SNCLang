# SNlang Architecture Baseline V1

This file defines the target architecture baseline requested for a complete compiler design:

- AST node model
- Minimal IR instruction set
- ARM64 stack/call ABI contract for this compiler

It is a design contract for implementation phases, not yet fully reflected in code.

## 1) AST Node Baseline

## Program

- `Program { declarations: Decl[] }`

## Declarations

- `VarDecl { name, type, initExpr, isConst }`
- `FnDecl { name, params, returnType, body }`
- `TypeDecl` (future: blueprint/contract/object)

## Statements

- `BlockStmt { statements[] }`
- `IfStmt { cond, thenBlock, elseBranch? }`
- `WhileStmt { cond, body }`
- `ForCountStmt { init, cond, update, body }`
- `ForInStmt { iterName, iterableExpr, body }`
- `MatchStmt { expr, arms[], defaultArm? }`
- `AssignStmt { target, op, expr }`
- `ReturnStmt { exprs[] }`
- `BreakStmt` (`stop`)
- `ContinueStmt` (`skip`)
- `ExprStmt { expr }`

## Expressions

- `LiteralExpr { kind, value }`
- `NameExpr { name }`
- `BinaryExpr { left, op, right }`
- `UnaryExpr { op, expr }`
- `CallExpr { callee, args[] }`
- `CastExpr { expr, targetType }`
- `ListExpr { elements[] }`
- `MapExpr { entries[] }` (future)
- `IndexExpr { base, index }` (future)
- `FallbackExpr { left, right }` (`otherwise`)

## 2) Type Model Baseline

- Primitive: `int`, `bool`, `byte`, `str`, `dec(scale)`
- Generic collections: `list<T>`, `map<K,V>`
- Nullable wrapper: `Nullable<T>`
- Special: `none`
- Function type metadata:
  - params: ordered typed list
  - returns: ordered typed list

## 3) Minimal IR Baseline

IR is three-address, block-based, SSA-optional first.

## Core values

- `temp` registers (virtual)
- constants
- symbol references
- labels

## Core instructions

- `const t, value`
- `mov t_dst, t_src`
- `binop t_dst, op, t_a, t_b`
- `cmp t_dst, pred, t_a, t_b`
- `jump label`
- `br t_cond, label_true, label_false`
- `label name`
- `call t_ret?, fn, args[]`
- `ret values[]`
- `load t, sym`
- `store sym, t`
- `alloca sym, type`

## Collection/runtime helpers (lowered via runtime calls initially)

- `list_new`, `list_push`, `list_get`, `list_set`, `list_len`
- `map_new`, `map_set`, `map_get`, `map_has`

## 4) ARM64 ABI/Frame Contract (Current Target)

## Function entry/exit

- Prologue:
  - save FP/LR
  - set FP (`x29`)
  - allocate frame for locals/spills
- Epilogue:
  - restore SP from FP
  - restore FP/LR
  - return

## Register policy baseline

- Arg/ret: AArch64 ABI defaults (`x0-x7` args, `x0-x1` returns)
- Temporaries: `x9-x15` preferred
- Preserve callee-saved when used (`x19+`)

## Stack frame layout baseline

- high addresses
  - caller frame
  - saved FP/LR
  - spill slots
  - local variable slots
  - temp expansion area
- low addresses

## Runtime value representations baseline

- `int`: signed 64-bit
- `bool`: 0/1 in 64-bit slot
- `byte`: low 8 bits in 64-bit slot
- `str`: pointer + length
- `dec`: scaled signed integer + scale metadata
- `list`: pointer/index + count (+ element type metadata)
- `none`: sentinel null value in nullable context

## 5) Implementation Milestones

1. Introduce explicit AST build stage from parser.
2. Introduce semantic pass over AST with symbol/type tables.
3. Emit minimal IR from typed AST.
4. Lower IR to current ARM64 emitter.
5. Move direct parser-side semantics to semantic+IR pipeline incrementally.

## 6) Non-Goals for First Refactor

- full SSA optimization
- advanced register allocator
- cross-architecture backend generation

Those follow once AST/semantic/IR layering is stable.
