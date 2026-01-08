module axi_target_mem (
// AXI INTERFACE
   input               ACLK,
   input               ARESETn,

//AXI addr COMMAND CHANNEL
   input  [1:0]        AWID,
   input  [31:0]       AWADDR,
   input  [7:0]        AWLEN,
   input  [2:0]        AWSIZE,
   input  [1:0]        AWBURST,
   input               AWLOCK,
   input  [3:0]        AWCACHE,
   input  [2:0]        AWPROT,
   input  [1:0]        AWQOS,
   input  [3:0]        AWREGION,
   input               AWVALID,
   output              AWREADY,

//AXI WRITE DATA CHANNEL
   input  [1:0]        WID,
   input  [31:0]      WDATA,
   input  [15:0]       WSTRB,
   input               WLAST,
   input               WVALID,
   output              WREADY,
  
//AXI WRITE RESPONSE CHANNEL
   output [1:0]        BID,
   output [1:0]        BRESP,
   output              BVALID,
   input               BREADY,

//AXI READ COMMAND CHANNEL
   input  [1:0]        ARID,
   input  [31:0]       ARADDR,
   input  [7:0]        ARLEN,
   input  [2:0]        ARSIZE,
   input  [1:0]        ARBURST,
   input               ARLOCK,
   input  [3:0]        ARCACHE,
   input  [2:0]        ARPROT,
   input  [1:0]        ARQOS,
   input  [3:0]        ARREGION,
   input               ARVALID,
   output              ARREADY,

//AXI READ DATA CHANNEL
   output [1:0]        RID,
   output [31:0]      RDATA,
   output              RLAST,
   output              RVALID,
   output [1:0]        RRESP,
   input               RREADY
);

//*******************************************************
//LOCAL LOGIC
//*******************************************************

reg [1:0] st_axi_wr;
parameter AXI_WR_IDLE     = 2'b00;   //IDLE STATE 
parameter AXI_WR_ADDR     = 2'b01;   //AXI WR ADDR STATE
parameter AXI_WR_DATA     = 2'b10;   //AXI WR DATA STATE
parameter AXI_WR_RESP     = 2'b11;   //AXI WR RESP STATE 

reg [1:0] st_axi_rd;
parameter AXI_RD_IDLE     = 2'b00;   //IDLE STATE 
parameter AXI_RD_ADDR     = 2'b01;   //AXI WR ADDR STATE
parameter AXI_RD_DATA     = 2'b10;   //AXI WR DATA STATE

reg [10:0] axi_rd_cnt;
reg [7:0]  arid_reg;
reg [7:0]  awid_reg;
reg [10:0] xfer_cnt;

reg [41:0] wr_addr;
reg [41:0] rd_addr;

wire       wr_addr_vld;
wire       wr_data_vld;
wire       wr_data_last_vld;
wire       wr_bresp_vld;

wire       rd_addr_vld;
wire       rd_data_vld;
wire       rd_data_last_vld;

reg  [31:0] mem[0:1023];
reg  [31:0]mem0;
reg  [31:0]mem1;
reg  [31:0]mem2;
reg  [31:0]mem3;
reg  [31:0]mem4;
reg  [31:0]mem5;
reg  [31:0]mem6;
reg  [31:0]mem7;
assign mem0 = mem[0];
assign mem1 = mem[1];
assign mem2 = mem[2];
assign mem3 = mem[3];
assign mem4 = mem[4];
assign mem5 = mem[5];
assign mem6 = mem[6];
assign mem7 = mem[7];
//*******************************************************
//LOCAL LOGIC
//*******************************************************

always @ (posedge ACLK or negedge ARESETn) begin
   if(~ARESETn) begin
       st_axi_wr <= AXI_WR_IDLE;
   end else begin
       case(st_axi_wr)
          AXI_WR_IDLE    : begin
                             if(AWVALID)
                                 st_axi_wr <= AXI_WR_ADDR;
                             else
                                 st_axi_wr <= st_axi_wr;
                           end 
          AXI_WR_ADDR    : begin
                             if(wr_addr_vld)
                                 st_axi_wr <= AXI_WR_DATA;
                             else
                                 st_axi_wr <= st_axi_wr;
                           end 
          AXI_WR_DATA    : begin
                             if(wr_data_last_vld)
                                 st_axi_wr <= AXI_WR_RESP;
                             else
                                 st_axi_wr <= st_axi_wr;
                           end 
          AXI_WR_RESP    : begin
                             if(wr_bresp_vld)
                                 st_axi_wr <= AXI_WR_IDLE;
                             else
                                 st_axi_wr <= st_axi_wr;
                           end 
          default        : begin
                             st_axi_wr <= AXI_WR_IDLE;
                           end 
       endcase
   end
end //always

