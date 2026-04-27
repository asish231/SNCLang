.global _main
.align 4

.extern _open
.extern _read
.extern _write
.extern _close
.extern _exit
.extern _parse_statement
.extern _lookup_function
.extern _cstring_length

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
    adrp x2, fn_count@PAGE
    add x2, x2, fn_count@PAGEOFF
    str x1, [x2]
    adrp x2, op_count@PAGE
    add x2, x2, op_count@PAGEOFF
    str x1, [x2]
    adrp x2, label_counter@PAGE
    add x2, x2, label_counter@PAGEOFF
    str x1, [x2]

    bl _parse_program
    cbnz x0, Lmain_fail

    // Auto-call main() if it was defined
    adrp x9, fn_count@PAGE
    add x9, x9, fn_count@PAGEOFF
    ldr x9, [x9]
    cbz x9, Lmain_no_main_fn

    // Look up "main"
    adrp x0, kw_main@PAGE
    add x0, x0, kw_main@PAGEOFF
    bl _cstring_length
    mov x1, x0
    adrp x0, kw_main@PAGE
    add x0, x0, kw_main@PAGEOFF
    bl _lookup_function
    cbz x0, Lmain_no_main_fn
    // x1 = fn index
    mov x19, x1

    // Save current cursor
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    ldr x20, [x9]

    // Clear return flag
    adrp x9, fn_return_flag@PAGE
    add x9, x9, fn_return_flag@PAGEOFF
    str xzr, [x9]

    // Jump cursor to function body
    adrp x9, fn_body_cursors@PAGE
    add x9, x9, fn_body_cursors@PAGEOFF
    ldr x10, [x9, x19, lsl #3]
    adrp x9, cursor_pos@PAGE
    add x9, x9, cursor_pos@PAGEOFF
    str x10, [x9]
    adrp x9, fn_body_lines@PAGE
    add x9, x9, fn_body_lines@PAGEOFF
    ldr x10, [x9, x19, lsl #3]
    adrp x9, current_line@PAGE
    add x9, x9, current_line@PAGEOFF
    str x10, [x9]

    // Execute function body
Lmain_fn_body_loop:
    adrp x9, fn_return_flag@PAGE
    add x9, x9, fn_return_flag@PAGEOFF
    ldr x10, [x9]
    cbnz x10, Lmain_fn_body_done

    bl _skip_whitespace
    bl _peek_char
    cmp w0, #'}'
    b.eq Lmain_fn_body_done
    cbz w0, Lmain_fail

    bl _parse_statement
    cbz x0, Lmain_fn_body_loop
    cmp x0, #4 // return
    b.eq Lmain_fn_body_done
    b Lmain_fail

Lmain_fn_body_done:
    // Clear return flag
    adrp x9, fn_return_flag@PAGE
    add x9, x9, fn_return_flag@PAGEOFF
    str xzr, [x9]

Lmain_no_main_fn:
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
