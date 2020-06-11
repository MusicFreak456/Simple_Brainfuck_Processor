`ifndef MEMORY
`define MEMORY

module memory(
    input clk,
    input load,
    input [7:0]datain,
    input [7:0]write_address,
    input [7:0]read_address,
    output signed logic [7:0]out,
);
    integer i;
    signed logic [7:0] mem [255:0];
    
    initial 
        for(i = 0; i < 256; i = i + 1)
            mem[i] = 7'b0;

    always_ff @(posedge clk)
        if(load) mem[write_address] <= datain;

    assign out = mem[read_address];
endmodule

`endif