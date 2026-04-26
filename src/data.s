.data
.global msg_usage
.global msg_open_error
.global msg_read_error
.global msg_truncated
.global msg_on_line
.global msg_colon_space
.global msg_expected_stmt
.global msg_expected_name
.global msg_expected_expr
.global msg_expected_char
.global msg_unknown_stmt
.global msg_unknown_var
.global msg_duplicate_var
.global msg_divide_zero
.global msg_const_assign
.global msg_expected_type
.global msg_expected_list
.global msg_too_many_vars
.global msg_too_many_prints
.global msg_too_many_ops
.global msg_too_many_fns
.global msg_too_many_params
.global msg_unknown_fn
.global msg_wrong_arg_count
.global msg_expected_arrow
.global kw_let
.global kw_print
.global kw_int
.global kw_bool
.global kw_const
.global kw_fn
.global kw_main
.global kw_if
.global kw_else
.global kw_while
.global kw_true
.global kw_false
.global kw_and
.global kw_or
.global kw_not
.global kw_str
.global kw_byte
.global kw_match
.global kw_default
.global kw_use
.global kw_list
.global kw_for
.global kw_stop
.global kw_skip
.global kw_in
.global kw_return
.global asm_header
.global asm_print_fmt_adrp
.global asm_print_val_adrp
.global asm_print_val_ldr
.global asm_print_str_val_adrp
.global asm_print_str_val_add
.global asm_print_call_suffix
.global asm_print_call_stack
.global asm_print_stack_only
.global asm_data_intro
.global asm_data_value_prefix
.global asm_data_value_mid
.global asm_data_value_mid_str
.global asm_data_value_suffix
.global asm_data_value_suffix_str
.global asm_align_3
.global asm_print_fmt_int_adrp
.global asm_print_fmt_str_adrp
.global asm_store_val_adrp
.global asm_store_val_ldr
.global asm_store_var_adrp
.global asm_store_var_str
.global asm_store_var_suffix
.global asm_print_var_adrp
.global asm_print_var_ldr
.global asm_math_var_x11_adrp
.global asm_math_var_x11_ldr
.global asm_math_var_x1_adrp
.global asm_math_var_x1_ldr
.global asm_math_var_x10_adrp
.global asm_math_var_x10_ldr
.global asm_math_store_x11_adrp
.global asm_math_store_x11_str
.global asm_math_add_x11_x10
.global asm_math_sub_x11_x10
.global asm_math_mul_x11_x10
.global asm_math_div_x11_x10
.global asm_math_mod_x11_x10
.global asm_math_add_x1_x10
.global asm_math_sub_x1_x10
.global asm_math_mul_x1_x10
.global asm_math_div_x1_x10
.global asm_math_mod_x1_x10
.global asm_var_slot_prefix
.global asm_store_data_prefix
.global asm_label_prefix
.global asm_label_suffix
.global asm_branch
.global asm_branch_zero
.global asm_branch_nonzero
.global asm_cmp_x11_x10
.global asm_cset_gt
.global asm_cset_lt
.global asm_cset_ge
.global asm_cset_le
.global asm_cset_eq
.global asm_cset_ne
.global asm_load_x11_var
.global asm_load_x10_var
.global asm_store_x11_var
.global asm_add_x11_imm
.global asm_sub_x11_imm
.global newline_char
.global zero_qword
.global single_char
.global close_brace_char
.global label_counter
.global buffer
.global number_buffer
.global source_ptr
.global source_len
.global cursor_pos
.global current_line
.global var_count
.global print_count
.global op_count
.global var_name_ptrs
.global var_name_lens
.global var_values
.global var_lengths
.global var_const_flags
.global var_types
.global list_pool_count
.global list_pool_values
.global list_pool_lengths
.global print_values
.global print_lengths
.global print_types
.global op_kinds
.global op_arg0
.global op_arg1
.global op_arg2
.global fn_count
.global fn_name_ptrs
.global fn_name_lens
.global fn_body_cursors
.global fn_body_lines
.global fn_param_counts
.global fn_param_types
.global fn_param_name_ptrs
.global fn_param_name_lens
.global fn_return_types
.global fn_return_value
.global fn_return_length
.global fn_return_flag
.global saved_var_count

