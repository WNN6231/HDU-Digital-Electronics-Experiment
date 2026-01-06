module top_module (
    input  wire       clk_50M,
    input  wire       rst_n,
    output wire [7:0] led_q,
    output wire       led_rco
);

    wire clk_1Hz;

    divider u_div (
        .clk_in  (clk_50M),
        .rst_n   (rst_n),
        .clk_out (clk_1Hz)
    );

    M45 u_count (
        .clk   (clk_1Hz),
        .rst_n (rst_n),
        .q     (led_q),
        .rco   (led_rco)
    );

endmodule

// 分频器子模块放在同一个文件底部即可
module divider (
    input  wire clk_in,
    input  wire rst_n,
    output reg  clk_out
);
    reg [24:0] cnt;
    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_out <= 0;
        end else if (cnt == 24_999_999) begin
            cnt <= 0;
            clk_out <= ~clk_out;
        end else begin
            cnt <= cnt + 1;
        end
    end
endmodule