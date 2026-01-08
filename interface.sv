interface axi_if(input logic aclk, input logic aresetn);
    import my_pack::*;


    // Paramteres
    parameter addr_width= 32;
    parameter data_width= 32;
    parameter id_width=2;

   // Write address channel
   
   logic [addr_width - 1:0]awaddr;
   logic [7:0] awlen;
   logic [2:0] awsize;
   burst_type  awburst;
   logic awvalid;
   logic awready;
   logic [id_width - 1:0] awid;

   // Write data channel signals

   logic [data_width - 1:0] wdata;
   logic wlast;
   logic wvalid;
   logic wready;

   //write response channel signals
   
   logic [id_width - 1:0]  bid;
   logic [1:0] bresp;
   logic bvalid;
   logic bready;

   //Read Address channel signals
   
   logic [id_width - 1 :0] arid;
   logic [addr_width - 1: 0] araddr;
   logic [7:0] arlen;
   logic [2:0] arsize;
   burst_type  arburst;
   logic arvalid;
   logic arready;

   //Read data channel signals
   
   logic [id_width - 1:0] rid;
   logic [data_width - 1 :0] rdata;
   logic [1:0] rresp;
   logic rlast;
   logic rvalid;
   logic rready;
   logic [2:0] arprot;
   logic [3:0]arcache;
   logic arlock;
   logic wstrb;
   logic [2:0]awprot;
   logic [3:0] awcache;
    logic awlock;

   clocking driver_cb @(posedge aclk);
       default input #1 output #1;
       output  awlock, awcache, arprot,arcache, arlock,wstrb,awprot, awaddr, awid, awlen, awsize, awburst, awvalid, wdata, wlast, wvalid, bready, arid, araddr, arlen, arsize, arburst, arvalid, rready;

       input awready, wready, bid, bresp, bvalid, arready, rid, rdata, rresp, rlast, rvalid;
   endclocking

   clocking monitor_cb @(posedge aclk);
       default input #1 output #1;
       input awlock, awcache, arprot,arcache, arlock,wstrb,awprot, awaddr, awid, awlen, awsize, awburst, awvalid, wdata, wlast, wvalid, bready, arid, araddr, arlen, arsize, arburst, arvalid, rready, awready, wready, bid, bresp, bvalid, arready, rid, rdata, rresp, rlast, rvalid;
   endclocking

   modport driver (clocking driver_cb, input aclk, input aresetn);
   modport monitor (clocking monitor_cb, input aclk, input aresetn);

endinterface
