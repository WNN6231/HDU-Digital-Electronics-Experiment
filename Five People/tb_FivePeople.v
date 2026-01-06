`timescale 1ns/1ps

module tb_fivepeople;

reg a, b, c, d, e;
wire result;

integer i;

FivePeople uut (
    .a(a), .b(b), .c(c), .d(d), .e(e),
    .result(result)
);

initial begin
    for (i = 0; i < 32; i = i + 1) begin
        {a, b, c, d, e} = i[4:0];
        #10; 
    end

    #10;
    $stop;
end

endmodule
