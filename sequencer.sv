class sequencer extends uvm_sequencer #(sequence_item#());

    `uvm_component_utils(sequencer)

    function new(string name = "Sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AXI Sequencer", "Build Phase", UVM_MEDIUM)

    endfunction

    function void start_of_simulation();
        super.start_of_simulation();
        `uvm_info("AXI Sequencer", "Start of Simulation phase", UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction

endclass
