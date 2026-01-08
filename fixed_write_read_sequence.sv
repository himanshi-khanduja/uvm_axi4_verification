class fixed_write_read_sequence extends uvm_sequence #(sequence_item#());
    
    `uvm_object_utils(fixed_write_read_sequence)

    function new(string name = "fixed_write_read_sequence");
        super.new(name);
    endfunction

    virtual task body();

        sequence_item#() req;
        logic [31:0] awaddr_counter = 32'h0000_0004;
        logic [31:0] wdata_counter = 32'd5;
        
        `uvm_info(get_type_name(), "AXI Sequence started", UVM_MEDIUM)
        $display("At %0t ---- Entering class: fixed_write_read_sequence ----", $time);

        req= sequence_item#()::type_id::create("req");

        start_item(req);

        req.trtype = sequence_item#()::write_op;

        req.awaddr = awaddr_counter;
        req.awid = 2'd1;
        req.awlen = 8'd3;
        req.awsize = 3'd2;
        req.awburst = fixed;
        req.wdata = wdata_counter;

        $display("At %0t fixed_write_read_sequence: WRITE Transaction details:", $time);
        $display("AWADDR=%0h AWID=%0d AWLEN=%0d AWSIZE=%0d AWBURST=%0d WDATA=%0h",
                 req.awaddr, req.awid, req.awlen, req.awsize, req.awburst, req.wdata);

        req.print();

        finish_item(req);

        `uvm_info(get_type_name(), "AXI Fixed write Sequence Completed", UVM_MEDIUM)

        req = sequence_item#()::type_id::create("req");
        start_item(req);

        req.trtype = sequence_item#()::read_op;

        req.arid = 2'd1;
        req.araddr = awaddr_counter;
        req.arlen = 8'd3;
        req.arsize = 3'd2;
        req.arburst = fixed;

        req.wdata = wdata_counter;

        $display("At %0t fixed_write_read_sequence: READ Transaction details:", $time);
        $display("ARADDR=%0h ARID=%0d ARLEN=%0d ARSIZE=%0d ARBURST=%0d",
                 req.araddr, req.arid, req.arlen, req.arsize, req.arburst);

        req.print();

        finish_item(req);

        `uvm_info(get_type_name(), "AXI fixed read sequence completed", UVM_MEDIUM)
        $display("At %0t ---- Exiting class: fixed_write_read_sequence ----", $time);

    endtask

endclass
