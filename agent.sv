class agent extends uvm_agent;

    `uvm_component_utils(agent)

    sequencer sequencer_h;
    driver driver_h;
    monitor monitor_h;

    virtual axi_if vif;

    function new(string name = "AGENT", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("[%0t] [agent] Build phase entered", $time);

        if(!uvm_config_db #(virtual axi_if)::get(this, "*", "vif", vif))
            `uvm_fatal("AXI AGENT", "VIRTUAL INTERFACE NOT FOUND IN CONFIG DB")

        if(get_is_active()==UVM_ACTIVE)
        begin
            sequencer_h = sequencer::type_id::create("sequencer_h", this);
            driver_h = driver::type_id::create("driver_h", this);
            uvm_config_db #(virtual axi_if)::set(this, "driver_h", "vif", vif);
            $display("[%0t] [agent] Sequencer and Driver created (active agent)", $time);
        end

        monitor_h = monitor :: type_id::create("monitor_h", this);
        uvm_config_db #(virtual axi_if) :: set(this, "monitor_h", "vif", vif);
        $display("[%0t] [agent] Monitor created and interface set", $time);

        `uvm_info("AXI AGENT", "BUILD PHASE", UVM_LOW)

    endfunction

    function void connect_phase(uvm_phase phase);

        `uvm_info("AXI AGENT", "CONNECT PHASE", UVM_LOW)
        $display("[%0t] [agent] Connect phase entered", $time);

        super.connect_phase(phase);

        if(get_is_active()==UVM_ACTIVE)
        begin
            driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
            $display("[%0t] [agent] Driver connected to Sequencer", $time);
        end

        $display("[%0t] [agent] Connect phase completed", $time);

    endfunction


endclass