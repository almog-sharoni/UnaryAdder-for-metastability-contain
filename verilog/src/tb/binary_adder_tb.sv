`timescale 1ns / 1ps

module BinaryAdder_tb();
    parameter NOF_BITS = 8; // Match the bit-width of your BinaryAdder
    // Testbench inputs and outputs as registers 
    reg clk;
    reg rst_n;
    reg start;
    reg [NOF_BITS-1:0] data_a;
    reg [NOF_BITS-1:0] data_b;

    // Instantiate the module under test as wires
    wire [NOF_BITS-1:0] data_out;
    wire done;

    // Instantiate your BinaryAdder
    BinaryAdder #(NOF_BITS) uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_a(data_a), 
        .data_b(data_b),
        .data_out(data_out), 
        .done(done)
    );

    // Generate a clock
    always #5 clk = ~clk; 

    // Test Vector Generation
    initial begin
        clk = 0;
        rst_n = 0; 
        start = 0;
        data_a = 0;
        data_b = 0;

        #10 rst_n = 1; 

        for (integer i = 0; i<10; i++) begin 
            data_a = $urandom_range(0, 127);
            data_b = $urandom_range(0, 127);
            #10 start = 1;
            #10 start = 0; // Wait for the calculation to finish 
            wait(done);
            $display("%b + %b = %b, correct:%s",
             data_a, data_b, data_out, (data_out == data_a + data_b) ? "True":"False" );
        end
        #1000 $finish; // End the simulation 
    end
endmodule
