module trafficlight(
    input  wire clk,
    input  wire rst_n,
    
    output wire led_as_right_g,
    output wire led_as_str_y,
    output wire led_as_str_g,
    output wire led_as_str_r,
    output wire led_as_left_g,
    // 逻辑同步A通道南侧
    output wire led_an_right_g, led_an_str_y, led_an_str_g, led_an_str_r, led_an_left_g,
    
    output wire led_be_right_g,
    output wire led_be_str_y,
    output wire led_be_str_g,
    output wire led_be_str_r,
    output wire led_be_left_g,
    // 逻辑同步B通道东侧
    output wire led_bw_right_g, led_bw_str_y, led_bw_str_g, led_bw_str_r, led_bw_left_g,

    output reg [3:0] seg_sel,
    output reg [7:0] seg_led
);


    // 1. 参数与信号定义
    // 时间参数
    parameter T_STRAIGHT = 8'd15;
    parameter T_LEFT     = 8'd10;
    parameter T_YELLOW   = 8'd3;
    parameter T_BLINK    = 8'd5;

    // 状态机编码
    localparam S_A_STR_G  = 3'd0, S_A_STR_Y  = 3'd1;
    localparam S_A_LEFT_G = 3'd2, S_A_LEFT_Y = 3'd3;
    localparam S_B_STR_G  = 3'd4, S_B_STR_Y  = 3'd5;
    localparam S_B_LEFT_G = 3'd6, S_B_LEFT_Y = 3'd7;

    reg [2:0] state;
    reg [7:0] cnt_time;
    reg [25:0] clk_cnt;
    reg clk_1hz, clk_blink;

    // 内部灯光逻辑寄存器
    reg r_a_rg, r_a_sy, r_a_sg, r_a_sr, r_a_lg;
    reg r_b_rg, r_b_sy, r_b_sg, r_b_sr, r_b_lg;


    // 2. 时钟产生模块 (50MHz -> 1Hz)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt <= 0; clk_1hz <= 0;
        end else if (clk_cnt >= 24_999_999) begin
            clk_cnt <= 0; clk_1hz <= ~clk_1hz;
        end else begin
            clk_cnt <= clk_cnt + 1;
        end
    end
    
    // 产生约4Hz的闪烁时钟
    always @(posedge clk) clk_blink <= clk_cnt[23];


    // 3. 状态控制逻辑 (FSM)
    always @(posedge clk_1hz or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_A_STR_G;
            cnt_time <= T_STRAIGHT;
        end else if (cnt_time == 0) begin
            case (state)
                S_A_STR_G  : begin state <= S_A_STR_Y;  cnt_time <= T_YELLOW - 1;   end
                S_A_STR_Y  : begin state <= S_A_LEFT_G; cnt_time <= T_LEFT - 1;     end
                S_A_LEFT_G : begin state <= S_A_LEFT_Y; cnt_time <= T_YELLOW - 1;   end
                S_A_LEFT_Y : begin state <= S_B_STR_G;  cnt_time <= T_STRAIGHT - 1; end
                S_B_STR_G  : begin state <= S_B_STR_Y;  cnt_time <= T_YELLOW - 1;   end
                S_B_STR_Y  : begin state <= S_B_LEFT_G; cnt_time <= T_LEFT - 1;     end
                S_B_LEFT_G : begin state <= S_B_LEFT_Y; cnt_time <= T_YELLOW - 1;   end
                S_B_LEFT_Y : begin state <= S_A_STR_G;  cnt_time <= T_STRAIGHT - 1; end
                default    : begin state <= S_A_STR_G;  cnt_time <= T_STRAIGHT - 1; end
            endcase
        end else begin
            cnt_time <= cnt_time - 1;
        end
    end


    // 4. 灯光输出映射逻辑
    wire is_blink = (cnt_time < T_BLINK) && clk_blink; // 倒计时小于T_BLINK（闪烁值）且闪烁脉冲为高

    always @(*) begin
        // 默认状态：双向红灯，其他熄灭
        {r_a_rg, r_a_sy, r_a_sg, r_a_sr, r_a_lg} = 5'b00010;
        {r_b_rg, r_b_sy, r_b_sg, r_b_sr, r_b_lg} = 5'b00010;

        case (state)
            S_A_STR_G: begin
                r_a_sr = 0; r_a_rg = 1; 
                r_a_sg = (cnt_time < T_BLINK) ? is_blink : 1;
            end
            S_A_STR_Y: begin
                r_a_sr = 0; r_a_sy = 1; r_a_rg = 0;
            end
            S_A_LEFT_G: begin
                r_a_sr = 0; r_a_rg = 1; // 左转时右转也亮
                r_a_lg = (cnt_time < T_BLINK) ? is_blink : 1;
            end
            S_A_LEFT_Y: begin
                r_a_sr = 0; r_a_sy = 1;
            end
            
            S_B_STR_G: begin
                r_b_sr = 0; r_b_rg = 1;
                r_b_sg = (cnt_time < T_BLINK) ? is_blink : 1;
            end
            S_B_STR_Y: begin
                r_b_sr = 0; r_b_sy = 1; r_b_rg = 0;
            end
            S_B_LEFT_G: begin
                r_b_sr = 0; r_b_rg = 1;
                r_b_lg = (cnt_time < T_BLINK) ? is_blink : 1;
            end
            S_B_LEFT_Y: begin
                r_b_sr = 0; r_b_sy = 1;
            end
        endcase
    end

    // --- 南北/东西 对称关联 ---
    assign {led_as_right_g, led_as_str_y, led_as_str_g, led_as_str_r, led_as_left_g} = {r_a_rg, r_a_sy, r_a_sg, r_a_sr, r_a_lg};
    assign {led_an_right_g, led_an_str_y, led_an_str_g, led_an_str_r, led_an_left_g} = {r_a_rg, r_a_sy, r_a_sg, r_a_sr, r_a_lg};
    
    assign {led_be_right_g, led_be_str_y, led_be_str_g, led_be_str_r, led_be_left_g} = {r_b_rg, r_b_sy, r_b_sg, r_b_sr, r_b_lg};
    assign {led_bw_right_g, led_bw_str_y, led_bw_str_g, led_bw_str_r, led_bw_left_g} = {r_b_rg, r_b_sy, r_b_sg, r_b_sr, r_b_lg};


    // 5. 数码管动态扫描显示 (显示 cnt_time)
    reg [15:0] scan_cnt; 
    always @(posedge clk) scan_cnt <= scan_cnt + 1;

    wire [3:0] tens = cnt_time / 10;
    wire [3:0] ones = cnt_time % 10;
    reg [3:0] disp_num;

    always @(*) begin
        case (scan_cnt[15:14])
            2'b00: begin seg_sel = 4'b1110; disp_num = ones; end
            2'b01: begin seg_sel = 4'b1101; disp_num = tens; end
            2'b10: begin seg_sel = 4'b1011; disp_num = ones; end
            2'b11: begin seg_sel = 4'b0111; disp_num = tens; end
        endcase
    end


    always @(*) begin
        case (disp_num)
            4'h0: seg_led = 8'b1100_0000;
            4'h1: seg_led = 8'b1111_1001;
            4'h2: seg_led = 8'b1010_0100;
            4'h3: seg_led = 8'b1011_0000;
            4'h4: seg_led = 8'b1001_1001;
            4'h5: seg_led = 8'b1001_0010;
            4'h6: seg_led = 8'b1000_0010;
            4'h7: seg_led = 8'b1111_1000;
            4'h8: seg_led = 8'b1000_0000;
            4'h9: seg_led = 8'b1001_0000;
            default: seg_led = 8'b1111_1111;
        endcase
    end

endmodule