// Box.asm  (K = 13)


(LOOP)
    @KBD
    D=M
    @BLACK
    D;JNE
    @color
    M=0
    @DRAW
    0;JMP
(BLACK)
    @color
    M=-1

(DRAW)
    @16800          // SCREEN + 32*13
    D=A
    @addr
    M=D
    @20             // 20 rows
    D=A
    @rows
    M=D

(ROWLOOP)
    @color
    D=M
    @addr
    A=M
    M=D             
    @addr
    A=M+1
    M=D            
    @32
    D=A
    @addr
    M=D+M           
    @rows
    M=M-1
    D=M
    @ROWLOOP
    D;JGT

    @LOOP
    0;JMP

