# snc

`snc` is a tiny programming language compiler written in ARM64 assembly.

It reads `.sn` source code and emits ARM64 assembly that can be assembled with `clang`.

The source now includes a small platform macro layer for Mach-O and COFF symbol
differences, so the compiler and emitted assembly can be built for:

- macOS on ARM64
- Windows on ARM64

It is still an ARM64 codebase, so a typical x64 Windows machine can cross-build
it but cannot run the resulting `snc.exe` natively.

## Architecture

The compiler is split by responsibility:

- `src/main.s` - entry point, argument handling, source file loading
- `src/lexer.s` - cursor movement, whitespace, and comment skipping
- `src/parser.s` - statements, expressions, conditions, and blocks
- `src/vars.s` - variable storage, constants, assignment, and print records
- `src/codegen.s` - generated ARM64 assembly output
- `src/utils.s` - string matching, error reporting, and write helpers
- `src/data.s` - shared messages, keywords, buffers, and compiler state

The old single-file version is archived at `archive/snc.monolith.s`.

Code generation currently emits runtime `printf` calls for integer output. Most
expressions are still evaluated by the compiler before emission. Integer and
boolean variables now have runtime slots in emitted programs for declarations,
assignments, direct `print(var)` loads, and simple runtime arithmetic of the form
`print(x + 2)` and `x = x + 3`.

For a conservative status view of spec vs README vs current source support, see
`FEATURE_MATRIX.md`.

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
    str name = "Asish"
    print(name)
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
- `else if (...) { ... }`
- `while (...) { ... }`
- `bool`, `true`, and `false`
- `byte`
- `str` string variables
- `const str`
- string literals in `print(...)`
- `input("prompt")` for `str` declarations/assignments (first-cut runtime path)
- `use module.path` syntax
- `match (...) { ... default { ... } }` with compile-time execution
- runtime slots for `int` / `bool` declarations and assignments
- runtime `print(var)` loads for `int` / `bool`
- runtime arithmetic for `print(var op number)` where `op` is `+ - * / %`
- runtime arithmetic for `x = x op number` where `op` is `+ - * / %`
- runtime arithmetic for `print(var op var)` where `op` is `+ - * / %`
- runtime arithmetic for `x = x op var` where `op` is `+ - * / %`
- runtime target assignments like `out = x + y` and `out = x + 7`
- exponent with `**`
- `const int` and `const bool`
- reassignment with `=`
- assignment shortcuts with `+=`, `-=`, `*=`, and `/=`
- logical `and`, `or`, and `not`
- `// line comments`
- `/* block comments */`

Still planned from `SNLANG_SPEC.md`:

- string concatenation
- `dec`, `byte`
- full runtime expression evaluation
- runtime code generation for `if` / `else`
- richer logical precedence
- `for`
- `for in`
- `stop` / `skip`
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

On PowerShell, you can also build without `make`:

```powershell
./build.ps1
```

To cross-build from Windows for ARM64 explicitly:

```powershell
./build.ps1 -Target aarch64-windows-msvc
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

On Windows ARM64, the generated assembly now expects COFF/Windows-style symbol
resolution and `printf` naming automatically when the assembler target is
Windows.
