`timescale 1ns / 1ps

module clk_50hz(clk, update_clk);
    input wire clk;
    output reg update_clk = 0;
    integer cnt = 0;

    always @(posedge clk) begin
        if (cnt < 1_000_000) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 0;
            update_clk <= ~update_clk;
        end
    end

endmodule
