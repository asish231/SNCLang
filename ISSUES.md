# SNlang Compiler Issues - Triage and Fix Notes

**Date:** 2026-04-28  
**Status:** Reviewed

---

## Summary

This file was reviewed against the current compiler source, repo examples, and docs.

Important result: several reported items are **not actual compiler bugs**. They come
from using syntax that SNlang does not currently support.

The current compiler grammar uses:

- function params as `fn add(int a, int b) -> int`
- counted `for` loops as `for (int i = 0, i < 3, i += 1) { ... }`
- nullable types as `int? value = none`
- `match` arms as `1 { ... }`, not `1 => ...`

---

## Issue Review

### 1. Nested Function Calls - Linker Error
**Original verdict:** Not a confirmed compiler bug  
**Actual status:** Invalid repro input

The reported sample is not valid SNlang:

- it uses `a: int` style parameters, but SNlang uses `int a`
- the `print(...)` call is missing a closing `)`

Reported input:

```sn
fn add(a: int, b: int) -> int { a + b }
fn main() { print(add(add(1,2),3) }
```

Valid SNlang form:

```sn
fn add(int a, int b) -> int {
    return a + b
}

fn main() {
    print(add(add(1, 2), 3))
}
```

**Repo evidence:** nested function calls are already covered in:

- `examples/functions.sn`
- `examples/fn_nested_call.sn`
- `examples/fn_nested_call_print.sn`

**Conclusion:** not an issue as reported.

**How to verify**

```bash
./snc examples/fn_nested_call.sn > /tmp/fn_nested_call.s
clang /tmp/fn_nested_call.s -o /tmp/fn_nested_call
/tmp/fn_nested_call
```

---

### 2. String Concatenation - Wrong Output
**Original verdict:** Real gap  
**Actual status:** Unsupported feature, not a regression fix already present

This one points at a real limitation, but it is better described as a **missing feature**
than a bug fix that is already done.

The README still lists string concatenation as planned work.

Problematic sample:

```sn
fn main() {
    let s = "a" + "b"
    print(s)
}
```

**Current reality**

- strings exist
- string literals print
- string variables can flow through functions
- string concatenation is not fully implemented

**Conclusion:** this is a real missing feature, but it is not fixed in the current repo.

**Solution**

- Do not treat `"a" + "b"` as supported yet.
- Keep this item open as a planned feature.
- If implementing later, the work belongs in expression typing plus string runtime/codegen.

**How to verify current behavior**

```bash
cat > /tmp/string_concat.sn <<'EOF'
fn main() {
    let s = "a" + "b"
    print(s)
}
EOF

./snc /tmp/string_concat.sn > /tmp/string_concat.s
clang /tmp/string_concat.s -o /tmp/string_concat
/tmp/string_concat
```

If this still fails or prints the wrong thing, that matches current project status.

---

### 3. For Count Loop - Parser Error
**Original verdict:** Not a compiler bug  
**Actual status:** Invalid repro syntax

Reported input uses C-style semicolon separators:

```sn
fn main() { for (i = 0; i < 3; i = i + 1) { print(i) } }
```

SNlang currently uses comma-separated counted `for` loops, and examples show:

```sn
fn main() {
    for (int i = 0, i < 3, i += 1) {
        print(i)
    }
}
```

**Repo evidence:** `examples/for_loop.sn`, `examples/mini_for.sn`

**Conclusion:** not an issue as reported.

**How to verify**

```bash
./snc examples/mini_for.sn > /tmp/mini_for.s
clang /tmp/mini_for.s -o /tmp/mini_for
/tmp/mini_for
```

---

### 4. Match Statement - Parser Error
**Original verdict:** Not a confirmed compiler bug  
**Actual status:** Invalid repro syntax

Reported input:

```sn
fn main() { match(1) { 1 => print(1) } }
```

Current SNlang `match` syntax is block-based, not `=>` based:

