class environment extends uvm_env;

    `uvm_component_utils(environment)

    agent agent_h;
    scoreboard scoreboard_h;

    function new(string name = "environment", uvm_component parent = null);

        super.new(name, parent);
        

    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        $display("[%0t] [environment] Build phase entered", $time);

        agent_h = agent::type_id::create("agent_h", this);
        scoreboard_h = scoreboard::type_id::create("scoreboard_h", this);
        $display("[%0t] [environment] Agent and Scoreboard created", $time);
        `uvm_info("AXI ENVIRONMENT", "BUILD PHASE", UVM_LOW)

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("[%0t] [environment] Connect phase entered", $time);
        agent_h.monitor_h.mon_ap.connect(scoreboard_h.mon_ap);
        $display("[%0t] [environment] Monitor analysis port connected to Scoreboard", $time);
        `uvm_info("AXI ENVIRONMENT", "CONNECT PHASE", UVM_LOW)
    endfunction

endclass

