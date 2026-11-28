// Program: Building complete Hack CPU chip

CHIP CPU {
    IN  inM[16], instruction[16], reset;
    OUT outM[16], writeM, addressM[15], pc[15];

    PARTS:
    // Instruction type
    Not(in=instruction[15], out=isA);
    Not(in=isA, out=isC);

    // A register: load on A-instr or d1 (bit 5)
    Mux16(a=instruction, b=aluOut, sel=isC, out=aIn);
    Or(a=isA, b=instruction[5], out=loadA);
    ARegister(in=aIn, load=loadA, out=aOut, out[0..14]=addressM);

    // ALU inputs: a-bit (12) picks A or M
    Mux16(a=aOut, b=inM, sel=instruction[12], out=aluY);

    ALU(x=dOut, y=aluY,
        zx=instruction[11], nx=instruction[10],
        zy=instruction[9],  ny=instruction[8],
        f=instruction[7],   no=instruction[6],
        out=aluOut, out=outM, zr=zr, ng=ng);

    // D register: d2 (bit 4)
    And(a=isC, b=instruction[4], out=loadD);
    DRegister(in=aluOut, load=loadD, out=dOut);

    // writeM: d3 (bit 3)
    And(a=isC, b=instruction[3], out=writeM);

    // Jump logic: j1 (bit 2) <0, j2 (bit 1) =0, j3 (bit 0) >0
    Or(a=zr, b=ng, out=zrOrNg);
    Not(in=zrOrNg, out=pos);
    And(a=instruction[2], b=ng,  out=jLT);
    And(a=instruction[1], b=zr,  out=jEQ);
    And(a=instruction[0], b=pos, out=jGT);
    Or(a=jLT, b=jEQ, out=jLE);
    Or(a=jLE, b=jGT, out=jmpCond);
    And(a=isC, b=jmpCond, out=jump);

    // Program counter
    PC(in=aOut, load=jump, inc=true, reset=reset, out[0..14]=pc);
}