`ifndef DATA_PATH
`define DATA_PATH

`include "constants.sv"
`include "memory.sv"

module brnfck_datapath(
    input clk,
    input nrst,
    input [4:0] control_signal,
    input [7:0] in_data,
    output [7:0] symbol,
    output [2:0] data_signal,
    output [7:0] out_data
);
    logic [7:0]hd;
    logic [7:0]pc;
    logic load_txt;
    logic load_mem;
    logic [7:0] text_out;
    logic [7:0] mem_out;
    logic [7:0] mem_value;

    always_comb begin
        load_txt  = 0;
        load_mem  = 0;
        mem_value = 0;

        if(nrst)
        unique case(control_signal)
            `SYMBOL_RD: load_txt = 1;
            `ZERO_STATE: load_mem = 1;
            `MHDPP: begin
                load_mem = 1;
                mem_value = mem_out + 1;
            end
            `MHDMM: begin
                load_mem = 1;
                mem_value = mem_out - 1;
            end
            `RDBYTE: begin
                load_mem = 1;
                mem_value = in_data;
            end
        endcase
    end

    memory text(
        clk,
        load_txt, 
        in_data, 
        pc, 
        pc, 
        text_out
    );

    memory mem(
        clk, 
        load_mem, 
        mem_value, 
        hd, 
        hd, 
        mem_out
    );


    always_ff @(posedge clk or negedge nrst)
        if(!nrst) begin
            pc <= 0;
            hd <= 0;
        end else unique case(control_signal)
            `SYMBOL_RD: pc <= pc + 1;
            `ZERO_STATE: begin
                hd <= hd + 1;
                pc <= 0;
            end
            `MHDPP: pc <= pc + 1;
            `MHDMM: pc <= pc + 1;
            `HDPP: begin
                hd <= hd + 1;
                pc <= pc + 1;
            end
            `HDMM: begin
                hd <= hd - 1;
                pc <= pc + 1;
            end
            `NEXT: pc <= pc + 1;
            `RESET: begin
                pc <= 0;
                hd <= 0;
            end
            `RDBYTE: pc <= pc + 1;
            `TORIGHT: begin
                c <= 0;
                pc <= pc + 1;
            end
            `TOLEFT: begin
                c <= 0;
                pc <= pc - 1;
            end
            `CPPR: begin
                c <= c + 1;
                pc <= pc + 1;
            end
            `CMMR: begin
                c <= c - 1;
                pc <= pc + 1;
            end
            `CPPL: begin
                c <= c + 1;
                pc <= pc - 1;
            end
            `CMML: begin
                c <= c - 1;
                pc <= pc - 1;
            end
            `PCMM: pc <= pc - 1;
        endcase

    logic [7:0] hdp1 = hd + 1;
    assign data_signal[0] = hdp1 == 8'd0;
    assign data_signal[1] = mem_out == 0;
    assign data_signal[2] = c > 0;
    assign symbol = text_out;
    assign out_data = mem_out;
endmodule

`endif