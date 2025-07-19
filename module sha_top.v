module sha_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_enable,
    input  wire [511:0] data_in,
    input  wire [7:0]  i_N,

    output reg         o_done,
    output reg [255:0] data_out
);

    // FSM States
    parameter IDLE     = 2'b00;
    parameter INIT     = 2'b01;
    parameter COMPRESS = 2'b10;
    parameter FINISH   = 2'b11;

    reg [1:0] current_state, next_state;

    // SHA-256 Initial Hash Values
    localparam [31:0] H0_0 = 32'h6a09e667;
    localparam [31:0] H0_1 = 32'hbb67ae85;
    localparam [31:0] H0_2 = 32'h3c6ef372;
    localparam [31:0] H0_3 = 32'ha54ff53a;
    localparam [31:0] H0_4 = 32'h510e527f;
    localparam [31:0] H0_5 = 32'h9b05688c;
    localparam [31:0] H0_6 = 32'h1f83d9ab;
    localparam [31:0] H0_7 = 32'h5be0cd19;

    // Hash value registers across blocks
    reg [31:0] H_reg [0:7];
    
    // Internal counters
    wire [5:0] j;
    wire [7:0] i;
    reg  clr_i, clr_j;
    reg  count_i_en, count_j_en;

    // Round registers for chaining
    reg [31:0] a_reg, b_reg, c_reg, d_reg, e_reg, f_reg, g_reg, h_reg;

    // Outputs from round
    wire [31:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out;

    // Counter modules
    sha256_counter_j u_counter_j (
        .i_clk(clk),
        .i_rst(~rst_n),
        .clr_j(clr_j),
        .cnt_j_en(count_j_en),
        .j(j)
    );

    sha256_counter_i u_counter_i (
        .i_clk(clk),
        .i_rst(~rst_n),
        .clr_i(clr_i),
        .cnt_i_en(count_i_en),
        .i(i)
    );

    // SHA round module
    sha_round_combined u_sha_round_combined (
        .j(j),
        .data_in(data_in),
        .a(a_reg),
        .b(b_reg),
        .c(c_reg),
        .d(d_reg),
        .e(e_reg),
        .f(f_reg),
        .g(g_reg),
        .h(h_reg),
        .a_out(a_out),
        .b_out(b_out),
        .c_out(c_out),
        .d_out(d_out),
        .e_out(e_out),
        .f_out(f_out),
        .g_out(g_out),
        .h_out(h_out)
    );

    // FSM next-state and control signals
    always @(*) begin
        next_state   = current_state;
        clr_i        = 0;
        clr_j        = 0;
        count_i_en   = 0;
        count_j_en   = 0;
        o_done       = 0;

        case (current_state)
            IDLE: begin
                clr_i = 1;
                clr_j = 1;
                if (i_enable)
                    next_state = INIT;
            end

            INIT: begin
                clr_j = 1;
                next_state = COMPRESS;
            end

            COMPRESS: begin
                if (j < 63) begin
                    count_j_en = 1;
                end else begin
                    // j == 63: kết thúc vòng nén, cộng vào H_reg tại đây
                    count_j_en = 0;
                    clr_j = 1;
                    next_state = FINISH;
                end
            end

            FINISH: begin
                if (i == i_N - 1) begin
                    o_done     = 1;
                    next_state = IDLE;
                end else begin
                    count_i_en = 1;
                    next_state = INIT;
                end
            end
        endcase
    end

    // FSM + Registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            H_reg[0] <= H0_0; H_reg[1] <= H0_1;
            H_reg[2] <= H0_2; H_reg[3] <= H0_3;
            H_reg[4] <= H0_4; H_reg[5] <= H0_5;
            H_reg[6] <= H0_6; H_reg[7] <= H0_7;
            data_out <= 256'b0;

            a_reg <= 0; b_reg <= 0; c_reg <= 0; d_reg <= 0;
            e_reg <= 0; f_reg <= 0; g_reg <= 0; h_reg <= 0;

        end else begin
            current_state <= next_state;

            case (current_state)
                INIT: begin
                    a_reg <= H_reg[0];
                    b_reg <= H_reg[1];
                    c_reg <= H_reg[2];
                    d_reg <= H_reg[3];
                    e_reg <= H_reg[4];
                    f_reg <= H_reg[5];
                    g_reg <= H_reg[6];
                    h_reg <= H_reg[7];
                end

                COMPRESS: begin
                    a_reg <= a_out;
                    b_reg <= b_out;
                    c_reg <= c_out;
                    d_reg <= d_out;
                    e_reg <= e_out;
                    f_reg <= f_out;
                    g_reg <= g_out;
                    h_reg <= h_out;

                    if (j == 6'd63) begin
                        H_reg[0] <= H_reg[0] + a_out;
                        H_reg[1] <= H_reg[1] + b_out;
                        H_reg[2] <= H_reg[2] + c_out;
                        H_reg[3] <= H_reg[3] + d_out;
                        H_reg[4] <= H_reg[4] + e_out;
                        H_reg[5] <= H_reg[5] + f_out;
                        H_reg[6] <= H_reg[6] + g_out;
                        H_reg[7] <= H_reg[7] + h_out;
                    end
                end

                FINISH: begin
                    if (i == i_N - 1) begin
                        data_out <= {
                            H_reg[0],
                            H_reg[1],
                            H_reg[2],
                            H_reg[3],
                            H_reg[4],
                            H_reg[5],
                            H_reg[6],
                            H_reg[7]
                        };
                    end
                end
            endcase
        end
    end
endmodule
