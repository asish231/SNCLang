# SNlang Feature Matrix

Tracks spec vs actual implementation status. Verified against source (`src/*.s`) not docs.

- `Spec`: appears in `SNLANG_SPEC.md`
- `Status`: DONE / IN_PROGRESS / MISSING

---

## Core Types

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `int` | Yes | DONE | Full runtime support |
| `bool` | Yes | DONE | Full runtime support |
| `str` | Yes | DONE | Literal, print, concat, pass-through |
| `byte` | Yes | DONE | Parser and runtime path validated |
| `dec(X)` | Yes | DONE | Decimal arithmetic, cast, print |
| `const int/bool/str/dec` | Yes | DONE | Immutability enforced |
| `none` / nullable `?` | Yes | IN_PROGRESS | Basic support, edge cases remain |
| `otherwise` | Yes | DONE | Null fallback operator works |
| `any` | Yes | MISSING | Not implemented |

---

## Variables and Assignment

| Feature | Spec | Status | Notes |
|---|---|---|---|
| Typed declaration `int x = 10` | Yes | DONE | All types |
| Reassignment `x = expr` | Yes | DONE | With type checking |
| `+=` `-=` `*=` `/=` `%=` | Yes | DONE | All compound ops |

---

## Operators

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `+ - * / %` | Yes | DONE | Integer and decimal |
| `**` (power) | Yes | DONE | |
| `== != > < >= <=` | Yes | DONE | Runtime comparisons |
| `and` `or` `not` | Yes | DONE | Runtime logical ops |
| String concat `+` | Yes | DONE | `str a + str b` works |
| `cast(x, type)` | Yes | DONE | int↔dec, int→str, bool→str, dec→str |

---

## Control Flow

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `if / else if / else` | Yes | DONE | Full runtime branching |
| `while` | Yes | DONE | Full runtime loop |
| counted `for` | Yes | DONE | Runtime with label-based codegen |
| `for in` list | Yes | DONE | Iterates list literals and variables |
| `for in` map value | Yes | IN_PROGRESS | Partial |
| `stop` (break) | Yes | DONE | Works in for and while |
| `skip` (continue) | Yes | DONE | Works in for and while |
| `match` with `default` | Yes | DONE | Pattern matching works |

---

## Functions

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `fn name() { }` | Yes | DONE | |
| `fn name(type param) -> type` | Yes | DONE | Up to 4 params |
| Return values | Yes | DONE | Single return |
| Forward calls | Yes | DONE | `_preparse_functions` handles this |
| Nested function calls | Yes | DONE | Top-level functions |
| Nested fn inside fn | Yes | IN_PROGRESS | Multiple calls have slot reuse bug |
| Default parameters | Yes | DONE | `fn f(int x = 0)` |
| Multi-return `-> (int, bool)` | Yes | IN_PROGRESS | Basic tuple syntax parsed; not fully stable |
| `return` statement | Yes | DONE | With missing-return enforcement |

---

## Collections

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `list<int>` / `list<str>` literal | Yes | DONE | `[1, 2, 3]` |
| `for in` list | Yes | DONE | |
| `list[i]` read | Yes | IN_PROGRESS | Partial — dynamic bases unstable |
| `list[i] = val` write | Yes | DONE | Mutation works |
| List bounds checking | Yes | MISSING | No bounds error yet |
| `map<str, int>` literal | Yes | DONE | `{"key": val}` |
| `map[key]` read | Yes | DONE | |
| `map[key] = val` update existing key | Yes | DONE | |
| `map[key] = val` insert new key | Yes | DONE | `Lstmt_index_map_insert_new` implemented |
| `map<K, list<T>>` nested | Yes | MISSING | Nested generics fail |

---

## Strings

| Feature | Spec | Status | Notes |
|---|---|---|---|
| String literals | Yes | DONE | |
| `print(str)` / `printn(str)` | Yes | DONE | |
| String concat `+` | Yes | DONE | |
| `cast(x, str)` | Yes | DONE | int, bool, dec all work |
| String interpolation `{name}` | Yes | DONE | `"Hello {name}!"` works |
| `.length()` | Yes | DONE | `Lprimary_member_length` implemented |
| `.slice(start, end)` | Yes | DONE | Op 90, `_string_slice` runtime helper |
| `.contains(x)` | Yes | DONE | `Lprimary_member_contains` implemented |
| `.split(sep)` | Yes | IN_PROGRESS | Op 91 wired; runtime unstable on indexed access |
| `.replace(a, b)` / `.upper()` / `.lower()` | Yes | MISSING | |

---

## I/O

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `print(expr)` / `printn(expr)` | Yes | DONE | |
| `input("prompt")` | Yes | DONE | String input |
| `file_read(path)` | Yes | DONE | Returns str |
| `file_write(path, data)` | Yes | DONE | Returns bool |

---

## Modules

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `use module.path` syntax | Yes | DONE | Single and multiple imports |
| Dotted module paths | Yes | DONE | |
| Module file loading | Yes | DONE | `_load_module` implemented |
| Single-level symbol resolution | Yes | DONE | Imported functions callable |
| Transitive imports | Yes | DONE | Chained module imports work |
| Runtime multi-file linking | Yes | MISSING | All modules compiled into one output |
| Standard library (`std.*`) | Yes | IN_PROGRESS | `std/math.sn`, `std/string.sn` exist |

---

## OOP / Advanced

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `blueprint` fields + instances | Yes | IN_PROGRESS | Field metadata, access, basic method calls work |
| `blueprint` method dispatch | Yes | IN_PROGRESS | `self.field` and method calls work in supported cases |
| `contract` enforcement | Yes | MISSING | Parser-only |
| Inheritance `from` | Yes | IN_PROGRESS | Parent names recorded; lookup partially works |
| `follows` enforcement | Yes | MISSING | Parser-only |
| Access control `open/closed/guarded` | Yes | MISSING | Parser-only |
| `ref<T>` pointer | Yes | DONE | |
| `alloc()` / `free()` / `value()` / `set()` | Yes | DONE | Wraps libc malloc/free |

---

## Concurrency

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `spawn` / `chan<T>` | Yes | MISSING | |
| `async` / `await` | Yes | MISSING | |

---

## Error Handling

| Feature | Spec | Status | Notes |
|---|---|---|---|
| `error` type / `panic()` | Yes | MISSING | |
| `try` / `catch` | Yes | MISSING | |

---

## Platform

| Feature | Status | Notes |
|---|---|---|
| macOS ARM64 | DONE | Primary target |
| `platform.inc` macro layer | DONE | Mach-O / COFF abstraction |
| Linux ARM64 | MISSING | |
| Windows ARM64 | MISSING | |
| x86_64 | MISSING | Different ISA |

---

## Summary

```
DONE         ~40 features
IN_PROGRESS  ~10 features
MISSING      ~20 features

Tests: 36 Makefile + runtime(10/10) + modules(10/10) + math + string — all passing
```
