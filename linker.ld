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
        . = 256;
    } > flash

    .boot3 :
    {
        /* SPI flash to RAM copying routine should go there */
        . = 4K;
    } > flash

    .text :
    {
        *(.text*)
    } > ram

    .bss :
    {
        *(.bss*)
    } > ram

    .data :
    {
        *(.bss*)
    } > ram
}
