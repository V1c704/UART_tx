`timescale 1ns / 1ps


module toggle_ff(
        input logic  toggle,
        input logic  clk,
        input logic  rst,
        output logic out
    );
    
    localparam Q0 = 1'b0;
    localparam Q1 = 1'b1;
    logic state, state_next;
    
    always_ff @(posedge clk) begin
        if(rst)begin
            state <= Q0;
        end
        else begin
            state <= state_next;
        end    
    end
    
    always_comb begin
        state_next = state;
        case(state)
            Q0: begin
                    if(toggle == 0) state_next = Q0;
                    else state_next = Q1;
                end
            Q1: begin
                    if(toggle == 0) state_next = Q1;
                    else state_next = Q0;
                end 
            default: begin
                    state_next = Q0;
                end          
        endcase
    end
    
    assign out = (state == Q1); 
    
endmodule
