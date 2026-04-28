.global _main
.align 4
.extern _printf
.extern _read
.extern _write

.text
_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #48
    adrp x9, store_val_0@PAGE
    ldr x10, [x9, store_val_0@PAGEOFF]
    stur x10, [x29, #-8]
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_0@PAGE
    add x1, x1, print_val_0@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x9, store_val_2@PAGE
    ldr x10, [x9, store_val_2@PAGEOFF]
    stur x10, [x29, #-16]
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_1@PAGE
    add x1, x1, print_val_1@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_2@PAGE
    add x1, x1, print_val_2@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_3@PAGE
    add x1, x1, print_val_3@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_4@PAGE
    add x1, x1, print_val_4@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    ldur x11, [x29, #-8]
    ldur x10, [x29, #-16]
    cmp x11, x10
    cset x11, gt
    stur x11, [x29, #-24]
    ldur x11, [x29, #-24]
    cbz x11, L_snl_1
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_5@PAGE
    add x1, x1, print_val_5@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    b L_snl_2
L_snl_1:
L_snl_2:
    adrp x9, store_val_12@PAGE
    ldr x10, [x9, store_val_12@PAGEOFF]
    stur x10, [x29, #-32]
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_6@PAGE
    add x1, x1, print_val_6@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    adrp x9, print_val_7@PAGE
    ldr x1, [x9, print_val_7@PAGEOFF]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_8@PAGE
    add x1, x1, print_val_8@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x9, store_val_16@PAGE
    ldr x10, [x9, store_val_16@PAGEOFF]
    stur x10, [x29, #-40]
    adrp x9, store_val_17@PAGE
    ldr x10, [x9, store_val_17@PAGEOFF]
    stur x10, [x29, #-48]
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_9@PAGE
    add x1, x1, print_val_9@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x9, store_val_19@PAGE
    ldr x10, [x9, store_val_19@PAGEOFF]
    stur x10, [x29, #-40]
L_snl_3:
    ldur x11, [x29, #-40]
    adrp x9, store_val_21@PAGE
    ldr x10, [x9, store_val_21@PAGEOFF]
    cmp x11, x10
    cset x11, lt
    stur x11, [x29, #-48]
    ldur x11, [x29, #-48]
    cbz x11, L_snl_4
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
    adrp x1, print_val_10@PAGE
    add x1, x1, print_val_10@PAGEOFF
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x9, store_val_24@PAGE
    ldr x10, [x9, store_val_24@PAGEOFF]
    stur x10, [x29, #-40]
    b L_snl_3
L_snl_4:
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
    .asciz "99.50"
.align 3
print_val_1:
    .asciz "109.75"
.align 3
print_val_2:
    .asciz "89.25"
.align 3
print_val_3:
    .asciz "1019.87"
.align 3
print_val_4:
    .asciz "9.70"
.align 3
print_val_5:
    .asciz "99.50"
.align 3
print_val_6:
    .asciz "42.00"
.align 3
print_val_7:
    .quad 42
.align 3
print_val_8:
    .asciz "42.000"
.align 3
print_val_9:
    .asciz "11.50"
.align 3
print_val_10:
    .asciz "1.20"
.align 3
store_val_0:
    .quad 9950
.align 3
store_val_2:
    .quad 1025
.align 3
store_val_12:
    .quad 4200
.align 3
store_val_16:
    .quad 1000
.align 3
store_val_17:
    .quad 150
.align 3
store_val_19:
    .quad 120
.align 3
store_val_21:
    .quad 320
.align 3
store_val_24:
    .quad 220
