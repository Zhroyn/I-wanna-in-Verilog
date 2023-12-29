module action_update (
    input clk,
    input [3:0] keys,
    output reg direction,
    output reg [1:0] action,
    output reg [3:0] is_move
);

    localparam speed_x_inv = 5;

    integer i;
    integer dir_y;

    reg [3:0] will_move = 4'b0;
    reg [7:0] will_move_filter [3:0];

    initial begin
        dir_y = 0;
        will_move = 4'b0000;
        direction = 1'b1;   // 0: left, 1: right
        action = 2'b00;     // 00: idle, 01: running, 10: jumping, 11: falling
        is_move = 4'b0000;  // up, down, left, right
    end

    always @(posedge clk) begin
        if (dir_y == 0) begin
            if (keys[1:0] == 2'b00) begin
                action = 2'b00;
                will_move = 4'b0000;
            end
            else if (keys[1:0] == 2'b01) begin
                direction = 1'b0;
                action = 2'b01;
                will_move = 4'b0100;
            end
            else if (keys[1:0] == 2'b10) begin
                direction = 1'b1;
                action = 2'b01;
                will_move = 4'b1000;
            end
            else if (keys[1:0] == 2'b11) begin
                action = 2'b00;
                will_move = 4'b0000;
            end
        end
    end

    always @(negedge clk) begin
        for (i = 0; i < 4; i = i + 1) begin
            if (will_move[i] == 1'b1) begin
                will_move_filter[i] = will_move_filter[i] + 1'b1;
            end else begin
                will_move_filter[i] = 8'h00;
            end
        end
        for (i = 0; i < 4; i = i + 1) begin
            if (will_move_filter[i] == speed_x_inv) begin
                is_move[i] = 1'b1;
                will_move_filter[i] = 8'h00;
            end else begin
                is_move[i] = 1'b0;
            end
        end
    end

endmodule
