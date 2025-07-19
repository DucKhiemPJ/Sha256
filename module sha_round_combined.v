module sha_round_combined (
    input  wire [5:0]  j,              
    input  wire [511:0] data_in,       

    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [31:0] c,
    input  wire [31:0] d,
    input  wire [31:0] e,
    input  wire [31:0] f,
    input  wire [31:0] g,
    input  wire [31:0] h,

    output wire [31:0] a_out,
    output wire [31:0] b_out,
    output wire [31:0] c_out,
    output wire [31:0] d_out,
    output wire [31:0] e_out,
    output wire [31:0] f_out,
    output wire [31:0] g_out,
    output wire [31:0] h_out
);

    wire [31:0] Wj;
    // Tính W[j]
    w_generator w_gen (
        .j(j),
        .data_in(data_in),
        .Wj(Wj)
    );


    combination comb (
        .j(j),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .Wj(Wj),
        .a_out(a_out),
        .b_out(b_out),
        .c_out(c_out),
        .d_out(d_out),
        .e_out(e_out),
        .f_out(f_out),
        .g_out(g_out),
        .h_out(h_out)
    );
endmodule
