# Self-Hosting Needs

What SNlang needs before `snc` can be rewritten in SNlang and compile itself.

Self-hosting means: write the compiler in `.sn`, run it through the current `snc`, and have the output compile the next version of itself.

---

## What Self-Hosting Demands

The compiler does these things internally:

1. Read a source file from disk
2. Lex it into tokens (scan characters, match keywords, handle strings)
3. Parse tokens into an AST (recursive descent, nested structures)
4. Walk the AST and emit ARM64 assembly text
5. Report errors with line numbers
6. Handle multiple source files (modules)

---

## Blockers — Critical (Must Have)

### 1. Runtime Multi-File Linking
**Status:** MISSING

`_load_module` exists and single-level + transitive imports work. But all modules are compiled into a single output file — there is no true separate compilation. A self-hosted compiler split across multiple `.sn` files needs each file to compile independently and link together.

**What is done:**
- `use module.path` syntax parses
- `_load_module` loads and parses module files
- Imported functions callable (single level and transitive)
- Duplicate `use` handled safely

**What is missing:**
- Separate compilation (each `.sn` → its own `.s`, then linked)
- Standard library namespace resolution at link time

---

### 2. `blueprint` — Full Method Dispatch
**Status:** IN_PROGRESS

AST nodes, tokens, and symbol table entries are naturally modeled as structs/objects. Blueprint field access and basic method calls work, but the system is not production-ready.

**What is done:**
- Field metadata, instances, field access
- Basic method calls
- `self.field` access in supported cases
- Parent names recorded for inheritance

**What is missing:**
- `contract` enforcement (parser-only)
- `follows` enforcement (parser-only)
- Access control enforcement (parser-only)
- Inherited field/method lookup not fully reliable
- `create()` constructor path limited

---

### 3. Multi-Return Values
**Status:** IN_PROGRESS

Basic tuple return/assign syntax is parsed. Not fully stable for production use.

**What is done:**
- `return (a, b)` syntax parsed
- `a, b = fn()` tuple assignment parsed

**What is missing:**
- Stable codegen for all multi-return cases
- More than 2 return values

---

### 4. Nested Function Call Stability
**Status:** IN_PROGRESS (workaround only)

Multiple calls to nested functions reuse stack slots incorrectly. The root cause (absolute vs relative slot indices per call frame) is known but not fixed. A self-hosted compiler is a deeply nested call graph — this would be a constant source of crashes.

---

### 5. `str.split()` Runtime Stability
**Status:** IN_PROGRESS

Op 91 is wired in parser and codegen. `_string_split` populates the list pool. Indexed access on the result (`p[0]`) is unstable. A lexer written in SNlang needs reliable string splitting.

---

### 6. Error Handling
**Status:** MISSING

A compiler must report errors and recover. SNlang has no `error` type, no `panic`, and no structured error propagation.

**What is missing:**
- `error` type
- `panic("msg")` builtin
- `try` / `catch`

---

## What Is Already Done (Self-Hosting Ready)

These features are solid and would carry over directly:

- `int`, `bool`, `str`, `byte`, `dec(X)` — full runtime support
- `const` types — immutability enforced
- `if / else if / else`, `while`, `for`, `for in` — full runtime
- `stop` / `skip`, `match` — all work
- Functions, parameters, single return, forward calls, default params
- String literals, print, concat, interpolation
- `cast(x, type)` — int↔dec, int→str, bool→str, dec→str
- `str.length()`, `str.slice()`, `str.contains()` — implemented
- `list<T>` literal, `for in`, mutation
- `map<K,V>` literal, read, update, new key insertion
- `none`, nullable `?`, `otherwise`
- `ref<T>`, `alloc()`, `free()`, `value()`, `set()` — pointer ops
- `input("prompt")`, `file_read()`, `file_write()` — I/O
- `use module.path` — single-level and transitive imports work
- `std/math.sn`, `std/string.sn` — stdlib exists
- `and`, `or`, `not`, compound assignment, `**`
- All tests passing (36 Makefile + runtime/modules/math/string suites)

---

## Current Score

```
Critical blockers:    6  (multi-file linking, blueprint dispatch, multi-return, nested fn slots, str.split, error handling)
Already working:     ~40 features

Estimated readiness: ~60% of features needed for self-hosting
```

## Roadmap

| What | Unlocks |
|---|---|
| Stable multi-file linking | Split compiler across `.sn` files |
| Full `blueprint` dispatch | AST node modeling |
| `str.split()` stability | Lexer written in SNlang |
| Multi-return + nested fn fix | Parser functions with error returns |
| Error handling | Compiler reports its own errors |

Earliest realistic self-hosting attempt: after multi-file linking and blueprint dispatch are stable.
