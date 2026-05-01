# SNlang Compiler Completion Checklist

Status board for this repository. Reflects actual source state, not aspirational plans.

## Status Legend

- DONE: Implemented and validated end-to-end on ARM64 macOS.
- IN_PROGRESS: Partially implemented and/or unstable.
- MISSING: Not implemented yet.

---

## 1) Compilation Stack

- Lexer:                              DONE
- Parser:                             DONE
- AST formalization layer:            MISSING
- Semantic analysis pass (separate):  MISSING
- IR layer:                           MISSING
- Optimization layer:                 MISSING
- ARM64 codegen:                      IN_PROGRESS (direct, no IR)
- Assembler/linker integration:       DONE (via `cc`)

---

## 2) Runtime Core

- Runtime control flow (`if/else`, loops, match):  DONE
- Runtime while loop:                              DONE
- Runtime for / for-in loop:                       DONE
- stop / skip (break/continue):                    DONE
- Function calls / returns / locals:               DONE
- Forward function calls:                          DONE
- Nested function calls (top-level):               DONE
- Nested fn inside fn (multiple calls):            IN_PROGRESS (workaround only)
- Calling convention compliance:                   IN_PROGRESS
- Stack frame contract documentation:              IN_PROGRESS
- Runtime data model for advanced aggregates:      IN_PROGRESS

---

## 3) Type and Semantics

- `int`, `bool`, `byte`, `str`:                    DONE
- `dec(X)` decimal type:                           DONE
- `const` types:                                   DONE
- Typed assignment validation:                     DONE
- Type mismatch errors:                            DONE
- Missing return enforcement:                      DONE
- Null model (`none`, `?`, `otherwise`):           IN_PROGRESS
- `list<T>` core (literal/for-in/mutation):        DONE
- `list<T>` indexing in expressions:               IN_PROGRESS
- `list<T>` bounds checking:                       MISSING
- `map<K,V>` literal/read/update existing keys:    DONE
- `map<K,V>` new key insertion:                    DONE
- `map<K,V>` nested types:                         MISSING
- Multi-return values (tuple return/assign):       IN_PROGRESS (basic syntax parsed, not fully stable)
- Default parameters:                              DONE

---

## 4) Language Feature Completeness

- Strings (literal/print/concat):                 DONE
- `cast(x, str)` in concat:                       DONE
- `cast(bool, str)`:                              DONE
- `cast(dec, str)`:                               DONE
- String interpolation `{name}`:                  DONE
- `str.length()`:                                 DONE
- `str.slice(start, end)`:                        DONE
- `str.contains(x)`:                              DONE
- `str.split(sep)`:                               IN_PROGRESS (parser wired, runtime unstable)
- `str.replace(a, b)` / `.upper()` / `.lower()`: MISSING
- `print()` with newline:                         DONE
- `printn()` without newline:                     DONE
- File I/O (`file_read`, `file_write`):           DONE
- `input("prompt")`:                              DONE
- `use module.path` (syntax + single-level):      DONE
- `use module.path` (transitive imports):         DONE
- `use module.path` (runtime multi-file linking): MISSING
- Object model (`blueprint` parse + fields):      IN_PROGRESS
- `blueprint` method calls:                       IN_PROGRESS
- `contract` / `follows` enforcement:             MISSING (parser-only)
- Access control (`open`/`closed`/`guarded`):     MISSING (parser-only)
- Pointers (`ref<T>`, `alloc`, `free`):           DONE
- Concurrency (`spawn`, `chan`, `async/await`):   MISSING

---

## 5) Tooling and Errors

- Basic error reporting (line number):            DONE
- Rich diagnostics (column, recovery):            MISSING
- `make clean && make` build:                     DONE
- `make test` full suite:                         DONE (36 Makefile tests + runtime/module/math/string suites)
- Single command build driver:                    MISSING
- Package manager:                                MISSING
- Debugger integration:                           MISSING

---

## 6) Portability / ABI

- macOS ARM64:                                    DONE
- `platform.inc` macro layer:                     DONE
- Linux ARM64:                                    MISSING
- Windows ARM64:                                  MISSING
- x86_64:                                         MISSING

---

## 7) Security / Safety

- Division by zero checks:                        DONE
- Const assignment enforcement:                   DONE
- Type mismatch enforcement:                      DONE
- Bounds checks for collections:                  MISSING
- Memory model for heap-based data:               DONE

---

## Current Test Status

- Makefile tests:        36 (all passing)
- runtime_test.sh:       10/10 passing
- test_modules.sh:       10/10 passing
- test_math.sh:          passing
- test_string.sh:        passing

---

## Critical Path to Self-Hosting

1. Stable multi-file module linking (runtime symbol resolution)
2. Full `blueprint` method dispatch
3. `str.split()` runtime stability
4. Multi-return stability
5. Nested fn slot fix (calling convention)
6. AST formalization + IR layer
