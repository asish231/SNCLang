 .text
 .align 4
 .global _match_cstr_span
 .global _match_span_span
 .global _report_error_prefix
 .global _write_cstr_fd
 .global _write_buffer_fd
 .global _write_newline_stderr
 .global _write_u64_fd
 .global _write_i64_fd
 .global _write_decimal_raw_fd
 .global _cstring_length

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

_write_i64_fd:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    cmp x19, #0
    b.ge Lwrite_i64_positive
    adrp x0, single_char@PAGE
    add x0, x0, single_char@PAGEOFF
    mov w9, #'-'
    strb w9, [x0]
    mov x1, #1
    mov x2, x20
    bl _write_buffer_fd
    neg x19, x19

Lwrite_i64_positive:
    mov x0, x19
    mov x1, x20
    bl _write_u64_fd

    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_write_decimal_raw_fd:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!

    mov x19, x0 // raw value
    mov x20, x1 // scale
    mov x21, x2 // fd

    cmp x19, #0
    b.ge Lwrite_dec_abs_ready
    adrp x0, single_char@PAGE
    add x0, x0, single_char@PAGEOFF
    mov w9, #'-'
    strb w9, [x0]
    mov x1, #1
    mov x2, x21
    bl _write_buffer_fd
    neg x19, x19

Lwrite_dec_abs_ready:
    cbz x20, Lwrite_dec_int_only

    mov x22, #1
    mov x23, x20
    mov x9, #10
Lwrite_dec_pow_loop:
    cbz x23, Lwrite_dec_pow_done
    mul x22, x22, x9
    sub x23, x23, #1
    b Lwrite_dec_pow_loop
Lwrite_dec_pow_done:
    udiv x23, x19, x22
    msub x24, x23, x22, x19

    mov x0, x23
    mov x1, x21
    bl _write_u64_fd

    adrp x0, single_char@PAGE
    add x0, x0, single_char@PAGEOFF
    mov w9, #'.'
    strb w9, [x0]
    mov x1, #1
    mov x2, x21
    bl _write_buffer_fd

    adrp x9, number_buffer@PAGE
    add x9, x9, number_buffer@PAGEOFF
    add x10, x9, #31
    mov x11, #0
    mov x12, x24
    cbnz x12, Lwrite_dec_frac_digits
    mov w13, #'0'
    strb w13, [x10]
    mov x11, #1
    b Lwrite_dec_frac_ready

Lwrite_dec_frac_digits:
    mov x13, #10
Lwrite_dec_frac_loop:
    udiv x14, x12, x13
    msub x15, x14, x13, x12
    add w15, w15, #'0'
    strb w15, [x10]
    sub x10, x10, #1
    add x11, x11, #1
    mov x12, x14
    cbnz x12, Lwrite_dec_frac_loop
    add x10, x10, #1

Lwrite_dec_frac_ready:
    cmp x11, x20
    b.ge Lwrite_dec_frac_emit
    sub x12, x20, x11
    mov w13, #'0'
Lwrite_dec_zero_pad_loop:
    cbz x12, Lwrite_dec_frac_emit
    adrp x0, single_char@PAGE
    add x0, x0, single_char@PAGEOFF
    strb w13, [x0]
    mov x1, #1
    mov x2, x21
    bl _write_buffer_fd
    sub x12, x12, #1
    b Lwrite_dec_zero_pad_loop

Lwrite_dec_frac_emit:
    mov x0, x10
    mov x1, x11
    mov x2, x21
    bl _write_buffer_fd
    b Lwrite_dec_done

Lwrite_dec_int_only:
    mov x0, x19
    mov x1, x21
    bl _write_u64_fd

Lwrite_dec_done:
    ldp x23, x24, [sp], #16
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

.global _get_next_label
_get_next_label:
    adrp x9, label_counter@PAGE
    add x9, x9, label_counter@PAGEOFF
    ldr x0, [x9]
    add x1, x0, #1
    str x1, [x9]
    ret
