.syntax unified
.cpu cortex-m0plus
.thumb

.align 2

#include "hardware/regs/m0plus.h"
#include "hardware/regs/addressmap.h"


// No need to any kind of initialization (stack, vector address) here.
// Pico boot2 does following on his own:
// 1. Set vector table address to XIP_START + 256 (just after boot2)
// 2. Set stack pointer to value of first word after boot2 (XIP_START + 256)
// 3. Jump to second word after boot2 (XIP_START + 256 + 4)
// As it has been decided to keep boot2 unchanged, let's keep it that way
// and follow its convention.
//; .text
//
//; .global _start
//
//; _start:
//; ldr r0, =_vectors
//; ldr r1, =(PPB_BASE + M0PLUS_VTOR_OFFSET)
//; str r0, [r1]
//; ldr r1, =0x20042000
//; msr msp, r1
//; bl main

// .section .vectors

// No matter what - start with regular post reset flow.
.global bootapp_start
bootapp_start:
b reset_handler

.global vectors
vectors:
.word stack_top
.word reset_handler
.word isr_nmi
.word isr_hardfault
.word isr_invalid // Reserved, should never fire
.word isr_invalid // Reserved, should never fire
.word isr_invalid // Reserved, should never fire
.word isr_invalid // Reserved, should never fire
.word isr_invalid // Reserved, should never fire
.word isr_invalid // Reserved, should never fire
.word isr_invalid // Reserved, should never fire
.word isr_svcall
.word isr_invalid // Reserved, should never fire
.word isr_invalid // Reserved, should never fire
.word isr_pendsv
.word isr_systick
.word isr_irq0
.word isr_irq1
.word isr_irq2
.word isr_irq3
.word isr_irq4
.word isr_irq5
.word isr_irq6
.word isr_irq7
.word isr_irq8
.word isr_irq9
.word isr_irq10
.word isr_irq11
.word isr_irq12
.word isr_irq13
.word isr_irq14
.word isr_irq15
.word isr_irq16
.word isr_irq17
.word isr_irq18
.word isr_irq19
.word isr_irq20
.word isr_irq21
.word isr_irq22
.word isr_irq23
.word isr_irq24
.word isr_irq25
.word isr_irq26
.word isr_irq27
.word isr_irq28
.word isr_irq29
.word isr_irq30
.word isr_irq31

.global reset_handler
.global isr_nmi
.global isr_hardfault
.global isr_invalid // Reserved, should never fire
.global isr_invalid // Reserved, should never fire
.global isr_invalid // Reserved, should never fire
.global isr_invalid // Reserved, should never fire
.global isr_invalid // Reserved, should never fire
.global isr_invalid // Reserved, should never fire
.global isr_invalid // Reserved, should never fire
.global isr_svcall
.global isr_invalid // Reserved, should never fire
.global isr_invalid // Reserved, should never fire
.global isr_pendsv
.global isr_systick
.global isr_irq0
.global isr_irq1
.global isr_irq2
.global isr_irq3
.global isr_irq4
.global isr_irq5
.global isr_irq6
.global isr_irq7
.global isr_irq8
.global isr_irq9
.global isr_irq10
.global isr_irq11
.global isr_irq12
.global isr_irq13
.global isr_irq14
.global isr_irq15
.global isr_irq16
.global isr_irq17
.global isr_irq18
.global isr_irq19
.global isr_irq20
.global isr_irq21
.global isr_irq22
.global isr_irq23
.global isr_irq24
.global isr_irq25
.global isr_irq26
.global isr_irq27
.global isr_irq28
.global isr_irq29
.global isr_irq30
.global isr_irq31
.global exit

.text

.weak reset_handler
.type reset_handler,%function
.thumb_func
reset_handler:
    // Do initialization of vectors as previous points to copier
    // At compile time vectors section is locaten in flash so it
    // needs to be recalculated. Fortunately we know where copier
    // has copied bootapp code.
    // Calculations go as follows:
    // bootapp_start is where the code starts
    // vectors is where vectors are located
    // knowing the difference between these two values we can
    // calculate where vectors are located knowing where
    // copier copied the code to SRAM:
    // fw_start_address + (vectors - bootapp_start)
    ldr r0, =vectors
    ldr r1, =(PPB_BASE + M0PLUS_VTOR_OFFSET)
    str r0, [r1]
    ldr r1, =stack_top
    msr msp, r1
    // would be extremely nice to zero out also the bss before main :)
    bl main
    bl exit

