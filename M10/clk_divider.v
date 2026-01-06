module clk_divider (
    input wire clk_in,
    input wire rst_n, 
    output reg clk_out
);

    reg [24:0] cnt; 
    
    parameter PERIOD = 24999999; 

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_out <= 0;
        end
        else begin
            if (cnt == PERIOD) begin
                cnt <= 0;
                clk_out <= ~clk_out;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule