`timescale 1ns / 1ps

module top(
        input logic       start,
        input logic [7:0] data_in,
        input logic       clk,
        input logic       rst,
        output logic      out_tx
    );
    
    logic a;
    
    toggle_ff toggle_ff(
        .toggle(),
        .clk(clk),   
        .rst(rst),   
        .out()    
    );
    
    counter_baud_rate counter_baud_rate(
        .en(),       
        .clk(),      
        .rst_async(),
        .rst_sync(), 
        .out()       
    );
    
    counter_bit_select counter_bit_select(
        .en(),  
        .rst(), 
        .clk(), 
        .out()  
    );
    
    crc_calc crc_calc(
        .in(),
        .out()
    );
    
    reg0 reg0(
        .data_in(),   
        .load(),      
        .clk(),       
        .rst(),       
        .data_out()   
    );
    
    mux mux(
        .in(), 
        .sel(),
        .out() 
    );
endmodule
