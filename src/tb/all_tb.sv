`timescale 1ns / 1ps

module all_tb();
    reg clk;
    reg rst_n;
    reg start;
    reg [3:0] data_a_binary, data_a_gray; // adders inputs
    reg [8:0] data_a_unary; // adders inputs
    reg [3:0] data_b_binary, data_b_gray; // adders inputs
    reg [8:0] data_b_unary; // adders inputs
    reg pa, pb;
    wire [4:0] data_out_gray, data_out_binary; // Adders outputs
    wire [15:0] data_out_unary; // Adders outputs
    wire done_b, done_u, done_g; // adders done signals

    // Instantiate GrayAdder
    gray_adder #(8) gdut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .A(data_a_gray), 
        .B(data_b_gray),
        .PA(pa),
        .PB(pb),
        .S(data_out_gray), 
        .done(done_g)
    );
    // Instantiate the UnaryAdder
    UnaryAdder #(8) udut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_a(data_a_unary),
        .data_b(data_b_unary),
        .data_out(data_out_unary),
        .done(done_u)
    );
    // Instantiate BinaryAdder
    BinaryAdder #(8) bdut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_a(data_a_binary), 
        .data_b(data_b_binary),
        .data_out(data_out_binary), 
        .done(done_b)
    );

    // Generate a clock
    always #5 clk = ~clk; 

    // Test Vector Generation
    initial begin
        clk = 0;
        #10 rst_n = 1; 
        #10 rst_n = 0; // reset FSM's
        start = 0;
        data_a_binary = 0;
        data_a_gray = 0;
        data_a_unary = 0;
        data_b_binary=0;
        data_b_gray = 0;
        data_b_unary = 0;
        pa =0;
        pb=0;
        #10 rst_n = 1; 

        // Check correct inputs: 2+3
        data_a_binary = 2;
        data_a_unary = (1<<2)-1; // 2 in unary: 0...011
        data_a_gray = 3; // 2 in grey code: 0...011

        data_b_binary = 3;
        data_b_unary = (1<<3)-1; // 3 unary: 0...0111
        data_b_gray = 2; // 3 in gray code: 0...010
        pa = 0;
        pb = 1;

        start = 1; // raise start signal for one clock
        #10 start = 0;
        wait(done_u); // Unary adder computation is the longest

        #10 rst_n = 0; // reset FSM's
        #10 rst_n = 1;
        
        // simulate x metastable bit 
        data_a_binary = 8'b0000000x; // the input may be 0 or 1
        data_a_unary = 16'b000000000000000x;
        data_a_gray = 8'b0000000x;

        data_b_binary = 8'b00000111;    // 7 in binary
        data_b_unary = (1<<7)-1;        // 7 unary
        data_b_gray = 8'b00000100;      //7 gray
        pa = 1;
        pb = 1;

        start = 1; // raise start signal for one clock
        #10 start = 0;
        wait(done_u);// Unary adder computation is the longest

        #10 rst_n = 0; // reset FSM's
        #10 rst_n = 1;
        
        // simulate x metastable bit 
        data_a_binary = 8'b000000x0; // the input may be 0 or 2
        data_a_unary = 16'b00000000000000x1; // the input may be 1 or 2
        data_a_gray = 8'b000000x1; // the input may be 1 or 2

        data_b_binary = 8'b00000111;    // 7 in binary
        data_b_unary = (1<<7)-1;        // 7 unary
        data_b_gray = 8'b00000100;      //7  gray
        pa = 1;
        pb = 1;

        start = 1; // raise start signal for one clock
        #10 start = 0;
        wait(done_u);// Unary adder computation is the longest

        #10 rst_n = 0; // reset FSM's
        #10 rst_n = 1;
        // simulate x metastable bit 
        data_a_binary = 8'b00000x00; // the input may be 0 or 4
        data_a_unary = 16'b000000000000x111; // the input may be 3 or 4
        data_a_gray = 8'b00000x10; // the input may be 3 or 4

        data_b_binary = 8'b00000010;    // 2 in binary
        data_b_unary = (1<<2)-1;        // 2 unary
        data_b_gray = 8'b00000011;      // 2 gray
        pa = 1;
        pb = 0;

        start = 1; // raise start signal for one clock
        #10 start = 0;
        wait(done_u);// Unary adder computation is the longest


        #1000000 $finish; // End the simulation 
    end
endmodule
