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
    stur x10, [x29, #-8]
    adrp x9, store_val_1@PAGE
    ldr x10, [x9, store_val_1@PAGEOFF]
    stur x10, [x29, #-16]
    adrp x9, store_val_2@PAGE
    ldr x10, [x9, store_val_2@PAGEOFF]
    stur x10, [x29, #-24]
    ldur x11, [x29, #-8]
    ldur x10, [x29, #-16]
    add x11, x11, x10
    stur x11, [x29, #-24]
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    ldur x11, [x29, #-8]
    ldur x10, [x29, #-16]
    mul x11, x11, x10
    stur x11, [x29, #-24]
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    ldur x11, [x29, #-8]
    adrp x9, store_val_7@PAGE
    ldr x10, [x9, store_val_7@PAGEOFF]
    add x11, x11, x10
    stur x11, [x29, #-24]
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
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
store_val_0:
    .quad 5
.align 3
store_val_1:
    .quad 3
.align 3
store_val_2:
    .quad 0
.align 3
store_val_7:
    .quad 7
