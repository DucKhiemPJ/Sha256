module sha256_counter_j (
    input wire          i_clk,
    input wire          i_rst,    // Active-high reset
    input wire          clr_j,    // Clear/load signal (active high)
    input wire          cnt_j_en, // Count enable (active high)
    output reg [5:0]    j
);

    // Synchronous reset, synchronous clear, synchronous enable counting
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin // Overall system reset (active high)
            j <= 0;
        end else if (clr_j) begin // Clear j (active high, takes precedence over counting)
            j <= 0;
        end else if (cnt_j_en) begin // Enable counting
                j <= j + 1;
        end
        // If not reset, not clear, and not enabled, j holds its value.
    end

endmodule