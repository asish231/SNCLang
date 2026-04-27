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
    mov x0, #1
    adrp x1, input_prompt_0@PAGE
    add x1, x1, input_prompt_0@PAGEOFF
    mov x2, #17
    bl _write
    mov x0, #0
    adrp x1, input_buf_0@PAGE
    add x1, x1, input_buf_0@PAGEOFF
    mov x2, #255
    bl _read
    mov x9, x0
    adrp x10, input_buf_0@PAGE
    add x10, x10, input_buf_0@PAGEOFF
    cmp x9, #0
    b.le L_input_store_0
    sub x11, x9, #1
    ldrb w12, [x10, x11]
    cmp w12, #10
    b.ne L_input_null_0
    strb wzr, [x10, x11]
    b L_input_store_0
L_input_null_0:
    add x11, x10, x9
    strb wzr, [x11]
L_input_store_0:
    stur x10, [x29, #-8]
    adrp x0, print_fmt_str@PAGE
    add x0, x0, print_fmt_str@PAGEOFF
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
input_prompt_0:
    .asciz "Enter your name: "
.align 3
input_buf_0:
    .space 256
