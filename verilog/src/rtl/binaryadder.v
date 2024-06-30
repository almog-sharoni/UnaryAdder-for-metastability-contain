`timescale 1ns / 1ps

module BinaryAdder #(
    parameter NOF_BITS = 8
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [NOF_BITS-1:0] data_a, data_b,
    output reg [NOF_BITS-1:0] data_out, // Reduced output size 
    output reg done
);

   wire [NOF_BITS-1:0] sum;
   wire [NOF_BITS-1:0] cout;  // Carry out

    full_adder_d FA0(.carry(cout[0]), .sum(sum[0]), .a(data_a[0]), .b(data_b[0]), .cin(1'b0));
    full_adder_d FA1(.carry(cout[1]), .sum(sum[1]), .a(data_a[1]), .b(data_b[1]), .cin(cout[0]));
    full_adder_d FA2(.carry(cout[2]), .sum(sum[2]), .a(data_a[2]), .b(data_b[2]), .cin(cout[1]));
    full_adder_d FA3(.carry(cout[3]), .sum(sum[3]), .a(data_a[3]), .b(data_b[3]), .cin(cout[2]));
    full_adder_d FA4(.carry(cout[4]), .sum(sum[4]), .a(data_a[4]), .b(data_b[4]), .cin(cout[3]));
    full_adder_d FA5(.carry(cout[5]), .sum(sum[5]), .a(data_a[5]), .b(data_b[5]), .cin(cout[4]));
    full_adder_d FA6(.carry(cout[6]), .sum(sum[6]), .a(data_a[6]), .b(data_b[6]), .cin(cout[5]));
    full_adder_d FA7(.carry(cout[7]), .sum(sum[7]), .a(data_a[7]), .b(data_b[7]), .cin(cout[6]));

    always @(posedge clk)  begin
        if(start) begin // Or adapt triggering condition if needed
            data_out <= sum; 
            done <= 1; 
        end else begin
            data_out <= 0;
            done <= 0;
        end
    end

endmodule

module full_adder_d (
    input a,b,cin,
    output sum,carry
);

assign sum = a ^ b ^ cin;
assign carry = (a & b) | (b & cin)  | (cin & a) ;

endmodule
