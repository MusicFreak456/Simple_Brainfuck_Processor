`ifndef CONSTANTS
`define CONSTANTS

/////////////////STATES/////////////////
`define READY  3'b000 
`define ZERO   3'b001
`define WORK   3'b010 
`define WRITE  3'b011
`define READ   3'b100 
`define LEFT   3'b101                      
`define RIGHT  3'b110

///////////////SYMBOLS ASCII CODE///////
`define PLUS      8'd43 
`define MINUS     8'd45
`define RIGHTS    8'd62 
`define LEFTS     8'd60
`define BBRACKET  8'd91 
`define EBRACKET  8'd93
`define DOT       8'd46 
`define COMMA     8'd44
`define END       8'd0

//////////////CONTROL SIGNALS///////////
`define SYMBOL_RD  5'b00000 
`define MHDPP      5'b00001
`define MHDMM      5'b00010 
`define HDPP       5'b00011
`define HDMM       5'b00100 
`define RESET      5'b00101
`define RDBYTE     5'b00110 
`define ZERO_STATE 5'b00111
`define NEXT       5'b01000 
`define TORIGHT    5'b01001
`define CPPR       5'b01010 
`define CMMR       5'b01011
`define TOLEFT     5'b01100 
`define CPPL       5'b01101
`define CMML       5'b01110 
`define DONOTHING  5'b01111
`define PCMM       5'b10000

`endif