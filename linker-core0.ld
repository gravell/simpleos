start = 0x20000000;
ENTRY(start)

MEMORY
{
    flash (rx)  : ORIGIN = 0x10000000, LENGTH = 0x00200000
    ram   (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00042000
}

SECTIONS
{
    .boot2 :
    {
        /* Reserved for default stage 2 bootloader (256B) */
        /* boot2.o */
        *(.boot2*)
        . = 256;
    } > flash

    /*
    .vectors :
    {
        boot2 requires that vector table is first data in binary
    } > flash
    */

    .copier :
    {
        /* SPI flash to RAM copying routine should go there */
        *(.copier*)
        . = 256;
    } > flash

    .text :
    {
        *(.text*)
    } > ram

    /*
    .data :
    {
        *(.data*)
    } > ram
    */

    .bss :
    {
        *(.bss*)
    } > ram

    stack_bottom = 0x20041000;
    .stack 0x20041000 :
    {
        . = 0x00001000;
        /* *(.stack*) */
    } > ram
    stack_top = .;
}
