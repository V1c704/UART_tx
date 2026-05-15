`timescale 1ns / 1ps

module reg0(
        input logic [10:0]  data_in,
        input logic         load,
        input logic         clk,
        input logic         rst,
        output logic [10:0] data_out
    );
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            data_out <= 11'd0;
        end
        else if(load) begin
            data_out <= data_in;
        end
    end
    
endmodule
