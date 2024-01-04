module top (
    input clk,
    input ps2_clk,
    input ps2_data,
    input [1:0] SW,
    output hsync,
    output vsync,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b
);

    wire in_screen;
    wire [5:0] keys;
    wire [9:0] col;
    wire [9:0] row;
    wire [11:0] rgb_out;
    wire [31:0] clk_div;

    assign {r, g, b} = in_screen ? rgb_out : 12'h000;

    clkdiv Divider (
        .clk(clk),
        .clkdiv(clk_div)
    );

    ps2_drv KeyboardDriver (
        .clk(clk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .keys(keys)
    );

    vga_sync ScreenSyncHandler (
        .vga_clk(clk_div[0]),
        .clrn(SW[0]),
        .hsync(hsync),
        .vsync(vsync),
        .col(col),
        .row(row),
        .in_screen(in_screen)
    );

    render Renderer (
        .clk(clk),
        .rst(SW[1] | keys[5]),
        .clkdiv(clk_div),
        .keys(keys[4:0]),
        .col(col),
        .row(row),
        .rgb_out(rgb_out)
    );

endmodule
