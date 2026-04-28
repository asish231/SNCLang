.global _main
.align 4
.extern _printf
.extern _read
.extern _write

.text
_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #16
    adrp x9, store_val_0@PAGE
    ldr x10, [x9, store_val_0@PAGEOFF]
    stur x10, [x29, #-8]
    adrp x9, store_val_1@PAGE
    ldr x10, [x9, store_val_1@PAGEOFF]
    stur x10, [x29, #-16]
    ldur x11, [x29, #-8]
    adrp x9, store_val_2@PAGE
    ldr x10, [x9, store_val_2@PAGEOFF]
    cmp x11, x10
    cset x11, ge
    stur x11, [x29, #-24]
    ldur x11, [x29, #-24]
    cbz x11, L_snl_1
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_0@PAGE
    ldr x1, [x9, print_val_0@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    b L_snl_2
L_snl_1:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_1@PAGE
    ldr x1, [x9, print_val_1@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_2:
    ldur x11, [x29, #-16]
    adrp x9, store_val_8@PAGE
    ldr x10, [x9, store_val_8@PAGEOFF]
    cmp x11, x10
    cset x11, gt
    stur x11, [x29, #-32]
    ldur x11, [x29, #-32]
    cbz x11, L_snl_3
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_2@PAGE
    ldr x1, [x9, print_val_2@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    b L_snl_4
L_snl_3:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_3@PAGE
    ldr x1, [x9, print_val_3@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_4:
    ldur x11, [x29, #-16]
    adrp x9, store_val_14@PAGE
    ldr x10, [x9, store_val_14@PAGEOFF]
    cmp x11, x10
    cset x11, ne
    stur x11, [x29, #-40]
    ldur x11, [x29, #-40]
    cbz x11, L_snl_5
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_4@PAGE
    ldr x1, [x9, print_val_4@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    b L_snl_6
L_snl_5:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_5@PAGE
    ldr x1, [x9, print_val_5@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_6:
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
    .quad 1
.align 3
print_val_1:
    .quad 0
.align 3
print_val_2:
    .quad 100
.align 3
print_val_3:
    .quad 200
.align 3
print_val_4:
    .quad 300
.align 3
print_val_5:
    .quad 400
.align 3
store_val_0:
    .quad 20
.align 3
store_val_1:
    .quad 45
.align 3
store_val_2:
    .quad 18
.align 3
store_val_8:
    .quad 50
.align 3
store_val_14:
    .quad 45
