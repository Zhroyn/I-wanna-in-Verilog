`timescale 1ns / 1ps

module test_action_update;

    integer i = 0;

    reg [9:0] a;
    reg [9:0] b;

    wire [9:0] c = a - b - 2;
    wire d = a - b - 2 < 2;

    initial begin
        a = 5;
        b = 0;
        #100;
        for (i = 0; i < 10; i = i + 1) begin
            b = b + 1;
            #100;
        end
    end

endmodule
