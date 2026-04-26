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
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    adrp x20, print_types@PAGE
    add x20, x20, print_types@PAGEOFF
    ldr x21, [x20, x19, lsl #3]

    cmp x21, #2 // type 2 is string
    b.eq Lemit_print_str_fmt

    adrp x0, asm_print_fmt_int_adrp@PAGE
    add x0, x0, asm_print_fmt_int_adrp@PAGEOFF
    b Lemit_print_fmt_done

Lemit_print_str_fmt:
    adrp x0, asm_print_fmt_str_adrp@PAGE
    add x0, x0, asm_print_fmt_str_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_print_str_val_adrp@PAGE
    add x0, x0, asm_print_str_val_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_print_str_val_add@PAGE
    add x0, x0, asm_print_str_val_add@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_print_call_stack@PAGE
    add x0, x0, asm_print_call_stack@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_print_call_done

Lemit_print_fmt_done:
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

Lemit_print_call_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_emit_print_data:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!

    mov x19, x0 // print id
    adrp x20, print_types@PAGE
    add x20, x20, print_types@PAGEOFF
    ldr x23, [x20, x19, lsl #3] // type

    adrp x20, print_values@PAGE
    add x20, x20, print_values@PAGEOFF
    ldr x21, [x20, x19, lsl #3] // value (ptr for str)

    adrp x0, asm_data_value_prefix@PAGE
    add x0, x0, asm_data_value_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd

    cmp x23, #2 // string
    b.eq Lemit_data_str

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
    b Lemit_data_done

Lemit_data_str:
    adrp x0, asm_data_value_mid_str@PAGE
    add x0, x0, asm_data_value_mid_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x20, print_lengths@PAGE
    add x20, x20, print_lengths@PAGEOFF
    ldr x22, [x20, x19, lsl #3] // length

    mov x0, x21
    mov x1, x22
    mov x2, #1
    bl _write_buffer_fd

    adrp x0, asm_data_value_suffix_str@PAGE
    add x0, x0, asm_data_value_suffix_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

Lemit_data_done:
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
