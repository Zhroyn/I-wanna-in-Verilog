module state_update (
    input clk,
    input rst,
    input [3:0] keys,
    input [3:0] is_collide,
    output reg direction,
    output reg [1:0] action,
    output reg [9:0] pos_x = init_pos_x,
    output reg [9:0] pos_y = init_pos_y
);

    parameter init_pos_x = 200;
    parameter init_pos_y = 556;
    parameter init_x_inv = 200;
    parameter init_jump_inv = 20;
    parameter init_fall_inv = 110;

    integer i;
    integer will_move_filter [3:0];
    integer speed_inv [3:0];

    reg idle_signal, run_signal, jump_signal, fall_signal;
    reg [1:0] jump_state = 2'b00;   // 00: no jump, 01: first press jump, 10: release jump, 11: second press jump
    reg [3:0] move_signal = 4'b0000;    // up, down, left, right
    reg [3:0] will_move = 4'b0000;

    wire left, right, jump, restart;
    wire up_signal, down_signal, left_signal, right_signal;

    assign {left, right, jump, restart} = keys;
    assign {up_signal, down_signal, left_signal, right_signal} = move_signal;

    initial begin
        direction = 1'b1;   // 0: left, 1: right
        action = 2'b00;     // 00: idle, 01: running, 10: jumping, 11: falling
        pos_x = init_pos_x;
        pos_y = init_pos_y;

        speed_inv[3] = init_jump_inv;
        speed_inv[2] = init_fall_inv;
        speed_inv[1] = init_x_inv;
        speed_inv[0] = init_x_inv;
    end

    always @(posedge clk) begin
        idle_signal = 1'b0;
        run_signal = 1'b0;
        jump_signal = 1'b0;
        fall_signal = 1'b0;

        if (is_collide[2]) begin
            jump_state = 2'b00;
            if (left ^ right) begin
                run_signal = 1'b1;
            end else begin
                idle_signal = 1'b1;
            end
            if (jump == 1'b1) begin
                jump_signal = 1'b1;
                jump_state = 2'b01;
            end
        end else begin
            if (jump_state == 2'b00) begin
                fall_signal = 1'b1;
            end

            if (jump == 1'b1) begin
                if (jump_state == 2'b00 || jump_state == 2'b10) begin
                    jump_signal = 1'b1;
                    jump_state[0] = 1'b1;
                end
            end else begin
                if (jump_state == 2'b01) begin
                    jump_state = 2'b10;
                end
            end
        end

        if (is_collide[3]) begin
            fall_signal = 1'b1;
        end
    end

    always @(negedge clk) begin
        if (rst) begin
            direction <= 1'b1;
            will_move[1:0] <= 2'b00;
        end else begin
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
    end

    always @(posedge clk) begin
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

    always @(negedge clk) begin
        if (rst) begin
            action = 2'b00;
            pos_x = init_pos_x;
            pos_y = init_pos_y;
            will_move[3:2] = 2'b00;
        end else begin
            if (idle_signal) begin
                action = 2'b00;
            end
            if (run_signal) begin
                action = 2'b01;
            end
            if (jump_signal) begin
                action = 2'b10;
                will_move[3:2] = 2'b10;
                speed_inv[3] = init_jump_inv;
            end
            if (fall_signal) begin
                action = 2'b11;
                will_move[3:2] = 2'b01;
                speed_inv[2] = init_fall_inv;
            end

            if (left_signal) begin
                pos_x = pos_x - 1;
            end
            if (right_signal) begin
                pos_x = pos_x + 1;
            end
            if (up_signal == 1'b1 && !is_collide[3]) begin
                pos_y = pos_y - 1;
                speed_inv[3] = speed_inv[3] + 1;
                if (speed_inv[3] == init_fall_inv) begin
                    action = 2'b11;
                    speed_inv[2] = init_fall_inv;
                    will_move[3:2] = 2'b01;
                end
            end
            if (down_signal == 1'b1 && !is_collide[2]) begin
                pos_y = pos_y + 1;
                if (speed_inv[2] > init_fall_inv) begin
                    speed_inv[2] = speed_inv[2] - 1;
                end
            end
        end
    end
    
endmodule
