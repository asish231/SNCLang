# snc

`snc` is a tiny programming language compiler written in ARM64 assembly for macOS.

It reads `.sn` source code and emits ARM64 assembly that can be assembled with `clang`.

## Syntax

```sn
fn main() {
    int a = 10
    int b = 4
    int total = a + b * 3
    print(total)
    print(total - 2)
    print((a + b) * 3)
    bool ready = true
    if (total >= 20) {
        print(1)
    } else {
        print(0)
    }
}
```

Supported today:

- `fn main() { ... }`
- `int name = expression`
- `let name = expression;` legacy syntax
- `print(expression)`
- `print expression;` legacy syntax
- integer numbers
- variables
- arithmetic with `+`, `-`, `*`, `/`, and `%`
- parentheses for grouped expressions
- comparisons with `==`, `!=`, `>`, `<`, `>=`, and `<=`
- compile-time `if (...) { ... } else { ... }`
- `bool`, `true`, and `false`
- `const int` and `const bool`
- reassignment with `=`
- assignment shortcuts with `+=`, `-=`, `*=`, and `/=`
- logical `and`, `or`, and `not`
- `// line comments`
- `/* block comments */`

Still planned from `SNLANG_SPEC.md`:

- `str`, `bool`, `dec`, `byte`
- runtime code generation for `if` / `else`
- richer logical precedence
- loops
- functions with parameters and returns
- lists/maps
- blueprints/contracts/OOP
- modules/imports
- pointers, allocation, and concurrency

## Commands

Build the compiler:

```sh
make
```

Emit assembly for the example:

```sh
make run
```

Compile and run the example program:

```sh
make example
```

Run the current language checks:

```sh
make test
```

Compile your own program:

```sh
./snc your_file.sn > /tmp/out.s
clang /tmp/out.s -o /tmp/out
/tmp/out
```
