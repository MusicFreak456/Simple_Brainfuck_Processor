`include "data_path.sv"
`include "control_path.sv"

module toplevel(
    input clk,
    input nrst,
    input [7:0] in_data,
    input in_valid,
    output in_ack,
    output [7:0] out_data,
    output out_valid,
    input out_ack,
    input start,
    output ready
);
    logic [7:0] symbol;
    logic [2:0] data_signal;
    logic [4:0] control_signal;

    brnfck_ctrlpath ctrl_path(
        clk, 
        nrst, 
        start, 
        in_valid, 
        out_ack, 
        in_ack, 
        out_valid, 
        data_signal, 
        symbol, 
        control_signal, 
        ready
    );

    brnfck_datapath dt_path(
        clk, 
        nrst, 
        control_signal, 
        in_data, 
        symbol, 
        data_signal, 
        out_data    
    );
endmodule