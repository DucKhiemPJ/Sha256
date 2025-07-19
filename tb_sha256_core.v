`timescale 1ns / 1ps

module tb_sha256_core;

    // Clock period
    parameter CLK_PERIOD = 10;

    // Inputs
    reg clk;
    reg rst_n;
    reg i_enable;
    reg [511:0] data_in_tb;
    reg [7:0] i_N_tb;

    // Outputs
    wire o_done_tb;
    wire [255:0] data_out_tb;

    // Expected hash output for message "abc"
    reg [255:0] expected_hash;

    // Instantiate the DUT
    sha_top uut (
        .clk       (clk),
        .rst_n     (rst_n),
        .i_enable  (i_enable),
        .data_in   (data_in_tb),
        .i_N       (i_N_tb),
        .o_done    (o_done_tb),
        .data_out  (data_out_tb)
    );

    // Clock generator
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        // Test vector for "abc" (pre-padded to 512 bits)
        data_in_tb = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
        expected_hash = 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad;

        // Reset and initialization
        rst_n = 0;
        i_enable = 0;
        i_N_tb = 8'd1;

        #(CLK_PERIOD * 2);
        rst_n = 1;
        #(CLK_PERIOD * 2);

        $display("--------------------------------------------------");
        $display("STARTING TEST: 1-block message 'abc'");
        $display("Expected Hash: %h", expected_hash);
        $display("--------------------------------------------------");

        // Feed the block
        @(posedge clk);
            i_enable = 1;
        @(posedge clk);  // giữ i_enable = 1 đúng 1 xung clock
            i_enable = 0;
        // Wait for processing to finish
        wait (o_done_tb == 1);


        // Check result
        $display("--------------------------------------------------");
        $display("Output Hash: %h", data_out_tb);
        if (data_out_tb == expected_hash) begin
            $display("✅ VERIFICATION PASSED!");
        end else begin
            $display("❌ VERIFICATION FAILED!");
            $display("Expected: %h", expected_hash);
            $display("Actual:   %h", data_out_tb);
        end
        $display("--------------------------------------------------");

        #(CLK_PERIOD * 5);
    end

endmodule