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

    adrp x19, var_count@PAGE
    add x19, x19, var_count@PAGEOFF
    ldr x19, [x19]
    mov x20, #8
    mul x19, x19, x20
    add x19, x19, #15
    and x19, x19, #0xFFFFFFFFFFFFFFF0
    cbz x19, Lemit_no_stack_alloc

    adrp x0, asm_sub_sp_prefix@PAGE
    add x0, x0, asm_sub_sp_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    mov x0, x19
    mov x1, #1
    bl _write_i64_fd

    adrp x0, single_char@PAGE
    add x0, x0, single_char@PAGEOFF
    mov w9, #'\n'
    strb w9, [x0]
    mov x1, #1
    mov x2, #1
    bl _write_buffer_fd

Lemit_no_stack_alloc:

    adrp x19, op_count@PAGE
    add x19, x19, op_count@PAGEOFF
    ldr x20, [x19]
    mov x21, #0

Lemit_body_loop:
    cmp x21, x20
    b.ge Lemit_body_done
    mov x0, x21
    bl _emit_operation
    add x21, x21, #1
    b Lemit_body_loop

Lemit_body_done:
    adrp x0, asm_data_intro@PAGE
    add x0, x0, asm_data_intro@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    mov x21, #0

Lemit_data_loop:
    adrp x19, print_count@PAGE
    add x19, x19, print_count@PAGEOFF
    ldr x20, [x19]
    cmp x21, x20
    b.ge Lemit_store_data_begin
    mov x0, x21
    bl _emit_print_data
    add x21, x21, #1
    b Lemit_data_loop

Lemit_store_data_begin:
    adrp x19, op_count@PAGE
    add x19, x19, op_count@PAGEOFF
    ldr x20, [x19]
    mov x21, #0

Lemit_store_data_loop:
    cmp x21, x20
    b.ge Lemit_program_done
    mov x0, x21
    bl _emit_store_data
    add x21, x21, #1
    b Lemit_store_data_loop

