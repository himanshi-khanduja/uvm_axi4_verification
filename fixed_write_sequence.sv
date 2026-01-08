class fixed_write_sequence extends uvm_sequence #(sequence_item#());
    
    `uvm_object_utils(fixed_write_sequence)

    function new(string name = "fixed_write_sequence");
        super.new(name);
    endfunction

    virtual task body();

        sequence_item#() req;
        
        `uvm_info(get_type_name(), "AXI Sequence started", UVM_MEDIUM)
        $display("At %0t ---- Entering class: fixed_write_sequence ----", $time);

        req= sequence_item#()::type_id::create("req");

        start_item(req);

        req.trtype = sequence_item#():: write_op;

        req.awaddr = 32'h0000_0004;
        req.awid = 2'd1;
        req.awlen = 8'd3;
        req.awsize = 3'd2;
        req.awburst = fixed;
        req.wdata = 32'd5;

        $display("At %0t fixed_write_sequence: Transaction details:", $time);
        $display("AWADDR=%0h AWID=%0d AWLEN=%0d AWSIZE=%0d AWBURST=%0d WDATA=%0h",
                 req.awaddr, req.awid, req.awlen, req.awsize, req.awburst, req.wdata);

        req.print();

        finish_item(req);

        $display("At %0t ---- Exiting class: fixed_write_sequence ----", $time);
        `uvm_info(get_type_name(), "AXI Sequence Completed", UVM_MEDIUM)

    endtask

endclass
