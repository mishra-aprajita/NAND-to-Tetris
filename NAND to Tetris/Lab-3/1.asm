//1. R1 = R0 - 3, jump to NEG if R1 < 0
@R0

D=M

@3

D=D-A

@R1

M=D

@NEG

D;JLT




//2. Compute 9 - 4 in D, jump to address 12 if D < 0
@9

D=A

@4

D=D-A

@12

D;JLT