`timescale 1ns / 1ps

module counter_baud_rate(
        input logic         en,
        input logic         clk,
        input logic         rst_async,
        input logic         rst_sync,
        output logic [19:0] out
    );
    
    always_ff @(posedge clk or posedge rst_async) begin
        if(rst_async) begin
            out <= 20'd0;
        end
        else if(rst_sync) begin
            out <= 20'd0;
        end
        else if(en == 1) begin
            out <= out + 20'd1;
        end
    end
    
endmodule
