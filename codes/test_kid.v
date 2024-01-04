`timescale 1ns / 1ps

module test_kid;

    // Inputs
    reg clk;
    reg toggle_clk;
    reg update_clk;
    reg [9:0] col;
    reg [9:0] row;
    reg [3:0] keys;

    // Outputs
    wire is_kid;
    wire [11:0] kid_rgb;

    kid uut (
        .clk(clk), 
        .toggle_clk(toggle_clk), 
        .update_clk(update_clk), 
        .col(col), 
        .row(row), 
        .keys(keys), 
        .is_kid(is_kid), 
        .kid_rgb(kid_rgb)
    );

    integer i;
    initial begin
        clk = 0;
        toggle_clk = 0;
        update_clk = 0;
        col = 0;
        row = 0;
        keys = 4'b0010;
        #1;
        for (i = 0; i < 40000; i = i + 1) begin
            clk = ~clk;
            toggle_clk = ~toggle_clk;
            update_clk = ~update_clk;
            if (i == 8000 || i == 24000) begin
                keys = 4'b0000;
            end else if (i == 16000) begin
				keys = 4'b0010;
			end
            #1;
        end
    end
      
endmodule

