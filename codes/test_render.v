`timescale 1ns / 1ps

module test_render;

    // Inputs
    reg clk;
    reg clrn;

    // Outputs
    wire [31:0] clk_div;
    wire hsync;
    wire vsync;
    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;

    // Instantiate the Unit Under Test (UUT)
    clkdiv ClkDiv (
        .clk(clk),
        .clkdiv(clk_div)
    );
     
    render Render (
        .clk(clk),
        .clkdiv(clk_div),
        .clrn(clrn),
        .hsync(hsync), 
        .vsync(vsync), 
        .r(r), 
        .g(g), 
        .b(b)
    );

    integer i;
    initial begin
        clrn = 1;
        clk = 0;
        i = 0;
        #1;
        for (i = 0; i < 3_000_000; i = i + 1) begin
            clk = ~clk;
            #1;
        end
    end
      
endmodule
