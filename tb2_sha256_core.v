`timescale 1ns / 1ps

module tb_sha256_core;
    reg clk;
    reg rst_n;
    reg i_enable;
    reg [511:0] data_in;
    reg [7:0] i_N;

    wire o_done;
    wire [255:0] data_out;

    // Instantiate DUT
    sha_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .i_enable(i_enable),
        .data_in(data_in),
        .i_N(i_N),
        .o_done(o_done),
        .data_out(data_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;


    reg [1023:0] full_message;

    initial begin
        // Full 1024-bit message (already padded)
        full_message = {
            // Block 1 (second 512 bits)
            512'h0000000000000000000000000000000000000000000000000000000000000000_00000000000000000000000000000000000000000000000000000000000001C0,
            // Block 0 (first 512 bits)
            512'h6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000
        };

        // Reset
        rst_n = 0;
        i_enable = 0;
        data_in = 0;
        i_N = 8'd2;  // 2 blocks
        #20;
        rst_n = 1;
        #10;

        // Start hashing
        data_in = full_message[511:0]; // Block 0
        i_enable = 1;
        #10;
        i_enable = 0;

        // Wait until i == 1 (i.e., start of Block 1)
        wait (uut.i == 8'd1);
        #10;
        data_in = full_message[1023:512]; // Block 1


        // Wait for done signal
        wait (o_done == 1);

        // Check output
        #10;
        $display("Expected: 248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1");
        $display("Got     : %h", data_out);
        if (data_out == 256'h248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1)
            $display("✅ Test Passed!");
        else
            $display("❌ Test Failed!");
    end
endmodule

