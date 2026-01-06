module FivePeople (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire y
);


    wire [2:0] sum;
    assign sum = a + b + c + d + e;   
    assign y   = (sum >= 3);        

endmodule
