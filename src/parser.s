 .text
 .align 4
 .global _parse_program

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
