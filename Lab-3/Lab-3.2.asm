// Program 1: Using A-instruction
// -- Store a constant value in the A register

// Symbolic Assembly code and binary code:

// Symbolic Assembly Code                           Binary Code
@5                                               //0000000000000101
@10                                              //0000000000001010
@15                                              //0000000000001111
// Here, the first bit is 0, which identifies an A-instruction



// Program 2: Using C-instruction

// -- Perform addition and store the result in D register

// Symbolic Assembly code and binary code:

// Symbolic Assembly Code                           Binary Code
D=A                                              //1110110000010000
D=D+A                                            //1110000001001000
D=D-A                                            //1110010011010000
M=D                                              //1110001100001000

// Field Breakdown:

// A-instruction Format:
// 0 + 15-bit address

// C-instruction Format:
// 111 + comp + dest + jump\

// Conclusion:

// A-instructions are used to specify addresses or constants, whereas C-instructions perform computations and store results.