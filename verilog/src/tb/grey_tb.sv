`timescale 1ns / 1ps

module BinaryAdder_tb();

    parameter NOF_BITS = 8; // Match the bit-width of your BinaryAdder

    // Testbench inputs and outputs as registers 
    reg clk;
    reg rst_n;
    reg start;
    reg [NOF_BITS-1:0] data_a;
    reg [NOF_BITS-1:0] data_b;
    reg pa, pb;

    // Instantiate the module under test as wires
    wire [NOF_BITS-1:0] data_out;
    wire done;

    // Instantiate your BinaryAdder
    gray_adder #(NOF_BITS) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .A(data_a), 
        .B(data_b),
        .PA(pa),
        .PB(pb),
        .S(data_out), 
        .done(done)
    );

    // Generate a clock
    always #5 clk = ~clk; 

    // Test Vector Generation
    initial begin
        clk = 0;
        #10 rst_n = 1;

        # 10 rst_n = 0; 
        start = 0;
        data_a = 0;
        data_b = 0;
        pa = 0;
        pb = 0;

        #10 rst_n = 1;  
        #10 start = 0; 

        for (integer i = 0; i<10; i++) begin 
            data_a = $urandom_range(0, 127);
            data_b = $urandom_range(0, 127);
            assign pa = ^data_a;
            assign pb = ^data_b;
            #10 start = 1;
            #10 start = 0; 
            wait(done);// Wait for the calculation to finish 
            $display("%b + %b = %b",
             data_a, data_b, data_out);
        end
        #1000 $finish; // End the simulation 
    end
endmodule
