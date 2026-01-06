`timescale 1ns/1ps

module Count25_tb;
    reg clk;
    reg rst_n;
    wire [3:0] ten;
    wire [3:0] unit;


    Count25 uut (
        .clk(clk),
        .rst_n(rst_n),
        .ten(ten),
        .unit(unit)
    );


    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        #25 rst_n = 1;
        
        #1000;
        $stop;
    end
endmodule