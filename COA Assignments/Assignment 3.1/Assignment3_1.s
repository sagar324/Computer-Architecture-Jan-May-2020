#########################################################
# Roll No:  CS18B029
# TITLE :- Assignment - 3.1 


# Initialyy it is in M mode, We set the mtvec to trap-entry for Machine mode,then we delegate traps to S-mode,by setting the medeleg bit
# Now using the MPP bits, we change the prev priv level to Supervisor mode ,because when we do an mret,we jump to start of Supervisor mode instructions,
# and now we come to Supervisor mode 
# Now set stvec to trap entry for Supervisor mode(S-mode),similarly set sepc to User mode instructions start address 
# Now we set the SPP bit so that when we sret, we move to sepc, but this time in U-mode. 
# Till this point , we moved from M-mode to S-mode to U-mode.
# Now In U-mode, we make an ecall. Since this is nothing but a trap, and we already delegated most of the traps to S-mode, we will enter the S-mode _s_trap_entry
# Where we will perform an illegal instruction. Now, since illegal instructions are
# handled in M-mode only, we now enter trap-entry for M-mode.
# Here,we moved from M-mode to S-mode to U-mode, and then from U-mode to S-mode ,then finally M-mode.

#if __riscv_xlen == 64
#define LREG ld
#define SREG sd
#define REGBYTES 8
#else
#define LREG lw
#define SREG sw
#define REGBYTES 4
#endif

#define STACK_BASE_ADDR 0x10010900

# We are in M- mode
_start:
    li sp, STACK_BASE_ADDR  
    la t0, _trap_entry       # Store address of _trap_entry.
    csrw mtvec, t0        # Setting mtvec to _trap_entry.

    andi t0,t0,0   
                   # Set medeleg to delegate all possible traps to S-mode.
    li t0, 0xffff                   
    csrs medeleg, t0
   
    li      t0, 0x1800
    csrrc   zero,mstatus, t0     # Clear the MPP[1:0] bits.
    li      t0, 0x0800
    csrs    mstatus, t0           # Set MPP with S-mode.
    la  t0, _s_mode        # Move the address of S-mode instructions to t0 and then to mepc.


    csrw    mepc, t0        
    mret                         # Jump to S-mode instructions in S-mode.

# S-mode code

_s_mode:
    la x17, _s_trap_entry # Store input address in x17.
    csrw stvec, x17         # Stvec contains start of _s_trap_entry

    li      t0, 0x0100
    csrc    sstatus, t0     # Set SPP with U-mode.
    la  t0, _u_mode         # Store the address of U-mode instructions in t0.
    csrw    sepc, t0         # Store that address into mepc.
    sret                     # Jump to U-mode instrcutions in U-mode.

# U-mode code

_u_mode:
    la x17, _s_trap_entry     # We store input address in x17 register.
    andi a0,a0,0
    addi a0,a0,65        # Passing one argument to ecall
    ecall
    jal _end

_end:
    ebreak

_trap_handler:
    andi t0,t0,0
    csrw mepc,t0
    addi t0,t0,4
    csrr t0,mepc
    ret

