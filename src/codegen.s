 .text
 .align 4
 .global _emit_program

_emit_program:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    adrp x0, asm_header@PAGE
    add x0, x0, asm_header@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x19, print_count@PAGE
    add x19, x19, print_count@PAGEOFF
    ldr x20, [x19]
    mov x21, #0

Lemit_body_loop:
    cmp x21, x20
    b.ge Lemit_body_done
    mov x0, x21
    bl _emit_print_call
    add x21, x21, #1
    b Lemit_body_loop

Lemit_body_done:
    adrp x0, asm_data_intro@PAGE
    add x0, x0, asm_data_intro@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    mov x21, #0

Lemit_data_loop:
    cmp x21, x20
    b.ge Lemit_program_done
    mov x0, x21
    bl _emit_print_data
    add x21, x21, #1
    b Lemit_data_loop

Lemit_program_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_emit_print_call:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, x0
    adrp x0, asm_print_fmt_adrp@PAGE
    add x0, x0, asm_print_fmt_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x0, asm_print_val_adrp@PAGE
    add x0, x0, asm_print_val_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_print_val_ldr@PAGE
    add x0, x0, asm_print_val_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_print_call_suffix@PAGE
    add x0, x0, asm_print_call_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_emit_print_data:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    adrp x20, print_values@PAGE
    add x20, x20, print_values@PAGEOFF
    ldr x21, [x20, x19, lsl #3]

    adrp x0, asm_data_value_prefix@PAGE
    add x0, x0, asm_data_value_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_value_mid@PAGE
    add x0, x0, asm_data_value_mid@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x21
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_value_suffix@PAGE
    add x0, x0, asm_data_value_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
