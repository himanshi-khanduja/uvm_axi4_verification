class driver extends uvm_driver #(sequence_item#());

    `uvm_component_utils(driver)

    virtual interface axi_if vif;

    logic [31:0] current_address;
    int aw_burst_size;
    int aw_burst_len;
    int ar_burst_len;
    int ar_burst_size;
    
    extern function new(string name = "Driver", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase); 
    extern task run_phase(uvm_phase phase); 
    extern task reset_task ();
    extern task write_address(sequence_item#() req);
    extern task write_data(sequence_item#() req);
    extern task write_response(sequence_item#() req);
    extern function int next_awaddr(sequence_item#() req, input int beat);
    extern task read_address(sequence_item#() req);
    extern task read_data(sequence_item#() req); 

endclass

    function driver:: new(string name = "Driver", uvm_component parent = null);
        super.new(name, parent);

    endfunction

    function void driver ::  build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual axi_if)::get(this, "*", "vif", vif))
            `uvm_fatal("AXI DRIVER", "VIRTAUL INTERFACE NOT FOUND IN CONFIG DB")
    endfunction

    task driver :: run_phase(uvm_phase phase);

        sequence_item#() req;
        `uvm_info("AXI DRIVER", "AXI DRIVER STARTED", UVM_MEDIUM)

        wait(vif.aresetn == 0);
        reset_task();
        wait(vif.aresetn == 1);

        `uvm_info("AXI DRIVER", "RESET ASSERTED", UVM_LOW)

        @(posedge vif.aclk);

        $display("At [%0t] Driver ready for new sequence items", $time);

        forever
        begin

            seq_item_port.get_next_item(req);

            $display("At [%0t], Got the new transaction from sequencer ", $time);

    case(req.trtype)

    sequence_item#()::write_op:begin

        write_address(req);
        write_data(req);
        write_response(req);
    end

    sequence_item#()::read_op:begin

        read_address(req);
        read_data(req);

        if(req.rdata!==req.wdata)
        `uvm_error("DRIVER", "READ DATA NOT MATCH WITH WRITE DATA")
    end

    endcase
    seq_item_port.item_done();

    @(posedge vif.aclk);

    $display("At [%0t], Transaction completed, waiting for the next one", $time);

    end
    endtask

    task driver :: reset_task();
        vif.awsize <= 0;
        vif.awlen  <= 0;
        vif.awburst <= burst_type'(0);
        vif.awvalid <= 0;
        vif.awid <= 0;
        vif.awaddr <=0;

        vif.wlast <= 0;
        vif.wvalid <= 0;
        vif.wdata <=0;

    
        vif.bresp <=0;
       // vif.bvalid <=0;
        vif.bready <= 0;

        vif.arsize<=0;
        vif.arlen <= 0;
        vif.arburst <= burst_type'(0);
        vif.arvalid <=0;
        vif.arid <=0;
        vif.araddr<=0;

    endtask

    task driver :: write_address(input sequence_item#() req);

        `uvm_info(get_type_name(), $sformatf("Driving Write Address: Addr = %0h", req.awaddr), UVM_LOW )
        vif.awaddr <= req.awaddr;
        vif.awid <= req.awid;
        vif.awlen <= req.awlen;
        vif.awsize <= req.awsize;
        vif.awburst <= req.awburst;

        case(req.awburst)
            fixed:begin
                `uvm_info("ADDRESS WRITE", "FIXED BURST",  UVM_LOW)

            end
            
            incr:begin
                `uvm_info("ADDRESS WRITE", "INCR BURST", UVM_LOW)
                
            end

            wrap:begin
                `uvm_info("ADDRESS WRITE", "WRAP BURST",UVM_LOW)
                
            end

            default:begin
                `uvm_info("ADDRESS WRITE", "INVALID BURST TYPE", UVM_LOW)

            end
        endcase

        @(posedge vif.aclk)

        vif.awvalid <= 1;

        wait(vif.awready==1)

        @(posedge vif.aclk)

        vif.awvalid <=0;

        `uvm_info("ADDRESS WRITE", "ADDRESS WRITE HANDSHAKING COMPLETED", UVM_LOW)

    endtask

    task driver :: write_data(input sequence_item#() req);


        `uvm_info(get_type_name(), $sformatf("Driving Write Address: Addr = %0h", req.awaddr), UVM_LOW )

        aw_burst_len = req.aw_burst_length();
        aw_burst_size = req.aw_burst_size();
        current_address = req.awaddr;

        for(int beat = 0; beat < aw_burst_len; beat++)
        begin

            case(req.awburst)

            fixed:begin

                current_address = req.awaddr;
            end
            incr:begin
            current_address= req.awaddr + (beat * aw_burst_size);
            end

            wrap:begin

                current_address= req.awaddr;
            end

            endcase

            `uvm_info(get_type_name(), 
            $sformatf("Beat[%0d/%0d]: addr=0x%0h, data=0x%0h", 
            beat, aw_burst_len-1, current_address, req.wdata), UVM_HIGH)

            vif.wdata <= req.wdata;
            if(beat == aw_burst_len -1)
                vif.wlast <=1;
            else
                vif.wlast <= 0;
            vif.wvalid <= 1;

            @(posedge vif.aclk)
            wait(vif.wready ==1)

            current_address = next_awaddr(req,beat);
            @(posedge vif.aclk);
        end

            vif.wvalid <= 0;
            vif.wlast <= 0;

            `uvm_info("AXI DRIVER", "WRITE DATA COMPLETE", UVM_LOW)

    endtask

    function int driver :: next_awaddr(input sequence_item#() req, input int beat);

        int next_addr;

        aw_burst_size = req.aw_burst_size();
        aw_burst_len = req.aw_burst_length();
         
        case(req.awburst)
            fixed:begin
                next_addr = req.awaddr;
            end

            incr:begin
                //incr function
                next_addr= req.awaddr + ((beat + 1)* aw_burst_size);

            end

            wrap:begin 
            //wrap function
            next_addr = current_address;

            
            end

            default : begin

                `uvm_info("AXI DRIVER", "INVALID ADDRESS WRITE BURST TYPE", UVM_LOW)
            end
        endcase
        return next_addr;

    endfunction

    task driver :: write_response(input sequence_item#() req);

        `uvm_info("AXI DRIVER", "GETTING WRITE RESPONSE", UVM_LOW)

            vif.bready <= 1;

        @(posedge vif.aclk)

        wait(vif.bvalid == 1)
        
        @(posedge vif.aclk)

        vif.bready <=0;

        `uvm_info("AXI DRIVER", "WRITE RESPONSE RECEIVED", UVM_LOW)
    endtask

    task driver::read_address(input sequence_item#() req);

  `uvm_info("READ_REQ_CHECK",
    $sformatf(
      "REQ values: araddr=0x%0h arlen=%0d arsize=%0d arburst=%0d arid=%0d",
      req.araddr,
      req.arlen,
      req.arsize,
      req.arburst,
      req.arid
    ),
    UVM_LOW
  )

  @(posedge vif.aclk);   // <-- use actual clock name
  vif.araddr  <= req.araddr;
  vif.arlen   <= req.arlen;
  vif.arsize  <= req.arsize;
  vif.arburst <= req.arburst;
  vif.arid    <= req.arid;
  vif.arvalid <= 1;

  wait (vif.arready == 1);

  @(posedge vif.aclk);
  vif.arvalid <= 0;

endtask



    task driver :: read_data(input sequence_item#() req);

            int beat=0;
            ar_burst_len= req.ar_burst_length();


        `uvm_info(get_type_name(), $sformatf("Receiving read data: Addr = %0h", req.araddr), UVM_LOW)

        

        vif.rready <= 1;

        while(beat < ar_burst_len)
    begin
            @(posedge vif.aclk)

            if(vif.rvalid)
                begin
                    req.rdata = vif.rdata;

                    `uvm_info(get_type_name(), $sformatf("Read beat = %0d, Data = %0h, rlast = %0b", beat, req.rdata, vif.rlast), UVM_LOW)

                    if(vif.rlast)
                    begin
                        beat ++;
                        break;
                    end
                    beat ++;
                end
            end

            vif.rready <=0;

    endtask
