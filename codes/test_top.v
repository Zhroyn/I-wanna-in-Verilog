`timescale 1ns / 1ps

module test_top;

    // Inputs
    reg clk;
    reg [15:0] SW;

    // Outputs
    wire vsync;
    wire hsync;
    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk(clk),
        .SW(SW),
        .vsync(vsync),
        .hsync(hsync),
        .r(r),
        .g(g),
        .b(b)
    );

    integer i;
    initial begin
        clk = 0;
        i = 0;
        SW = 16'hFFFF;
        #1;
        for (i = 0; i < 3_000_000; i = i + 1) begin
            clk = ~clk;
            #1;
        end
    end
      
endmodule

