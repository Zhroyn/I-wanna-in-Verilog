module collide_det (
    input clk,
    input [9:0] kid_t,
    input [9:0] kid_b,
    input [9:0] kid_l,
    input [9:0] kid_r,
    output reg [3:0] is_collide
);

    localparam bound_t_num = 1;
    localparam bound_b_num = 1;
    localparam bound_l_num = 1;
    localparam bound_r_num = 1;

    integer i;

    reg [9:0] bound_t [bound_t_num-1:0][2:0] = {
        {10'd351, 10'd190, 10'd677}
    };
    reg [9:0] bound_b [bound_b_num-1:0][2:0] = {
        {10'd578, 10'd190, 10'd677}
    };
    reg [9:0] bound_l [bound_l_num-1:0][2:0] = {
        {10'd190, 10'd351, 10'd578}
    };
    reg [9:0] bound_r [bound_r_num-1:0][2:0] = {
        {10'd677, 10'd351, 10'd578}
    };

    always @(posedge clk) begin
        for (i = 0; i < bound_t_num; i = i + 1) begin
            if (kid_t == bound_t[i][0] && 
                ((kid_l > bound_t[i][1] && kid_l < bound_t[i][2]) || 
                 (kid_r > bound_t[i][1] && kid_r < bound_t[i][2]))) begin
                is_collide[0] = 1'b1;
            end
        end
        for (i = 0; i < bound_b_num; i = i + 1) begin
            if (kid_b == bound_b[i][0] && 
                ((kid_l > bound_b[i][1] && kid_l < bound_b[i][2]) || 
                 (kid_r > bound_b[i][1] && kid_r < bound_b[i][2]))) begin
                is_collide[1] = 1'b1;
            end
        end
        for (i = 0; i < bound_l_num; i = i + 1) begin
            if (kid_l == bound_l[i][0] && 
                ((kid_t > bound_l[i][1] && kid_t < bound_l[i][2]) || 
                 (kid_b > bound_l[i][1] && kid_b < bound_l[i][2]))) begin
                is_collide[2] = 1'b1;
            end
        end
        for (i = 0; i < bound_r_num; i = i + 1) begin
            if (kid_r == bound_r[i][0] && 
                ((kid_t > bound_r[i][1] && kid_t < bound_r[i][2]) || 
                 (kid_b > bound_r[i][1] && kid_b < bound_r[i][2]))) begin
                is_collide[3] = 1'b1;
            end
        end
    end

endmodule
