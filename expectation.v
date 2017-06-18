`define IS_REQ_ID_ENB(selk) (selk[7] & (|(dec_4to16(selk[4:1]) & p_req_id_enb)))
`define IS_THIS_SEL_HIT(selk) ((p_arb_ch == selk[6:5]) & `IS_REQ_ID_ENB(selk))
`define HOLD       2'b00
`define WRITE_ONLY 2'b01
`define READ_ONLY  2'b10
`define READ_WRITE 2'b11

module expection(
    input wire clk,
    input wire rst,
    input wire p_req_val,
    input wire [2-1:0] p_req_ch,
    input wire [4-1:0] p_req_id,
    input wire p_arb_val,
    input wire [2-1:0] p_arb_ch,
    input wire [16-1:0] p_req_id_enb,
    output wire p_sel_val,
    output wire [4-1:0] p_sel_req_id,
    output wire [4-1:0] p_lru_ch,
    output wire p_pe
    );
    
    wire [8-1:0] sel0, sel1, sel2, sel3, sel4, sel5, sel6, sel7, sel8, sel9, sela, selb, selc, seld, sele, self;
    reg [8-1:0] rfile [0:15];
    assign sel0 = rfile[0]; assign sel1 = rfile[1]; assign sel2 = rfile[2]; assign sel3 = rfile[3]; assign sel4 = rfile[4]; assign sel5 = rfile[5]; assign sel6 = rfile[6]; assign sel7 = rfile[7];
    assign sel8 = rfile[8]; assign sel9 = rfile[9]; assign sela = rfile[10]; assign selb = rfile[11]; assign selc = rfile[12]; assign seld = rfile[13]; assign sele = rfile[14]; assign self = rfile[15];
    // additonal registor
    reg [4-1+1:0] w_ptr;

    wire p_sel_val_stb;
    assign p_sel_val = p_arb_val & p_sel_val_stb;
    wire [4-1:0] idx_sel_hit;
    assign {p_sel_val_stb, p_sel_req_idi, idx_sel_hit} =
        IS_THIS_SEL_HIT(sel0) ? {1'b1, sel0[4:1], 4'h0}:
        IS_THIS_SEL_HIT(sel1) ? {1'b1, sel1[4:1], 4'h1}:
        IS_THIS_SEL_HIT(sel2) ? {1'b1, sel2[4:1], 4'h2}:
        IS_THIS_SEL_HIT(sel3) ? {1'b1, sel3[4:1], 4'h3}:
        IS_THIS_SEL_HIT(sel4) ? {1'b1, sel4[4:1], 4'h4}:
        IS_THIS_SEL_HIT(sel5) ? {1'b1, sel5[4:1], 4'h5}:
        IS_THIS_SEL_HIT(sel6) ? {1'b1, sel6[4:1], 4'h6}:
        IS_THIS_SEL_HIT(sel7) ? {1'b1, sel7[4:1], 4'h7}:
        IS_THIS_SEL_HIT(sel8) ? {1'b1, sel8[4:1], 4'h8}:
        IS_THIS_SEL_HIT(sel9) ? {1'b1, sel9[4:1], 4'h9}:
        IS_THIS_SEL_HIT(sela) ? {1'b1, sela[4:1], 4'ha}:
        IS_THIS_SEL_HIT(selb) ? {1'b1, selb[4:1], 4'hb}:
        IS_THIS_SEL_HIT(selc) ? {1'b1, selc[4:1], 4'hc}:
        IS_THIS_SEL_HIT(seld) ? {1'b1, seld[4:1], 4'hd}:
        IS_THIS_SEL_HIT(sele) ? {1'b1, sele[4:1], 4'he}:
        IS_THIS_SEL_HIT(self) ? {1'b1, self[4:1], 4'hf}:
            :5'b0_0000;

    assign p_lru_ch = sel0[6:5] | 

    function [4-1:0] sel_ch_dec_masked(
        input [8-1:0] selk,
    );
    begin
        function [16-1:0] dec_2to4 (
            input [4-1:0] dec_in
            );
            begin
            case (dec_in)
                2'b00:  dec_2to4 = 4'b0001;
                2'b01:  dec_2to4 = 4'b0010;
                2'b10:  dec_2to4 = 4'b0100;
                2'b11:  dec_2to4 = 4'b1000;
                default:dec_2to4 = 4'bxxxx;
            endcase
            end
        endfunction
        assign sel_ch_dec_masked = (IS_REQ_ID_ENB(selk)? <-この書き方はできない考えなおし
    end
    endfunction
    // parity check
    assign p_pe = | {^sel0, ^sel1, ^sel2, ^sel3, ^sel4, ^sel5, ^sel6, ^sel7, ^sel8, ^sel9, ^sela, ^selb, ^selc, ^seld, ^sele, ^self};
    
    integer i;
    wire [2-1:0] ctrl_ob;
    assign ctrl_ob = {p_sel_val, p_req_val & (~w_ptr[4] | p_sel_val)};
    wire [8-1:0] din;
    assign din = {1'b1, p_req_ch, p_req_id, ^{1'b1,p_req_ch, p_req_id}};
    always @(posedge clk or negedge rst) begin
        if(~rst)begin
            w_ptr <= 5'b0_0000;
            for (i=0; i<=15; i=i+1) rfile[i] <= 8'h0;
        end else if (ctrl_ob==`HOLD) begin
            w_ptr <= w_ptr;
        end else if (ctrl_ob==`WRITE_ONLY) begin
            w_ptr <= w_ptr + 5'b0_0001;
            rfile[w_ptr[3:0]] <= din;
        end else if (ctrl_ob==`READ_ONLY) begin
            w_ptr <= w_ptr - 5'b0_0001;
            rfile[0] <= (4'h0 >= idx_sel_hit)?rfile[1]:rfile[0];
            rfile[1] <= (4'h1 >= idx_sel_hit)?rfile[2]:rfile[1];
            rfile[2] <= (4'h2 >= idx_sel_hit)?rfile[3]:rfile[2];
            rfile[3] <= (4'h3 >= idx_sel_hit)?rfile[4]:rfile[3];
            rfile[4] <= (4'h4 >= idx_sel_hit)?rfile[5]:rfile[4];
            rfile[5] <= (4'h5 >= idx_sel_hit)?rfile[6]:rfile[5];
            rfile[6] <= (4'h6 >= idx_sel_hit)?rfile[7]:rfile[6];
            rfile[7] <= (4'h7 >= idx_sel_hit)?rfile[8]:rfile[7];
            rfile[8] <= (4'h8 >= idx_sel_hit)?rfile[9]:rfile[8];
            rfile[9] <= (4'h9 >= idx_sel_hit)?rfile[10]:rfile[9];
            rfile[10] <= (4'ha >= idx_sel_hit)?rfile[11]:rfile[10];
            rfile[11] <= (4'hb >= idx_sel_hit)?rfile[12]:rfile[11];
            rfile[12] <= (4'hc >= idx_sel_hit)?rfile[13]:rfile[12];
            rfile[13] <= (4'hd >= idx_sel_hit)?rfile[14]:rfile[13];
            rfile[14] <= (4'he >= idx_sel_hit)?rfile[15]:rfile[14];
            rfile[15] <= (4'hf >= idx_sel_hit)?8'h00    :rfile[15];
        end else begin // if (ctrl_ob==`READ_WRITE) begin
            w_ptr <= w_ptr;
            rfile[0] <= (5'h0_0001 == w_ptr)?din: (4'h0 >= idx_sel_hit)?rfile[1]:rfile[0];
            rfile[1] <= (5'b0_0010 == w_ptr)?din: (4'h1 >= idx_sel_hit)?rfile[2]:rfile[1];
            rfile[2] <= (5'b0_0011 == w_ptr)?din: (4'h2 >= idx_sel_hit)?rfile[3]:rfile[2];
            rfile[3] <= (5'b0_0100 == w_ptr)?din: (4'h3 >= idx_sel_hit)?rfile[4]:rfile[3];
            rfile[4] <= (5'b0_0101 == w_ptr)?din: (4'h4 >= idx_sel_hit)?rfile[5]:rfile[4];
            rfile[5] <= (5'b0_0110 == w_ptr)?din: (4'h5 >= idx_sel_hit)?rfile[6]:rfile[5];
            rfile[6] <= (5'b0_0111 == w_ptr)?din: (4'h6 >= idx_sel_hit)?rfile[7]:rfile[6];
            rfile[7] <= (5'b0_1000 == w_ptr)?din: (4'h7 >= idx_sel_hit)?rfile[8]:rfile[7];
            rfile[8] <= (5'b0_1001 == w_ptr)?din: (4'h8 >= idx_sel_hit)?rfile[9]:rfile[8];
            rfile[9] <= (5'b0_1010 == w_ptr)?din: (4'h9 >= idx_sel_hit)?rfile[10]:rfile[9];
            rfile[10] <= (5'b0_1011 == w_ptr)?din: (4'ha >= idx_sel_hit)?rfile[11]:rfile[10];
            rfile[11] <= (5'b0_1100 == w_ptr)?din: (4'hb >= idx_sel_hit)?rfile[12]:rfile[11];
            rfile[12] <= (5'b0_1101 == w_ptr)?din: (4'hc >= idx_sel_hit)?rfile[13]:rfile[12];
            rfile[13] <= (5'b0_1110 == w_ptr)?din: (4'hd >= idx_sel_hit)?rfile[14]:rfile[13];
            rfile[14] <= (5'b0_1111 == w_ptr)?din: (4'he >= idx_sel_hit)?rfile[15]:rfile[14];
            rfile[15] <= (5'b1_0000 == w_ptr)?din: (4'hf >= idx_sel_hit)?8'h00    :rfile[15];
        end
    end

    function [16-1:0] dec_4to16 (
        input [4-1:0] dec_in
       );
    begin
        case (dec_in)
            4'h0:   dec_4to16 = 16'b0000_0000_0000_0001;
            4'h1:   dec_4to16 = 16'b0000_0000_0000_0010;
            4'h2:   dec_4to16 = 16'b0000_0000_0000_0100;
            4'h3:   dec_4to16 = 16'b0000_0000_0000_1000;
            4'h4:   dec_4to16 = 16'b0000_0000_0001_0000;
            4'h5:   dec_4to16 = 16'b0000_0000_0010_0000;
            4'h6:   dec_4to16 = 16'b0000_0000_0100_0000;
            4'h7:   dec_4to16 = 16'b0000_0000_1000_0000;
            4'h8:   dec_4to16 = 16'b0000_0001_0000_0000;
            4'h9:   dec_4to16 = 16'b0000_0010_0000_0000;
            4'ha:   dec_4to16 = 16'b0000_0100_0000_0000;
            4'hb:   dec_4to16 = 16'b0000_1000_0000_0000;
            4'hc:   dec_4to16 = 16'b0001_0000_0000_0000;
            4'hd:   dec_4to16 = 16'b0010_0000_0000_0000;
            4'he:   dec_4to16 = 16'b0100_0000_0000_0000;
            4'hf:   dec_4to16 = 16'b1000_0000_0000_0000;
            default:dec_4to16 = 16'hxxxx;
        endcase
    end
    endfunction

endmodule
