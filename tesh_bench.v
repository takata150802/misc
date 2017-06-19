`timescale 1ns/1ns
// ncverilog 
module testbench;

  reg clk;
  reg rst;
  parameter STEP = 10; //10ns
  //--------------------------------------

  // for fifo16
  reg p_req_val, p_arb_val;
  reg [1:0] p_req_ch, p_arb_ch;
  reg [3:0] p_req_id;
  reg [15:0] p_req_id_enb;
  wire p_sel_val;
  wire [3:0] p_sel_req_id;
  wire p_pe;
  wire [4-1:0] p_lru_join_ch;

  // clk
  always #(STEP / 2) clk = ~clk;

  // initial statements
  integer i, i2;
  initial begin
    // $shm_open("./shm_fifo16_rtl");
    // $shm_probe("AS");
    $monitor("req(val,ch,id):%h,%h,%h, arb(val,ch):%h,%h, sel(val,req_id):%h,%h, pe:%h, lru:%b\nval:%h%h%h%h%h%h%h%h%h%h%h%h%h%h%h%h\n ch:%h%h%h%h%h%h%h%h%h%h%h%h%h%h%h%h\n id:%h%h%h%h%h%h%h%h%h%h%h%h%h%h%h%h\n ep:%h%h%h%h%h%h%h%h%h%h%h%h%h%h%h%h"
        , p_req_val, p_req_ch, p_req_id, p_arb_val, p_arb_ch, p_sel_val, p_sel_req_id, p_pe, p_lru_join_ch
        , expec_0.self[7], expec_0.sele[7], expec_0.seld[7], expec_0.selc[7], expec_0.selb[7], expec_0.sela[7], expec_0.sel9[7], expec_0.sel8[7]
        , expec_0.sel7[7], expec_0.sel6[7], expec_0.sel5[7], expec_0.sel4[7], expec_0.sel3[7], expec_0.sel2[7], expec_0.sel1[7], expec_0.sel0[7]
        , expec_0.self[6:5], expec_0.sele[6:5], expec_0.seld[6:5], expec_0.selc[6:5], expec_0.selb[6:5], expec_0.sela[6:5], expec_0.sel9[6:5], expec_0.sel8[6:5]
        , expec_0.sel7[6:5], expec_0.sel6[6:5], expec_0.sel5[6:5], expec_0.sel4[6:5], expec_0.sel3[6:5], expec_0.sel2[6:5], expec_0.sel1[6:5], expec_0.sel0[6:5]
        , expec_0.self[4:1], expec_0.sele[4:1], expec_0.seld[4:1], expec_0.selc[4:1], expec_0.selb[4:1], expec_0.sela[4:1], expec_0.sel9[4:1], expec_0.sel8[4:1]
        , expec_0.sel7[4:1], expec_0.sel6[4:1], expec_0.sel5[4:1], expec_0.sel4[4:1], expec_0.sel3[4:1], expec_0.sel2[4:1], expec_0.sel1[4:1], expec_0.sel0[4:1]
        , expec_0.self[0], expec_0.sele[0], expec_0.seld[0], expec_0.selc[0], expec_0.selb[0], expec_0.sela[0], expec_0.sel9[0], expec_0.sel8[0]
        , expec_0.sel7[0], expec_0.sel6[0], expec_0.sel5[0], expec_0.sel4[0], expec_0.sel3[0], expec_0.sel2[0], expec_0.sel1[0], expec_0.sel0[0]
        );
    $monitoron ;
    #0 clk <= 1;
    rst <= 1;
    test(0,0,0,0,0,16'hFFFF);
    #(4)
    rst <= 0;
    #(6)
    #(STEP)
    rst <= 1;
    test(0,0,0,0,0,16'hFFFF);
    test(1,1,0,0,0,16'hFFFF);
    test(1,0,1,0,0,16'hFFFF);
    test(1,1,2,0,0,16'hFFFF);
    test(1,2,3,1,0,16'hFFFF);
    test(0,0,0,0,0,16'hFFFF);
    test(0,0,0,1,2,16'hFFFF);
    test(0,0,0,1,1,16'hFFFF);
    test(0,0,0,1,1,16'hFFFF);
    test(0,0,0,0,0,16'hFFFF);
    // $shm_close();
    $finish;
  end

  // task
  task test;
    input p_req_val_task;
    input [1:0] p_req_ch_task;
    input [3:0] p_req_id_task;
    input p_arb_val_task;
    input [1:0] p_arb_ch_task;
    input [15:0] p_req_id_enb_task;
    begin
      @ (posedge clk);
        $monitoroff;
        #(STEP/4)
        p_req_val <= p_req_val_task;
        p_req_ch <= p_req_ch_task;
        p_req_id <= p_req_id_task;
        p_arb_val <= p_arb_val_task;
        p_arb_ch <= p_arb_ch_task;
        p_req_id_enb <= p_req_id_enb_task;
        $monitoron ;
    end
  endtask

  expectation expec_0(.clk(clk),
    .rst(rst),
    .p_req_val(p_req_val),
    .p_req_ch(p_req_ch),
    .p_req_id(p_req_id),
    .p_arb_val(p_arb_val),
    .p_arb_ch(p_arb_ch),
    .p_sel_val(p_sel_val),
    .p_sel_req_id(p_sel_req_id),
    .p_req_id_enb(p_req_id_enb),
    .p_pe(p_pe),
    .p_lru_join_ch(p_lru_join_ch)
  );

endmodule
