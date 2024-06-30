`timescale 1ns/1ps

module UnaryAdder_tb;

    parameter NOF_BITS = 8;

    reg clk;
    reg rst_n;
    reg start;
    reg [NOF_BITS-1:0] data_a, data_b;
    wire [2*NOF_BITS-1:0] data_out;
    wire done;

    // Instantiate the UnaryAdder
    UnaryAdder #(NOF_BITS) uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_a(data_a),
        .data_b(data_b),
        .data_out(data_out),
        .done(done)
    );

    // Generate clock
    always #5 clk = ~clk; // 100MHz clock

    // Initial block for test cases
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 1; // Assert reset
        start = 0;
        data_a = 0;
        data_b = 0;

        #10
        rst_n = 0; // Reset system
        #20;
        rst_n = 1; // De-assert reset

        for (integer i = 0;i<10;i=i+1) begin
            data_a = (1 << $urandom_range(0, NOF_BITS))-1;
            data_b = (1 << $urandom_range(0, NOF_BITS))-1;
            start = 1;
            #10 start=0;
            wait(done);
            $display("%b + %b = %b",data_a,data_b,data_out);
            #10;
        end
        #100000 $finish; // End simulation after a delay
    end
endmodule
