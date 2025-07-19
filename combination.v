module combination (
    input  wire [5:0]  j,
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [31:0] c,
    input  wire [31:0] d,
    input  wire [31:0] e,
    input  wire [31:0] f,
    input  wire [31:0] g,
    input  wire [31:0] h,
    input  wire [31:0] Wj,

    output wire [31:0] a_out,
    output wire [31:0] b_out,
    output wire [31:0] c_out,
    output wire [31:0] d_out,
    output wire [31:0] e_out,
    output wire [31:0] f_out,
    output wire [31:0] g_out,
    output wire [31:0] h_out
);


    // Hàm Sigma0 và Sigma1 lớn
    wire [31:0] Sigma0 = {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[31:22]};
    wire [31:0] Sigma1 = {e[5:0], e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[31:25]};

    // Hàm Ch và Maj
    wire [31:0] Ch  = (e & f) ^ (~e & g);
    wire [31:0] Maj = (a & b) ^ (a & c) ^ (b & c);


    // Hằng số K
    wire [31:0] K [0:63];
    assign K[ 0] = 32'h428a2f98; assign K[ 1] = 32'h71374491; assign K[ 2] = 32'hb5c0fbcf; assign K[ 3] = 32'he9b5dba5;
    assign K[ 4] = 32'h3956c25b; assign K[ 5] = 32'h59f111f1; assign K[ 6] = 32'h923f82a4; assign K[ 7] = 32'hab1c5ed5;
    assign K[ 8] = 32'hd807aa98; assign K[ 9] = 32'h12835b01; assign K[10] = 32'h243185be; assign K[11] = 32'h550c7dc3;
    assign K[12] = 32'h72be5d74; assign K[13] = 32'h80deb1fe; assign K[14] = 32'h9bdc06a7; assign K[15] = 32'hc19bf174;
    assign K[16] = 32'he49b69c1; assign K[17] = 32'hefbe4786; assign K[18] = 32'h0fc19dc6; assign K[19] = 32'h240ca1cc;
    assign K[20] = 32'h2de92c6f; assign K[21] = 32'h4a7484aa; assign K[22] = 32'h5cb0a9dc; assign K[23] = 32'h76f988da;
    assign K[24] = 32'h983e5152; assign K[25] = 32'ha831c66d; assign K[26] = 32'hb00327c8; assign K[27] = 32'hbf597fc7;
    assign K[28] = 32'hc6e00bf3; assign K[29] = 32'hd5a79147; assign K[30] = 32'h06ca6351; assign K[31] = 32'h14292967;
    assign K[32] = 32'h27b70a85; assign K[33] = 32'h2e1b2138; assign K[34] = 32'h4d2c6dfc; assign K[35] = 32'h53380d13;
    assign K[36] = 32'h650a7354; assign K[37] = 32'h766a0abb; assign K[38] = 32'h81c2c92e; assign K[39] = 32'h92722c85;
    assign K[40] = 32'ha2bfe8a1; assign K[41] = 32'ha81a664b; assign K[42] = 32'hc24b8b70; assign K[43] = 32'hc76c51a3;
    assign K[44] = 32'hd192e819; assign K[45] = 32'hd6990624; assign K[46] = 32'hf40e3585; assign K[47] = 32'h106aa070;
    assign K[48] = 32'h19a4c116; assign K[49] = 32'h1e376c08; assign K[50] = 32'h2748774c; assign K[51] = 32'h34b0bcb5;
    assign K[52] = 32'h391c0cb3; assign K[53] = 32'h4ed8aa4a; assign K[54] = 32'h5b9cca4f; assign K[55] = 32'h682e6ff3;
    assign K[56] = 32'h748f82ee; assign K[57] = 32'h78a5636f; assign K[58] = 32'h84c87814; assign K[59] = 32'h8cc70208;
    assign K[60] = 32'h90befffa; assign K[61] = 32'ha4506ceb; assign K[62] = 32'hbef9a3f7; assign K[63] = 32'hc67178f2;

    // Tính T1, T2
    wire [31:0] T1 = h + Sigma1 + Ch + K[j] + Wj;
    wire [31:0] T2 = Sigma0 + Maj;

    // Giá trị mới sau 1 vòng
    assign a_out = T1 + T2;
    assign b_out = a;
    assign c_out = b;
    assign d_out = c;
    assign e_out = d + T1;
    assign f_out = e;
    assign g_out = f;
    assign h_out = g;

endmodule
