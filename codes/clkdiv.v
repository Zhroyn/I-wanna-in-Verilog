module clkdiv
(
    input clk,
    output reg [31:0] clkdiv
);
    
    initial clkdiv = 0;
    always @(posedge clk) begin
        clkdiv <= clkdiv + 1'b1;
    end
    
endmodule
