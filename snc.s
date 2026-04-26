.global _main
.align 4

.extern _open
.extern _read
.extern _write
.extern _close
.extern _exit

_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, x0
    mov x20, x1

    cmp x19, #2
    b.ge Lmain_have_input

    adrp x0, msg_usage@PAGE
    add x0, x0, msg_usage@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd
    mov w0, #1
    bl _exit

Lmain_have_input:
    ldr x0, [x20, #8]
    bl _load_file
    cmp x0, #0
    b.lt Lmain_fail
    mov x19, x0

    adrp x0, buffer@PAGE
    add x0, x0, buffer@PAGEOFF
    mov x1, x19
    bl _set_source

    adrp x0, zero_qword@PAGE
    add x0, x0, zero_qword@PAGEOFF
    ldr x1, [x0]
    adrp x2, cursor_pos@PAGE
    add x2, x2, cursor_pos@PAGEOFF
    str x1, [x2]
    adrp x2, current_line@PAGE
    add x2, x2, current_line@PAGEOFF
    mov x3, #1
    str x3, [x2]
    adrp x2, var_count@PAGE
    add x2, x2, var_count@PAGEOFF
    str x1, [x2]
    adrp x2, print_count@PAGE
    add x2, x2, print_count@PAGEOFF
    str x1, [x2]

    bl _parse_program
    cbnz x0, Lmain_fail

    bl _emit_program

    mov w0, #0
    bl _exit

Lmain_fail:
    mov w0, #1
    bl _exit

_load_file:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    mov x1, #0
    bl _open
    cmp x0, #0
    b.lt Lload_open_failed

    mov x20, x0
    mov x0, x20
    bl _read_into_buffer
    mov x21, x0
    mov x0, x20
    bl _close
    mov x0, x21
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

Lload_open_failed:
    adrp x0, msg_open_error@PAGE
    add x0, x0, msg_open_error@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #2
    bl _write_cstr_fd
    bl _write_newline_stderr
    mov x0, #-1
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_read_into_buffer:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    mov x20, #0
    adrp x21, buffer@PAGE
    add x21, x21, buffer@PAGEOFF

Lread_loop:
    mov x22, #8191
    sub x22, x22, x20
    cbz x22, Lbuffer_full

    mov x0, x19
    add x1, x21, x20
    mov x2, x22
    bl _read
    cmp x0, #0
    b.lt Lread_failed
    cbz x0, Lread_done

    add x20, x20, x0
    b Lread_loop

Lbuffer_full:
    adrp x0, msg_truncated@PAGE
    add x0, x0, msg_truncated@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd

Lread_done:
    add x1, x21, x20
    strb wzr, [x1]
    mov x0, x20
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

Lread_failed:
    adrp x0, msg_read_error@PAGE
    add x0, x0, msg_read_error@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd
    mov x0, #-1
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_set_source:
    adrp x2, source_ptr@PAGE
    add x2, x2, source_ptr@PAGEOFF
    str x0, [x2]
    adrp x2, source_len@PAGE
    add x2, x2, source_len@PAGEOFF
    str x1, [x2]
    ret

_parse_program:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

Lprogram_loop:
    bl _skip_whitespace
    bl _is_eof
    cbnz x0, Lprogram_ok

    bl _parse_statement
    cbnz x0, Lprogram_fail
    b Lprogram_loop

Lprogram_ok:
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

Lprogram_fail:
    mov x0, #1
    ldp x29, x30, [sp], #16
    ret

_parse_statement:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    bl _parse_identifier
    cbz x0, Lstmt_need_keyword
    mov x19, x0
    mov x20, x1

    mov x0, x19
    mov x1, x20
    adrp x2, kw_let@PAGE
    add x2, x2, kw_let@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_let

    mov x0, x19
    mov x1, x20
    adrp x2, kw_print@PAGE
    add x2, x2, kw_print@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_print

    mov x0, x19
    mov x1, x20
    adrp x2, kw_int@PAGE
    add x2, x2, kw_int@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_int

    mov x0, x19
    mov x1, x20
    adrp x2, kw_bool@PAGE
    add x2, x2, kw_bool@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_bool

    mov x0, x19
    mov x1, x20
    adrp x2, kw_const@PAGE
    add x2, x2, kw_const@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_const

    mov x0, x19
    mov x1, x20
    adrp x2, kw_fn@PAGE
    add x2, x2, kw_fn@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_fn

    mov x0, x19
    mov x1, x20
    adrp x2, kw_if@PAGE
    add x2, x2, kw_if@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_if

    b Lstmt_assign

    adrp x0, msg_unknown_stmt@PAGE
    add x0, x0, msg_unknown_stmt@PAGEOFF
    bl _report_error_prefix
    mov x0, x19
    mov x1, x20
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    b Lstmt_fail

Lstmt_let:
    bl _skip_whitespace
    bl _parse_identifier
    cbz x0, Lstmt_need_name
    mov x19, x0
    mov x20, x1

    bl _skip_whitespace
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail

    bl _parse_expr_value
    cbz x0, Lstmt_fail
    mov x21, x1

    bl _consume_optional_semicolon

    mov x0, x19
    mov x1, x20
    mov x2, x21
    mov x3, #0
    bl _define_variable
    cbnz x0, Lstmt_fail

    mov x0, #0
    b Lstmt_return

Lstmt_int:
    bl _skip_whitespace
    bl _parse_identifier
    cbz x0, Lstmt_need_name
    mov x19, x0
    mov x20, x1

    bl _skip_whitespace
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail

    bl _parse_expr_value
    cbz x0, Lstmt_fail
    mov x21, x1

    bl _consume_optional_semicolon

    mov x0, x19
    mov x1, x20
    mov x2, x21
    mov x3, #0
    bl _define_variable
    cbnz x0, Lstmt_fail

    mov x0, #0
    b Lstmt_return

Lstmt_bool:
    bl _skip_whitespace
    bl _parse_identifier
    cbz x0, Lstmt_need_name
    mov x19, x0
    mov x20, x1

    bl _skip_whitespace
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail

    bl _parse_condition_value
    cbz x0, Lstmt_fail
    mov x21, x1

    bl _consume_optional_semicolon

    mov x0, x19
    mov x1, x20
    mov x2, x21
    mov x3, #0
    bl _define_variable
    cbnz x0, Lstmt_fail

    mov x0, #0
    b Lstmt_return

Lstmt_const:
    bl _skip_whitespace
    bl _parse_identifier
    cbz x0, Lstmt_need_name
    mov x21, x0
    mov x22, x1

    mov x0, x21
    mov x1, x22
    adrp x2, kw_int@PAGE
    add x2, x2, kw_int@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_const_int

    mov x0, x21
    mov x1, x22
    adrp x2, kw_bool@PAGE
    add x2, x2, kw_bool@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lstmt_const_bool

    adrp x0, msg_expected_type@PAGE
    add x0, x0, msg_expected_type@PAGEOFF
    bl _report_error_prefix
    b Lstmt_fail

Lstmt_const_int:
    bl _skip_whitespace
    bl _parse_identifier
    cbz x0, Lstmt_need_name
    mov x19, x0
    mov x20, x1

    bl _skip_whitespace
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail

    bl _parse_expr_value
    cbz x0, Lstmt_fail
    mov x21, x1
    b Lstmt_const_store

Lstmt_const_bool:
    bl _skip_whitespace
    bl _parse_identifier
    cbz x0, Lstmt_need_name
    mov x19, x0
    mov x20, x1

    bl _skip_whitespace
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail

    bl _parse_condition_value
    cbz x0, Lstmt_fail
    mov x21, x1

Lstmt_const_store:
    bl _consume_optional_semicolon

    mov x0, x19
    mov x1, x20
    mov x2, x21
    mov x3, #1
    bl _define_variable
    cbnz x0, Lstmt_fail

    mov x0, #0
    b Lstmt_return

Lstmt_print:
    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'('
    b.ne Lstmt_print_plain
    bl _advance_char
    bl _parse_expr_value
    cbz x0, Lstmt_fail
    mov x19, x1
    bl _skip_whitespace
    mov w0, #')'
    bl _expect_char
    cbz x0, Lstmt_fail
    b Lstmt_print_record

Lstmt_print_plain:
    bl _parse_expr_value
    cbz x0, Lstmt_fail
    mov x19, x1

Lstmt_print_record:
    bl _consume_optional_semicolon

    mov x0, x19
    bl _record_print_value
    cbnz x0, Lstmt_fail
    mov x0, #0
    b Lstmt_return

Lstmt_fn:
    bl _parse_identifier
    cbz x0, Lstmt_need_name

    bl _skip_whitespace
    mov w0, #'('
    bl _expect_char
    cbz x0, Lstmt_fail
    bl _skip_whitespace
    mov w0, #')'
    bl _expect_char
    cbz x0, Lstmt_fail
    bl _skip_whitespace
    mov w0, #'{'
    bl _expect_char
    cbz x0, Lstmt_fail

Lstmt_fn_loop:
    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'}'
    b.eq Lstmt_fn_done
    cbz w0, Lstmt_fn_unclosed
    bl _parse_statement
    cbnz x0, Lstmt_fail
    b Lstmt_fn_loop

Lstmt_fn_done:
    bl _advance_char
    mov x0, #0
    b Lstmt_return

Lstmt_fn_unclosed:
    adrp x0, msg_expected_char@PAGE
    add x0, x0, msg_expected_char@PAGEOFF
    bl _report_error_prefix
    adrp x0, close_brace_char@PAGE
    add x0, x0, close_brace_char@PAGEOFF
    mov x1, #1
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    b Lstmt_fail

Lstmt_if:
    bl _skip_whitespace
    mov w0, #'('
    bl _expect_char
    cbz x0, Lstmt_fail

    bl _parse_condition_value
    cbz x0, Lstmt_fail
    mov x19, x1

    bl _skip_whitespace
    mov w0, #')'
    bl _expect_char
    cbz x0, Lstmt_fail

    bl _skip_whitespace
    mov w0, #'{'
    bl _expect_char
    cbz x0, Lstmt_fail

    cbz x19, Lstmt_if_skip_then

Lstmt_if_then_loop:
    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'}'
    b.eq Lstmt_if_then_done
    cbz w0, Lstmt_fn_unclosed
    bl _parse_statement
    cbnz x0, Lstmt_fail
    b Lstmt_if_then_loop

Lstmt_if_then_done:
    bl _advance_char
    bl _consume_optional_else
    cbz x0, Lstmt_if_done
    bl _skip_whitespace
    mov w0, #'{'
    bl _expect_char
    cbz x0, Lstmt_fail
    bl _skip_block_contents
    cbnz x0, Lstmt_fail
    b Lstmt_if_done

Lstmt_if_skip_then:
    bl _skip_block_contents
    cbnz x0, Lstmt_fail
    bl _consume_optional_else
    cbz x0, Lstmt_if_done
    bl _skip_whitespace
    mov w0, #'{'
    bl _expect_char
    cbz x0, Lstmt_fail

Lstmt_if_else_loop:
    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'}'
    b.eq Lstmt_if_else_done
    cbz w0, Lstmt_fn_unclosed
    bl _parse_statement
    cbnz x0, Lstmt_fail
    b Lstmt_if_else_loop

Lstmt_if_else_done:
    bl _advance_char

Lstmt_if_done:
    mov x0, #0
    b Lstmt_return

Lstmt_assign:
    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'='
    b.eq Lstmt_assign_set
    cmp w0, #'+'
    b.eq Lstmt_assign_add
    cmp w0, #'-'
    b.eq Lstmt_assign_subtract
    cmp w0, #'*'
    b.eq Lstmt_assign_multiply
    cmp w0, #'/'
    b.eq Lstmt_assign_divide
    b Lstmt_unknown

Lstmt_assign_set:
    bl _advance_char
    bl _parse_expr_value
    cbz x0, Lstmt_fail
    mov x21, x1
    b Lstmt_assign_store

Lstmt_assign_add:
    bl _advance_char
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail
    mov x0, x19
    mov x1, x20
    bl _lookup_variable
    cbz x0, Lstmt_unknown_var_assign
    mov x22, x1
    bl _parse_expr_value
    cbz x0, Lstmt_fail
    add x21, x22, x1
    b Lstmt_assign_store

Lstmt_assign_subtract:
    bl _advance_char
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail
    mov x0, x19
    mov x1, x20
    bl _lookup_variable
    cbz x0, Lstmt_unknown_var_assign
    mov x22, x1
    bl _parse_expr_value
    cbz x0, Lstmt_fail
    sub x21, x22, x1
    b Lstmt_assign_store

Lstmt_assign_multiply:
    bl _advance_char
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail
    mov x0, x19
    mov x1, x20
    bl _lookup_variable
    cbz x0, Lstmt_unknown_var_assign
    mov x22, x1
    bl _parse_expr_value
    cbz x0, Lstmt_fail
    mul x21, x22, x1
    b Lstmt_assign_store

Lstmt_assign_divide:
    bl _advance_char
    mov w0, #'='
    bl _expect_char
    cbz x0, Lstmt_fail
    mov x0, x19
    mov x1, x20
    bl _lookup_variable
    cbz x0, Lstmt_unknown_var_assign
    mov x22, x1
    bl _parse_expr_value
    cbz x0, Lstmt_fail
    cbz x1, Lstmt_assign_divide_zero
    udiv x21, x22, x1
    b Lstmt_assign_store

Lstmt_assign_divide_zero:
    adrp x0, msg_divide_zero@PAGE
    add x0, x0, msg_divide_zero@PAGEOFF
    bl _report_error_prefix
    bl _write_newline_stderr
    b Lstmt_fail

Lstmt_assign_store:
    bl _consume_optional_semicolon
    mov x0, x19
    mov x1, x20
    mov x2, x21
    bl _set_variable
    cbnz x0, Lstmt_fail
    mov x0, #0
    b Lstmt_return

Lstmt_unknown_var_assign:
    adrp x0, msg_unknown_var@PAGE
    add x0, x0, msg_unknown_var@PAGEOFF
    bl _report_error_prefix
    mov x0, x19
    mov x1, x20
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    b Lstmt_fail

Lstmt_unknown:
    adrp x0, msg_unknown_stmt@PAGE
    add x0, x0, msg_unknown_stmt@PAGEOFF
    bl _report_error_prefix
    mov x0, x19
    mov x1, x20
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    b Lstmt_fail

Lstmt_need_keyword:
    adrp x0, msg_expected_stmt@PAGE
    add x0, x0, msg_expected_stmt@PAGEOFF
    bl _report_error_prefix
    b Lstmt_fail

Lstmt_need_name:
    adrp x0, msg_expected_name@PAGE
    add x0, x0, msg_expected_name@PAGEOFF
    bl _report_error_prefix

Lstmt_fail:
    mov x0, #1

Lstmt_return:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_parse_expr_value:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    bl _parse_term_value
    cbz x0, Lexpr_fail
    mov x19, x1

Lexpr_loop:
    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'+'
    b.eq Lexpr_add
    cmp w0, #'-'
    b.eq Lexpr_subtract

    mov x0, #1
    mov x1, x19
    b Lexpr_return

Lexpr_add:
    bl _advance_char
    bl _parse_term_value
    cbz x0, Lexpr_fail
    add x19, x19, x1
    b Lexpr_loop

Lexpr_subtract:
    bl _advance_char
    bl _parse_term_value
    cbz x0, Lexpr_fail
    sub x19, x19, x1
    b Lexpr_loop

Lexpr_fail:
    mov x0, #0

Lexpr_return:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_parse_condition_value:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    adrp x0, kw_not@PAGE
    add x0, x0, kw_not@PAGEOFF
    bl _consume_keyword
    cbz x0, Lcond_parse_first
    bl _parse_condition_value
    cbz x0, Lcond_fail
    cmp x1, #0
    cset x1, eq
    mov x0, #1
    b Lcond_return

Lcond_parse_first:
    bl _parse_condition_atom
    cbz x0, Lcond_fail
    mov x19, x1

Lcond_logic_loop:
    adrp x0, kw_and@PAGE
    add x0, x0, kw_and@PAGEOFF
    bl _consume_keyword
    cbnz x0, Lcond_logic_and

    adrp x0, kw_or@PAGE
    add x0, x0, kw_or@PAGEOFF
    bl _consume_keyword
    cbnz x0, Lcond_logic_or

    mov x0, #1
    mov x1, x19
    b Lcond_return

Lcond_logic_and:
    bl _parse_condition_value
    cbz x0, Lcond_fail
    and x19, x19, x1
    b Lcond_logic_loop

Lcond_logic_or:
    bl _parse_condition_value
    cbz x0, Lcond_fail
    orr x19, x19, x1
    cmp x19, #0
    cset x19, ne
    b Lcond_logic_loop

Lcond_fail:
    mov x0, #0
    mov x1, #0

Lcond_return:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_parse_condition_atom:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    bl _parse_expr_value
    cbz x0, Lcond_atom_fail
    mov x19, x1

    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'='
    b.eq Lcond_equal
    cmp w0, #'!'
    b.eq Lcond_not_equal
    cmp w0, #'>'
    b.eq Lcond_greater
    cmp w0, #'<'
    b.eq Lcond_less

    cmp x19, #0
    cset x1, ne
    mov x0, #1
    b Lcond_atom_return

Lcond_equal:
    bl _advance_char
    mov w0, #'='
    bl _expect_char
    cbz x0, Lcond_atom_fail
    bl _parse_expr_value
    cbz x0, Lcond_atom_fail
    cmp x19, x1
    cset x1, eq
    mov x0, #1
    b Lcond_atom_return

Lcond_not_equal:
    bl _advance_char
    mov w0, #'='
    bl _expect_char
    cbz x0, Lcond_atom_fail
    bl _parse_expr_value
    cbz x0, Lcond_atom_fail
    cmp x19, x1
    cset x1, ne
    mov x0, #1
    b Lcond_atom_return

Lcond_greater:
    bl _advance_char
    bl _peek_char
    cmp w0, #'='
    b.eq Lcond_greater_equal
    bl _parse_expr_value
    cbz x0, Lcond_atom_fail
    cmp x19, x1
    cset x1, gt
    mov x0, #1
    b Lcond_atom_return

Lcond_greater_equal:
    bl _advance_char
    bl _parse_expr_value
    cbz x0, Lcond_atom_fail
    cmp x19, x1
    cset x1, ge
    mov x0, #1
    b Lcond_atom_return

Lcond_less:
    bl _advance_char
    bl _peek_char
    cmp w0, #'='
    b.eq Lcond_less_equal
    bl _parse_expr_value
    cbz x0, Lcond_atom_fail
    cmp x19, x1
    cset x1, lt
    mov x0, #1
    b Lcond_atom_return

Lcond_less_equal:
    bl _advance_char
    bl _parse_expr_value
    cbz x0, Lcond_atom_fail
    cmp x19, x1
    cset x1, le
    mov x0, #1
    b Lcond_atom_return

Lcond_atom_fail:
    mov x0, #0
    mov x1, #0

Lcond_atom_return:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_parse_term_value:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    bl _parse_primary_value
    cbz x0, Lterm_fail
    mov x19, x1

Lterm_loop:
    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'*'
    b.eq Lterm_multiply
    cmp w0, #'/'
    b.eq Lterm_divide
    cmp w0, #'%'
    b.eq Lterm_modulo
    b Lterm_done

Lterm_multiply:
    bl _advance_char
    bl _parse_primary_value
    cbz x0, Lterm_fail
    mul x19, x19, x1
    b Lterm_loop

Lterm_divide:
    bl _advance_char
    bl _parse_primary_value
    cbz x0, Lterm_fail
    cbz x1, Lterm_divide_zero
    udiv x19, x19, x1
    b Lterm_loop

Lterm_modulo:
    bl _advance_char
    bl _parse_primary_value
    cbz x0, Lterm_fail
    cbz x1, Lterm_divide_zero
    udiv x9, x19, x1
    msub x19, x9, x1, x19
    b Lterm_loop

Lterm_divide_zero:
    adrp x0, msg_divide_zero@PAGE
    add x0, x0, msg_divide_zero@PAGEOFF
    bl _report_error_prefix
    bl _write_newline_stderr
    b Lterm_fail

Lterm_done:
    mov x0, #1
    mov x1, x19
    b Lterm_return

Lterm_fail:
    mov x0, #0

Lterm_return:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_parse_primary_value:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    bl _skip_whitespace
    bl _peek_char
    cbz w0, Lprimary_fail

    cmp w0, #'('
    b.eq Lprimary_group

    cmp w0, #'0'
    b.lt Lprimary_identifier
    cmp w0, #'9'
    b.le Lprimary_number
    b Lprimary_identifier

Lprimary_group:
    bl _advance_char
    bl _parse_expr_value
    cbz x0, Lprimary_fail
    mov x19, x1

    bl _skip_whitespace
    mov w0, #')'
    bl _expect_char
    cbz x0, Lprimary_fail

    mov x0, #1
    mov x1, x19
    b Lprimary_return

Lprimary_identifier:
    bl _parse_identifier
    cbz x0, Lprimary_missing
    mov x19, x0
    mov x20, x1

    mov x0, x19
    mov x1, x20
    adrp x2, kw_true@PAGE
    add x2, x2, kw_true@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lprimary_true

    mov x0, x19
    mov x1, x20
    adrp x2, kw_false@PAGE
    add x2, x2, kw_false@PAGEOFF
    bl _match_cstr_span
    cbnz x0, Lprimary_false

    mov x0, x19
    mov x1, x20
    bl _lookup_variable
    cbz x0, Lprimary_unknown_var
    mov x1, x1
    mov x0, #1
    b Lprimary_return

Lprimary_true:
    mov x0, #1
    mov x1, #1
    b Lprimary_return

Lprimary_false:
    mov x0, #1
    mov x1, #0
    b Lprimary_return

Lprimary_number:
    bl _parse_number
    cbz x0, Lprimary_fail
    mov x0, #1
    b Lprimary_return

Lprimary_missing:
    adrp x0, msg_expected_expr@PAGE
    add x0, x0, msg_expected_expr@PAGEOFF
    bl _report_error_prefix
    b Lprimary_fail

Lprimary_unknown_var:
    adrp x0, msg_unknown_var@PAGE
    add x0, x0, msg_unknown_var@PAGEOFF
    bl _report_error_prefix
    mov x0, x19
    mov x1, x20
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr

Lprimary_fail:
    mov x0, #0

Lprimary_return:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_parse_identifier:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    bl _skip_whitespace
    bl _peek_char
    cbz w0, Lident_fail

    cmp w0, #'A'
    b.lt Lident_lower
    cmp w0, #'Z'
    b.le Lident_start_ok

Lident_lower:
    cmp w0, #'a'
    b.lt Lident_underscore
    cmp w0, #'z'
    b.le Lident_start_ok

Lident_underscore:
    cmp w0, #'_'
    b.ne Lident_fail

Lident_start_ok:
    bl _get_cursor_ptr
    mov x19, x0
    mov x20, #0

Lident_loop:
    bl _peek_char
    cbz w0, Lident_done
    cmp w0, #'A'
    b.lt Lident_check_lower
    cmp w0, #'Z'
    b.le Lident_take

Lident_check_lower:
    cmp w0, #'a'
    b.lt Lident_check_underscore
    cmp w0, #'z'
    b.le Lident_take

Lident_check_underscore:
    cmp w0, #'_'
    b.eq Lident_take
    cmp w0, #'0'
    b.lt Lident_done
    cmp w0, #'9'
    b.gt Lident_done

Lident_take:
    bl _advance_char
    add x20, x20, #1
    b Lident_loop

Lident_done:
    mov x0, x19
    mov x1, x20
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

Lident_fail:
    mov x0, #0
    mov x1, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_parse_number:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    bl _skip_whitespace
    mov x19, #0
    mov x20, #0

Lnum_loop:
    bl _peek_char
    cmp w0, #'0'
    b.lt Lnum_done
    cmp w0, #'9'
    b.gt Lnum_done
    mov x9, #10
    mul x19, x19, x9
    sub w10, w0, #'0'
    add x19, x19, x10
    bl _advance_char
    add x20, x20, #1
    b Lnum_loop

Lnum_done:
    cbz x20, Lnum_fail
    mov x0, #1
    mov x1, x19
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

Lnum_fail:
    mov x0, #0
    mov x1, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_expect_char:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov w19, w0
    bl _skip_whitespace
    bl _peek_char
    cmp w0, w19
    b.ne Lexpect_fail
    bl _advance_char
    mov x0, #1
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

Lexpect_fail:
    adrp x0, msg_expected_char@PAGE
    add x0, x0, msg_expected_char@PAGEOFF
    bl _report_error_prefix
    adrp x0, single_char@PAGE
    add x0, x0, single_char@PAGEOFF
    strb w19, [x0]
    mov x1, #1
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    mov x0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_consume_optional_semicolon:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    bl _skip_whitespace
    bl _peek_char
    cmp w0, #';'
    b.ne Lconsume_semicolon_done
    bl _advance_char

Lconsume_semicolon_done:
    ldp x29, x30, [sp], #16
    ret

_consume_optional_else:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    ldr x19, [x9]
    adrp x9, current_line@PAGE
    add x9, x9, current_line@PAGEOFF
    ldr x20, [x9]

    bl _skip_whitespace
    bl _parse_identifier
    cbz x0, Lconsume_else_restore

    mov x21, x0
    mov x22, x1
    mov x0, x21
    mov x1, x22
    adrp x2, kw_else@PAGE
    add x2, x2, kw_else@PAGEOFF
    bl _match_cstr_span
    cbz x0, Lconsume_else_restore

    mov x0, #1
    b Lconsume_else_return

Lconsume_else_restore:
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    str x19, [x9]
    adrp x9, current_line@PAGE
    add x9, x9, current_line@PAGEOFF
    str x20, [x9]
    mov x0, #0

Lconsume_else_return:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_consume_keyword:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!

    mov x21, x0
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    ldr x19, [x9]
    adrp x9, current_line@PAGE
    add x9, x9, current_line@PAGEOFF
    ldr x20, [x9]

    bl _skip_whitespace
    bl _parse_identifier
    cbz x0, Lconsume_keyword_restore

    mov x22, x0
    mov x23, x1
    mov x0, x22
    mov x1, x23
    mov x2, x21
    bl _match_cstr_span
    cbz x0, Lconsume_keyword_restore

    mov x0, #1
    b Lconsume_keyword_return

Lconsume_keyword_restore:
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    str x19, [x9]
    adrp x9, current_line@PAGE
    add x9, x9, current_line@PAGEOFF
    str x20, [x9]
    mov x0, #0

Lconsume_keyword_return:
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_skip_block_contents:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, #1

Lskip_block_loop:
    bl _peek_char
    cbz w0, Lskip_block_fail
    cmp w0, #'{'
    b.eq Lskip_block_open
    cmp w0, #'}'
    b.eq Lskip_block_close
    bl _advance_char
    b Lskip_block_loop

Lskip_block_open:
    bl _advance_char
    add x19, x19, #1
    b Lskip_block_loop

Lskip_block_close:
    bl _advance_char
    sub x19, x19, #1
    cbnz x19, Lskip_block_loop
    mov x0, #0
    b Lskip_block_return

Lskip_block_fail:
    adrp x0, msg_expected_char@PAGE
    add x0, x0, msg_expected_char@PAGEOFF
    bl _report_error_prefix
    adrp x0, close_brace_char@PAGE
    add x0, x0, close_brace_char@PAGEOFF
    mov x1, #1
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    mov x0, #1

Lskip_block_return:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_define_variable:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    stp x25, x26, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x25, x3

    mov x0, x19
    mov x1, x20
    bl _lookup_variable
    cbnz x0, Ldefine_duplicate

    adrp x22, var_count@PAGE
    add x22, x22, var_count@PAGEOFF
    ldr x23, [x22]
    cmp x23, #64
    b.ge Ldefine_full

    adrp x24, var_name_ptrs@PAGE
    add x24, x24, var_name_ptrs@PAGEOFF
    str x19, [x24, x23, lsl #3]
    adrp x24, var_name_lens@PAGE
    add x24, x24, var_name_lens@PAGEOFF
    str x20, [x24, x23, lsl #3]
    adrp x24, var_values@PAGE
    add x24, x24, var_values@PAGEOFF
    str x21, [x24, x23, lsl #3]
    adrp x24, var_const_flags@PAGE
    add x24, x24, var_const_flags@PAGEOFF
    str x25, [x24, x23, lsl #3]
    add x23, x23, #1
    str x23, [x22]
    mov x0, #0
    b Ldefine_return

Ldefine_duplicate:
    adrp x0, msg_duplicate_var@PAGE
    add x0, x0, msg_duplicate_var@PAGEOFF
    bl _report_error_prefix
    mov x0, x19
    mov x1, x20
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    mov x0, #1
    b Ldefine_return

Ldefine_full:
    adrp x0, msg_too_many_vars@PAGE
    add x0, x0, msg_too_many_vars@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd
    mov x0, #1

Ldefine_return:
    ldp x25, x26, [sp], #16
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_set_variable:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, #0
    adrp x23, var_count@PAGE
    add x23, x23, var_count@PAGEOFF
    ldr x23, [x23]

Lset_loop:
    cmp x22, x23
    b.ge Lset_unknown

    adrp x9, var_name_lens@PAGE
    add x9, x9, var_name_lens@PAGEOFF
    ldr x10, [x9, x22, lsl #3]
    cmp x10, x20
    b.ne Lset_next

    adrp x9, var_name_ptrs@PAGE
    add x9, x9, var_name_ptrs@PAGEOFF
    ldr x11, [x9, x22, lsl #3]
    mov x0, x19
    mov x1, x20
    mov x2, x11
    bl _match_span_span
    cbz x0, Lset_next

    adrp x9, var_const_flags@PAGE
    add x9, x9, var_const_flags@PAGEOFF
    ldr x10, [x9, x22, lsl #3]
    cbnz x10, Lset_const

    adrp x9, var_values@PAGE
    add x9, x9, var_values@PAGEOFF
    str x21, [x9, x22, lsl #3]
    mov x0, #0
    b Lset_return

Lset_next:
    add x22, x22, #1
    b Lset_loop

Lset_unknown:
    adrp x0, msg_unknown_var@PAGE
    add x0, x0, msg_unknown_var@PAGEOFF
    bl _report_error_prefix
    mov x0, x19
    mov x1, x20
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    mov x0, #1
    b Lset_return

Lset_const:
    adrp x0, msg_const_assign@PAGE
    add x0, x0, msg_const_assign@PAGEOFF
    bl _report_error_prefix
    mov x0, x19
    mov x1, x20
    mov x2, #2
    bl _write_buffer_fd
    bl _write_newline_stderr
    mov x0, #1

Lset_return:
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_lookup_variable:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x21, #0
    adrp x22, var_count@PAGE
    add x22, x22, var_count@PAGEOFF
    ldr x22, [x22]

Llookup_loop:
    cmp x21, x22
    b.ge Llookup_fail

    adrp x9, var_name_lens@PAGE
    add x9, x9, var_name_lens@PAGEOFF
    ldr x10, [x9, x21, lsl #3]
    cmp x10, x20
    b.ne Llookup_next

    adrp x9, var_name_ptrs@PAGE
    add x9, x9, var_name_ptrs@PAGEOFF
    ldr x11, [x9, x21, lsl #3]
    mov x0, x19
    mov x1, x20
    mov x2, x11
    bl _match_span_span
    cbz x0, Llookup_next

    adrp x9, var_values@PAGE
    add x9, x9, var_values@PAGEOFF
    ldr x1, [x9, x21, lsl #3]
    mov x0, #1
    b Llookup_return

Llookup_next:
    add x21, x21, #1
    b Llookup_loop

Llookup_fail:
    mov x0, #0
    mov x1, #0

Llookup_return:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_record_print_value:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, x0
    adrp x20, print_count@PAGE
    add x20, x20, print_count@PAGEOFF
    ldr x9, [x20]
    cmp x9, #256
    b.ge Lrecord_print_full

    adrp x10, print_values@PAGE
    add x10, x10, print_values@PAGEOFF
    str x19, [x10, x9, lsl #3]
    add x9, x9, #1
    str x9, [x20]
    mov x0, #0
    b Lrecord_print_return

Lrecord_print_full:
    adrp x0, msg_too_many_prints@PAGE
    add x0, x0, msg_too_many_prints@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd
    mov x0, #1

Lrecord_print_return:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

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
    adrp x0, asm_call_prefix_a@PAGE
    add x0, x0, asm_call_prefix_a@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_call_prefix_b@PAGE
    add x0, x0, asm_call_prefix_b@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_call_suffix@PAGE
    add x0, x0, asm_call_suffix@PAGEOFF
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

    adrp x0, asm_data_label_prefix@PAGE
    add x0, x0, asm_data_label_prefix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x19
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_label_mid@PAGE
    add x0, x0, asm_data_label_mid@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd
    mov x0, x21
    mov x1, #1
    bl _write_u64_fd
    adrp x0, asm_data_label_suffix@PAGE
    add x0, x0, asm_data_label_suffix@PAGEOFF
    mov x1, #1
    bl _write_cstr_fd

    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_skip_whitespace:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

Lskip_loop:
    bl _peek_char
    cbz w0, Lskip_done
    cmp w0, #32
    b.eq Lskip_take
    cmp w0, #9
    b.eq Lskip_take
    cmp w0, #13
    b.eq Lskip_take
    cmp w0, #10
    b.eq Lskip_take
    cmp w0, #'/'
    b.ne Lskip_done
    bl _peek_next_char
    cmp w0, #'/'
    b.eq Lskip_line_comment
    cmp w0, #'*'
    b.eq Lskip_block_comment
    b Lskip_done

Lskip_take:
    bl _advance_char
    b Lskip_loop

Lskip_line_comment:
    bl _advance_char
    bl _advance_char

Lskip_line_comment_loop:
    bl _peek_char
    cbz w0, Lskip_done
    cmp w0, #10
    b.eq Lskip_loop
    bl _advance_char
    b Lskip_line_comment_loop

Lskip_block_comment:
    bl _advance_char
    bl _advance_char

Lskip_block_comment_loop:
    bl _peek_char
    cbz w0, Lskip_done
    cmp w0, #'*'
    b.ne Lskip_block_comment_take
    bl _peek_next_char
    cmp w0, #'/'
    b.eq Lskip_block_comment_close

Lskip_block_comment_take:
    bl _advance_char
    b Lskip_block_comment_loop

Lskip_block_comment_close:
    bl _advance_char
    bl _advance_char
    b Lskip_loop

Lskip_done:
    ldp x29, x30, [sp], #16
    ret

_peek_char:
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    ldr x10, [x9]
    adrp x11, source_len@PAGE
    add x11, x11, source_len@PAGEOFF
    ldr x11, [x11]
    cmp x10, x11
    b.ge Lpeek_eof
    adrp x12, source_ptr@PAGE
    add x12, x12, source_ptr@PAGEOFF
    ldr x12, [x12]
    ldrb w0, [x12, x10]
    ret

Lpeek_eof:
    mov w0, #0
    ret

_peek_next_char:
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    ldr x10, [x9]
    add x10, x10, #1
    adrp x11, source_len@PAGE
    add x11, x11, source_len@PAGEOFF
    ldr x11, [x11]
    cmp x10, x11
    b.ge Lpeek_next_eof
    adrp x12, source_ptr@PAGE
    add x12, x12, source_ptr@PAGEOFF
    ldr x12, [x12]
    ldrb w0, [x12, x10]
    ret

Lpeek_next_eof:
    mov w0, #0
    ret

_advance_char:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    bl _peek_char
    cbz w0, Ladvance_done

    cmp w0, #10
    b.ne Ladvance_no_newline
    adrp x9, current_line@PAGE
    add x9, x9, current_line@PAGEOFF
    ldr x10, [x9]
    add x10, x10, #1
    str x10, [x9]

Ladvance_no_newline:
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    ldr x10, [x9]
    add x10, x10, #1
    str x10, [x9]

Ladvance_done:
    ldp x29, x30, [sp], #16
    ret

_get_cursor_ptr:
    adrp x9, source_ptr@PAGE
    add x9, x9, source_ptr@PAGEOFF
    ldr x9, [x9]
    adrp x10, cursor_pos@PAGE
    add x10, x10, cursor_pos@PAGEOFF
    ldr x10, [x10]
    add x0, x9, x10
    ret

_is_eof:
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    ldr x9, [x9]
    adrp x10, source_len@PAGE
    add x10, x10, source_len@PAGEOFF
    ldr x10, [x10]
    cmp x9, x10
    cset x0, hs
    ret

_match_cstr_span:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x0, x21
    bl _cstring_length
    cmp x0, x20
    b.ne Lmatch_cstr_fail
    mov x0, x19
    mov x1, x20
    mov x2, x21
    bl _match_span_span
    b Lmatch_cstr_return

Lmatch_cstr_fail:
    mov x0, #0

Lmatch_cstr_return:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_match_span_span:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, #0

Lspan_cmp_loop:
    cmp x19, x1
    b.ge Lspan_cmp_yes
    ldrb w9, [x0, x19]
    ldrb w10, [x2, x19]
    cmp w9, w10
    b.ne Lspan_cmp_no
    add x19, x19, #1
    b Lspan_cmp_loop

Lspan_cmp_yes:
    mov x0, #1
    b Lspan_cmp_return

Lspan_cmp_no:
    mov x0, #0

Lspan_cmp_return:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_report_error_prefix:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, x0
    mov x1, #2
    bl _write_cstr_fd
    adrp x0, msg_on_line@PAGE
    add x0, x0, msg_on_line@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd
    adrp x9, current_line@PAGE
    add x9, x9, current_line@PAGEOFF
    ldr x0, [x9]
    mov x1, #2
    bl _write_u64_fd
    adrp x0, msg_colon_space@PAGE
    add x0, x0, msg_colon_space@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd

    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_write_cstr_fd:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    bl _cstring_length
    mov x1, x0
    mov x0, x19
    mov x2, x20
    bl _write_buffer_fd

    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_write_buffer_fd:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    cbz x1, Lwrite_buffer_done
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x0, x21
    mov x1, x19
    mov x2, x20
    bl _write

Lwrite_buffer_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_write_newline_stderr:
    adrp x0, newline_char@PAGE
    add x0, x0, newline_char@PAGEOFF
    mov x1, #1
    mov x2, #2
    b _write_buffer_fd

_write_u64_fd:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    adrp x21, number_buffer@PAGE
    add x21, x21, number_buffer@PAGEOFF
    add x22, x21, #31
    mov x9, #0

    cbnz x19, Lwrite_u64_digits
    mov w10, #'0'
    strb w10, [x22]
    mov x0, x22
    mov x1, #1
    mov x2, x20
    bl _write_buffer_fd
    b Lwrite_u64_done

Lwrite_u64_digits:
    mov x11, #10

Lwrite_u64_loop:
    udiv x12, x19, x11
    msub x13, x12, x11, x19
    add w13, w13, #'0'
    strb w13, [x22]
    sub x22, x22, #1
    add x9, x9, #1
    mov x19, x12
    cbnz x19, Lwrite_u64_loop

    add x22, x22, #1
    mov x0, x22
    mov x1, x9
    mov x2, x20
    bl _write_buffer_fd

Lwrite_u64_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_cstring_length:
    mov x1, x0
    mov x0, #0

Lstrlen_loop:
    ldrb w2, [x1, x0]
    cbz w2, Lstrlen_done
    add x0, x0, #1
    b Lstrlen_loop

Lstrlen_done:
    ret

.data
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
