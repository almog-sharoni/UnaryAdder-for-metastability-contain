`timescale 1ns/1ps

module gray_adder #(
    parameter NOF_BITS = 8
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [NOF_BITS-1:0] A, B,
    input wire PA, PB,
    output reg [NOF_BITS-1:0] S,
    output reg done
);

    // FSM States
    localparam IDLE  = 2'b01;
    localparam ADD   = 2'b10;

    // State and intermediate registers
    reg [1:0] state, next_state;
    reg [NOF_BITS-1:0] E, F;
    reg [$clog2(NOF_BITS):0] counter; // Introduce a counter 

    // next state
    always @(*) begin 
        case(state)
            IDLE: begin
                next_state = (start) ? ADD : IDLE; 
            end
            ADD: begin
                if (counter == NOF_BITS - 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ADD;                                        
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential updates of state and outputs
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            done <= 0;
        end else begin
            state <= next_state;
            // ... update registers based on next_state if needed 
            if (state == ADD && next_state == IDLE) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always @(posedge clk) begin
        if (state == IDLE) begin
            E <= {{NOF_BITS-1{1'b0}}, PA};  // Initialize E
            F <= {{NOF_BITS-1{1'b0}}, PB};  // Initialize F
            counter <= 0;                   // Reset the counter
        end else begin
            S[counter] <= (E[counter] & F[counter]) ^ A[counter] ^ B[counter];  
            E[counter+1] <= (E[counter] & (~F[counter])) ^ A[counter];   
            F[counter+1] <= ((~E[counter]) & F[counter]) ^ B[counter];
            counter <= counter + 1;
        end
    end

endmodule
