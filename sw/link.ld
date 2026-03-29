MEMORY {
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 64K
    RAM (rwx) : ORIGIN = 0x00010000, LENGTH = 64K
}

SECTIONS {
    .text : {
        *(.text.start)   /* start.S goes first — CPU boots here */
        *(.text*)
    } > ROM

    .rodata : { *(.rodata*) } > ROM

    .data : { *(.data*) } > RAM

    .bss : {
        _bss_start = .;
        *(.bss*)
        _bss_end = .;
    } > RAM

    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}