.global _main
.align 4
.extern _printf
.extern _read
.extern _write

.text
_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32
    adrp x9, store_val_0@PAGE
    ldr x10, [x9, store_val_0@PAGEOFF]
    stur x10, [x29, #-16]
    adrp x9, store_val_1@PAGE
    ldr x10, [x9, store_val_1@PAGEOFF]
    stur x10, [x29, #-24]
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_0@PAGE
    add x1, x1, print_val_0@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-16]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_1@PAGE
    ldr x1, [x9, print_val_1@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_2@PAGE
    ldr x1, [x9, print_val_2@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    mov w0, #0
    mov sp, x29
    ldp x29, x30, [sp], #16
    ret

.data
print_fmt_int:
    .asciz "%lld\n"
print_fmt_str:
    .asciz "%s\n"
.align 3
.align 3
print_val_0:
    .asciz "SNlang"
.align 3
print_val_1:
    .quad 400
.align 3
print_val_2:
    .quad 2
.align 3
store_val_0:
    .quad 4
.align 3
store_val_1:
    .quad 32
