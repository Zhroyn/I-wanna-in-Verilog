module read_rom
(
    input clk,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b
);

    parameter MAX_ADDR = 800 * 600;

    reg [18:0] addr = 0;
    wire [11:0] rgb_data;

    always @(posedge clk) begin
        if (addr == MAX_ADDR) begin
            addr <= 0;
        end else begin
            addr <= addr + 1;
        end
    end

    running m1 (
        .addra(addr),
        .douta(rgb_data),
        .clka(clk)
    );
    
    assign {r, g, b} = rgb_data;

endmodule
