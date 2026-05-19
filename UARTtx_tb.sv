`timescale 1ns / 1ps

module UARTtx_tb();

logic       start;   
logic [7:0] data_in; 
logic       clk;     
logic       rst;     
logic       out_tx;   

top dut(
    .start(start),  
    .data_in(data_in),
    .clk(clk),    
    .rst(rst),    
    .out_tx(out_tx)  
);

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    rst = 1'b1;
    start = 1'b0;
    data_in = 8'b01010101;
    #100;
    
    rst = 1'b0;
    #35;
    
    start = 1'b1;
    #20;
    
    start = 1'b0;
    #1200000;
    
    $stop;    
end

endmodule
