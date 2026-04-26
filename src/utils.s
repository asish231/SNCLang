 .text
 .align 4
 .global _match_cstr_span
 .global _match_span_span
 .global _report_error_prefix
 .global _write_cstr_fd
 .global _write_buffer_fd
 .global _write_newline_stderr
 .global _write_u64_fd
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
