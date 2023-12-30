module collide_det (
    input clk,
    input [9:0] kid_t,
    input [9:0] kid_b,
    input [9:0] kid_l,
    input [9:0] kid_r,
    output reg [3:0] is_collide
);

    localparam bound_t_num = 7;
    localparam bound_b_num = 11;
    localparam bound_l_num = 10;
    localparam bound_r_num = 10;

    integer i;

    reg [29:0] bound_t [bound_t_num-1:0];
    reg [29:0] bound_b [bound_b_num-1:0];
    reg [29:0] bound_l [bound_l_num-1:0];
    reg [29:0] bound_r [bound_r_num-1:0];

    initial begin
        is_collide = 4'b0000;

        bound_t[0] = {10'd60 , 10'd125, 10'd416};
        bound_t[1] = {10'd28 , 10'd60 , 10'd448};
        bound_t[2] = {10'd645, 10'd711, 10'd384};
        bound_t[3] = {10'd547, 10'd613, 10'd351};
        bound_t[4] = {10'd385, 10'd418, 10'd351};
        bound_t[5] = {10'd287, 10'd353, 10'd351};
        bound_t[6] = {10'd743, 10'd775, 10'd416};

        bound_b[0] = {10'd0  , 10'd28 , 10'd318};
        bound_b[1] = {10'd28 , 10'd125, 10'd383};
        bound_b[2] = {10'd28 , 10'd93 , 10'd578};
        bound_b[3] = {10'd189, 10'd677, 10'd578};
        bound_b[4] = {10'd677, 10'd710, 10'd546};
        bound_b[5] = {10'd710, 10'd775, 10'd513};
        bound_b[6] = {10'd743, 10'd775, 10'd383};
        bound_b[7] = {10'd645, 10'd711, 10'd351};
        bound_b[8] = {10'd547, 10'd613, 10'd318};
        bound_b[9] = {10'd385, 10'd418, 10'd318};
        bound_b[10] = {10'd287, 10'd353, 10'd318};

        bound_l[0] = {10'd0  , 10'd318, 10'd0  };
        bound_l[1] = {10'd318, 10'd383, 10'd28 };
        bound_l[2] = {10'd383, 10'd416, 10'd125};
        bound_l[3] = {10'd416, 10'd448, 10'd60 };
        bound_l[4] = {10'd448, 10'd578, 10'd28 };
        bound_l[5] = {10'd578, 10'd599, 10'd93 };
        bound_l[6] = {10'd351, 10'd384, 10'd711};
        bound_l[7] = {10'd318, 10'd351, 10'd613};
        bound_l[8] = {10'd318, 10'd351, 10'd418};
        bound_l[9] = {10'd318, 10'd351, 10'd353};

        bound_r[0] = {10'd578, 10'd599, 10'd189};
        bound_r[1] = {10'd546, 10'd578, 10'd677};
        bound_r[2] = {10'd513, 10'd546, 10'd710};
        bound_r[3] = {10'd416, 10'd513, 10'd775};
        bound_r[4] = {10'd383, 10'd416, 10'd743};
        bound_r[5] = {10'd0  , 10'd383, 10'd775};
        bound_r[6] = {10'd351, 10'd384, 10'd645};
        bound_r[7] = {10'd318, 10'd351, 10'd547};
        bound_r[8] = {10'd318, 10'd351, 10'd385};
        bound_r[9] = {10'd318, 10'd351, 10'd287};
    end

    always @(negedge clk) begin
        is_collide = 4'b0000;
        for (i = 0; i < bound_t_num; i = i + 1) begin
            if (kid_t == bound_t[i][9:0] && kid_l < bound_t[i][19:10] && kid_r > bound_t[i][29:20]) begin
                is_collide[3] = 1'b1;
            end
        end
        for (i = 0; i < bound_b_num; i = i + 1) begin
            if (kid_b == bound_b[i][9:0] && kid_l < bound_b[i][19:10] && kid_r > bound_b[i][29:20]) begin
                is_collide[2] = 1'b1;
            end
        end
        for (i = 0; i < bound_l_num; i = i + 1) begin
            if (kid_l == bound_l[i][9:0] && kid_t < bound_l[i][19:10] && kid_b > bound_l[i][29:20]) begin
                is_collide[1] = 1'b1;
            end
        end
        for (i = 0; i < bound_r_num; i = i + 1) begin
            if (kid_r == bound_r[i][9:0] && kid_t < bound_r[i][19:10] && kid_b > bound_r[i][29:20]) begin
                is_collide[0] = 1'b1;
            end
        end
    end

endmodule
