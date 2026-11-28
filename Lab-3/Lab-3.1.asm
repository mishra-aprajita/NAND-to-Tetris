// (a) Arithmetic Operation:
// R0 = 5 + 3
@5
D=A
@3
D=D+A
@R0
M=D

// R1 = 10 - 4
@10
D=A
@4
D=D-A
@R1
M=D

// R2 = 5 & 3
@5
D=A
@3
D=D&A
@R2
M=D

(END)
@END
0; JMP


// (b) Branching with Conditional Jumps:
// If R0 >= R1, set R2 = 1, else R2 = 0
@R0
D=M
@R1
D=D-M

@IS_GREATER_OR_EQUAL
D; JGE

// Else branch (R0 < R1)
@0
D=A
@R2
M=D
@END
0; JMP

(IS_GREATER_OR_EQUAL)
@1
D=A
@R2
M=D

(END)
@END
0; JMP


// (c) Simple Loop:
// R0 = 5(limit), R1 = accumulator(sum) R2 = counter
@5
D=A
@R0
M=D

@R1
M=0

@1
D=A
@R2
M=D

(LOOP_START)
// Check if counter > limit (if R2 - R0 > 0, exit loop)
@R2
D=M
@R0
D=D-M
@LOOP_END
D; JGT

// Sum = Sum + Counter
@R1
D=M
@R2
D=D+M
@R1
M=D

// Increment counter
@R2
M=M+1

@LOOP_START
0; JMP

(LOOP_END)
(END)
@END
0; JMP