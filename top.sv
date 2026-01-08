`include "uvm_macros.svh"

module top;

  import uvm_pkg::*;
  import my_pack::*;

  bit aclk;
  bit aresetn;

  // -----------------------------
  // Clock initialization
  // -----------------------------
  initial begin
    $display("[%0t] [top] Entering clock init block", $time);
    aclk = 0;
    $display("[%0t] [top] Clock initialized to 0", $time);
  end

  // Clock toggling
  always #5 begin
    aclk = ~aclk;
    $display("[%0t] [top] Clock toggled, aclk=%0b", $time, aclk);
  end

  // -----------------------------
  // Reset sequence
  // -----------------------------
  initial begin
    $display("[%0t] [top] Entering reset block", $time);

    aresetn = 0;
    $display("[%0t] [top] Reset deasserted (high)", $time);

    #20;
    $display("[%0t] [top] After 20 time units", $time);

    aresetn = 1;
    $display("[%0t] [top] Reset asserted (low)", $time);
  end

  // -----------------------------
  // Interface instantiation
  // -----------------------------
  axi_if vif(aclk, aresetn);
  initial $display("[%0t] [top] AXI interface instantiated", $time);

  // -----------------------------
  // DUT instantiation (UPDATED)
  // -----------------------------
  axi_target_mem  dut (
      .ACLK     (vif.aclk),
      .ARESETn  (vif.aresetn),

      // Write address channel
      .AWID     (vif.awid),
      .AWADDR   (vif.awaddr),
      .AWLEN    (vif.awlen),
      .AWSIZE   (vif.awsize),
      .AWBURST  (vif.awburst),
      .AWVALID  (vif.awvalid),
      .AWREADY  (vif.awready),

      // Write data channel
      .WDATA    (vif.wdata),
      .WLAST    (vif.wlast),
      .WVALID   (vif.wvalid),
      .WREADY   (vif.wready),

      // Write response channel
      .BID      (vif.bid),
      .BRESP    (vif.bresp),
      .BVALID   (vif.bvalid),
      .BREADY   (vif.bready),

      // Read address channel
      .ARID     (vif.arid),
      .ARADDR   (vif.araddr),
      .ARLEN    (vif.arlen),
      .ARSIZE   (vif.arsize),
      .ARBURST  (vif.arburst),
      .ARVALID  (vif.arvalid),
      .ARREADY  (vif.arready),

      // Read data channel
      .RID      (vif.rid),
      .RDATA    (vif.rdata),
      .RRESP    (vif.rresp),
      .RLAST    (vif.rlast),
      .RVALID   (vif.rvalid),
      .RREADY   (vif.rready)
  );
  initial $display("[%0t] [top] DUT instantiated", $time);


  // -----------------------------
  // Config DB setup
  // -----------------------------
  initial begin
    $display("[%0t] [top] Entering config DB block", $time);
    uvm_config_db#(virtual axi_if)::set(null, "*", "vif", vif);
    $display("[%0t] [top] Virtual interface set in config DB", $time);
  end

  // -----------------------------
  // Test start
  // -----------------------------
  initial begin
    $display("[%0t] [top] Entering test start block", $time);
    $display("[%0t] [top] Starting UVM test: fixed_write_read_test", $time);
    run_test("incr_write_test");
    $display("[%0t] [top] run_test() call returned", $time);
  end

  // -----------------------------
  // Simulation finish
  // -----------------------------
  initial begin
    $display("[%0t] [top] Entering finish block", $time);
    #1000;
    $display("[%0t] [top] Simulation finished", $time);
    $finish;
  end

endmodule