Lemit_program_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_emit_operation:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    adrp x20, op_kinds@PAGE
    add x20, x20, op_kinds@PAGEOFF
    ldr x21, [x20, x19, lsl #3]

    cmp x21, #0
    b.eq Lemit_op_print_value
    cmp x21, #1
    b.eq Lemit_op_store_var
    cmp x21, #2
    b.eq Lemit_op_print_var
    cmp x21, #7
    b.le Lemit_op_store_math_imm

    cmp x21, #33
    b.eq Lemit_op_if_start
    cmp x21, #34
    b.eq Lemit_op_if_else
    cmp x21, #35
    b.eq Lemit_op_if_end
    cmp x21, #36
    b.eq Lemit_op_while_start
    cmp x21, #37
    b.eq Lemit_op_while_cond
    cmp x21, #38
    b.eq Lemit_op_while_end
    cmp x21, #39
    b.eq Lemit_op_cmp_imm
    cmp x21, #40
    b.eq Lemit_op_cmp_var
    cmp x21, #41
    b.eq Lemit_op_jump
    cmp x21, #46
    b.eq Lemit_op_for_update
    cmp x21, #12
    b.le Lemit_op_print_math_imm
    cmp x21, #17
    b.le Lemit_op_store_math_var
    cmp x21, #22
    b.le Lemit_op_print_math_var
    cmp x21, #27
    b.le Lemit_op_store_math_target_imm
    cmp x21, #32
    b.le Lemit_op_store_math_target_var
    b Lemit_op_done

Lemit_op_print_value:
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    bl _emit_print_call
    b Lemit_op_done

Lemit_op_store_var:
    adrp x0, asm_store_val_adrp@PAGE
    add x0, x0, asm_store_val_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_val_ldr@PAGE
    add x0, x0, asm_store_val_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_var_str@PAGE
    add x0, x0, asm_store_var_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_op_done

Lemit_op_print_var:
    adrp x0, asm_print_fmt_int_adrp@PAGE
    add x0, x0, asm_print_fmt_int_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x0, asm_print_var_ldr@PAGE
    add x0, x0, asm_print_var_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_print_call_suffix_stack@PAGE
    add x0, x0, asm_print_call_suffix_stack@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_op_done

Lemit_op_store_math_imm:
    adrp x0, asm_math_var_x11_ldr@PAGE
    add x0, x0, asm_math_var_x11_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_store_val_adrp@PAGE
    add x0, x0, asm_store_val_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_val_ldr@PAGE
    add x0, x0, asm_store_val_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_var_suffix@PAGE
    add x0, x0, asm_store_var_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    sub x22, x21, #2
    mov x0, x22
    bl _emit_math_opcode_x11

    adrp x0, asm_math_store_x11_str@PAGE
    add x0, x0, asm_math_store_x11_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_op_done

Lemit_op_print_math_imm:
    adrp x0, asm_print_fmt_int_adrp@PAGE
    add x0, x0, asm_print_fmt_int_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_math_var_x1_ldr@PAGE
    add x0, x0, asm_math_var_x1_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_store_val_adrp@PAGE
    add x0, x0, asm_store_val_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_val_ldr@PAGE
    add x0, x0, asm_store_val_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_var_suffix@PAGE
    add x0, x0, asm_store_var_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    sub x22, x21, #7
    mov x0, x22
    bl _emit_math_opcode_x1

    adrp x0, asm_print_stack_only@PAGE
    add x0, x0, asm_print_stack_only@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_op_done

Lemit_op_store_math_var:
    adrp x0, asm_math_var_x11_ldr@PAGE
    add x0, x0, asm_math_var_x11_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_math_var_x10_ldr@PAGE
    add x0, x0, asm_math_var_x10_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_store_var_suffix@PAGE
    add x0, x0, asm_store_var_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    sub x22, x21, #12
    mov x0, x22
    bl _emit_math_opcode_x11

    adrp x0, asm_math_store_x11_str@PAGE
    add x0, x0, asm_math_store_x11_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_op_done

Lemit_op_print_math_var:
    adrp x0, asm_print_fmt_int_adrp@PAGE
    add x0, x0, asm_print_fmt_int_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_math_var_x1_ldr@PAGE
    add x0, x0, asm_math_var_x1_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_math_var_x10_ldr@PAGE
    add x0, x0, asm_math_var_x10_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_store_var_suffix@PAGE
    add x0, x0, asm_store_var_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    sub x22, x21, #17
    mov x0, x22
    bl _emit_math_opcode_x1

    adrp x0, asm_print_stack_only@PAGE
    add x0, x0, asm_print_stack_only@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_op_done

Lemit_op_store_math_target_imm:
    adrp x0, asm_math_var_x11_ldr@PAGE
    add x0, x0, asm_math_var_x11_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_store_val_adrp@PAGE
    add x0, x0, asm_store_val_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_val_ldr@PAGE
    add x0, x0, asm_store_val_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_var_suffix@PAGE
    add x0, x0, asm_store_var_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    sub x22, x21, #22
    mov x0, x22
    bl _emit_math_opcode_x11

    adrp x0, asm_math_store_x11_str@PAGE
    add x0, x0, asm_math_store_x11_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_op_done

Lemit_op_store_math_target_var:
    adrp x0, asm_math_var_x11_ldr@PAGE
    add x0, x0, asm_math_var_x11_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x0, asm_math_var_x10_ldr@PAGE
    add x0, x0, asm_math_var_x10_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg2@PAGE
    add x20, x20, op_arg2@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_store_var_suffix@PAGE
    add x0, x0, asm_store_var_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    sub x22, x21, #27
    mov x0, x22
    bl _emit_math_opcode_x11

    adrp x0, asm_math_store_x11_str@PAGE
    add x0, x0, asm_math_store_x11_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_op_done

Lemit_op_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_emit_math_opcode_x11:
    b Lemit_math_x11_dispatch


Lemit_op_if_start:
    // load var into x11
    adrp x0, asm_math_var_x11_ldr@PAGE
    add x0, x0, asm_math_var_x11_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    // cbz x11, L_snl_ELSE
    adrp x0, asm_branch_zero@PAGE
    add x0, x0, asm_branch_zero@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, newline_char@PAGE
    add x0, x0, newline_char@PAGEOFF
    mov x1, #1
    mov x2, #1
    bl _write_buffer_fd
    
    b Lemit_op_done

Lemit_op_if_else:
    // branch to END (op_arg1)
    adrp x0, asm_branch@PAGE
    add x0, x0, asm_branch@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, newline_char@PAGE
    add x0, x0, newline_char@PAGEOFF
    mov x1, #1
    mov x2, #1
    bl _write_buffer_fd
    
    // place ELSE label (op_arg0)
    adrp x0, asm_label_prefix@PAGE
    add x0, x0, asm_label_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, asm_label_suffix@PAGE
    add x0, x0, asm_label_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    b Lemit_op_done

Lemit_op_if_end:
    // place END label (op_arg0)
    adrp x0, asm_label_prefix@PAGE
    add x0, x0, asm_label_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, asm_label_suffix@PAGE
    add x0, x0, asm_label_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    b Lemit_op_done

Lemit_op_while_start:
    // place START label (op_arg0)
    adrp x0, asm_label_prefix@PAGE
    add x0, x0, asm_label_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, asm_label_suffix@PAGE
    add x0, x0, asm_label_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    b Lemit_op_done

Lemit_op_while_cond:
    // load var into x11
    adrp x0, asm_math_var_x11_ldr@PAGE
    add x0, x0, asm_math_var_x11_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    // cbz x11, L_snl_END
    adrp x0, asm_branch_zero@PAGE
    add x0, x0, asm_branch_zero@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, newline_char@PAGE
    add x0, x0, newline_char@PAGEOFF
    mov x1, #1
    mov x2, #1
    bl _write_buffer_fd
    
    b Lemit_op_done

Lemit_op_while_end:
    // branch to START (op_arg0)
    adrp x0, asm_branch@PAGE
    add x0, x0, asm_branch@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, newline_char@PAGE
    add x0, x0, newline_char@PAGEOFF
    mov x1, #1
    mov x2, #1
    bl _write_buffer_fd
    
    // place END label (op_arg1)
    adrp x0, asm_label_prefix@PAGE
    add x0, x0, asm_label_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, asm_label_suffix@PAGE
    add x0, x0, asm_label_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    b Lemit_op_done

Lemit_op_jump:
    // unconditional jump to label in op_arg0
    adrp x0, asm_branch@PAGE
    add x0, x0, asm_branch@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    
    adrp x0, newline_char@PAGE
    add x0, x0, newline_char@PAGEOFF
    mov x1, #1
    mov x2, #1
    bl _write_buffer_fd
    
    b Lemit_op_done

Lemit_op_for_update:
    // place UPDATE label (op_arg0)
    adrp x0, asm_label_prefix@PAGE
    add x0, x0, asm_label_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd

    adrp x0, asm_label_suffix@PAGE
    add x0, x0, asm_label_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    b Lemit_op_done

Lemit_op_cmp_imm:
    // load left var into x11
    adrp x0, asm_math_var_x11_ldr@PAGE
    add x0, x0, asm_math_var_x11_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    // load right imm from store_val
    adrp x0, asm_store_val_adrp@PAGE
    add x0, x0, asm_store_val_adrp@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_val_ldr@PAGE
    add x0, x0, asm_store_val_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_store_var_suffix@PAGE
    add x0, x0, asm_store_var_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    b Lemit_cmp_shared

Lemit_op_cmp_var:
    // load left var into x11
    adrp x0, asm_math_var_x11_ldr@PAGE
    add x0, x0, asm_math_var_x11_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg0@PAGE
    add x20, x20, op_arg0@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    // load right var into x10
    adrp x0, asm_math_var_x10_ldr@PAGE
    add x0, x0, asm_math_var_x10_ldr@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

Lemit_cmp_shared:
    // emit `cmp x11, x10`
    adrp x0, asm_cmp_x11_x10@PAGE
    add x0, x0, asm_cmp_x11_x10@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    // emit cset depending on op_arg2
    adrp x20, op_arg2@PAGE
    add x20, x20, op_arg2@PAGEOFF
    ldr x22, [x20, x19, lsl #3]
    
    cmp x22, #0
    b.eq Lemit_cmp_eq
    cmp x22, #1
    b.eq Lemit_cmp_ne
    cmp x22, #2
    b.eq Lemit_cmp_gt
    cmp x22, #3
    b.eq Lemit_cmp_lt
    cmp x22, #4
    b.eq Lemit_cmp_ge
    cmp x22, #5
    b.eq Lemit_cmp_le
    b Lemit_cmp_write_cset

Lemit_cmp_eq:
    adrp x0, asm_cset_eq@PAGE
    add x0, x0, asm_cset_eq@PAGEOFF
    b Lemit_cmp_write_cset
Lemit_cmp_ne:
    adrp x0, asm_cset_ne@PAGE
    add x0, x0, asm_cset_ne@PAGEOFF
    b Lemit_cmp_write_cset
Lemit_cmp_gt:
    adrp x0, asm_cset_gt@PAGE
    add x0, x0, asm_cset_gt@PAGEOFF
    b Lemit_cmp_write_cset
Lemit_cmp_lt:
    adrp x0, asm_cset_lt@PAGE
    add x0, x0, asm_cset_lt@PAGEOFF
    b Lemit_cmp_write_cset
Lemit_cmp_ge:
    adrp x0, asm_cset_ge@PAGE
    add x0, x0, asm_cset_ge@PAGEOFF
    b Lemit_cmp_write_cset
Lemit_cmp_le:
    adrp x0, asm_cset_le@PAGE
    add x0, x0, asm_cset_le@PAGEOFF

Lemit_cmp_write_cset:
    mov x1, #1
    bl _write_cstr_fd
    
    // emit `stur x11, [x29, #-dest]`
    adrp x0, asm_math_store_x11_str@PAGE
    add x0, x0, asm_math_store_x11_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    adrp x20, op_arg3@PAGE
    add x20, x20, op_arg3@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_stack_offset_fd
    
    adrp x0, asm_close_bracket@PAGE
    add x0, x0, asm_close_bracket@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    
    b Lemit_op_done


Lemit_math_x11_dispatch:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, x0
    cmp x19, #1
    b.eq Lemit_math_x11_add
    cmp x19, #2
    b.eq Lemit_math_x11_sub
    cmp x19, #3
    b.eq Lemit_math_x11_mul
    cmp x19, #4
    b.eq Lemit_math_x11_div
    adrp x0, asm_math_mod_x11_x10@PAGE
    add x0, x0, asm_math_mod_x11_x10@PAGEOFF
    b Lemit_math_x11_write
Lemit_math_x11_add:
    adrp x0, asm_math_add_x11_x10@PAGE
    add x0, x0, asm_math_add_x11_x10@PAGEOFF
    b Lemit_math_x11_write
Lemit_math_x11_sub:
    adrp x0, asm_math_sub_x11_x10@PAGE
    add x0, x0, asm_math_sub_x11_x10@PAGEOFF
    b Lemit_math_x11_write
Lemit_math_x11_mul:
    adrp x0, asm_math_mul_x11_x10@PAGE
    add x0, x0, asm_math_mul_x11_x10@PAGEOFF
    b Lemit_math_x11_write
Lemit_math_x11_div:
    adrp x0, asm_math_div_x11_x10@PAGE
    add x0, x0, asm_math_div_x11_x10@PAGEOFF
Lemit_math_x11_write:
    mov x1, #1
    bl _write_cstr_fd
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_emit_math_opcode_x1:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, x0
    cmp x19, #1
    b.eq Lemit_math_x1_add
    cmp x19, #2
    b.eq Lemit_math_x1_sub
    cmp x19, #3
    b.eq Lemit_math_x1_mul
    cmp x19, #4
    b.eq Lemit_math_x1_div
    adrp x0, asm_math_mod_x1_x10@PAGE
    add x0, x0, asm_math_mod_x1_x10@PAGEOFF
    b Lemit_math_x1_write
Lemit_math_x1_add:
    adrp x0, asm_math_add_x1_x10@PAGE
    add x0, x0, asm_math_add_x1_x10@PAGEOFF
    b Lemit_math_x1_write
Lemit_math_x1_sub:
    adrp x0, asm_math_sub_x1_x10@PAGE
    add x0, x0, asm_math_sub_x1_x10@PAGEOFF
    b Lemit_math_x1_write
Lemit_math_x1_mul:
    adrp x0, asm_math_mul_x1_x10@PAGE
    add x0, x0, asm_math_mul_x1_x10@PAGEOFF
    b Lemit_math_x1_write
Lemit_math_x1_div:
    adrp x0, asm_math_div_x1_x10@PAGE
    add x0, x0, asm_math_div_x1_x10@PAGEOFF
Lemit_math_x1_write:
    mov x1, #1
    bl _write_cstr_fd
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
    cmp x21, #6 // decimal prints via generated string data
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

    adrp x0, asm_align_3@PAGE
    add x0, x0, asm_align_3@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x0, asm_data_value_prefix@PAGE
    add x0, x0, asm_data_value_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd

    cmp x23, #2 // string
    b.eq Lemit_data_str
    cmp x23, #6 // decimal rendered as string literal
    b.eq Lemit_data_dec

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
    b Lemit_data_done

Lemit_data_dec:
    adrp x0, asm_data_value_mid_str@PAGE
    add x0, x0, asm_data_value_mid_str@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    adrp x20, print_lengths@PAGE
    add x20, x20, print_lengths@PAGEOFF
    ldr x22, [x20, x19, lsl #3] // scale

    mov x0, x21
    mov x1, x22
    mov x2, #1
    bl _write_decimal_raw_fd

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

_emit_var_slot_data:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x20, #64
    mov x21, #0

Lemit_var_slot_loop:
    cmp x21, x20
    b.ge Lemit_var_slot_done
    adrp x19, var_types@PAGE
    add x19, x19, var_types@PAGEOFF
    ldr x22, [x19, x21, lsl #3]
    cmp x22, #2
    b.eq Lemit_var_slot_next
    adrp x0, asm_align_3@PAGE
    add x0, x0, asm_align_3@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x0, asm_var_slot_prefix@PAGE
    add x0, x0, asm_var_slot_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x21
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_value_mid@PAGE
    add x0, x0, asm_data_value_mid@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, #0
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_value_suffix@PAGE
    add x0, x0, asm_data_value_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

Lemit_var_slot_next:
    add x21, x21, #1
    b Lemit_var_slot_loop

Lemit_var_slot_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_emit_store_data:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    adrp x20, op_kinds@PAGE
    add x20, x20, op_kinds@PAGEOFF
    ldr x21, [x20, x19, lsl #3]
    cmp x21, #1
    b.eq Lemit_store_data_emit
    cmp x21, #3
    b.lt Lemit_store_data_done

    // skip runtime branch/control ops — they don't need store_val data
    // except op 39 (cmp_imm) which needs a store_val for the right-hand immediate
    cmp x21, #39
    b.eq Lemit_store_data_cmp_imm
    cmp x21, #33
    b.ge Lemit_store_data_check_high
    b Lemit_store_data_check_math

Lemit_store_data_check_high:
    cmp x21, #41
    b.le Lemit_store_data_done

Lemit_store_data_check_math:
    cmp x21, #12
    b.le Lemit_store_data_emit
    cmp x21, #23
    b.lt Lemit_store_data_done
    cmp x21, #27
    b.gt Lemit_store_data_done

Lemit_store_data_cmp_imm:
    // emit store_val_{op_index}: .quad {op_arg1}  for the right-hand immediate
    adrp x0, asm_align_3@PAGE
    add x0, x0, asm_align_3@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x0, asm_store_data_prefix@PAGE
    add x0, x0, asm_store_data_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_value_mid@PAGE
    add x0, x0, asm_data_value_mid@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_value_suffix@PAGE
    add x0, x0, asm_data_value_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    b Lemit_store_data_done

Lemit_store_data_emit:
    adrp x0, asm_align_3@PAGE
    add x0, x0, asm_align_3@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    adrp x0, asm_store_data_prefix@PAGE
    add x0, x0, asm_store_data_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_value_mid@PAGE
    add x0, x0, asm_data_value_mid@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    cmp x21, #23
    b.lt Lemit_store_data_arg1
    adrp x20, op_arg2@PAGE
    add x20, x20, op_arg2@PAGEOFF
    b Lemit_store_data_load
Lemit_store_data_arg1:
    adrp x20, op_arg1@PAGE
    add x20, x20, op_arg1@PAGEOFF
Lemit_store_data_load:
    ldr x0, [x20, x19, lsl #3]
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_value_suffix@PAGE
    add x0, x0, asm_data_value_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

Lemit_store_data_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_write_stack_offset_fd:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    add x0, x0, #1
    mov x2, #8
    mul x0, x0, x2
    bl _write_u64_fd
    ldp x29, x30, [sp], #16
    ret
