.syntax unified
.cpu cortex-m0plus
.thumb

.align 2

.section .copier
.word 0x20042000    // This is SP value to be set
.word (copier_start+1)  // This is vector table address (dummy for now, beginning of this code)
// .word 0x736F5F73 // Copier magic. This is needed because boot2, after its execution,
//                  // jumps to XIP_START + 256 + 4 and copier starts at XIP_START + 256.
.global copier_start
copier_start:
    ldr r6, =(0xABACADAE) // Just debug track
    ldr r7, =(0xABACADAE) // Just debug track
    // Initial conditions
    ldr r1, =0x10000200 // Source address
    ldr r2, =0x10004200 // Source address to stop copying at
    ldr r4, =0x20000000 // Destination address
 
1:
    // bkpt
    // Copying routine
    ldr r3, [r1]    // Read 4B of data from source address
    str r3, [r4]    // Write 4B of data to destination address
    adds r1, r1, #4 // Increment source address by 4B
    adds r4, r4, #4 // Increment destination address by 4B
    cmp r1, r2      // Check whether it is max. source address
    bne 1b          // If not then jump to beginning of copy routine
    ldr r6, =(0xDEADBEEF) // Just debug track
    ldr r7, =(0xDEADBEEF) // Just debug track
    ldr r5, =(fw_start_addr+1) // Jump to expected start of FW - debug for now, taken from elf +1
                    // Increment jumpt addres by 1. This is required because
                    // ARMv6-M needs LSB set for code location when jumping
                    // (this bit is used to indicate this is thumb instruction)
    bx r5 // Jump to expected start of FW - debug for now, taken from elf +1
    // bl =0x20000000 // Jump to expected start of FW
 
hang:
    b hang           // We should never reach this point but in such case
                     // let's stick to this place

