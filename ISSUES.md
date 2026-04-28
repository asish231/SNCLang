# SNlang Compiler Issues - Triage and Tracking

**Last Updated:** 2026-04-28  
**Status:** Active Research & Triage

This document tracks verified bugs, confirmed missing features, and invalid syntax reports. Use this to prioritize fixes for the self-hosting milestone.

---

## 1. Verified Bugs (High Priority)

### 1.1 Nullable Stack Initialization Failure
**Status:** REPRODUCED  
**Description:** Comparing a nullable variable to `none` (e.g., `if (x == none)`) fails if the variable is checked before its first assignment. The compiler generates comparison logic against uninitialized stack slots, leading to garbage results or incorrect branch behavior.  
**Requirements to Fix:**
- Implement a "zero-init" pass for all local variables at the start of a function.
- Ensure `none` comparisons (`stur xzr` vs `stur -1`) use consistent sentinel values across all types.

---

## 2. Confirmed Missing Features (Batch 2/3 Roadmap)

### 2.1 String Concatenation (`"a" + "b"`)
**Status:** PLANNED  
**Description:** The parser currently treats `+` as a numeric-only operator. It silently fails or produces empty assembly when strings are added.  
**Requirements to Fix:**
- Update `_parse_expr_value` in `parser.s` to detect `str` types during addition.
- Implement a runtime `str_concat` function in `utils.s` that allocates new memory.
- Add codegen for `op_str_concat`.

### 2.2 Maps (`map<K, V>`)
**Status:** MISSING  
**Description:** No implementation for hash-table based storage or lookup.  
**Requirements to Fix:**
- Add `map` keyword to lexer/parser.
- Implement a runtime hash-map in Assembly (requires Heap/Alloc or fixed-size buffers).

### 2.3 Multiple Return Values
**Status:** MISSING  
**Description:** Syntax `fn f() -> (int, bool)` is reserved but not implemented in codegen.  
**Requirements to Fix:**
- Update Function ABI to use `x0-x7` for multiple returns or reserved stack space.
- Update `AssignStmt` to handle tuple unpacking.

---

## 3. Invalid Syntax Reports (Non-Issues)

The following reports were triaged and found to be using incorrect SNlang grammar. No compiler changes are required for these.

| Reported Issue | Reason for Rejection | Valid SNlang Syntax |
| :--- | :--- | :--- |
| **Nested Calls** | Used `a: int` instead of `int a`. | `fn add(int a, int b)` |
| **For Loops** | Used `;` instead of `,`. | `for (int i = 0, i < 10, i += 1)` |
| **Match Arms** | Used `=>` instead of blocks. | `match (x) { 1 { ... } }` |
| **If-Expressions** | `if` is a statement, not an expression. | Use a temporary variable. |
| **Nullable Prefix** | Used `?int` instead of `int?`. | `int? x = none` |

---

## 4. Technical Debt & Architecture

### 4.1 Parser Bloat
**Observation:** `src/parser.s` is exceeding 5,400 lines. Direct codegen is making the compiler fragile.  
**Strategy:** Prioritize **Phase B (AST Separation)**. Building an AST instead of emitting strings will make fixing the "Nullable Bug" and "String Concatenation" significantly cleaner.