```sn
fn main() {
    match (1) {
        1 {
            print(1)
        }
        default {
            print(0)
        }
    }
}
```

**Repo evidence:** `examples/spec_batch.sn`

**Conclusion:** not an issue as reported.

**How to verify**

```bash
./snc examples/spec_batch.sn > /tmp/spec_batch.s
clang /tmp/spec_batch.s -o /tmp/spec_batch
/tmp/spec_batch
```

---

### 5. Deep Block Nesting - Parser Error
**Original verdict:** Not a normal supported construct  
**Actual status:** Unsupported expression form

Reported input:

```sn
fn main() { if (if (1 > 0) { true } else { false }) { print(1) } }
```

This treats `if` as an expression returning a value. SNlang currently parses `if` as a
statement, not as an expression.

Equivalent supported form:

```sn
fn main() {
    bool ok = false
    if (1 > 0) {
        ok = true
    } else {
        ok = false
    }

    if (ok) {
        print(1)
    }
}
```

**Conclusion:** not a parser bug under the current language model.

**How to verify**

Use the rewritten form above, or verify normal nested blocks with existing examples:

```bash
./snc examples/nested_for_control.sn > /tmp/nested_for_control.s
clang /tmp/nested_for_control.s -o /tmp/nested_for_control
/tmp/nested_for_control
```

---

### 6. Nullable Explicit Syntax Rejection
**Original verdict:** Not a compiler bug  
**Actual status:** Invalid repro syntax

Reported input:

```sn
fn main() { let x: ?int = none; print(1) }
```

Current SNlang nullable syntax is postfix `?` on the type:

```sn
fn main() {
    int? x = none
    print(1)
}
```

Also, the legacy `let` form does not use `name: type` style annotation here.

**Repo evidence:**

- `examples/nullable_basic.sn`
- `examples/nullable_functions.sn`
- `examples/nullable_list_direct.sn`
- `examples/nullable_decimal.sn`

**Conclusion:** not an issue as reported.

**How to verify**

```bash
./snc examples/nullable_basic.sn > /tmp/nullable_basic.s
clang /tmp/nullable_basic.s -o /tmp/nullable_basic
/tmp/nullable_basic
```

---

## Actual Fixes Already Applied In This Repo

The current local repo has already been updated for real nullable/default-param gaps:

1. Nullable list direct declarations were fixed.
   - `list<int>? nums = [1, 2, 3]`

2. Nullable decimal declaration flow was fixed.
   - `dec(2)? price = maybePrice(false)`
   - `price = maybePrice(true)`

3. `otherwise` type checking was tightened for nullable fallback use.

4. Default-parameter handling was tightened for decimal and nullable paths.

---

## Recommended Open Items

These are the items that should remain open after triage:

1. **String concatenation**
   - still incomplete
   - should stay tracked as a missing feature

2. **Broader language completeness**
   - `if` expressions are not supported
   - alternate syntax forms like `a: int` and `=>` match arms are not part of current grammar

---

## How To Check The Current Fixed State

Run these on macOS after building the compiler:

```bash
cd /path/to/snc
make test
```

Then verify the important regression cases directly:

```bash
./snc examples/nullable_list_direct.sn > /tmp/nullable_list_direct.s
clang /tmp/nullable_list_direct.s -o /tmp/nullable_list_direct
/tmp/nullable_list_direct
```

```bash
./snc examples/nullable_decimal.sn > /tmp/nullable_decimal.s
clang /tmp/nullable_decimal.s -o /tmp/nullable_decimal
/tmp/nullable_decimal
```

```bash
./snc examples/default_params.sn > /tmp/default_params.s
clang /tmp/default_params.s -o /tmp/default_params
/tmp/default_params
```

```bash
./snc examples/nullable_basic.sn > /tmp/nullable_basic.s
clang /tmp/nullable_basic.s -o /tmp/nullable_basic
/tmp/nullable_basic
```

If these pass, the nullable/default-parameter fixes are in good shape on the Mac toolchain.
