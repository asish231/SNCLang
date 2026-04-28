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
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_0@PAGE
    ldr x1, [x9, print_val_0@PAGEOFF]
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
    adrp x9, store_val_4@PAGE
    ldr x10, [x9, store_val_4@PAGEOFF]
    stur x10, [x29, #-8]
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_2@PAGE
    ldr x1, [x9, print_val_2@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x9, store_val_6@PAGE
    ldr x10, [x9, store_val_6@PAGEOFF]
    stur x10, [x29, #-8]
    adrp x9, store_val_7@PAGE
    ldr x10, [x9, store_val_7@PAGEOFF]
    stur x10, [x29, #-16]
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_3@PAGE
    ldr x1, [x9, print_val_3@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x9, store_val_9@PAGE
    ldr x10, [x9, store_val_9@PAGEOFF]
    stur x10, [x29, #-8]
    adrp x9, store_val_10@PAGE
    ldr x10, [x9, store_val_10@PAGEOFF]
    stur x10, [x29, #-16]
    ldur x11, [x29, #-8]
    ldur x10, [x29, #-16]
    cmp x11, x10
    cset x11, gt
    stur x11, [x29, #-24]
    ldur x11, [x29, #-24]
    cbz x11, L_snl_1
    b L_snl_2
L_snl_1:
L_snl_2:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_4@PAGE
    ldr x1, [x9, print_val_4@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x9, store_val_16@PAGE
    ldr x10, [x9, store_val_16@PAGEOFF]
    stur x10, [x29, #-8]
    adrp x9, store_val_17@PAGE
    ldr x10, [x9, store_val_17@PAGEOFF]
    stur x10, [x29, #-16]
    ldur x11, [x29, #-8]
    ldur x10, [x29, #-16]
    cmp x11, x10
    cset x11, gt
    stur x11, [x29, #-24]
    ldur x11, [x29, #-24]
    cbz x11, L_snl_3
    b L_snl_4
L_snl_3:
L_snl_4:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_5@PAGE
    ldr x1, [x9, print_val_5@PAGEOFF]
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
    .quad 42
.align 3
print_val_1:
    .quad 42
.align 3
print_val_2:
    .quad 10
.align 3
print_val_3:
    .quad 10
.align 3
print_val_4:
    .quad 7
.align 3
print_val_5:
    .quad 7
.align 3
store_val_0:
    .quad 20
.align 3
store_val_1:
    .quad 22
.align 3
store_val_4:
    .quad 5
.align 3
store_val_6:
    .quad 3
.align 3
store_val_7:
    .quad 7
.align 3
store_val_9:
    .quad 10
.align 3
store_val_10:
    .quad 3
.align 3
store_val_16:
    .quad 3
.align 3
store_val_17:
    .quad 10
