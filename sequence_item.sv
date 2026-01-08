typedef enum logic [1:0] {fixed = 2'b00, incr = 2'b01, wrap = 2'b10} burst_type;
class sequence_item #(parameter addr_width = 32, 
    parameter data_width = 32,
    parameter id_width = 2) extends uvm_sequence_item;

    typedef enum bit[1:0] { write_op, read_op} trans_type;

    // write address channel
    rand logic [addr_width - 1:0] awaddr;
    rand logic [id_width -1:0] awid;
    rand logic [7:0] awlen;
    rand logic [2:0] awsize;
    rand burst_type awburst;
    logic awvalid;
    logic awready;

    //write data channel signals

    rand logic [data_width - 1:0] wdata;
    logic wlast;
    logic wvalid;
    logic wready;

    //write response channel signals
    
    logic [id_width - 1:0] bid;
    logic [1:0] bresp;
    logic bvalid;
    logic bready;

    //read address channel signals

    rand logic [id_width - 1:0] arid;
    rand logic [addr_width - 1:0] araddr;
    rand logic [7:0] arlen;
    rand logic [2:0] arsize;
    rand burst_type arburst;
    logic arvalid;
    logic arready;

    //read data channel signals
    
    rand logic [id_width -1:0] rid;
    logic [data_width -1:0] rdata;
    logic [1:0] rresp;
    logic rlast;
    logic rvalid;
    logic rready;


    rand trans_type trtype;

    function int aw_burst_length();
        return awlen + 1;
    endfunction

    function int ar_burst_length();
        return arlen + 1;
    endfunction

    function int aw_burst_size();
        return 1 << awsize; // 2**awsize
    endfunction

    function int ar_burst_size();
        return 1 << arsize;
    endfunction

    function int aw_transfer_size();
        return aw_burst_size()* aw_burst_length();
    endfunction

    function int ar_transfer_size();
        return ar_burst_size() * ar_burst_length();
    endfunction


    `uvm_object_utils_begin(sequence_item#())

    `uvm_field_int(awaddr,UVM_ALL_ON)
    `uvm_field_int(awlen,UVM_ALL_ON)
    `uvm_field_int(awsize, UVM_ALL_ON)
    `uvm_field_enum(burst_type, awburst,UVM_ALL_ON)
    `uvm_field_int(awvalid, UVM_ALL_ON)
    `uvm_field_int(awready, UVM_ALL_ON)
    `uvm_field_int(awid, UVM_ALL_ON)

    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(wlast, UVM_ALL_ON)
    `uvm_field_int(wvalid, UVM_ALL_ON)
    `uvm_field_int(wready, UVM_ALL_ON)

    `uvm_field_int(bid, UVM_ALL_ON)
    `uvm_field_int(bresp, UVM_ALL_ON)
    `uvm_field_int(bvalid, UVM_ALL_ON)
    `uvm_field_int(bready, UVM_ALL_ON)

    `uvm_field_int(arid, UVM_ALL_ON)
    `uvm_field_int(araddr, UVM_ALL_ON)
    `uvm_field_int(arlen, UVM_ALL_ON)
    `uvm_field_int(arsize, UVM_ALL_ON)
    `uvm_field_enum(burst_type, arburst, UVM_ALL_ON)
    `uvm_field_int(arvalid, UVM_ALL_ON)
    `uvm_field_int(arready, UVM_ALL_ON)

    `uvm_field_int(rid, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(rresp, UVM_ALL_ON)
    `uvm_field_int(rlast, UVM_ALL_ON)
    `uvm_field_int(rvalid, UVM_ALL_ON)
    `uvm_field_int(rready, UVM_ALL_ON)

    `uvm_object_utils_end

    function new(string name= "sequence_item");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);

        $display("At %0t---- Display from class: sequence_item ----", $time);

        // Write Address
        $display("At %0t , AWADDR=%0h AWID=%0d AWLEN=%0d AWSIZE=%0d AWBURST=%0d AWVALID=%0b AWREADY=%0b",
                 $time, awaddr, awid, awlen, awsize, awburst, awvalid, awready);

        // Write Data
        $display("At %0t WDATA=%0h WLAST=%0b WVALID=%0b WREADY=%0b", $time,
                 wdata, wlast, wvalid, wready);

        // Write Response
        $display("At %0t BID=%0d BRESP=%0d BVALID=%0b BREADY=%0b",
                 $time, bid, bresp, bvalid, bready);

        // Read Address
        $display("At %0t ARADDR=%0h ARID=%0d ARLEN=%0d ARSIZE=%0d ARBURST=%0d ARVALID=%0b ARREADY=%0b",
                 $time, araddr, arid, arlen, arsize, arburst, arvalid, arready);

        // Read Data
        $display("At %0t RID=%0d RDATA=%0h RRESP=%0d RLAST=%0b RVALID=%0b RREADY=%0b",
                 $time, rid, rdata, rresp, rlast, rvalid, rready);

        // Derived values
        $display("AW Burst Length=%0d AW Burst Size=%0d AW Transfer Size=%0d",
                 aw_burst_length(), aw_burst_size(), aw_transfer_size());
        $display("AR Burst Length=%0d AR Burst Size=%0d AR Transfer Size=%0d",
                 ar_burst_length(), ar_burst_size(), ar_transfer_size());

        $display("At %0t ---- End of sequence_item display ----", $time);
    endfunction

endclass
