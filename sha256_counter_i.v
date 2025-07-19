module sha256_counter_i (
    input wire          i_clk,
    input wire          i_rst,    // Active-high reset
    input wire          clr_i,    // Clear/load signal (active high)
    input wire          cnt_i_en, // Count enable (active high)
    output reg [7:0]    i
);

    // Synchronous reset, synchronous clear, synchronous enable counting
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin // Overall system reset (active high)
            i <= 0;
        end else if (clr_i) begin // Clear i (active high, takes precedence over counting)
            i <= 0;
        end else if (cnt_i_en) begin // Enable counting
            i <= i + 1;
        end
        // If not reset, not clear, and not enabled, i holds its value.
    end

endmodule