msg_usage:         .asciz "usage: ./snc <source.sn>\n"
msg_open_error:    .asciz "error: could not open "
msg_read_error:    .asciz "error: failed to read source input\n"
msg_truncated:     .asciz "warning: source truncated to 8191 bytes\n"
msg_on_line:       .asciz "line "
msg_colon_space:   .asciz ": "
msg_expected_stmt: .asciz "error: expected statement on "
msg_expected_name: .asciz "error: expected variable name on "
msg_expected_expr: .asciz "error: expected expression on "
msg_expected_char: .asciz "error: expected character on "
msg_unknown_stmt:  .asciz "error: unknown statement on "
msg_unknown_var:   .asciz "error: unknown variable on "
msg_duplicate_var: .asciz "error: duplicate variable on "
msg_divide_zero:   .asciz "error: division by zero on "
msg_const_assign:  .asciz "error: cannot assign to const on "
msg_expected_type: .asciz "error: expected type on "
msg_expected_list: .asciz "error: expected list on "
msg_too_many_vars: .asciz "error: too many variables\n"
msg_too_many_prints: .asciz "error: too many print statements\n"
msg_too_many_ops:  .asciz "error: too many operations\n"
msg_too_many_fns:  .asciz "error: too many functions\n"
msg_too_many_params: .asciz "error: too many parameters on "
msg_unknown_fn:    .asciz "error: unknown function on "
msg_wrong_arg_count: .asciz "error: wrong number of arguments on "
msg_expected_arrow: .asciz "error: expected -> on "
kw_let:            .asciz "let"
kw_print:          .asciz "print"
kw_int:            .asciz "int"
kw_bool:           .asciz "bool"
kw_const:          .asciz "const"
kw_fn:             .asciz "fn"
kw_main:           .asciz "main"
kw_if:             .asciz "if"
kw_else:           .asciz "else"
kw_while:          .asciz "while"
kw_true:           .asciz "true"
kw_false:          .asciz "false"
kw_and:            .asciz "and"
kw_or:             .asciz "or"
kw_not:            .asciz "not"
kw_str:            .asciz "str"
kw_byte:           .asciz "byte"
kw_match:          .asciz "match"
kw_default:        .asciz "default"
kw_use:            .asciz "use"
kw_list:           .asciz "list"
kw_for:            .asciz "for"
kw_stop:           .asciz "stop"
kw_skip:           .asciz "skip"
kw_in:             .asciz "in"
kw_return:         .asciz "return"
asm_header:
    .asciz ".global _main\n.align 4\n.extern _printf\n\n.text\n_main:\n    stp x29, x30, [sp, #-16]!\n    mov x29, sp\n"
asm_print_fmt_int_adrp:
    .asciz "    adrp x0, print_fmt_int@PAGE\n    add x0, x0, print_fmt_int@PAGEOFF\n"
asm_print_fmt_str_adrp:
    .asciz "    adrp x0, print_fmt_str@PAGE\n    add x0, x0, print_fmt_str@PAGEOFF\n"
asm_print_val_adrp:
    .asciz "    adrp x9, print_val_"
asm_print_val_ldr:
    .asciz "@PAGE\n    ldr x1, [x9, print_val_"
asm_print_str_val_adrp:
    .asciz "    adrp x1, print_val_"
asm_print_str_val_add:
    .asciz "@PAGE\n    add x1, x1, print_val_"
asm_print_call_suffix:
    .asciz "@PAGEOFF]\n    sub sp, sp, #16\n    str x1, [sp]\n    bl _printf\n    add sp, sp, #16\n"
asm_print_call_stack:
    .asciz "@PAGEOFF\n    sub sp, sp, #16\n    str x1, [sp]\n    bl _printf\n    add sp, sp, #16\n"
asm_print_stack_only:
    .asciz "    sub sp, sp, #16\n    str x1, [sp]\n    bl _printf\n    add sp, sp, #16\n"
asm_store_val_adrp:
    .asciz "    adrp x9, store_val_"
asm_store_val_ldr:
    .asciz "@PAGE\n    ldr x10, [x9, store_val_"
asm_store_var_adrp:
    .asciz "@PAGEOFF]\n    adrp x11, var_slot_"
asm_store_var_str:
    .asciz "@PAGE\n    str x10, [x11, var_slot_"
asm_store_var_suffix:
    .asciz "@PAGEOFF]\n"
asm_print_var_adrp:
    .asciz "    adrp x9, var_slot_"
asm_print_var_ldr:
    .asciz "@PAGE\n    ldr x1, [x9, var_slot_"
asm_math_var_x11_adrp:
    .asciz "    adrp x11, var_slot_"
asm_math_var_x11_ldr:
    .asciz "@PAGE\n    ldr x11, [x11, var_slot_"
asm_math_var_x1_adrp:
    .asciz "    adrp x11, var_slot_"
asm_math_var_x1_ldr:
    .asciz "@PAGE\n    ldr x1, [x11, var_slot_"
asm_math_var_x10_adrp:
    .asciz "    adrp x12, var_slot_"
asm_math_var_x10_ldr:
    .asciz "@PAGE\n    ldr x10, [x12, var_slot_"
