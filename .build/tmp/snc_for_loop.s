.global _main
.align 4
.extern _printf
.extern _read
.extern _write

.text
_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #160
    adrp x9, store_val_0@PAGE
    ldr x10, [x9, store_val_0@PAGEOFF]
    stur x10, [x29, #-8]
L_snl_1:
    ldur x11, [x29, #-8]
    adrp x9, store_val_2@PAGE
    ldr x10, [x9, store_val_2@PAGEOFF]
    cmp x11, x10
    cset x11, lt
    stur x11, [x29, #-16]
    ldur x11, [x29, #-16]
    cbz x11, L_snl_2
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-8]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_3:
    ldur x11, [x29, #-8]
    adrp x9, store_val_6@PAGE
    ldr x10, [x9, store_val_6@PAGEOFF]
    add x11, x11, x10
    stur x11, [x29, #-8]
    b L_snl_1
L_snl_2:
    adrp x9, store_val_8@PAGE
    ldr x10, [x9, store_val_8@PAGEOFF]
    stur x10, [x29, #-24]
L_snl_4:
    ldur x11, [x29, #-24]
    adrp x9, store_val_10@PAGE
    ldr x10, [x9, store_val_10@PAGEOFF]
    cmp x11, x10
    cset x11, lt
    stur x11, [x29, #-32]
    ldur x11, [x29, #-32]
    cbz x11, L_snl_5
    ldur x11, [x29, #-24]
    adrp x9, store_val_12@PAGE
    ldr x10, [x9, store_val_12@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-40]
    ldur x11, [x29, #-40]
    cbz x11, L_snl_7
    b L_snl_5
    b L_snl_8
L_snl_7:
L_snl_8:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_6:
    ldur x11, [x29, #-24]
    adrp x9, store_val_19@PAGE
    ldr x10, [x9, store_val_19@PAGEOFF]
    add x11, x11, x10
    stur x11, [x29, #-24]
    b L_snl_4
L_snl_5:
    adrp x9, store_val_21@PAGE
    ldr x10, [x9, store_val_21@PAGEOFF]
    stur x10, [x29, #-48]
L_snl_9:
    ldur x11, [x29, #-48]
    adrp x9, store_val_23@PAGE
    ldr x10, [x9, store_val_23@PAGEOFF]
    cmp x11, x10
    cset x11, lt
    stur x11, [x29, #-56]
    ldur x11, [x29, #-56]
    cbz x11, L_snl_10
    ldur x11, [x29, #-48]
    adrp x9, store_val_25@PAGE
    ldr x10, [x9, store_val_25@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-64]
    ldur x11, [x29, #-64]
    cbz x11, L_snl_12
    b L_snl_11
    b L_snl_13
L_snl_12:
L_snl_13:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-48]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_11:
    ldur x11, [x29, #-48]
    adrp x9, store_val_32@PAGE
    ldr x10, [x9, store_val_32@PAGEOFF]
    add x11, x11, x10
    stur x11, [x29, #-48]
    b L_snl_9
L_snl_10:
    adrp x9, store_val_34@PAGE
    ldr x10, [x9, store_val_34@PAGEOFF]
    stur x10, [x29, #-72]
L_snl_14:
    ldur x11, [x29, #-72]
    adrp x9, store_val_36@PAGE
    ldr x10, [x9, store_val_36@PAGEOFF]
    cmp x11, x10
    cset x11, lt
    stur x11, [x29, #-80]
    ldur x11, [x29, #-80]
    cbz x11, L_snl_15
    ldur x11, [x29, #-72]
    adrp x9, store_val_38@PAGE
    ldr x10, [x9, store_val_38@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-88]
    ldur x11, [x29, #-88]
    cbz x11, L_snl_16
    b L_snl_15
    b L_snl_17
L_snl_16:
L_snl_17:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-72]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    ldur x11, [x29, #-72]
    adrp x9, store_val_44@PAGE
    ldr x10, [x9, store_val_44@PAGEOFF]
    add x11, x11, x10
    stur x11, [x29, #-72]
    b L_snl_14
L_snl_15:
    adrp x9, store_val_46@PAGE
    ldr x10, [x9, store_val_46@PAGEOFF]
    stur x10, [x29, #-104]
    ldur x11, [x29, #-104]
    adrp x9, store_val_47@PAGE
    ldr x10, [x9, store_val_47@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-112]
    ldur x11, [x29, #-112]
    cbz x11, L_snl_20
    b L_snl_19
    b L_snl_21
L_snl_20:
L_snl_21:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-104]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_19:
    adrp x9, store_val_54@PAGE
    ldr x10, [x9, store_val_54@PAGEOFF]
    stur x10, [x29, #-104]
    ldur x11, [x29, #-104]
    adrp x9, store_val_55@PAGE
    ldr x10, [x9, store_val_55@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-120]
    ldur x11, [x29, #-120]
    cbz x11, L_snl_23
    b L_snl_22
    b L_snl_24
L_snl_23:
L_snl_24:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-104]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_22:
    adrp x9, store_val_62@PAGE
    ldr x10, [x9, store_val_62@PAGEOFF]
    stur x10, [x29, #-104]
    ldur x11, [x29, #-104]
    adrp x9, store_val_63@PAGE
    ldr x10, [x9, store_val_63@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-128]
    ldur x11, [x29, #-128]
    cbz x11, L_snl_26
    b L_snl_25
    b L_snl_27
L_snl_26:
L_snl_27:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-104]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_25:
    adrp x9, store_val_70@PAGE
    ldr x10, [x9, store_val_70@PAGEOFF]
    stur x10, [x29, #-104]
    ldur x11, [x29, #-104]
    adrp x9, store_val_71@PAGE
    ldr x10, [x9, store_val_71@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-136]
    ldur x11, [x29, #-136]
    cbz x11, L_snl_29
    b L_snl_28
    b L_snl_30
L_snl_29:
L_snl_30:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-104]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_28:
L_snl_18:
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_0@PAGE
    add x1, x1, print_val_0@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_32:
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_1@PAGE
    add x1, x1, print_val_1@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_33:
L_snl_31:
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
    .asciz "Apple"
.align 3
print_val_1:
    .asciz "Banana"
.align 3
store_val_0:
    .quad 0
.align 3
store_val_2:
    .quad 5
.align 3
store_val_6:
    .quad 1
.align 3
store_val_8:
    .quad 10
.align 3
store_val_10:
    .quad 20
.align 3
store_val_12:
    .quad 13
.align 3
store_val_19:
    .quad 1
.align 3
store_val_21:
    .quad 0
.align 3
store_val_23:
    .quad 5
.align 3
store_val_25:
    .quad 2
.align 3
store_val_32:
    .quad 1
.align 3
store_val_34:
    .quad 100
.align 3
store_val_36:
    .quad 200
.align 3
store_val_38:
    .quad 103
.align 3
store_val_44:
    .quad 1
.align 3
store_val_46:
    .quad 7
.align 3
store_val_47:
    .quad 9
.align 3
store_val_54:
    .quad 8
.align 3
store_val_55:
    .quad 9
.align 3
store_val_62:
    .quad 9
.align 3
store_val_63:
    .quad 9
.align 3
store_val_70:
    .quad 10
.align 3
store_val_71:
    .quad 9
