#########################################################
# Roll No:  CS18B029
# TITLE :- Assignment - 3.2






# Initially we start in M mode then we move to S mode 
# Set stvec to handle ecall from U mode then we move to U mode
# In U mode we pass arguments
# If no of arguments are greater than 7 then we push arguments onto stack
# a0 is used to distinguish system calls
# we set medleg to handle all possible traps to be handled in S mode






#if __riscv_xlen == 64
#define LREG ld
#define SREG sd
#define REGBYTES 8
#define XLEN 63

#else
#define LREG lw
#define SREG sw
#define REGBYTES 4
#define XLEN 31
#endif
# This is stack base address
#define STACK_BASE_ADDR 0x10012000

_start:
li sp, STACK_BASE_ADDR # set sp
la t0, trap_entry      # set entry point for traps
csrw mtvec, t0

# Trying to delegate all traps to S mode.
# But only some get delegated.

# While debugging, list of delegated traps will be known
andi t0,t0,0
la t0, 0xffff
csrs medeleg, t0    
#We need ecall from user mode to be delegated to supervisor mode

#clearing the MPP[1:0] bits in mstatus

andi t0,t0,0
li      t0, 0x1800
csrrc   zero,mstatus, t0



#set MPP[1:0] to 01. This means, we have hardcoded prev priv as S mode

li      t0, 0x0800
csrs    mstatus, t0          # set mpp (previous mode) with S mode
la  t0, s_mode_begin         # set up mepc with address of S mode re-entry function

#When we do a mret, we go to the prev priv.

# Where do we go in prev priv mode ?
#we are saying to go to some address using mepc register 
csrw    mepc, t0
mret                         #exiting M mode
 

#S mode entry 
s_mode_begin:

  # instrn to set trap entry in S mode
la x17, _data1  #base address
csrw stvec, x17 #stvec is set to _data1

  #set SPP bit = 0 in sstatus. 
  #Hardcoding, prev priv mode to User
li      t0, 0x0100
csrc    sstatus, t0   # set spp (previous mode) with U mode
la  t0, u_mode_begin  # set up sepc with address of U mode re-entry function

csrw    sepc, t0   #setting the U mode entry code here
sret                         #exiting S mode



# U mode entry
u_mode_begin:

# passing arguments for bite
andi a0,a0,0
addi a0,a0,1  #a0 = 1 for bite
# passing 1st argument
andi a1,a1,0
addi a1,a1,10 
# passing 2nd argument
andi a2,a2,0
addi a2,a2,95 
# passing 3rd argument
andi a3,a3,0
  addi a3,a3,66 

ecall  # this is for bite

andi a0,a0,0
addi a0,a0,2 #a0 = 2 for cite
# passing 1st argument
andi a1,a1,0
addi,a1,a1,23 
# passing 2nd argument
andi a2,a2,0
addi a2,a2,67 

ecall # this is for cite

andi a0,a0,0
addi a0,a0,3 # a0 = 3 for kite

addi sp,sp,-15*8 as we are pushing 14 arguments

andi t0,t0,0
addi t0,t0,35
sd t0,1*8(sp)

andi t0,t0,0
addi t0,t0,99
sd t0,2*8(sp)

andi t0,t0,0
addi t0,t0,12
sd t0,3*8(sp)

andi t0,t0,0
addi t0,t0,13
sd t0,4*8(sp)

andi t0,t0,0
addi t0,t0,0
sd t0,5*8(sp)

andi t0,t0,0
addi t0,t0,4
sd t0,6*8(sp)

andi t0,t0,0
addi t0,t0,5
sd t0,7*8(sp)

andi t0,t0,0
addi t0,t0,9
sd t0,8*8(sp)

andi t0,t0,0
addi t0,t0,12
sd t0,9*8(sp)

andi t0,t0,0
addi t0,t0,1
sd t0,10*8(sp)

andi t0,t0,0
addi t0,t0,2
sd t0,11*8(sp)

andi t0,t0,0
addi t0,t0,2
sd t0,12*8(sp)

andi t0,t0,0
addi t0,t0,3
sd t0,13*8(sp)

andi t0,t0,0
addi t0,t0,9
sd t0,14*8(sp)

ecall  # this ecall is for kite

# random instruction
andi t1,t1,0
addi t1,t1,3
jal _end     # to end the program

_end:
ebreak

#trap handler code
trap_handler:

ret


#trap entry
.p2align 2
trap_entry:     #trap_entry saves base register values and calls trap handler
addi sp, sp, -32*8
 #x0 is always 0
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

#jump to trap handler
jal trap_handler

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



#trap handler in S mode
strap_handler:

andi t2,t2,0
csrr t2,sepc # store sepc value in t2
addi t2,t2,4 # increase sepc value by 4
sd t2,32*8(sp) # storing new sepc value on stack
csrw sepc,t2

andi t0,t0,0
addi t0,t0,1
beq a0,t0,_bite
andi t0,t0,0
addi t0,t0,2
beq a0,t0,_cite
andi t0,t0,0
addi t0,t0,3
beq a0,t0,_kite

ret


#data section
.p2align 2
_data1:     #trap_entry saves base register values and calls trap handler
addi sp, sp, -33*8
 #x0 is always 0
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

#jump to trap handler
jal strap_handler

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
ld x31, 32*8(sp)
# store  new sepc value in sepc
csrw sepc,x31 
ld x31,31*8(sp)
sret