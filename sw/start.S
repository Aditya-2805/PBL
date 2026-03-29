.section .text.start   /* linker puts this first, before any C code */
.global _start

_start:
    /* Set stack pointer to top of RAM */
    la   sp, _stack_top

    /* Zero out .bss section (uninitialized globals) */
    la   a0, _bss_start
    la   a1, _bss_end
bss_loop:
    bge  a0, a1, bss_done
    sw   zero, 0(a0)
    addi a0, a0, 4
    j    bss_loop
bss_done:

    /* Jump into C */
    call main

    /* If main returns, halt forever */
halt:
    j halt