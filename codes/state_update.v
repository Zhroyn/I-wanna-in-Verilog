module state_update (
    input clk,
    input [3:0] keys,
    input [3:0] is_collide,
    output reg direction,
    output reg [1:0] action,
    output reg [9:0] pos_x = init_pos_x,
    output reg [9:0] pos_y = init_pos_y
);

    parameter init_pos_x = 200;
    parameter init_pos_y = 556;
    parameter init_x_inv = 100;
    parameter init_jump_inv = 50;
    parameter init_fall_inv = 130;

    integer i;
    integer will_move_filter [3:0];
    integer speed_inv [3:0];

    reg [1:0] jump_state = 2'b00;   // 00: no jump, 01: first press jump, 10: release jump, 11: second press jump
    reg [3:0] move_signal;
    reg [3:0] will_move = 4'b0000;

    wire shoot, jump, right, left;
    assign {shoot, jump, right, left} = keys;

    initial begin
        direction = 1'b1;   // 0: left, 1: right
        action = 2'b00;     // 00: idle, 01: running, 10: jumping, 11: falling
        move_signal = 4'b0000;  // up, down, left, right
        pos_x = init_pos_x;
        pos_y = init_pos_y;

        speed_inv[3] = init_jump_inv;
        speed_inv[2] = init_fall_inv;
        speed_inv[1] = init_x_inv;
        speed_inv[0] = init_x_inv;
    end

    always @(posedge clk) begin
        if (left == 1'b0 && right == 1'b0) begin
            direction <= direction;
            will_move[1:0] <= 2'b00;
        end
        if (left == 1'b1 && right == 1'b0) begin
            direction <= 1'b0;
            will_move[1:0] <= 2'b10;
        end
        if (left == 1'b0 && right == 1'b1) begin
            direction <= 1'b1;
            will_move[1:0] <= 2'b01;
        end
        if (left == 1'b1 && right == 1'b1) begin
            direction <= direction;
            will_move[1:0] <= 2'b00;
        end
    end

    always @(posedge clk) begin
        if (is_collide[2]) begin
            jump_state = 2'b00;

            if (left ^ right) begin
                action = 2'b01;
            end else begin
                action = 2'b00;
            end

            if (jump == 1'b1) begin
                pos_y = pos_y - 1;
                action = 2'b10;
                jump_state = 2'b01;
                speed_inv[3] = init_jump_inv;
                will_move[3:2] = 2'b10;
            end
        end else begin
            if (jump_state == 2'b00) begin
                action = 2'b11;
                will_move[3:2] = 2'b01;
            end

            if (jump == 1'b1) begin
                if (jump_state == 2'b00 || jump_state == 2'b10) begin
                    action = 2'b10;
                    jump_state = jump_state[1] ? 2'b11 : 2'b01;
                    speed_inv[3] = init_jump_inv;
                    will_move[3:2] = 2'b10;
                end
            end else begin
                if (jump_state == 2'b00) begin
                    jump_state = 2'b01;
                end
            end

            if (move_signal[3] == 1'b1) begin
                speed_inv[3] = (jump_state == 2'b11) ? speed_inv[3] + 2 : speed_inv[3] + 1;
                if (speed_inv[3] == init_fall_inv) begin
                    action = 2'b11;
                    speed_inv[2] = init_fall_inv;
                    will_move[3:2] = 2'b01;
                end
            end else if (move_signal[2] == 1'b1) begin
                if (speed_inv[2] > 50) begin
                    speed_inv[2] = speed_inv[2] - 1;
                end
            end
        end

        if (move_signal[3]) begin
            pos_y = pos_y - 1;
        end
        if (move_signal[2]) begin
            pos_y = pos_y + 1;
        end
        if (move_signal[1]) begin
            pos_x = pos_x - 1;
        end
        if (move_signal[0]) begin
            pos_x = pos_x + 1;
        end
    end

    always @(negedge clk) begin
        for (i = 0; i < 4; i = i + 1) begin
            if (will_move[i] == 1'b1 && !is_collide[i]) begin
                will_move_filter[i] = will_move_filter[i] + 1'b1;
            end else begin
                will_move_filter[i] = 8'h00;
            end
        end
        for (i = 0; i < 4; i = i + 1) begin
            if (will_move_filter[i] == speed_inv[i]) begin
                move_signal[i] = 1'b1;
                will_move_filter[i] = 8'h00;
            end else begin
                move_signal[i] = 1'b0;
            end
        end
    end

endmodule
