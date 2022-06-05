start = 0x10000000;
ENTRY(start)

MEMORY
{
    flash (rx)  : ORIGIN = 0x10000000, LENGTH = 0x00200000
    ram   (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00042000
}

fw_start_addr = 0x20000000;

SECTIONS
{
    .boot2 :
    {
        /* Reserved for default stage 2 bootloader */
        *(.boot2*)
        . = 256;
    } > flash

    .copier :
    {
        /* SPI flash to RAM copying routine should go there */
        *(.copier*)
        . = 256;
    } > flash

    .bootapp :
    {
        /* Bootloader application that loads OS */
        *(.text*)
    } > flash

    /* To make binary 16kB of size, hacky but works */
    .fill 0x10003fff:
    {
        BYTE(0x00);
    } > flash

    .bss :
    {
        *(.bss*)
    } > ram

    stack_bottom = 0x20041000;
    .stack 0x20041000 :
    {
        . = 0x00001000;
    } > ram
    stack_top = .;
}
