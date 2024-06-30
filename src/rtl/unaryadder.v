`timescale  1ns/1ps

module UnaryAdder #(
    parameter NOF_BITS = 32
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [NOF_BITS-1:0] data_a, data_b,
    output reg [2*NOF_BITS-1:0] data_out,
    output reg done
);
    localparam IDLE = 2'b01;
    localparam SORT = 2'b10;

    // Define state register
    reg [1:0] state, next_state;
    wire sort_done;
    wire[2*NOF_BITS-1:0] data_in;
    wire [2*NOF_BITS-1:0] sort_out;
    reg sort_start;

    assign data_in = {data_a, data_b};
    // FSM
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            // busy <= 0;
            done <= 0;
            data_out <=  0;
        end else begin
            state <= next_state;
            // busy <= busy;
            done <= done;
            data_out <= data_out;
        end
    end

    always @(*) begin
        case (state)
            IDLE:
                if (start) begin
                    next_state = SORT;
                end else begin
                    next_state = IDLE;
                end
            SORT:
                if (done) begin
                    next_state = IDLE;
                end else begin
                    next_state = SORT;
                end
        endcase
    end
    


    always @(posedge clk)  begin
        if(sort_done) begin
        data_out <= sort_out;
        done<=1;
        end
        else begin
        data_out <= 0;
        done<=0;
        end
    end
    
    always @(posedge clk) begin
        sort_start <= start;
    end
    
    BubbleSort #(2*NOF_BITS) sorter ( 
        .clk(clk),                       
        .start(sort_start), // each time this signal is high the run starts again         
        .done(sort_done), // this signal is high for only one cycle             
        .in_data(data_in),
        .out_data(sort_out),
        .rst_n(rst_n)
    );
    
endmodule

module BubbleSort # (
    parameter NOF_BITS = 16
)(
    input wire clk,
    input wire start,
    input wire rst_n,
    input wire [NOF_BITS-1:0] in_data,
    output reg [NOF_BITS-1:0] out_data,
    output reg done
);

    // Define states
    localparam IDLE = 2'b01;
    localparam SORT = 2'b10;

    reg [NOF_BITS-1:0] temp;
    reg [1:0] state, next_state;
    reg [$clog2(2*NOF_BITS-3):0] i;

    integer j;

    always @(posedge start) begin
        temp <= in_data;
        i = 2;
    end

    always @(negedge rst_n) begin
        temp<=0;
        out_data<=0;
        done<=0;
        next_state<=IDLE;
    end

    always @(*) begin
        case (state)
            IDLE:
                if (start) begin
                    next_state = SORT;
                end else begin
                    next_state = IDLE;
                end
            SORT:
                if (done) begin
                    next_state = IDLE;
                end else begin
                    next_state = SORT;
                end
            default:
                next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        state <= next_state;
    end

    always @(posedge clk) begin
        if (state == SORT) begin
            //COMPARATOR
            for (j = i[0]; j<NOF_BITS-1; j= j+2) begin
                temp[j] <= temp[j]|temp[j+1];
                temp[j+1] <= temp[j]&temp[j+1];
            end
            i <= i+1;
        end else begin
            i<= i;
            temp[j] <= temp[j];
            temp[j+1] <= temp[j+1];
        end
    end

    always @(posedge clk) begin
        if (i==2*NOF_BITS-4)
            done <= 1;
        else
            done<=0;

        out_data<=temp;
    end
endmodule
