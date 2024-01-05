module render
(
    input clk,
    input rst,
    input [31:0] clkdiv,
    input [5:0] keys,
    input [9:0] col,
    input [9:0] row,
    output reg [11:0] rgb_out
);

    parameter cloud_num = 3;
    parameter bullet_num = 4;
    parameter apple_num = 15;

    integer i;
    reg game_over = 0;
    reg [1:0] bullet_cnt = 0;

    wire is_kid, is_end_scene;
    wire restart, game_reset, kid_dir, shoot;
    wire [9:0] kid_x, kid_y;
    wire [11:0] scene_rgb, end_scene_rgb, kid_rgb, button_rgb;

    wire [cloud_num-1:0] is_cloud;
    wire [cloud_num*12-1:0] cloud_rgb;

    wire [bullet_num-1:0] is_bullet;
    wire [bullet_num*10-1:0] bullet_x;
    wire [bullet_num*10-1:0] bullet_y;
    wire [bullet_num*12-1:0] bullet_rgb;

    wire [apple_num-1:0] is_apple;
    wire [apple_num-1:0] is_collide;
    wire [apple_num*12-1:0] apple_rgb;

    assign shoot = keys[5];
    assign restart = |is_collide || kid_y > 600;
    assign game_reset = game_over || rst;

    always @(posedge clk) begin
        rgb_out = scene_rgb;
        for (i = 0; i < cloud_num; i = i + 1) begin
            if (is_cloud[i]) begin
                rgb_out = cloud_rgb[(i*12+11)-:12];
            end
        end
        for (i = 0; i < apple_num; i = i + 1) begin
            if (is_apple[i]) begin
                rgb_out = apple_rgb[(i*12+11)-:12];
            end
        end
        for (i = 0; i < bullet_num; i = i + 1) begin
            if (is_bullet[i]) begin
                rgb_out = bullet_rgb[(i*12+11)-:12];
            end
        end
        if (is_button) begin
            rgb_out = button_rgb;
        end
        if (is_kid) begin
            rgb_out = kid_rgb;
        end
        if (is_end_scene && game_over) begin
            rgb_out = end_scene_rgb;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            game_over = 1'b0;
        end else if (restart) begin
            game_over = 1'b1;
        end
    end

    always @(posedge shoot) begin
        bullet_cnt = bullet_cnt + 1'b1;
    end

    scene scene (
        .clk(clk),
        .col(col),
        .row(row),
        .scene_rgb(scene_rgb)
    );

    end_scene end_scene (
        .clk(clk),
        .col(col),
        .row(row),
        .is_end_scene(is_end_scene),
        .end_scene_rgb(end_scene_rgb)
    );

    kid kid (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[22]),
        .update_clk(clkdiv[11]),
        .col(col),
        .row(row),
        .keys(keys[3:0]),
        .is_kid(is_kid),
        .kid_dir(kid_dir),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .kid_rgb(kid_rgb)
    );

    button button (
        .clk(clk),
        .rst(game_reset),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .bullet_x(bullet_x),
        .bullet_y(bullet_y),
        .is_button(is_button),
        .button_rgb(button_rgb)
    );

    cloud #(.init_x(64), .init_y(91)) cloud0 (
        .clk(clk),
        .toggle_clk(clkdiv[24]),
        .col(col),
        .row(row),
        .is_cloud(is_cloud[0]),
        .cloud_rgb(cloud_rgb[11:0])
    );
    cloud #(.init_x(389), .init_y(156)) cloud1 (
        .clk(clk),
        .toggle_clk(clkdiv[24]),
        .col(col),
        .row(row),
        .is_cloud(is_cloud[1]),
        .cloud_rgb(cloud_rgb[23:12])
    );
    cloud #(.init_x(584), .init_y(91)) cloud2 (
        .clk(clk),
        .toggle_clk(clkdiv[24]),
        .col(col),
        .row(row),
        .is_cloud(is_cloud[2]),
        .cloud_rgb(cloud_rgb[35:24])
    );

    bullet bullet0 (
        .clk(clk),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .kid_dir(kid_dir),
        .shoot(bullet_cnt == 0 && shoot && !game_over),
        .is_bullet(is_bullet[0]),
        .bullet_x(bullet_x[9:0]),
        .bullet_y(bullet_y[9:0]),
        .bullet_rgb(bullet_rgb[11:0])
    );
    bullet bullet1 (
        .clk(clk),
        .rst(rst),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .kid_dir(kid_dir),
        .shoot(bullet_cnt == 1 && shoot && !game_over),
        .is_bullet(is_bullet[1]),
        .bullet_x(bullet_x[19:10]),
        .bullet_y(bullet_y[19:10]),
        .bullet_rgb(bullet_rgb[23:12])
    );
    bullet bullet2 (
        .clk(clk),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .kid_dir(kid_dir),
        .shoot(bullet_cnt == 2 && shoot && !game_over),
        .is_bullet(is_bullet[2]),
        .bullet_x(bullet_x[29:20]),
        .bullet_y(bullet_y[29:20]),
        .bullet_rgb(bullet_rgb[35:24])
    );
    bullet bullet3 (
        .clk(clk),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .kid_dir(kid_dir),
        .shoot(bullet_cnt == 3 && shoot && !game_over),
        .is_bullet(is_bullet[3]),
        .bullet_x(bullet_x[39:30]),
        .bullet_y(bullet_y[39:30]),
        .bullet_rgb(bullet_rgb[47:36])
    );

    apple #(.init_x(59), .init_y(449), .trig_x(20), .move_dir(-1)) apple0 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[0]),
        .is_collide(is_collide[0]),
        .apple_rgb(apple_rgb[11:0])
    );
    apple #(.init_x(253), .init_y(480), .trig_x(-25), .move_dir(1)) apple1 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[1]),
        .is_collide(is_collide[1]),
        .apple_rgb(apple_rgb[23:12])
    );
    apple #(.init_x(290), .init_y(448), .trig_x(-25), .move_dir(-1)) apple2 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[2]),
        .is_collide(is_collide[2]),
        .apple_rgb(apple_rgb[35:24])
    );
    apple #(.init_x(344), .init_y(466), .trig_x(10), .move_dir(1)) apple3 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[3]),
        .is_collide(is_collide[3]),
        .apple_rgb(apple_rgb[47:36])
    );
    apple #(.init_x(377), .init_y(466), .trig_x(-20), .move_dir(1)) apple4 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[4]),
        .is_collide(is_collide[4]),
        .apple_rgb(apple_rgb[59:48])
    );
    apple #(.init_x(419), .init_y(454), .trig_x(40), .move_dir(-1)) apple5 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[5]),
        .is_collide(is_collide[5]),
        .apple_rgb(apple_rgb[71:60])
    );
    apple #(.init_x(434), .init_y(482), .trig_x(10), .move_dir(1)) apple6 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[6]),
        .is_collide(is_collide[6]),
        .apple_rgb(apple_rgb[83:72])
    );
    apple #(.init_x(474), .init_y(466), .trig_x(-20), .move_dir(1)) apple7 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[7]),
        .is_collide(is_collide[7]),
        .apple_rgb(apple_rgb[95:84])
    );
    apple #(.init_x(501), .init_y(463), .trig_x(55), .move_dir(-1)) apple8 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[8]),
        .is_collide(is_collide[8]),
        .apple_rgb(apple_rgb[107:96])
    );
    apple #(.init_x(546), .init_y(483), .trig_x(10), .move_dir(1)) apple9 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[9]),
        .is_collide(is_collide[9]),
        .apple_rgb(apple_rgb[119:108])
    );
    apple #(.init_x(595), .init_y(461), .trig_x(-25), .move_dir(1)) apple10 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[10]),
        .is_collide(is_collide[10]),
        .apple_rgb(apple_rgb[131:120])
    );
    apple #(.init_x(602), .init_y(422), .trig_x(-32), .move_dir(1)) apple11 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[11]),
        .is_collide(is_collide[11]),
        .apple_rgb(apple_rgb[143:132])
    );
    apple #(.init_x(629), .init_y(422), .trig_x(45), .move_dir(-1)) apple12 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[12]),
        .is_collide(is_collide[12]),
        .apple_rgb(apple_rgb[155:144])
    );
    apple #(.init_x(672), .init_y(457), .trig_x(-10), .move_dir(1)) apple13 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[13]),
        .is_collide(is_collide[13]),
        .apple_rgb(apple_rgb[167:156])
    );
    apple #(.init_x(745), .init_y(436), .trig_x(0), .move_dir(-1)) apple14 (
        .clk(clk),
        .rst(game_reset),
        .toggle_clk(clkdiv[24]),
        .update_clk(clkdiv[17]),
        .col(col),
        .row(row),
        .kid_x(kid_x),
        .kid_y(kid_y),
        .is_apple(is_apple[14]),
        .is_collide(is_collide[14]),
        .apple_rgb(apple_rgb[179:168])
    );

endmodule
