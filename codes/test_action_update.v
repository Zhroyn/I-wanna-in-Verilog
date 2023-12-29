`timescale 1ns / 1ps

module test_action_update;

    // Inputs
    reg clk;
    reg [3:0] keys;

    // Outputs
    wire direction;
    wire [1:0] action;
    wire [3:0] move_signal;

    // Instantiate the Unit Under Test (UUT)
    action_update uut (
        .clk(clk),
        .keys(keys),
        .direction(direction),
        .action(action),
        .move_signal(move_signal)
    );

    integer i;
    initial begin
        clk = 0;
        keys = 4'b0001;
        i = 0;
        #100;
        for (i = 0; i < 1000; i = i + 1) begin
            clk = ~clk;
            if (i == 500) begin
                keys = 4'b0000;
            end
            #1;
        end
    end
      
endmodule