//AXI RD FSM 
always @ (posedge ACLK or negedge ARESETn) begin
   if(~ARESETn) begin
       st_axi_rd <= AXI_RD_IDLE;
   end else begin
       case(st_axi_rd)
          AXI_RD_IDLE    : begin
                             if(ARVALID)
                                 st_axi_rd <= AXI_RD_ADDR;
                             else
                                 st_axi_rd <= st_axi_rd;
                           end 
          AXI_RD_ADDR    : begin
                             if(rd_addr_vld)
                                 st_axi_rd <= AXI_RD_DATA;
                             else
                                 st_axi_rd <= st_axi_rd;
                           end 
          AXI_RD_DATA    : begin
                             if(rd_data_last_vld)
                                 st_axi_rd <= AXI_RD_IDLE;
                             else
                                 st_axi_rd <= st_axi_rd;
                           end 
          default        : begin
                             st_axi_rd <= AXI_RD_IDLE;
                           end 
       endcase
   end
end //always

//*******************************************************
//LOCAL LOGIC
//*******************************************************

assign wr_addr_vld       = AWVALID && AWREADY;
assign wr_data_vld       = WVALID  && WREADY;
assign wr_data_last_vld  = WLAST   && wr_data_vld;
assign wr_bresp_vld      = BVALID  && BREADY;

assign rd_addr_vld       = ARVALID && ARREADY;
assign rd_data_vld       = RVALID  && RREADY;
assign rd_data_last_vld  = RLAST   && rd_data_vld;

always @ (posedge ACLK or negedge ARESETn) begin
   if(~ARESETn) begin
       xfer_cnt <= 'd0;
   end else if(st_axi_rd == AXI_RD_IDLE) begin
       xfer_cnt <= 'd0;
   end else if(rd_data_vld) begin
       xfer_cnt <= xfer_cnt + 1'b1;
   end else begin
       xfer_cnt <= xfer_cnt;
   end
end //always

//*******************************************************
//AXI INTERFACE LOGIC
//*******************************************************

assign ARREADY  = (st_axi_rd == AXI_RD_ADDR) ? 1'b1 : 1'b0;
assign RVALID   = (st_axi_rd == AXI_RD_DATA) ? 1'b1 : 1'b0;
assign RLAST    = ((st_axi_rd == AXI_RD_DATA) && (xfer_cnt == axi_rd_cnt)) ? 1'b1 : 1'b0;
assign RDATA    = mem[rd_addr[9:0]]; 
assign RRESP    = (st_axi_rd == AXI_RD_DATA) ? 2'b00 : 2'b01;
assign RID      = arid_reg;

assign AWREADY  = (st_axi_wr == AXI_WR_ADDR) ? 1'b1 : 1'b0;
assign WREADY   = (st_axi_wr == AXI_WR_DATA) ? 1'b1 : 1'b0;
assign BID      = awid_reg;
// If in Response State, send OKAY (00), otherwise default to SLVERR/ExOKAY (01) for debug visibility
assign BRESP = (st_axi_wr == AXI_WR_RESP) ? 2'b00 : 2'b01;
assign BVALID   = (st_axi_wr == AXI_WR_RESP) ? 1'b1 : 1'b0;

//*******************************************************
//DMA INTERFACE LOGIC
//*******************************************************

always @(posedge ACLK) begin
   if (wr_data_vld) begin
       mem[wr_addr[9:0]] <= WDATA;
   end
end

always @(posedge ACLK or negedge ARESETn) begin
   if (!ARESETn) begin
       awid_reg <= 'd0;
   end else if (wr_addr_vld) begin
       awid_reg <= AWID;
   end else begin
       awid_reg <= awid_reg;
   end
end

always @(posedge ACLK or negedge ARESETn) begin
   if (!ARESETn) begin
       arid_reg <= 'd0;
   end else if (rd_addr_vld) begin
       arid_reg <= ARID;
   end else begin
       arid_reg <= arid_reg;
   end
end

always @(posedge ACLK or negedge ARESETn) begin
   if (!ARESETn) begin
       axi_rd_cnt <= 'd0;
   end else if (rd_addr_vld) begin
       axi_rd_cnt <= ARLEN;
   end else begin
       axi_rd_cnt <= axi_rd_cnt;
   end
end

always @(posedge ACLK or negedge ARESETn) begin
   if (!ARESETn) begin
       wr_addr <= 'd0;
   end else if (wr_addr_vld) begin
       wr_addr <= AWADDR[31:2];
   end else if (wr_data_vld) begin
       wr_addr <= wr_addr + 1'b1;
   end else begin
       wr_addr <= wr_addr;
   end
end

always @(posedge ACLK or negedge ARESETn) begin
   if (!ARESETn) begin
       rd_addr <= 'd0;
   end else if (rd_addr_vld) begin
       rd_addr <= ARADDR[31:2];
   end else if (rd_data_vld) begin
       rd_addr <= rd_addr + 1'b1;
   end else begin
       rd_addr <= rd_addr;
   end
end

endmodule