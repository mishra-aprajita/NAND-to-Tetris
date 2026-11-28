// Memory-Mapped I/O at the Binary Level
// 00/01 (0-16383): Routes to Ram16K

// 10(16384-24575): Routes to the Screen memory map (8192 16-bit words; each bit controls 1 pixel: 0=white, 1=black)

// 11(24576): Routes to the Keyboard register(outputs the 16-bit scan code of the pressed key, or 0000000000000000 if idle)

// Machine-Level Execution Trace:
(LOOP)
   @KBD
   D=M
   @CLEAR
   D; JEQ
   @SCREEN
   M=-1
   @LOOP
   0; JMP
(CLEAR)
   @SCREEN
   M=0
   @LOOP
   0; JMP