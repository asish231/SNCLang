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
    ldur x11, [x29, #-24]
    adrp x9, store_val_3@PAGE
    ldr x10, [x9, store_val_3@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-32]
    ldur x11, [x29, #-32]
    cbz x11, L_snl_3
    b L_snl_2
    b L_snl_4
L_snl_3:
L_snl_4:
    ldur x11, [x29, #-24]
    adrp x9, store_val_8@PAGE
    ldr x10, [x9, store_val_8@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-40]
    ldur x11, [x29, #-40]
    cbz x11, L_snl_5
    b L_snl_1
    b L_snl_6
L_snl_5:
L_snl_6:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    ldur x10, [x29, #-16]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_2:
    adrp x9, store_val_15@PAGE
    ldr x10, [x9, store_val_15@PAGEOFF]
    stur x10, [x29, #-24]
    ldur x11, [x29, #-24]
    adrp x9, store_val_16@PAGE
    ldr x10, [x9, store_val_16@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-48]
    ldur x11, [x29, #-48]
    cbz x11, L_snl_8
    b L_snl_7
    b L_snl_9
L_snl_8:
L_snl_9:
    ldur x11, [x29, #-24]
    adrp x9, store_val_21@PAGE
    ldr x10, [x9, store_val_21@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-56]
    ldur x11, [x29, #-56]
    cbz x11, L_snl_10
    b L_snl_1
    b L_snl_11
L_snl_10:
L_snl_11:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    ldur x10, [x29, #-16]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_7:
    adrp x9, store_val_28@PAGE
    ldr x10, [x9, store_val_28@PAGEOFF]
    stur x10, [x29, #-24]
    ldur x11, [x29, #-24]
    adrp x9, store_val_29@PAGE
    ldr x10, [x9, store_val_29@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-64]
    ldur x11, [x29, #-64]
    cbz x11, L_snl_13
    b L_snl_12
    b L_snl_14
L_snl_13:
L_snl_14:
    ldur x11, [x29, #-24]
    adrp x9, store_val_34@PAGE
    ldr x10, [x9, store_val_34@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-72]
    ldur x11, [x29, #-72]
    cbz x11, L_snl_15
    b L_snl_1
    b L_snl_16
L_snl_15:
L_snl_16:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    ldur x10, [x29, #-16]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_12:
    adrp x9, store_val_41@PAGE
    ldr x10, [x9, store_val_41@PAGEOFF]
    stur x10, [x29, #-24]
    ldur x11, [x29, #-24]
    adrp x9, store_val_42@PAGE
    ldr x10, [x9, store_val_42@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-80]
    ldur x11, [x29, #-80]
    cbz x11, L_snl_18
    b L_snl_17
    b L_snl_19
L_snl_18:
L_snl_19:
    ldur x11, [x29, #-24]
    adrp x9, store_val_47@PAGE
    ldr x10, [x9, store_val_47@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-88]
    ldur x11, [x29, #-88]
    cbz x11, L_snl_20
    b L_snl_1
    b L_snl_21
L_snl_20:
L_snl_21:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    ldur x10, [x29, #-16]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_17:
    adrp x9, store_val_54@PAGE
    ldr x10, [x9, store_val_54@PAGEOFF]
    stur x10, [x29, #-24]
    ldur x11, [x29, #-24]
    adrp x9, store_val_55@PAGE
    ldr x10, [x9, store_val_55@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-96]
    ldur x11, [x29, #-96]
    cbz x11, L_snl_23
    b L_snl_22
    b L_snl_24
L_snl_23:
L_snl_24:
    ldur x11, [x29, #-24]
    adrp x9, store_val_60@PAGE
    ldr x10, [x9, store_val_60@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-104]
    ldur x11, [x29, #-104]
    cbz x11, L_snl_25
    b L_snl_1
    b L_snl_26
L_snl_25:
L_snl_26:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    ldur x10, [x29, #-16]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_22:
L_snl_1:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-8]
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
    .quad 10
.align 3
store_val_1:
    .quad 5
.align 3
store_val_2:
    .quad 1
.align 3
store_val_3:
    .quad 3
.align 3
store_val_8:
    .quad 5
.align 3
store_val_15:
    .quad 2
.align 3
store_val_16:
    .quad 3
.align 3
store_val_21:
    .quad 5
.align 3
store_val_28:
    .quad 3
.align 3
store_val_29:
    .quad 3
.align 3
store_val_34:
    .quad 5
.align 3
store_val_41:
    .quad 4
.align 3
store_val_42:
    .quad 3
.align 3
store_val_47:
    .quad 5
.align 3
store_val_54:
    .quad 5
.align 3
store_val_55:
    .quad 3
.align 3
store_val_60:
    .quad 5