.weak isr_nmi
.type isr_nmi,%function
.thumb_func
isr_nmi:

.weak isr_hardfault
.type isr_hardfault,%function
.thumb_func
isr_hardfault:

.weak isr_invalid
.type isr_invalid,%function
.thumb_func
isr_invalid:

.weak isr_svcall
.type isr_svcall,%function
.thumb_func
isr_svcall:

.weak isr_pendsv
.type isr_pendsv,%function
.thumb_func
isr_pendsv:

.weak isr_systick
.type isr_systick,%function
.thumb_func
isr_systick:

.weak isr_irq0
.type isr_irq0,%function
.thumb_func
isr_irq0:

.weak isr_irq1
.type isr_irq1,%function
.thumb_func
isr_irq1:

.weak isr_irq2
.type isr_irq2,%function
.thumb_func
isr_irq2:

.weak isr_irq3
.type isr_irq3,%function
.thumb_func
isr_irq3:

.weak isr_irq4
.type isr_irq4,%function
.thumb_func
isr_irq4:

.weak isr_irq5
.type isr_irq5,%function
.thumb_func
isr_irq5:

.weak isr_irq6
.type isr_irq6,%function
.thumb_func
isr_irq6:

.weak isr_irq7
.type isr_irq7,%function
.thumb_func
isr_irq7:

.weak isr_irq8
.type isr_irq8,%function
.thumb_func
isr_irq8:

.weak isr_irq9
.type isr_irq9,%function
.thumb_func
isr_irq9:

.weak isr_irq10
.type isr_irq10,%function
.thumb_func
isr_irq10:

.weak isr_irq11
.type isr_irq11,%function
.thumb_func
isr_irq11:

.weak isr_irq12
.type isr_irq12,%function
.thumb_func
isr_irq12:

.weak isr_irq13
.type isr_irq13,%function
.thumb_func
isr_irq13:

.weak isr_irq14
.type isr_irq14,%function
.thumb_func
isr_irq14:

.weak isr_irq15
.type isr_irq15,%function
.thumb_func
isr_irq15:

.weak isr_irq16
.type isr_irq16,%function
.thumb_func
isr_irq16:

.weak isr_irq17
.type isr_irq17,%function
.thumb_func
isr_irq17:

.weak isr_irq18
.type isr_irq18,%function
.thumb_func
isr_irq18:

.weak isr_irq19
.type isr_irq19,%function
.thumb_func
isr_irq19:

.weak isr_irq20
.type isr_irq20,%function
.thumb_func
isr_irq20:

.weak isr_irq21
.type isr_irq21,%function
.thumb_func
isr_irq21:

.weak isr_irq22
.type isr_irq22,%function
.thumb_func
isr_irq22:

.weak isr_irq23
.type isr_irq23,%function
.thumb_func
isr_irq23:

.weak isr_irq24
.type isr_irq24,%function
.thumb_func
isr_irq24:

.weak isr_irq25
.type isr_irq25,%function
.thumb_func
isr_irq25:

.weak isr_irq26
.type isr_irq26,%function
.thumb_func
isr_irq26:

.weak isr_irq27
.type isr_irq27,%function
.thumb_func
isr_irq27:

.weak isr_irq28
.type isr_irq28,%function
.thumb_func
isr_irq28:

.weak isr_irq29
.type isr_irq29,%function
.thumb_func
isr_irq29:

.weak isr_irq30
.type isr_irq30,%function
.thumb_func
isr_irq30:

.weak isr_irq31
.type isr_irq31,%function
.thumb_func
isr_irq31:

.weak exit
.type exit,%function
.thumb_func
exit:
    // This is where we land if main finishes. Such situation should never happen
    // but just in case let's make program stay here
    b exit
