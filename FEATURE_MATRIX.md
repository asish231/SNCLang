# SNlang Feature Matrix

This file separates three things:

- `Spec`: appears in `SNLANG_SPEC.md`
- `README`: claimed as supported in `README.md`
- `Source`: visible in the current compiler source

It is intentionally conservative: `Source` means "there is parser/codegen support in
the repo", not "fully validated end-to-end on a real ARM64 toolchain".

| Feature | Spec | README | Source | Notes |
|---|---|---|---|---|
| `int`, `bool`, `str` declarations | Yes | Yes | Yes | Core typed declarations exist. |
| Legacy `let name = expr;` | No | Yes | Yes | Restored as inferred-type declaration path. |
| `byte` | Yes | Yes | Partial | Parser/type path exists; runtime behavior still needs validation. |
| `dec(X)` | Yes | Yes | Partial | Decimal parser/support exists; needs stronger validation and coverage. |
| `print(...)` | Yes | Yes | Yes | Core path exists. |
| Legacy `print expr;` | No | Yes | Yes | Plain-print path exists. |
| Arithmetic and grouping | Yes | Yes | Partial | Present in parser; runtime evaluation is still incomplete. |
| Comparisons | Yes | Yes | Partial | Present in parser/codegen; needs validation. |
| `if / else if / else` | Yes | Yes | Partial | Runtime-codegen path exists, but behavior needs validation. |
| `while` | Yes | Yes | Partial | Parser/codegen path exists; needs validation. |
| counted `for` | Yes | README says planned | Partial | Source path exists, docs are out of sync. |
| `for in` | Yes | README says planned | Partial | Source path exists, docs are out of sync. |
| `stop` / `skip` | Yes | README says planned | Partial | Source path exists, docs are out of sync. |
| `match` | Yes | Yes | Partial | Parser path exists; needs validation. |
| `input("prompt")` | Yes | No | Partial | First-cut source support added for string declarations/assignments; still needs real ARM64 validation. |
| functions with params and returns | Yes | README says planned | Partial | Source path exists, docs are out of sync. |
| `list<T>` | Yes | README says planned | Partial | Parser/storage path exists; full semantics still need work. |
| `map<K,V>` | Yes | README says planned | Partial | Parser/runtime path exists; needs end-to-end validation and broader coverage. |
| multiple return values | Yes | README says planned | Partial | Tuple return/unpack source path exists; needs stronger type validation and runtime coverage. |
| string concatenation | Yes | README says planned | Partial | Source path exists via runtime concat helper; needs ARM64 validation and more edge-case coverage. |
| file I/O built-ins | Yes | README says planned | Partial | `file_read(...)` and `file_write(...)` source paths exist; needs platform validation. |
| `use module.path` | Yes | Yes | Partial | Parse path exists; real module behavior still needs validation. |
| blueprints / contracts / OOP | Yes | README says planned | No | Deferred. |
| pointers / allocation / concurrency | Yes | README says planned | No | Deferred. |

## Immediate known blockers

1. Real compile-and-run validation currently requires an ARM64-capable toolchain (`clang`) that is not available in this workspace.
2. The compiler is still in a stabilization phase; source presence is not the same as passing tests.
3. README feature claims should be updated after a real ARM64 validation pass, not before.
