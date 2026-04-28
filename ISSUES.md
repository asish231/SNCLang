# SNlang Compiler Issues - Bug Report

**Date:** 2026-04-28  
**Status:** Open

---

## Issues Found

### 1. Nested Function Calls - Linker Error
**Severity:** High  
**File:** parser.s / codegen.s

```
Input:
fn add(a: int, b: int) -> int { a + b }
fn main() { print(add(add(1,2),3) }

Output:
Undefined symbols for architecture arm64:
  "_main", referenced from: <initial-undefines>
```

**Expected:** Should print `3`  
**Actual:** Linker error

---

### 2. String Concatenation - Wrong Output
**Severity:** High  
**File:** codegen.s

```
Input:
fn main() { let s = "a" + "b"; print(s) }

Expected: "ab"
Actual: 8734286544 (memory address printed as int)
```

**Note:** String concatenation outputs a memory address instead of the actual string value.

---

### 3. For Count Loop - Parser Error
**Severity:** High  
**File:** parser.s

```
Input:
fn main() { for (i = 0; i < 3; i = i + 1) { print(i) } }

Expected: 0, 1, 2
Actual: error: expected statement on line 1:
```

**Note:** For-in loops work, but for-count loops don't parse correctly.

---

### 4. Match Statement - Parser Error
**Severity:** Medium  
**File:** parser.s

```
Input:
fn main() { match(1) { 1 => print(1) } }

Actual: exit code 1, no output
```

---

### 5. Deep Block Nesting - Parser Error
**Severity:** Medium  
**File:** parser.s

```
Input:
fn main() { if (if (1 > 0) { true } else { false }) { print(1) } }

Actual: exit code 1
```

---

### 6. Nullable Explicit Syntax Rejection
**Severity:** Medium  
**File:** parser.s

```
Input:
fn main() { let x: ?int = none; print(1) }

Expected: compiles
Actual: error: expected character on line 1: =
```

**Note:** Works with `str?` but not with `int?`

---

## Working Features

| Feature | Status |
|---------|--------|
| Basic int/ops | ✅ |
| Strings (basic) | ✅ |
| Decimals | ✅ |
| Lists | ✅ |
| If/else | ✅ |
| While loops | ✅ |
| For-in loops | ✅ |
| Functions | ✅ |
| Default params | ✅ |
| Nullable (implicit) | ✅ |
| Long variable names | ✅ |

---

## Test Commands Used

```bash
# Build compiler
make clean && make snc

# Test nested fn calls
echo "fn add(a: int, b: int) -> int { a + b }
fn main() { print(add(add(1,2),3)) }" > test.sn
./snc test.sn > test.s
cc test.s -o test && test

# Test string concat
echo 'fn main() { let s = "a" + "b"; print(s) }' > test.sn
./snc test.sn > test.s && test
```