asm_math_store_x11_adrp:
    .asciz "    adrp x12, var_slot_"
asm_math_store_x11_str:
    .asciz "@PAGE\n    str x11, [x12, var_slot_"
asm_math_add_x11_x10:
    .asciz "    add x11, x11, x10\n"
asm_math_sub_x11_x10:
    .asciz "    sub x11, x11, x10\n"
asm_math_mul_x11_x10:
    .asciz "    mul x11, x11, x10\n"
asm_math_div_x11_x10:
    .asciz "    udiv x11, x11, x10\n"
asm_math_mod_x11_x10:
    .asciz "    udiv x13, x11, x10\n    msub x11, x13, x10, x11\n"
asm_math_add_x1_x10:
    .asciz "    add x1, x1, x10\n"
asm_math_sub_x1_x10:
    .asciz "    sub x1, x1, x10\n"
asm_math_mul_x1_x10:
    .asciz "    mul x1, x1, x10\n"
asm_math_div_x1_x10:
    .asciz "    udiv x1, x1, x10\n"
asm_math_mod_x1_x10:
    .asciz "    udiv x13, x1, x10\n    msub x1, x13, x10, x1\n"
asm_data_intro:
    .asciz "    mov w0, #0\n    ldp x29, x30, [sp], #16\n    ret\n\n.data\nprint_fmt_int:\n    .asciz \"%lld\\n\"\nprint_fmt_str:\n    .asciz \"%s\\n\"\n.align 3\n"
asm_data_value_prefix:
    .asciz "print_val_"
asm_data_value_mid:
    .asciz ":\n    .quad "
asm_data_value_mid_str:
    .asciz ":\n    .asciz \""
asm_data_value_suffix:
    .asciz "\n"
asm_data_value_suffix_str:
    .asciz "\"\n"
asm_align_3:
    .asciz ".align 3\n"
asm_var_slot_prefix:
    .asciz "var_slot_"
asm_store_data_prefix:
    .asciz "store_val_"
asm_label_prefix:
    .asciz "L_snl_"
asm_label_suffix:
    .asciz ":\n"
asm_branch:
    .asciz "    b L_snl_"
asm_branch_zero:
    .asciz "    cbz x11, L_snl_"
asm_branch_nonzero:
    .asciz "    cbnz x11, L_snl_"
asm_cmp_x11_x10:
    .asciz "    cmp x11, x10\n"
asm_cset_gt:
    .asciz "    cset x11, gt\n"
asm_cset_lt:
    .asciz "    cset x11, lt\n"
asm_cset_ge:
    .asciz "    cset x11, ge\n"
asm_cset_le:
    .asciz "    cset x11, le\n"
asm_cset_eq:
    .asciz "    cset x11, eq\n"
asm_cset_ne:
    .asciz "    cset x11, ne\n"
asm_load_x11_var:
    .asciz "    adrp x11, var_slot_"
asm_load_x10_var:
    .asciz "    adrp x12, var_slot_"
asm_store_x11_var:
    .asciz "    str x11, [x12, var_slot_"
asm_add_x11_imm:
    .asciz "    add x11, x11, #"
asm_sub_x11_imm:
    .asciz "    sub x11, x11, #"
newline_char:      .byte 10
zero_qword:        .quad 0
single_char:       .byte 0
close_brace_char:  .byte 125

.bss
.align 4
buffer:         .space 8192
number_buffer:  .space 32
source_ptr:     .space 8
source_len:     .space 8
cursor_pos:     .space 8
current_line:   .space 8
var_count:      .space 8
print_count:    .space 8
op_count:       .space 8
label_counter:  .space 8
var_name_ptrs:  .space 512
var_name_lens:  .space 512
var_values:     .space 512
var_lengths:    .space 512
var_const_flags: .space 512
var_types:       .space 512
list_pool_count: .space 8
list_pool_values: .space 4096
list_pool_lengths: .space 4096
print_values:   .space 2048
print_lengths:  .space 2048
print_types:    .space 2048
op_kinds:       .space 4096
op_arg0:        .space 4096
op_arg1:        .space 4096
op_arg2:        .space 4096
fn_count:       .space 8
fn_name_ptrs:   .space 256        // 32 functions * 8 bytes
fn_name_lens:   .space 256
fn_body_cursors: .space 256
fn_body_lines:  .space 256
fn_param_counts: .space 256
fn_return_types: .space 256
fn_param_types: .space 1024       // 32 fns * 4 params * 8 bytes
fn_param_name_ptrs: .space 1024
fn_param_name_lens: .space 1024
fn_return_value: .space 8
fn_return_length: .space 8
fn_return_flag:  .space 8
saved_var_count: .space 8
