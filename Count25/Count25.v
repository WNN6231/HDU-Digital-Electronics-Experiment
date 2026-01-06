module Count25 (
    input  wire       clk,
    input  wire       rst_n,
    output reg [3:0]  ten,
    output reg [3:0]  unit
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ten  <= 4'd2;
            unit <= 4'd4;
        end else begin
            if (ten == 4'd0 && unit == 4'd0) begin
                ten <= 4'd2; unit <= 4'd4;
            end else if (unit == 4'd0) begin
                ten <= ten - 1'b1; unit <= 4'd9;
            end else begin
                unit <= unit - 1'b1;
            end
        end
    end
endmodule