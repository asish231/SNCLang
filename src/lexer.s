#include "platform.inc"
 .text
 .align 4
 .global _skip_whitespace
 .global _peek_char
 .global _peek_next_char
 .global _advance_char
 .global _get_cursor_ptr
 .global _is_eof

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
    LOAD_ADDR x9, cursor_pos
    ldr x10, [x9]
    LOAD_ADDR x11, source_len
    ldr x11, [x11]
    cmp x10, x11
    b.ge Lpeek_eof
    LOAD_ADDR x12, source_ptr
    ldr x12, [x12]
    ldrb w0, [x12, x10]
    ret

Lpeek_eof:
    mov w0, #0
    ret

_peek_next_char:
    LOAD_ADDR x9, cursor_pos
    ldr x10, [x9]
    add x10, x10, #1
    LOAD_ADDR x11, source_len
    ldr x11, [x11]
    cmp x10, x11
    b.ge Lpeek_next_eof
    LOAD_ADDR x12, source_ptr
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
    LOAD_ADDR x9, current_line
    ldr x10, [x9]
    add x10, x10, #1
    str x10, [x9]

Ladvance_no_newline:
    LOAD_ADDR x9, cursor_pos
    ldr x10, [x9]
    add x10, x10, #1
    str x10, [x9]

Ladvance_done:
    ldp x29, x30, [sp], #16
    ret

_get_cursor_ptr:
    LOAD_ADDR x9, source_ptr
    ldr x9, [x9]
    LOAD_ADDR x10, cursor_pos
    ldr x10, [x10]
    add x0, x9, x10
    ret

_is_eof:
    LOAD_ADDR x9, cursor_pos
    ldr x9, [x9]
    LOAD_ADDR x10, source_len
    ldr x10, [x10]
    cmp x9, x10
    cset x0, hs
    ret