.p2align 2
_trap_entry:     # currently _trap_entry saves base reg values and calls trap handler
    addi sp, sp, -32*8
    sd x1, 1*8(sp)
    sd x2, 2*8(sp)
    sd x3, 3*8(sp)
    sd x4, 4*8(sp)
    sd x5, 5*8(sp)
    sd x6, 6*8(sp)
    sd x7, 7*8(sp)
    sd x8, 8*8(sp)
    sd x9, 9*8(sp)
    sd x10, 10*8(sp)
    sd x11, 11*8(sp)
    sd x12, 12*8(sp)
    sd x13, 13*8(sp)
    sd x14, 14*8(sp)
    sd x15, 15*8(sp)
    sd x16, 16*8(sp)
    sd x17, 17*8(sp)
    sd x18, 18*8(sp)
    sd x19, 19*8(sp)
    sd x20, 20*8(sp)
    sd x21, 21*8(sp)
    sd x22, 22*8(sp)
    sd x23, 23*8(sp)
    sd x24, 24*8(sp)
    sd x25, 25*8(sp)
    sd x26, 26*8(sp)
    sd x27, 27*8(sp)
    sd x28, 28*8(sp)
    sd x29, 29*8(sp)
    sd x30, 30*8(sp)
    sd x31, 31*8(sp)


    jal _trap_handler


    ld x1, 1*8(sp)
    ld x2, 2*8(sp)
    ld x3, 3*8(sp)
    ld x4, 4*8(sp)
    ld x5, 5*8(sp)
    ld x6, 6*8(sp)
    ld x7, 7*8(sp)
    ld x8, 8*8(sp)
    ld x9, 9*8(sp)
    ld x10, 10*8(sp)
    ld x11, 11*8(sp)
    ld x12, 12*8(sp)
    ld x13, 13*8(sp)
    ld x14, 14*8(sp)
    ld x15, 15*8(sp)
    ld x16, 16*8(sp)
    ld x17, 17*8(sp)
    ld x18, 18*8(sp)
    ld x19, 19*8(sp)
    ld x20, 20*8(sp)
    ld x21, 21*8(sp)
    ld x22, 22*8(sp)
    ld x23, 23*8(sp)
    ld x24, 24*8(sp)
    ld x25, 25*8(sp)
    ld x26, 26*8(sp)
    ld x27, 27*8(sp)
    ld x28, 28*8(sp)
    ld x29, 29*8(sp)
    ld x30, 30*8(sp)
    ld x31, 31*8(sp)
    mret

#data section
.p2align 2
_s_trap_entry:

    csrr t0, mstatus        # Illegal instrcution so that the trap is dealt with in M-mode.
                            # IN S-mode, we cant access mcause, so this is an illegal instruction and we move to M-mode.
                             
    addi sp, sp, -32*8
    sd x1, 1*8(sp)
    sd x2, 2*8(sp)
    sd x3, 3*8(sp)
    sd x4, 4*8(sp)
    sd x5, 5*8(sp)
    sd x6, 6*8(sp)
    sd x7, 7*8(sp)
    sd x8, 8*8(sp)
    sd x9, 9*8(sp)
    sd x10, 10*8(sp)
    sd x11, 11*8(sp)
    sd x12, 12*8(sp)
    sd x13, 13*8(sp)
    sd x14, 14*8(sp)
    sd x15, 15*8(sp)
    sd x16, 16*8(sp)
    sd x17, 17*8(sp)
    sd x18, 18*8(sp)
    sd x19, 19*8(sp)
    sd x20, 20*8(sp)
    sd x21, 21*8(sp)
    sd x22, 22*8(sp)
    sd x23, 23*8(sp)
    sd x24, 24*8(sp)
    sd x25, 25*8(sp)
    sd x26, 26*8(sp)
    sd x27, 27*8(sp)
    sd x28, 28*8(sp)
    sd x29, 29*8(sp)
    sd x30, 30*8(sp)
    sd x31, 31*8(sp)

    jal _strap_handler

    ld x1, 1*8(sp)
    ld x2, 2*8(sp)
    ld x3, 3*8(sp)
    ld x4, 4*8(sp)
    ld x5, 5*8(sp)
    ld x6, 6*8(sp)
    ld x7, 7*8(sp)
    ld x8, 8*8(sp)
    ld x9, 9*8(sp)
    ld x10, 10*8(sp)
    ld x11, 11*8(sp)
    ld x12, 12*8(sp)
    ld x13, 13*8(sp)
    ld x14, 14*8(sp)
    ld x15, 15*8(sp)
    ld x16, 16*8(sp)
    ld x17, 17*8(sp)
    ld x18, 18*8(sp)
    ld x19, 19*8(sp)
    ld x20, 20*8(sp)
    ld x21, 21*8(sp)
    ld x22, 22*8(sp)
    ld x23, 23*8(sp)
    ld x24, 24*8(sp)
    ld x25, 25*8(sp)
    ld x26, 26*8(sp)
    ld x27, 27*8(sp)
    ld x28, 28*8(sp)
    ld x29, 29*8(sp)
    ld x30, 30*8(sp)
    ld x31, 31*8(sp)
    sret

# Trap handler in S mode
_strap_handler:
    andi t0,t0,0
    csrw sepc,t0
    addi t0,t0,4
    csrr t0,sepc
    ret
