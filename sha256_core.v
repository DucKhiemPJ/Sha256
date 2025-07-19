module sha256_core (
    input wire clk,             // Clock
    input wire rst_n,          // Active-low reset
    input wire i_enable,       // Start hashing process for a new message
    input wire [511:0] data_in, // Input data block (512 bits)
    input wire [7:0] i_N,      // Total number of blocks to process (N)

    output wire o_done,         // Hashing process for the current message is complete
    output wire [255:0] data_out // Final 256-bit hash output
);
    sha_top u_sha_top (
            .clk,
            .rst_n,
            .i_enable,
            .data_in,
            .i_N,
            .o_done,
            .data_out
        );
endmodule


