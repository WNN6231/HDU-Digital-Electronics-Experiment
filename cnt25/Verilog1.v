// 模块功能：将 4位 BCD 码转换为七段数码管段选信号（低电平有效）
module bcd_to_7seg (
    input  [3:0] bcd,       // 来自 74192 的 QA, QB, QC, QD
    output reg [6:0] seg    // 对应数码管的 {g, f, e, d, c, b, a}
);

    always @(*) begin
        case (bcd)
            4'h0: seg = 7'b1000000; // 显示 0
            4'h1: seg = 7'b1111001; // 显示 1
            4'h2: seg = 7'b0100100; // 显示 2
            4'h3: seg = 7'b0110000; // 显示 3
            4'h4: seg = 7'b0011001; // 显示 4
            4'h5: seg = 7'b0010010; // 显示 5
            4'h6: seg = 7'b0000010; // 显示 6
            4'h7: seg = 7'b1111000; // 显示 7
            4'h8: seg = 7'b0000000; // 显示 8
            4'h9: seg = 7'b0010000; // 显示 9
            default: seg = 7'b1111111; // 全灭
        endcase
    end
endmodule