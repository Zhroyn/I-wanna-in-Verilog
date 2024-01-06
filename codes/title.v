module title (
    input [9:0] col,
    input [9:0] row,
    output is_title,
    output [11:0] title_rgb
);

    parameter pos_x = 8;
    parameter pos_y = 8;
    parameter title_w = 49;
    parameter title_h = 7;

    reg [48:0] letters [4:0];   // A, I, N, W, SPACE

    wire in_box, is_pixel;
    wire [2:0] index, addr_x;
    wire [5:0] letter_addr;
    wire [10:0] apple_addr;

    assign in_box = (col - pos_x >= 0 && col - pos_x < title_w &&
                     row - pos_y >= 0 && row - pos_y < title_h) 
                     ? 1'b1 : 1'b0;
    assign index = (col < pos_x + 7) ? 3'd1 :
                   (col < pos_x + 14) ? 3'd4 :
                   (col < pos_x + 21) ? 3'd3 :
                   (col < pos_x + 28) ? 3'd0 :
                   (col < pos_x + 35) ? 3'd2 :
                   (col < pos_x + 42) ? 3'd2 : 3'd0;
    assign addr_x = (col < pos_x + 7) ? col - pos_x :
                    (col < pos_x + 14) ? col - pos_x - 7 :
                    (col < pos_x + 21) ? col - pos_x - 14 :
                    (col < pos_x + 28) ? col - pos_x - 21 :
                    (col < pos_x + 35) ? col - pos_x - 28 :
                    (col < pos_x + 42) ? col - pos_x - 35 : col - pos_x - 42;
    assign letter_addr = in_box ? (6 - addr_x) + (6 - row + pos_y) * 7 : 1'b0;
    assign is_pixel = letters[index][letter_addr];
    assign is_title = in_box && is_pixel;
    assign title_rgb = 12'hFFF;

    initial begin
        letters[0] = {
            7'b0001000,
            7'b0010100,
            7'b0100010,
            7'b0111110,
            7'b0100010,
            7'b0100010,
            7'b0100010
        };
        letters[1] = {
            7'b0111110,
            7'b0001000,
            7'b0001000,
            7'b0001000,
            7'b0001000,
            7'b0001000,
            7'b0111110
        };
        letters[2] = {
            7'b0100010,
            7'b0100010,
            7'b0110010,
            7'b0101010,
            7'b0100110,
            7'b0100010,
            7'b0100010
        };
        letters[3] = {
            7'b0100010,
            7'b0100010,
            7'b0101010,
            7'b0101010,
            7'b0101010,
            7'b0110110,
            7'b0100010
        };
        letters[4] = {
            7'b0000000,
            7'b0000000,
            7'b0000000,
            7'b0000000,
            7'b0000000,
            7'b0000000,
            7'b0000000
        };
    end

endmodule
