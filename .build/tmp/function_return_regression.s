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
    adrp x9, store_val_1@PAGE
    ldr x10, [x9, store_val_1@PAGEOFF]
    stur x10, [x29, #-16]
    adrp x9, store_val_2@PAGE
    ldr x10, [x9, store_val_2@PAGEOFF]
    stur x10, [x29, #-24]
    adrp x9, store_val_3@PAGE
    ldr x10, [x9, store_val_3@PAGEOFF]
    stur x10, [x29, #-32]
    ldur x11, [x29, #-32]
    ldur x10, [x29, #-24]
    add x11, x11, x10
    stur x11, [x29, #-32]
    ldur x11, [x29, #-32]
    adrp x9, store_val_5@PAGE
    ldr x10, [x9, store_val_5@PAGEOFF]
    cmp x11, x10
    cset x11, gt
    stur x11, [x29, #-40]
    ldur x11, [x29, #-40]
    cbz x11, L_snl_1
    b L_snl_2
L_snl_1:
L_snl_2:
    adrp x9, store_val_9@PAGE
    ldr x10, [x9, store_val_9@PAGEOFF]
    stur x10, [x29, #-16]
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-16]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
    adrp x9, store_val_11@PAGE
    ldr x10, [x9, store_val_11@PAGEOFF]
    stur x10, [x29, #-24]
    adrp x9, store_val_12@PAGE
    ldr x10, [x9, store_val_12@PAGEOFF]
    stur x10, [x29, #-32]
    adrp x9, store_val_13@PAGE
    ldr x10, [x9, store_val_13@PAGEOFF]
    stur x10, [x29, #-40]
    ldur x11, [x29, #-40]
    ldur x10, [x29, #-32]
    add x11, x11, x10
    stur x11, [x29, #-40]
    ldur x11, [x29, #-40]
    adrp x9, store_val_15@PAGE
    ldr x10, [x9, store_val_15@PAGEOFF]
    cmp x11, x10
    cset x11, gt
    stur x11, [x29, #-48]
    ldur x11, [x29, #-48]
    cbz x11, L_snl_3
    b L_snl_4
L_snl_3:
L_snl_4:
    adrp x9, store_val_19@PAGE
    ldr x10, [x9, store_val_19@PAGEOFF]
    stur x10, [x29, #-24]
    adrp x0, print_fmt_int@PAGE
    add x0, x0, print_fmt_int@PAGEOFF
    ldur x1, [x29, #-24]
    sub sp, sp, #16
    str x1, [sp]
    bl _printf
    add sp, sp, #16
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
    .quad 50
.align 3
store_val_1:
    .quad 20
.align 3
store_val_2:
    .quad 5
.align 3
store_val_3:
    .quad 20
.align 3
store_val_5:
    .quad 60
.align 3
store_val_9:
    .quad 50
.align 3
store_val_11:
    .quad 55
.align 3
store_val_12:
    .quad 10
.align 3
store_val_13:
    .quad 55
.align 3
store_val_15:
    .quad 60
.align 3
store_val_19:
    .quad 65
