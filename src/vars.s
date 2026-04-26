 .text
 .align 4
 .global _define_variable
 .global _set_variable
 .global _lookup_variable
 .global _record_print_value
.global _record_store_variable
.global _record_print_variable
.global _record_operation
.global _record_operation3

_define_variable:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    stp x25, x26, [sp, #-16]!
    stp x27, x28, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x25, x3
    mov x26, x4
    mov x27, x5

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
    adrp x24, var_types@PAGE
    add x24, x24, var_types@PAGEOFF
    str x26, [x24, x23, lsl #3]
    adrp x24, var_lengths@PAGE
    add x24, x24, var_lengths@PAGEOFF
    str x27, [x24, x23, lsl #3]
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
    ldp x27, x28, [sp], #16
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
    adrp x9, var_types@PAGE
    add x9, x9, var_types@PAGEOFF
    ldr x2, [x9, x21, lsl #3]
    adrp x9, var_lengths@PAGE
    add x9, x9, var_lengths@PAGEOFF
    ldr x3, [x9, x21, lsl #3]
    mov x4, x21
    mov x0, #1
    b Llookup_return

Llookup_next:
    add x21, x21, #1
    b Llookup_loop

Llookup_fail:
    mov x0, #0
    mov x1, #0
    mov x4, #-1

Llookup_return:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_record_print_value:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0 // value
    mov x21, x1 // type
    mov x22, x2 // length
    mov x23, x2 // length
    adrp x20, print_count@PAGE
    add x20, x20, print_count@PAGEOFF
    ldr x9, [x20]
    cmp x9, #256
    b.ge Lrecord_print_full

    adrp x10, print_values@PAGE
    add x10, x10, print_values@PAGEOFF
    str x19, [x10, x9, lsl #3]
    adrp x10, print_types@PAGE
    add x10, x10, print_types@PAGEOFF
    str x21, [x10, x9, lsl #3]
    adrp x10, print_lengths@PAGE
    add x10, x10, print_lengths@PAGEOFF
    str x22, [x10, x9, lsl #3]
    mov x19, x9
    add x9, x9, #1
    str x9, [x20]
    mov x0, x19
    bl _record_operation_print_value
    mov x0, #0
    b Lrecord_print_return

Lrecord_print_full:
    adrp x0, msg_too_many_prints@PAGE
    add x0, x0, msg_too_many_prints@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd
    mov x0, #1

Lrecord_print_return:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_record_store_variable:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x0, #1
    mov x1, x19
    mov x2, x20
    bl _record_operation

    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_record_print_variable:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x0, #2
    mov x1, x19
    mov x2, x20
    bl _record_operation

    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

_record_operation_print_value:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    mov x1, x0
    mov x0, #0
    mov x2, #0
    bl _record_operation
    ldp x29, x30, [sp], #16
    ret

_record_operation:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, #0
    b Lrecord_operation_common

_record_operation3:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!

    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3

Lrecord_operation_common:
    adrp x23, op_count@PAGE
    add x23, x23, op_count@PAGEOFF
    ldr x9, [x23]
    cmp x9, #512
    b.ge Lrecord_op_full

    adrp x10, op_kinds@PAGE
    add x10, x10, op_kinds@PAGEOFF
    str x19, [x10, x9, lsl #3]
    adrp x10, op_arg0@PAGE
    add x10, x10, op_arg0@PAGEOFF
    str x20, [x10, x9, lsl #3]
    adrp x10, op_arg1@PAGE
    add x10, x10, op_arg1@PAGEOFF
    str x21, [x10, x9, lsl #3]
    adrp x10, op_arg2@PAGE
    add x10, x10, op_arg2@PAGEOFF
    str x22, [x10, x9, lsl #3]
    add x9, x9, #1
    str x9, [x23]
    mov x0, #0
    b Lrecord_op_return

Lrecord_op_full:
    adrp x0, msg_too_many_ops@PAGE
    add x0, x0, msg_too_many_ops@PAGEOFF
    mov x1, #2
    bl _write_cstr_fd
    mov x0, #1

Lrecord_op_return:
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
