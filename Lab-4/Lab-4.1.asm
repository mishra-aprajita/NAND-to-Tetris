// Critical Case: Loop Termination
// In the Hack CPU, the ALU outputs two status flag alongside the 16-bit result out:

// zr - 1 if out == 0, else 0.

// ng - 1 if out < 0, else 0.

// The CPU combines zr, ng, and the instruction's jump bits to decide whether PC jumps or continues.

// Demonstration Program:
@3
   D=A
   @R0
   M=D

(LOOP)
   @R0
   D=M
   @END
   D; JLE
   @R0
   M=M-1
   @LOOP
   0; JMP

(END)
    @END
    0; JMP

// What Happens if Flag Logic is Incorrect
// Bug in zr

// 1. When R0 reaches 0, zr fails to assert, so D; JLE does not jump

// 2. R0 decrements to -1. On next iteration, ng=1 triggers the jump, causing an off-by-one error. If the instruction were D; JEQ , the program would enter an infinite loop, corrupting memory and never halting.

// Bug in ng

// 1. On iteration 1, out[0]=1 falsely sets ng=1.

// 2. D; JLE evaluates jump=1 immediately, prematurely terminating the loop on the very first pass before any work is done.