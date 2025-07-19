module w_generator (
    input  wire [5:0]    j,
    input  wire [511:0]  data_in,
    output wire [31:0]   Wj 
);

    // Internal wires to hold all W values
    wire [31:0] W[0:63];

    // Functions for sigma0 and sigma1 (combinational by nature)
    function automatic [31:0] sigma0(input [31:0] x);
        sigma0 = {x[6:0], x[31:7]} ^ {x[17:0], x[31:18]} ^ (x >> 3);
    endfunction

    function automatic [31:0] sigma1(input [31:0] x);
        sigma1 = {x[16:0], x[31:17]} ^ {x[18:0], x[31:19]} ^ (x >> 10);
    endfunction

    // Generate block to compute W[j] combinatorially
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : W_calc
            if (i < 16) begin
                assign W[i] = data_in[511 - i*32 -: 32];
            end else begin
                assign W[i] = sigma1(W[i-2]) + W[i-7] + sigma0(W[i-15]) + W[i-16];
            end
        end
    endgenerate

    // Assign the final Wj based on the input j
    assign Wj = W[j];

endmodule