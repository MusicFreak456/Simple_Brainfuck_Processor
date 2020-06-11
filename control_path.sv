`ifndef CONTROL_PATH
`define CONTROL_PATH
`include "constants.sv"

module brnfck_ctrlpath(
    input clk,
    input nrst,
    input start,
    input in_valid,
    input out_ack,
    output in_ack,
    output out_valid,
    input [2:0] data_signal,
    input [7:0] symbol,
    output [4:0] control_signal,
    output ready
);
    logic [3:0]state;

    always_ff @(posedge clk or negedge nrst)
        if(!nrst) begin
            state <= `READY;
        end
        else unique case(state)
            `READY: if(start) state <= `ZERO;
            `ZERO: if(data_signal[0]) state <= `WORK;
            `WORK: begin
                unique case(symbol)
                    `DOT: state <= `WRITE;
                    `COMMA: state <= `READ;
                    `BBRACKET: if(data_signal[1]) state <= `RIGHT;
                              else state <= `WORK;
                    `EBRACKET: if(data_signal[1]) state <= `WORK;
                              else state <= `LEFT;
                    `END: state <= `READY; 
                endcase
            end
            `WRITE: if(out_ack) state <= `WORK;
            `READ: if(in_valid) state <= `WORK;
            `RIGHT: if(symbol == `EBRACKET & !data_signal[2]) state <= `WORK;
            `LEFT: if(symbol == `BBRACKET & !data_signal[2]) state <= `WORK;
        endcase

    assign ready = state == `READY;

    always_comb begin
        control_signal = `DONOTHING;
        out_valid = 0;
        in_ack = 0;

        if(nrst)
        unique case(state)
            `READY: begin
                    if(in_valid) begin
                        in_ack = 1;
                        control_signal = `SYMBOL_RD;
                    end
            end
            `ZERO: control_signal = `ZERO_STATE;
            `WORK: begin
                unique case(symbol)
                    `PLUS:   control_signal = `MHDPP;
                    `MINUS:  control_signal = `MHDMM;
                    `RIGHTS: control_signal = `HDPP;
                    `LEFTS:  control_signal = `HDMM;
                    `BBRACKET: if(data_signal[1]) control_signal <= `TORIGHT;
                               else               control_signal <= `NEXT;
                    `EBRACKET: if(data_signal[1]) control_signal <= `NEXT;
                               else               control_signal <= `TOLEFT;
                    `END:                         control_signal = `RESET;
                endcase
            end
            `WRITE: begin
                    out_valid = 1;
                    if(out_ack) control_signal = `NEXT;
            end
            `READ: begin
                  in_ack = 1;
                  if(in_valid) control_signal = `RDBYTE;
            end
            `RIGHT: begin
                unique case(symbol)
                    `BBRACKET: control_signal <= `CPPR;
                    `EBRACKET: if(data_signal[2]) control_signal <= `CMMR;
                              else control_signal <= `NEXT;
                    default: control_signal <= `NEXT;
                endcase
            end
            `LEFT: begin
                unique case(symbol)
                    `EBRACKET: control_signal <= `CPPL;
                    `BBRACKET: if(data_signal[2]) control_signal <= `CMML;
                              else control_signal <= `NEXT;
                    default: control_signal <= `PCMM;
                endcase
            end
        endcase
    end

endmodule

`endif