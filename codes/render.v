`timescale 1ns / 1ps

module render(
    input clk,
    input [31:0] clkdiv,
    input clrn,
    input vga_clk,
    input [7:0] keycode,
    output hsync,
    output vsync,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b
    );

    parameter cloud_num = 3;
    parameter apple_num = 13;

    integer  i;

    wire [9:0] col;
    wire [9:0] row;
    wire [9:0] kid_x;

    wire is_kid;
    wire [11:0] scene_rgb, kid_rgb;
    wire [cloud_num-1:0] is_cloud;
    wire [cloud_num*12-1:0] cloud_rgb;
    wire [apple_num-1:0] is_apple;
    wire [apple_num*12-1:0] apple_rgb;

    always @(posedge clkdiv[13]) begin
        {r, g, b} = scene_rgb;
        for (i = 0; i < cloud_num; i = i + 1) begin
            if (is_cloud[i]) begin
                {r, g, b} = cloud_rgb[(i*12+11)-:12];
            end
        end
        for (i = 0; i < apple_num; i = i + 1) begin
            if (is_apple[i]) begin
                {r, g, b} = apple_rgb[(i*12+11)-:12];
            end
        end
        if (is_kid) begin
            {r, g, b} = kid_rgb;
        end
    end

    vga_sync vga_sync (
        .vga_clk(vga_clk),
        .clrn(clrn),
        .hsync(hsync),
        .vsync(vsync),
        .col(col),
        .row(row)
    );

    scene scene (
        .clk(clk),
        .col(col),
        .row(row),
        .scene_rgb(scene_rgb)
    );

    cloud #(.init_x(64), .init_y(91)) cloud0 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .col(col),
        .row(row),
        .is_cloud(is_cloud[0]),
        .cloud_rgb(cloud_rgb[11:0])
    );
    cloud #(.init_x(389), .init_y(156)) cloud1 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .col(col),
        .row(row),
        .is_cloud(is_cloud[1]),
        .cloud_rgb(cloud_rgb[23:12])
    );
    cloud #(.init_x(584), .init_y(91)) cloud2 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .col(col),
        .row(row),
        .is_cloud(is_cloud[2]),
        .cloud_rgb(cloud_rgb[35:24])
    );

    apple #(.init_x(59), .init_y(449), .direction(1)) apple0 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[0]),
        .apple_rgb(apple_rgb[11:0])
    );
    apple #(.init_x(344), .init_y(466), .direction(1)) apple1 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[1]),
        .apple_rgb(apple_rgb[23:12])
    );
    apple #(.init_x(377), .init_y(466), .direction(1)) apple2 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[2]),
        .apple_rgb(apple_rgb[35:24])
    );
    apple #(.init_x(419), .init_y(454), .direction(1)) apple3 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[3]),
        .apple_rgb(apple_rgb[47:36])
    );
    apple #(.init_x(434), .init_y(482), .direction(1)) apple4 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[4]),
        .apple_rgb(apple_rgb[59:48])
    );
    apple #(.init_x(474), .init_y(466), .direction(1)) apple5 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[5]),
        .apple_rgb(apple_rgb[71:60])
    );
    apple #(.init_x(501), .init_y(463), .direction(1)) apple6 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[6]),
        .apple_rgb(apple_rgb[83:72])
    );
    apple #(.init_x(546), .init_y(483), .direction(1)) apple7 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[7]),
        .apple_rgb(apple_rgb[95:84])
    );
    apple #(.init_x(595), .init_y(461), .direction(1)) apple8 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[8]),
        .apple_rgb(apple_rgb[107:96])
    );
    apple #(.init_x(602), .init_y(422), .direction(1)) apple9 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[9]),
        .apple_rgb(apple_rgb[119:108])
    );
    apple #(.init_x(629), .init_y(422), .direction(1)) apple10 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[10]),
        .apple_rgb(apple_rgb[131:120])
    );
    apple #(.init_x(672), .init_y(457), .direction(1)) apple11 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col), 
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[11]),
        .apple_rgb(apple_rgb[143:132])
    );
    apple #(.init_x(745), .init_y(436), .direction(1)) apple12 (
        .clk(clk),
        .toggle_clk(clkdiv[19]),
        .update_clk(clkdiv[13]),
        .col(col), 
        .row(row),
        .kid_x(kid_x),
        .is_apple(is_apple[12]),
        .apple_rgb(apple_rgb[155:144])
    );

    kid kid (
        .clk(clk),
        .toggle_clk(clkdiv[17]),
        .update_clk(clkdiv[13]),
        .col(col),
        .row(row),
        .keycode(keycode),
        .is_kid(is_kid),
        .kid_rgb(kig_rgb),
        .kid_x(kid_x)
    );

endmodule
