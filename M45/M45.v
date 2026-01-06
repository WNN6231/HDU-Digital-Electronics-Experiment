module M45 (
    input  wire       clk,
    input  wire       rst_n,
    output reg  [7:0] q,
    output wire       rco
);


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 8'd0;
        end else begin
            if (q >= 8'd44) begin
                q <= 8'd0;
            end else begin
                q <= q + 1'b1;
            end
        end
    end

 
    assign rco = (q == 8'd44) ? 1'b1 : 1'b0;

endmodule