`timescale 1ns / 1ps

module top(
        input logic       start,
        input logic [7:0] data_in,
        input logic       clk,
        input logic       rst,
        output logic      out_tx
    );
    
    logic        toggle_out;
    logic [19:0] baud_count;
    logic [3:0]  bit_count;
    logic        crc_out;
    logic [10:0] reg_out;
    logic        mux_out;
    logic        baud_tick;
    logic        bit_10_reached;
    logic        start_condition;
    logic        a;
    logic        toggle_signal;
    logic        bit_counter_rst;
    
    assign baud_tick = (baud_count == 20'd5208);
    assign bit_10_reached = (bit_count == 4'd10);
    assign a = baud_tick & bit_10_reached;
    assign start_condition = start & (~toggle_out);
    assign toggle_signal = a | start_condition;
    assign bit_counter_rst = a | rst;
    assign out_tx = (~toggle_out) | mux_out;
    
    toggle_ff toggle_ff(
        .toggle(toggle_signal),
        .clk(clk),   
        .rst(rst),   
        .out(toggle_out)    
    );
    
    counter_baud_rate counter_baud_rate(
        .en(toggle_out),       
        .clk(clk),      
        .rst_async(rst), 
        .rst_sync(baud_tick),        
        .out(baud_count)       
    );
    
    counter_bit_select counter_bit_select(
        .en(baud_tick),  
        .rst(bit_counter_rst), 
        .clk(clk), 
        .out(bit_count)  
    );
    
    crc_calc crc_calc(
        .in(data_in),
        .out(crc_out)
    );
    
    reg0 reg0(
        .data_in({1'b1,crc_out,data_in,1'b0}),   
        .load(start & (bit_count == 4'd0) & (baud_count == 20'd0)),      
        .clk(clk),       
        .rst(rst),       
        .data_out(reg_out)   
    );
    
    mux mux(
        .in(reg_out), 
        .sel(bit_count),
        .out(mux_out) 
    );       
    
endmodule
