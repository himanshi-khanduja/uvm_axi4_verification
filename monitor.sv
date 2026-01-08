class monitor extends uvm_monitor;

    `uvm_component_utils(monitor)

    sequence_item#() trans;
    virtual axi_if vif;

    uvm_analysis_port #(sequence_item#()) mon_ap;

    function new(string name = "Monitor", uvm_component parent = null);

        super.new(name, parent);
        mon_ap = new("mon_ap", this);
        
    endfunction

    function void build_phase (uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db #(virtual axi_if)::get(this, "*", "vif", vif))
            `uvm_fatal("AXI MONITOR", "VIRTUAL INTERFACE NOT FOUND IN CONFIG DB")

    endfunction

    task run_phase(uvm_phase phase);

        `uvm_info("AXI MONITOR", "MONITOR STARTED", UVM_LOW)
        $display("[%0t] [monitor] Monitor started and waiting for transactions", $time);

        forever 
        begin


            @(posedge vif.aclk);
            

            if(vif.awvalid && vif.awready)
            begin
            trans = sequence_item#()::type_id::create("trans");
            
                trans.awaddr = vif.awaddr;
                trans.awid = vif.awid;
                trans.awlen = vif.awlen;
                trans.awsize = vif.awsize;
                trans.awburst = vif.awburst;
                $display("[%0t] [monitor] Captured WRITE ADDRESS: Addr=%0h ID=%0d LEN=%0d SIZE=%0d BURST=%0d",
                         $time, trans.awaddr, trans.awid, trans.awlen, trans.awsize, trans.awburst);
            end

            if (vif.wvalid && vif.wready)
            begin
                trans.wdata = vif.wdata;
                trans.wlast = vif.wlast;
                $display("[%0t] [monitor] Captured WRITE DATA: Data=%0h Last=%0b",
                         $time, trans.wdata, trans.wlast);
            end

            if (vif.bvalid && vif.bready)
            begin
                trans.bid = vif.bid;
                trans.bresp = vif.bresp;
                $display("[%0t] [monitor] Captured WRITE RESPONSE: BID=%0d BRESP=%0d",
                         $time, trans.bid, trans.bresp);
            end

            if (vif.arvalid && vif.arready) begin
                trans.araddr  = vif.araddr;
                trans.arid    = vif.arid;
                trans.arlen   = vif.arlen;
                trans.arsize  = vif.arsize;
                trans.arburst = vif.arburst;

                $display("[%0t] [monitor] Captured READ ADDRESS: Addr=%0h ID=%0d LEN=%0d SIZE=%0d BURST=%0d",
                         $time, trans.araddr, trans.arid, trans.arlen, trans.arsize, trans.arburst);
            end

            if (vif.rvalid && vif.rready) begin
                trans.rid   = vif.rid;
                trans.rdata = vif.rdata;
                trans.rresp = vif.rresp;
                trans.rlast = vif.rlast;

                $display("[%0t] [monitor] Captured READ DATA: RID=%0d Data=%0h RESP=%0d Last=%0b",
                         $time, trans.rid, trans.rdata, trans.rresp, trans.rlast);
            end

            `uvm_info("AXI MONITOR", $sformatf("AXI MONTOR- TRANSACTION DETECTED AT %0t", $time), UVM_LOW)
            
            mon_ap.write(trans);
            
        end
        
    endtask

endclass
