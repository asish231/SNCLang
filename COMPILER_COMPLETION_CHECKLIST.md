# SNlang Compiler Completion Checklist

This document converts the full-system checklist into a concrete status board for this repository.

## Status Legend

- DONE: Implemented and validated in current pipeline.
- IN_PROGRESS: Partially implemented and/or unstable.
- MISSING: Not implemented yet.

## 1) Compilation Stack

- Lexer: DONE
- Parser: DONE
- AST formalization layer: MISSING
- Semantic analysis pass (separate): MISSING
- IR layer: MISSING
- Optimization layer: MISSING
- ARM64 codegen: IN_PROGRESS (direct, no IR)
- Assembler/linker integration: DONE (via `cc`)

## 2) Runtime Core

- Runtime control flow (`if/else`, loops, match): DONE
- Function calls/returns/locals: DONE (single-return model)
- Calling convention compliance (current backend): IN_PROGRESS
- Stack frame contract documentation: IN_PROGRESS
- Runtime data model for advanced aggregates: IN_PROGRESS

## 3) Type and Semantics

- Primitive types (`int`, `bool`, `byte`, `str`, `dec`): DONE
- Typed assignment validation: IN_PROGRESS
- Null model (`none`, nullable `?`, `otherwise`): DONE
- `list<T>` core behavior: IN_PROGRESS
- `map<K,V>`: MISSING
- Multi-return values: MISSING
- Default parameters: MISSING

## 4) Language Feature Completeness

- Strings (basic literal/print/pass-through): DONE
- String operators/helpers (concat/helpers/interpolation): MISSING
- Lists (indexing/mutation/bounds): MISSING
- Modules (`use` runtime behavior): MISSING
- Object model (`blueprint`, `object`, contracts, access): MISSING

## 5) Tooling and Errors

- Basic error reporting: DONE
- Rich diagnostics (line/column detail, recovery): IN_PROGRESS
- Single command build driver (`snc build` style): MISSING
- Structured unit/regression coverage by component: IN_PROGRESS

## 6) Portability / ABI

- Mach-O/COFF string emission abstraction: IN_PROGRESS
- Backend abstraction for multiple architectures: MISSING

## 7) Security / Safety

- Division safety checks: DONE
- Bounds checks for collections: MISSING
- Memory model for heap-based data: MISSING

## Execution Order (Critical Path)

1. Phase A (now): finish Batch 2 data model (`map`, multi-return, default params).
2. Phase B: formal semantic pass boundary (symbol/type checking pass separation).
3. Phase C: AST formalization.
4. Phase D: minimal IR + IR->ARM64 lowering.
5. Phase E: runtime consolidation (strings/lists/maps/heap conventions).
6. Phase F: modules and multi-file compilation driver.

## Acceptance Criteria for "Complete v1"

SNlang v1 is considered complete when all are true:

- AST + semantic analysis + IR exist as explicit layers.
- Core language (`int/bool/byte/str/dec/list/map/none/nullable`) is stable.
- Function system supports multi-return and default params.
- Runtime data representations are documented and enforced.
- `use` works across files with symbol resolution.
- Diagnostics and tests cover compiler stages and runtime regressions.
