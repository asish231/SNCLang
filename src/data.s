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
.global msg_too_many_vars
.global msg_too_many_prints
.global kw_let
.global kw_print
.global kw_int
.global kw_bool
.global kw_const
.global kw_fn
.global kw_if
.global kw_else
.global kw_true
.global kw_false
.global kw_and
.global kw_or
.global kw_not
.global asm_header
.global asm_call_prefix_a
.global asm_call_prefix_b
.global asm_call_suffix
.global asm_data_intro
.global asm_data_label_prefix
.global asm_data_label_mid
.global asm_data_label_suffix
.global newline_char
.global zero_qword
.global single_char
.global close_brace_char
.global buffer
.global number_buffer
.global source_ptr
.global source_len
.global cursor_pos
.global current_line
.global var_count
.global print_count
.global var_name_ptrs
.global var_name_lens
.global var_values
.global var_const_flags
.global print_values

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
msg_too_many_vars: .asciz "error: too many variables\n"
msg_too_many_prints: .asciz "error: too many print statements\n"
kw_let:            .asciz "let"
kw_print:          .asciz "print"
kw_int:            .asciz "int"
kw_bool:           .asciz "bool"
kw_const:          .asciz "const"
kw_fn:             .asciz "fn"
kw_if:             .asciz "if"
kw_else:           .asciz "else"
kw_true:           .asciz "true"
kw_false:          .asciz "false"
kw_and:            .asciz "and"
kw_or:             .asciz "or"
kw_not:            .asciz "not"
asm_header:
    .asciz ".global _main\n.align 4\n.extern _printf\n\n.text\n_main:\n    stp x29, x30, [sp, #-16]!\n    mov x29, sp\n"
asm_call_prefix_a:
    .asciz "    adrp x0, print_"
asm_call_prefix_b:
    .asciz "@PAGE\n    add x0, x0, print_"
asm_call_suffix:
    .asciz "@PAGEOFF\n    bl _printf\n"
asm_data_intro:
    .asciz "    mov w0, #0\n    ldp x29, x30, [sp], #16\n    ret\n\n.data\n"
asm_data_label_prefix:
    .asciz "print_"
asm_data_label_mid:
    .asciz ":\n    .asciz \""
asm_data_label_suffix:
    .asciz "\\n\"\n"
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
var_name_ptrs:  .space 512
var_name_lens:  .space 512
var_values:     .space 512
var_const_flags: .space 512
print_values:   .space 2048
