class fixed_write_read_test extends uvm_test;

    `uvm_component_utils(fixed_write_read_test)

    environment env_h;
    fixed_write_read_sequence seq_h;

    function new(string name = "fixed_write_read_test", uvm_component parent = null);
        super.new(name, parent);

    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        $display("[%0t] [fixed_write_read_test] Build phase entered", $time);

        `uvm_info("AXI TEST", "BUILD PHASE", UVM_LOW)

        env_h = environment::type_id::create("env_h", this);
        $display("[%0t] [fixed_write_read_test] Environment created", $time);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);
        $display("[%0t] [fixed_write_read_test] Run phase entered", $time);

        `uvm_info("AXI_TEST", "RUN_PHASE", UVM_LOW)

        `uvm_info("AXI_TEST", "TEST STARTED", UVM_LOW)

        seq_h = fixed_write_read_sequence::type_id::create("seq_h", this);

        $display("[%0t] [fixed_write_read_test] Sequence created, starting on sequencer", $time);
        seq_h.start(env_h.agent_h.sequencer_h);

        $display("[%0t] [fixed_write_read_test] Sequence completed", $time);
        `uvm_info("AXI TEST", "SEQUENCE COMPLETED", UVM_LOW)

        #200;
        $display("At %0t, time delays of 200", $time);

        phase.drop_objection(this);
        $display("[%0t] [fixed_write_read_test] Run phase completed, objection dropped", $time);
    endtask

endclass
