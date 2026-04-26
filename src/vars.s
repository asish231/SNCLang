 .text
 .align 4
 .global _define_variable
 .global _set_variable
 .global _lookup_variable
 .global _record_print_value

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
