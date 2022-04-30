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
        /* Reserved for default stage 2 bootloader (256B) */
        *(.boot2*)
        . = 256;
    } > flash

    .copier :
    {
        /* SPI flash to RAM copying routine should go there */
        *(.copier*)
        . = 256;
    } > flash
}
