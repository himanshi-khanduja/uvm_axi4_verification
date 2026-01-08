class scoreboard extends uvm_component;

    `uvm_component_utils(scoreboard)

    uvm_analysis_imp #(sequence_item#(), scoreboard) mon_ap;

    function new (string name = "scoreboard", uvm_component parent = null);

        super.new(name, parent);
        mon_ap = new("mon_ap", this);
    endfunction

    function void build_phase (uvm_phase phase);

        super.build_phase(phase);
        $display("[%0t] [scoreboard] Build phase entered", $time);

        `uvm_info("AXI SCOREBOARD", "BUILD PHASE", UVM_LOW)
    endfunction

    function void write (sequence_item#() trans);

        `uvm_info("AXI SCOREBOARD", "WRITE FUNCTION", UVM_LOW)

    endfunction

endclass