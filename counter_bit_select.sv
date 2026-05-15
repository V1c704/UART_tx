`timescale 1ns / 1ps

module counter_bit_select(
        input logic        en,
        input logic        rst,
        input logic        clk,
        output logic [3:0] out
    );
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            out <= 4'd0;
        end
        else if(en) begin
            out <= out + 4'd1;
        end
    end
    
endmodule
