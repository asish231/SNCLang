.global _main
.align 4
.extern _printf
.extern _read
.extern _write

.text
_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #208
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
    ldur x11, [x29, #-8]
    adrp x9, store_val_4@PAGE
    ldr x10, [x9, store_val_4@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-24]
    ldur x11, [x29, #-24]
    cbz x11, L_snl_4
    b L_snl_5
L_snl_4:
L_snl_5:
    ldur x11, [x29, #-8]
    adrp x9, store_val_8@PAGE
    ldr x10, [x9, store_val_8@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-32]
    ldur x11, [x29, #-32]
    cbz x11, L_snl_6
    b L_snl_7
L_snl_6:
L_snl_7:
    ldur x11, [x29, #-0]
    adrp x9, store_val_12@PAGE
    ldr x10, [x9, store_val_12@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-40]
    ldur x11, [x29, #-40]
    cbz x11, L_snl_8
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-8]
    adrp x9, store_val_14@PAGE
    ldr x10, [x9, store_val_14@PAGEOFF]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    b L_snl_9
L_snl_8:
L_snl_9:
L_snl_3:
    ldur x11, [x29, #-8]
    adrp x9, store_val_18@PAGE
    ldr x10, [x9, store_val_18@PAGEOFF]
    add x11, x11, x10
    stur x11, [x29, #-8]
    b L_snl_1
L_snl_2:
    adrp x9, store_val_20@PAGE
    ldr x10, [x9, store_val_20@PAGEOFF]
    stur x10, [x29, #-56]
    ldur x11, [x29, #-56]
    adrp x9, store_val_21@PAGE
    ldr x10, [x9, store_val_21@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-64]
    ldur x11, [x29, #-64]
    cbz x11, L_snl_12
    b L_snl_13
L_snl_12:
L_snl_13:
    ldur x11, [x29, #-56]
    adrp x9, store_val_25@PAGE
    ldr x10, [x9, store_val_25@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-72]
    ldur x11, [x29, #-72]
    cbz x11, L_snl_14
    b L_snl_15
L_snl_14:
L_snl_15:
    ldur x11, [x29, #-0]
    adrp x9, store_val_29@PAGE
    ldr x10, [x9, store_val_29@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-80]
    ldur x11, [x29, #-80]
    cbz x11, L_snl_16
    b L_snl_17
L_snl_16:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-56]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_17:
L_snl_11:
    adrp x9, store_val_35@PAGE
    ldr x10, [x9, store_val_35@PAGEOFF]
    stur x10, [x29, #-56]
    ldur x11, [x29, #-56]
    adrp x9, store_val_36@PAGE
    ldr x10, [x9, store_val_36@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-88]
    ldur x11, [x29, #-88]
    cbz x11, L_snl_19
    b L_snl_18
    b L_snl_20
L_snl_19:
L_snl_20:
    ldur x11, [x29, #-56]
    adrp x9, store_val_41@PAGE
    ldr x10, [x9, store_val_41@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-96]
    ldur x11, [x29, #-96]
    cbz x11, L_snl_21
    b L_snl_22
L_snl_21:
L_snl_22:
    ldur x11, [x29, #-0]
    adrp x9, store_val_45@PAGE
    ldr x10, [x9, store_val_45@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-104]
    ldur x11, [x29, #-104]
    cbz x11, L_snl_23
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-56]
    adrp x9, store_val_47@PAGE
    ldr x10, [x9, store_val_47@PAGEOFF]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    b L_snl_24
L_snl_23:
L_snl_24:
L_snl_18:
    adrp x9, store_val_51@PAGE
    ldr x10, [x9, store_val_51@PAGEOFF]
    stur x10, [x29, #-56]
    ldur x11, [x29, #-56]
    adrp x9, store_val_52@PAGE
    ldr x10, [x9, store_val_52@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-112]
    ldur x11, [x29, #-112]
    cbz x11, L_snl_26
    b L_snl_27
L_snl_26:
L_snl_27:
    ldur x11, [x29, #-56]
    adrp x9, store_val_56@PAGE
    ldr x10, [x9, store_val_56@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-120]
    ldur x11, [x29, #-120]
    cbz x11, L_snl_28
    b L_snl_29
L_snl_28:
L_snl_29:
    ldur x11, [x29, #-0]
    adrp x9, store_val_60@PAGE
    ldr x10, [x9, store_val_60@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-128]
    ldur x11, [x29, #-128]
    cbz x11, L_snl_30
    b L_snl_31
L_snl_30:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-56]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_31:
L_snl_25:
    adrp x9, store_val_66@PAGE
    ldr x10, [x9, store_val_66@PAGEOFF]
    stur x10, [x29, #-56]
    ldur x11, [x29, #-56]
    adrp x9, store_val_67@PAGE
    ldr x10, [x9, store_val_67@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-136]
    ldur x11, [x29, #-136]
    cbz x11, L_snl_33
    b L_snl_34
L_snl_33:
L_snl_34:
    ldur x11, [x29, #-56]
    adrp x9, store_val_71@PAGE
    ldr x10, [x9, store_val_71@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-144]
    ldur x11, [x29, #-144]
    cbz x11, L_snl_35
    b L_snl_36
L_snl_35:
L_snl_36:
    ldur x11, [x29, #-0]
    adrp x9, store_val_75@PAGE
    ldr x10, [x9, store_val_75@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-152]
    ldur x11, [x29, #-152]
    cbz x11, L_snl_37
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-56]
    adrp x9, store_val_77@PAGE
    ldr x10, [x9, store_val_77@PAGEOFF]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    b L_snl_38
L_snl_37:
L_snl_38:
L_snl_32:
    adrp x9, store_val_81@PAGE
    ldr x10, [x9, store_val_81@PAGEOFF]
    stur x10, [x29, #-56]
    ldur x11, [x29, #-56]
    adrp x9, store_val_82@PAGE
    ldr x10, [x9, store_val_82@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-160]
    ldur x11, [x29, #-160]
    cbz x11, L_snl_40
    b L_snl_41
L_snl_40:
L_snl_41:
    ldur x11, [x29, #-56]
    adrp x9, store_val_86@PAGE
    ldr x10, [x9, store_val_86@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-168]
    ldur x11, [x29, #-168]
    cbz x11, L_snl_42
    b L_snl_10
    b L_snl_43
L_snl_42:
L_snl_43:
    ldur x11, [x29, #-0]
    adrp x9, store_val_91@PAGE
    ldr x10, [x9, store_val_91@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-176]
    ldur x11, [x29, #-176]
    cbz x11, L_snl_44
    b L_snl_45
L_snl_44:
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-56]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
L_snl_45:
L_snl_39:
    adrp x9, store_val_97@PAGE
    ldr x10, [x9, store_val_97@PAGEOFF]
    stur x10, [x29, #-56]
    ldur x11, [x29, #-56]
    adrp x9, store_val_98@PAGE
    ldr x10, [x9, store_val_98@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-184]
    ldur x11, [x29, #-184]
    cbz x11, L_snl_47
    b L_snl_48
L_snl_47:
L_snl_48:
    ldur x11, [x29, #-56]
    adrp x9, store_val_102@PAGE
    ldr x10, [x9, store_val_102@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-192]
    ldur x11, [x29, #-192]
    cbz x11, L_snl_49
    b L_snl_50
L_snl_49:
L_snl_50:
    ldur x11, [x29, #-0]
    adrp x9, store_val_106@PAGE
    ldr x10, [x9, store_val_106@PAGEOFF]
    cmp x11, x10
    cset x11, eq
    stur x11, [x29, #-200]
    ldur x11, [x29, #-200]
    cbz x11, L_snl_51
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-56]
    adrp x9, store_val_108@PAGE
    ldr x10, [x9, store_val_108@PAGEOFF]
    mul x1, x1, x10
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    b L_snl_52
L_snl_51:
L_snl_52:
L_snl_46:
L_snl_10:
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
    .quad 0
.align 3
store_val_2:
    .quad 8
.align 3
store_val_4:
    .quad 2
.align 3
store_val_8:
    .quad 6
.align 3
store_val_12:
    .quad 0
.align 3
store_val_14:
    .quad 10
.align 3
store_val_18:
    .quad 1
.align 3
store_val_20:
    .quad 1
.align 3
store_val_21:
    .quad 2
.align 3
store_val_25:
    .quad 5
.align 3
store_val_29:
    .quad 0
.align 3
store_val_35:
    .quad 2
.align 3
store_val_36:
    .quad 2
.align 3
store_val_41:
    .quad 5
.align 3
store_val_45:
    .quad 0
.align 3
store_val_47:
    .quad 100
.align 3
store_val_51:
    .quad 3
.align 3
store_val_52:
    .quad 2
.align 3
store_val_56:
    .quad 5
.align 3
store_val_60:
    .quad 0
.align 3
store_val_66:
    .quad 4
.align 3
store_val_67:
    .quad 2
.align 3
store_val_71:
    .quad 5
.align 3
store_val_75:
    .quad 0
.align 3
store_val_77:
    .quad 100
.align 3
store_val_81:
    .quad 5
.align 3
store_val_82:
    .quad 2
.align 3
store_val_86:
    .quad 5
.align 3
store_val_91:
    .quad 0
.align 3
store_val_97:
    .quad 6
.align 3
store_val_98:
    .quad 2
.align 3
store_val_102:
    .quad 5
.align 3
store_val_106:
    .quad 0
.align 3
store_val_108:
    .quad 100
