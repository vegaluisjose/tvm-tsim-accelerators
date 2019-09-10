// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2019.1
// Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="adder,hls_ip_2019_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7z020-clg400-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=8.750000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=2,HLS_SYN_DSP=0,HLS_SYN_FF=1101,HLS_SYN_LUT=1330,HLS_VERSION=2019_1}" *)

module adder (
        ap_clk,
        ap_rst_n,
        m_axi_data_AWVALID,
        m_axi_data_AWREADY,
        m_axi_data_AWADDR,
        m_axi_data_AWID,
        m_axi_data_AWLEN,
        m_axi_data_AWSIZE,
        m_axi_data_AWBURST,
        m_axi_data_AWLOCK,
        m_axi_data_AWCACHE,
        m_axi_data_AWPROT,
        m_axi_data_AWQOS,
        m_axi_data_AWREGION,
        m_axi_data_AWUSER,
        m_axi_data_WVALID,
        m_axi_data_WREADY,
        m_axi_data_WDATA,
        m_axi_data_WSTRB,
        m_axi_data_WLAST,
        m_axi_data_WID,
        m_axi_data_WUSER,
        m_axi_data_ARVALID,
        m_axi_data_ARREADY,
        m_axi_data_ARADDR,
        m_axi_data_ARID,
        m_axi_data_ARLEN,
        m_axi_data_ARSIZE,
        m_axi_data_ARBURST,
        m_axi_data_ARLOCK,
        m_axi_data_ARCACHE,
        m_axi_data_ARPROT,
        m_axi_data_ARQOS,
        m_axi_data_ARREGION,
        m_axi_data_ARUSER,
        m_axi_data_RVALID,
        m_axi_data_RREADY,
        m_axi_data_RDATA,
        m_axi_data_RLAST,
        m_axi_data_RID,
        m_axi_data_RUSER,
        m_axi_data_RRESP,
        m_axi_data_BVALID,
        m_axi_data_BREADY,
        m_axi_data_BRESP,
        m_axi_data_BID,
        m_axi_data_BUSER,
        s_axi_control_AWVALID,
        s_axi_control_AWREADY,
        s_axi_control_AWADDR,
        s_axi_control_WVALID,
        s_axi_control_WREADY,
        s_axi_control_WDATA,
        s_axi_control_WSTRB,
        s_axi_control_ARVALID,
        s_axi_control_ARREADY,
        s_axi_control_ARADDR,
        s_axi_control_RVALID,
        s_axi_control_RREADY,
        s_axi_control_RDATA,
        s_axi_control_RRESP,
        s_axi_control_BVALID,
        s_axi_control_BREADY,
        s_axi_control_BRESP,
        interrupt
);

parameter    ap_ST_fsm_state1 = 18'd1;
parameter    ap_ST_fsm_state2 = 18'd2;
parameter    ap_ST_fsm_state3 = 18'd4;
parameter    ap_ST_fsm_state4 = 18'd8;
parameter    ap_ST_fsm_state5 = 18'd16;
parameter    ap_ST_fsm_state6 = 18'd32;
parameter    ap_ST_fsm_state7 = 18'd64;
parameter    ap_ST_fsm_state8 = 18'd128;
parameter    ap_ST_fsm_state9 = 18'd256;
parameter    ap_ST_fsm_state10 = 18'd512;
parameter    ap_ST_fsm_state11 = 18'd1024;
parameter    ap_ST_fsm_state12 = 18'd2048;
parameter    ap_ST_fsm_state13 = 18'd4096;
parameter    ap_ST_fsm_state14 = 18'd8192;
parameter    ap_ST_fsm_state15 = 18'd16384;
parameter    ap_ST_fsm_state16 = 18'd32768;
parameter    ap_ST_fsm_state17 = 18'd65536;
parameter    ap_ST_fsm_state18 = 18'd131072;
parameter    C_S_AXI_CONTROL_DATA_WIDTH = 32;
parameter    C_S_AXI_CONTROL_ADDR_WIDTH = 6;
parameter    C_S_AXI_DATA_WIDTH = 32;
parameter    C_M_AXI_DATA_ID_WIDTH = 1;
parameter    C_M_AXI_DATA_ADDR_WIDTH = 32;
parameter    C_M_AXI_DATA_DATA_WIDTH = 32;
parameter    C_M_AXI_DATA_AWUSER_WIDTH = 1;
parameter    C_M_AXI_DATA_ARUSER_WIDTH = 1;
parameter    C_M_AXI_DATA_WUSER_WIDTH = 1;
parameter    C_M_AXI_DATA_RUSER_WIDTH = 1;
parameter    C_M_AXI_DATA_BUSER_WIDTH = 1;
parameter    C_M_AXI_DATA_USER_VALUE = 0;
parameter    C_M_AXI_DATA_PROT_VALUE = 0;
parameter    C_M_AXI_DATA_CACHE_VALUE = 3;
parameter    C_M_AXI_DATA_WIDTH = 32;

parameter C_S_AXI_CONTROL_WSTRB_WIDTH = (32 / 8);
parameter C_S_AXI_WSTRB_WIDTH = (32 / 8);
parameter C_M_AXI_DATA_WSTRB_WIDTH = (32 / 8);
parameter C_M_AXI_WSTRB_WIDTH = (32 / 8);

input   ap_clk;
input   ap_rst_n;
output   m_axi_data_AWVALID;
input   m_axi_data_AWREADY;
output  [C_M_AXI_DATA_ADDR_WIDTH - 1:0] m_axi_data_AWADDR;
output  [C_M_AXI_DATA_ID_WIDTH - 1:0] m_axi_data_AWID;
output  [7:0] m_axi_data_AWLEN;
output  [2:0] m_axi_data_AWSIZE;
output  [1:0] m_axi_data_AWBURST;
output  [1:0] m_axi_data_AWLOCK;
output  [3:0] m_axi_data_AWCACHE;
output  [2:0] m_axi_data_AWPROT;
output  [3:0] m_axi_data_AWQOS;
output  [3:0] m_axi_data_AWREGION;
output  [C_M_AXI_DATA_AWUSER_WIDTH - 1:0] m_axi_data_AWUSER;
output   m_axi_data_WVALID;
input   m_axi_data_WREADY;
output  [C_M_AXI_DATA_DATA_WIDTH - 1:0] m_axi_data_WDATA;
output  [C_M_AXI_DATA_WSTRB_WIDTH - 1:0] m_axi_data_WSTRB;
output   m_axi_data_WLAST;
output  [C_M_AXI_DATA_ID_WIDTH - 1:0] m_axi_data_WID;
output  [C_M_AXI_DATA_WUSER_WIDTH - 1:0] m_axi_data_WUSER;
output   m_axi_data_ARVALID;
input   m_axi_data_ARREADY;
output  [C_M_AXI_DATA_ADDR_WIDTH - 1:0] m_axi_data_ARADDR;
output  [C_M_AXI_DATA_ID_WIDTH - 1:0] m_axi_data_ARID;
output  [7:0] m_axi_data_ARLEN;
output  [2:0] m_axi_data_ARSIZE;
output  [1:0] m_axi_data_ARBURST;
output  [1:0] m_axi_data_ARLOCK;
output  [3:0] m_axi_data_ARCACHE;
output  [2:0] m_axi_data_ARPROT;
output  [3:0] m_axi_data_ARQOS;
output  [3:0] m_axi_data_ARREGION;
output  [C_M_AXI_DATA_ARUSER_WIDTH - 1:0] m_axi_data_ARUSER;
input   m_axi_data_RVALID;
output   m_axi_data_RREADY;
input  [C_M_AXI_DATA_DATA_WIDTH - 1:0] m_axi_data_RDATA;
input   m_axi_data_RLAST;
input  [C_M_AXI_DATA_ID_WIDTH - 1:0] m_axi_data_RID;
input  [C_M_AXI_DATA_RUSER_WIDTH - 1:0] m_axi_data_RUSER;
input  [1:0] m_axi_data_RRESP;
input   m_axi_data_BVALID;
output   m_axi_data_BREADY;
input  [1:0] m_axi_data_BRESP;
input  [C_M_AXI_DATA_ID_WIDTH - 1:0] m_axi_data_BID;
input  [C_M_AXI_DATA_BUSER_WIDTH - 1:0] m_axi_data_BUSER;
input   s_axi_control_AWVALID;
output   s_axi_control_AWREADY;
input  [C_S_AXI_CONTROL_ADDR_WIDTH - 1:0] s_axi_control_AWADDR;
input   s_axi_control_WVALID;
output   s_axi_control_WREADY;
input  [C_S_AXI_CONTROL_DATA_WIDTH - 1:0] s_axi_control_WDATA;
input  [C_S_AXI_CONTROL_WSTRB_WIDTH - 1:0] s_axi_control_WSTRB;
input   s_axi_control_ARVALID;
output   s_axi_control_ARREADY;
input  [C_S_AXI_CONTROL_ADDR_WIDTH - 1:0] s_axi_control_ARADDR;
output   s_axi_control_RVALID;
input   s_axi_control_RREADY;
output  [C_S_AXI_CONTROL_DATA_WIDTH - 1:0] s_axi_control_RDATA;
output  [1:0] s_axi_control_RRESP;
output   s_axi_control_BVALID;
input   s_axi_control_BREADY;
output  [1:0] s_axi_control_BRESP;
output   interrupt;

 reg    ap_rst_n_inv;
wire    ap_start;
reg    ap_done;
reg    ap_idle;
(* fsm_encoding = "none" *) reg   [17:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    ap_ready;
wire   [31:0] length_r;
wire   [31:0] a;
wire   [31:0] b;
wire   [31:0] y;
reg    data_blk_n_AW;
wire    ap_CS_fsm_state2;
reg    data_blk_n_W;
wire    ap_CS_fsm_state14;
reg    data_blk_n_B;
wire    ap_CS_fsm_state18;
reg   [0:0] icmp_ln32_reg_247;
reg    data_blk_n_AR;
wire    ap_CS_fsm_state4;
reg    data_blk_n_R;
wire    ap_CS_fsm_state11;
wire    ap_CS_fsm_state5;
wire    ap_CS_fsm_state12;
reg    data_AWVALID;
wire    data_AWREADY;
reg    data_WVALID;
wire    data_WREADY;
reg    data_ARVALID;
wire    data_ARREADY;
reg   [31:0] data_ARADDR;
wire    data_RVALID;
reg    data_RREADY;
wire   [7:0] data_RDATA;
wire    data_RLAST;
wire   [0:0] data_RID;
wire   [0:0] data_RUSER;
wire   [1:0] data_RRESP;
wire    data_BVALID;
reg    data_BREADY;
wire   [1:0] data_BRESP;
wire   [0:0] data_BID;
wire   [0:0] data_BUSER;
reg   [31:0] b_read_reg_194;
reg   [31:0] a_read_reg_199;
reg   [31:0] length_read_reg_204;
reg   [31:0] data_addr_reg_211;
wire  signed [32:0] p_cast7_fu_134_p1;
reg  signed [32:0] p_cast7_reg_217;
wire  signed [32:0] p_cast_fu_137_p1;
reg  signed [32:0] p_cast_reg_222;
wire   [31:0] i_fu_145_p2;
reg   [31:0] i_reg_230;
wire    ap_CS_fsm_state3;
reg   [31:0] data_addr_1_reg_235;
wire   [0:0] icmp_ln31_fu_140_p2;
reg   [31:0] data_addr_2_reg_241;
wire   [0:0] icmp_ln32_fu_185_p2;
reg   [7:0] data_addr_1_read_reg_251;
reg   [7:0] data_addr_2_read_reg_256;
wire   [7:0] add_ln32_fu_190_p2;
reg   [7:0] add_ln32_reg_261;
wire    ap_CS_fsm_state13;
reg  signed [31:0] i_0_reg_113;
wire  signed [63:0] empty_fu_124_p1;
wire  signed [63:0] sext_ln32_1_fu_160_p1;
wire  signed [63:0] sext_ln32_2_fu_175_p1;
reg    ap_block_state18;
wire  signed [32:0] sext_ln32_fu_151_p1;
wire   [32:0] add_ln32_1_fu_155_p2;
wire   [32:0] add_ln32_2_fu_170_p2;
reg   [17:0] ap_NS_fsm;

// power-on initialization
initial begin
#0 ap_CS_fsm = 18'd1;
end

adder_control_s_axi #(
    .C_S_AXI_ADDR_WIDTH( C_S_AXI_CONTROL_ADDR_WIDTH ),
    .C_S_AXI_DATA_WIDTH( C_S_AXI_CONTROL_DATA_WIDTH ))
adder_control_s_axi_U(
    .AWVALID(s_axi_control_AWVALID),
    .AWREADY(s_axi_control_AWREADY),
    .AWADDR(s_axi_control_AWADDR),
    .WVALID(s_axi_control_WVALID),
    .WREADY(s_axi_control_WREADY),
    .WDATA(s_axi_control_WDATA),
    .WSTRB(s_axi_control_WSTRB),
    .ARVALID(s_axi_control_ARVALID),
    .ARREADY(s_axi_control_ARREADY),
    .ARADDR(s_axi_control_ARADDR),
    .RVALID(s_axi_control_RVALID),
    .RREADY(s_axi_control_RREADY),
    .RDATA(s_axi_control_RDATA),
    .RRESP(s_axi_control_RRESP),
    .BVALID(s_axi_control_BVALID),
    .BREADY(s_axi_control_BREADY),
    .BRESP(s_axi_control_BRESP),
    .ACLK(ap_clk),
    .ARESET(ap_rst_n_inv),
    .ACLK_EN(1'b1),
    .ap_start(ap_start),
    .interrupt(interrupt),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_idle(ap_idle),
    .length_r(length_r),
    .a(a),
    .b(b),
    .y(y)
);

adder_data_m_axi #(
    .CONSERVATIVE( 0 ),
    .USER_DW( 8 ),
    .USER_AW( 32 ),
    .USER_MAXREQS( 5 ),
    .NUM_READ_OUTSTANDING( 16 ),
    .NUM_WRITE_OUTSTANDING( 16 ),
    .MAX_READ_BURST_LENGTH( 16 ),
    .MAX_WRITE_BURST_LENGTH( 16 ),
    .C_M_AXI_ID_WIDTH( C_M_AXI_DATA_ID_WIDTH ),
    .C_M_AXI_ADDR_WIDTH( C_M_AXI_DATA_ADDR_WIDTH ),
    .C_M_AXI_DATA_WIDTH( C_M_AXI_DATA_DATA_WIDTH ),
    .C_M_AXI_AWUSER_WIDTH( C_M_AXI_DATA_AWUSER_WIDTH ),
    .C_M_AXI_ARUSER_WIDTH( C_M_AXI_DATA_ARUSER_WIDTH ),
    .C_M_AXI_WUSER_WIDTH( C_M_AXI_DATA_WUSER_WIDTH ),
    .C_M_AXI_RUSER_WIDTH( C_M_AXI_DATA_RUSER_WIDTH ),
    .C_M_AXI_BUSER_WIDTH( C_M_AXI_DATA_BUSER_WIDTH ),
    .C_USER_VALUE( C_M_AXI_DATA_USER_VALUE ),
    .C_PROT_VALUE( C_M_AXI_DATA_PROT_VALUE ),
    .C_CACHE_VALUE( C_M_AXI_DATA_CACHE_VALUE ))
adder_data_m_axi_U(
    .AWVALID(m_axi_data_AWVALID),
    .AWREADY(m_axi_data_AWREADY),
    .AWADDR(m_axi_data_AWADDR),
    .AWID(m_axi_data_AWID),
    .AWLEN(m_axi_data_AWLEN),
    .AWSIZE(m_axi_data_AWSIZE),
    .AWBURST(m_axi_data_AWBURST),
    .AWLOCK(m_axi_data_AWLOCK),
    .AWCACHE(m_axi_data_AWCACHE),
    .AWPROT(m_axi_data_AWPROT),
    .AWQOS(m_axi_data_AWQOS),
    .AWREGION(m_axi_data_AWREGION),
    .AWUSER(m_axi_data_AWUSER),
    .WVALID(m_axi_data_WVALID),
    .WREADY(m_axi_data_WREADY),
    .WDATA(m_axi_data_WDATA),
    .WSTRB(m_axi_data_WSTRB),
    .WLAST(m_axi_data_WLAST),
    .WID(m_axi_data_WID),
    .WUSER(m_axi_data_WUSER),
    .ARVALID(m_axi_data_ARVALID),
    .ARREADY(m_axi_data_ARREADY),
    .ARADDR(m_axi_data_ARADDR),
    .ARID(m_axi_data_ARID),
    .ARLEN(m_axi_data_ARLEN),
    .ARSIZE(m_axi_data_ARSIZE),
    .ARBURST(m_axi_data_ARBURST),
    .ARLOCK(m_axi_data_ARLOCK),
    .ARCACHE(m_axi_data_ARCACHE),
    .ARPROT(m_axi_data_ARPROT),
    .ARQOS(m_axi_data_ARQOS),
    .ARREGION(m_axi_data_ARREGION),
    .ARUSER(m_axi_data_ARUSER),
    .RVALID(m_axi_data_RVALID),
    .RREADY(m_axi_data_RREADY),
    .RDATA(m_axi_data_RDATA),
    .RLAST(m_axi_data_RLAST),
    .RID(m_axi_data_RID),
    .RUSER(m_axi_data_RUSER),
    .RRESP(m_axi_data_RRESP),
    .BVALID(m_axi_data_BVALID),
    .BREADY(m_axi_data_BREADY),
    .BRESP(m_axi_data_BRESP),
    .BID(m_axi_data_BID),
    .BUSER(m_axi_data_BUSER),
    .ACLK(ap_clk),
    .ARESET(ap_rst_n_inv),
    .ACLK_EN(1'b1),
    .I_ARVALID(data_ARVALID),
    .I_ARREADY(data_ARREADY),
    .I_ARADDR(data_ARADDR),
    .I_ARID(1'd0),
    .I_ARLEN(32'd1),
    .I_ARSIZE(3'd0),
    .I_ARLOCK(2'd0),
    .I_ARCACHE(4'd0),
    .I_ARQOS(4'd0),
    .I_ARPROT(3'd0),
    .I_ARUSER(1'd0),
    .I_ARBURST(2'd0),
    .I_ARREGION(4'd0),
    .I_RVALID(data_RVALID),
    .I_RREADY(data_RREADY),
    .I_RDATA(data_RDATA),
    .I_RID(data_RID),
    .I_RUSER(data_RUSER),
    .I_RRESP(data_RRESP),
    .I_RLAST(data_RLAST),
    .I_AWVALID(data_AWVALID),
    .I_AWREADY(data_AWREADY),
    .I_AWADDR(data_addr_reg_211),
    .I_AWID(1'd0),
    .I_AWLEN(length_read_reg_204),
    .I_AWSIZE(3'd0),
    .I_AWLOCK(2'd0),
    .I_AWCACHE(4'd0),
    .I_AWQOS(4'd0),
    .I_AWPROT(3'd0),
    .I_AWUSER(1'd0),
    .I_AWBURST(2'd0),
    .I_AWREGION(4'd0),
    .I_WVALID(data_WVALID),
    .I_WREADY(data_WREADY),
    .I_WDATA(add_ln32_reg_261),
    .I_WID(1'd0),
    .I_WUSER(1'd0),
    .I_WLAST(1'b0),
    .I_WSTRB(1'd1),
    .I_BVALID(data_BVALID),
    .I_BREADY(data_BREADY),
    .I_BRESP(data_BRESP),
    .I_BID(data_BID),
    .I_BUSER(data_BUSER)
);

always @ (posedge ap_clk) begin
    if (ap_rst_n_inv == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (((data_WREADY == 1'b1) & (1'b1 == ap_CS_fsm_state14))) begin
        i_0_reg_113 <= i_reg_230;
    end else if (((1'b1 == ap_CS_fsm_state2) & (data_AWREADY == 1'b1))) begin
        i_0_reg_113 <= 32'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((ap_start == 1'b1) & (1'b1 == ap_CS_fsm_state1))) begin
        a_read_reg_199 <= a;
        b_read_reg_194 <= b;
        data_addr_reg_211 <= empty_fu_124_p1;
        length_read_reg_204 <= length_r;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state13)) begin
        add_ln32_reg_261 <= add_ln32_fu_190_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((data_RVALID == 1'b1) & (1'b1 == ap_CS_fsm_state11))) begin
        data_addr_1_read_reg_251 <= data_RDATA;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state3) & (icmp_ln31_fu_140_p2 == 1'd0))) begin
        data_addr_1_reg_235 <= sext_ln32_1_fu_160_p1;
        data_addr_2_reg_241 <= sext_ln32_2_fu_175_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((data_RVALID == 1'b1) & (1'b1 == ap_CS_fsm_state12))) begin
        data_addr_2_read_reg_256 <= data_RDATA;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        i_reg_230 <= i_fu_145_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln31_fu_140_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
        icmp_ln32_reg_247 <= icmp_ln32_fu_185_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state2) & (data_AWREADY == 1'b1))) begin
        p_cast7_reg_217 <= p_cast7_fu_134_p1;
        p_cast_reg_222 <= p_cast_fu_137_p1;
    end
end

always @ (*) begin
    if ((~((data_BVALID == 1'b0) & (icmp_ln32_reg_247 == 1'd0)) & (1'b1 == ap_CS_fsm_state18))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if ((~((data_BVALID == 1'b0) & (icmp_ln32_reg_247 == 1'd0)) & (1'b1 == ap_CS_fsm_state18))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((data_ARREADY == 1'b1)) begin
        if ((1'b1 == ap_CS_fsm_state5)) begin
            data_ARADDR = data_addr_2_reg_241;
        end else if ((1'b1 == ap_CS_fsm_state4)) begin
            data_ARADDR = data_addr_1_reg_235;
        end else begin
            data_ARADDR = 'bx;
        end
    end else begin
        data_ARADDR = 'bx;
    end
end

always @ (*) begin
    if ((((data_ARREADY == 1'b1) & (1'b1 == ap_CS_fsm_state5)) | ((data_ARREADY == 1'b1) & (1'b1 == ap_CS_fsm_state4)))) begin
        data_ARVALID = 1'b1;
    end else begin
        data_ARVALID = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (data_AWREADY == 1'b1))) begin
        data_AWVALID = 1'b1;
    end else begin
        data_AWVALID = 1'b0;
    end
end

always @ (*) begin
    if ((~((data_BVALID == 1'b0) & (icmp_ln32_reg_247 == 1'd0)) & (1'b1 == ap_CS_fsm_state18) & (icmp_ln32_reg_247 == 1'd0))) begin
        data_BREADY = 1'b1;
    end else begin
        data_BREADY = 1'b0;
    end
end

always @ (*) begin
    if ((((data_RVALID == 1'b1) & (1'b1 == ap_CS_fsm_state12)) | ((data_RVALID == 1'b1) & (1'b1 == ap_CS_fsm_state11)))) begin
        data_RREADY = 1'b1;
    end else begin
        data_RREADY = 1'b0;
    end
end

always @ (*) begin
    if (((data_WREADY == 1'b1) & (1'b1 == ap_CS_fsm_state14))) begin
        data_WVALID = 1'b1;
    end else begin
        data_WVALID = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state5) | (1'b1 == ap_CS_fsm_state4))) begin
        data_blk_n_AR = m_axi_data_ARREADY;
    end else begin
        data_blk_n_AR = 1'b1;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        data_blk_n_AW = m_axi_data_AWREADY;
    end else begin
        data_blk_n_AW = 1'b1;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state18) & (icmp_ln32_reg_247 == 1'd0))) begin
        data_blk_n_B = m_axi_data_BVALID;
    end else begin
        data_blk_n_B = 1'b1;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state12) | (1'b1 == ap_CS_fsm_state11))) begin
        data_blk_n_R = m_axi_data_RVALID;
    end else begin
        data_blk_n_R = 1'b1;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state14)) begin
        data_blk_n_W = m_axi_data_WREADY;
    end else begin
        data_blk_n_W = 1'b1;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if (((ap_start == 1'b1) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if (((1'b1 == ap_CS_fsm_state2) & (data_AWREADY == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end
        end
        ap_ST_fsm_state3 : begin
            if (((icmp_ln32_fu_185_p2 == 1'd1) & (icmp_ln31_fu_140_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state3))) begin
                ap_NS_fsm = ap_ST_fsm_state18;
            end else if (((icmp_ln31_fu_140_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state3) & (icmp_ln32_fu_185_p2 == 1'd0))) begin
                ap_NS_fsm = ap_ST_fsm_state15;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end
        end
        ap_ST_fsm_state4 : begin
            if (((data_ARREADY == 1'b1) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end
        end
        ap_ST_fsm_state5 : begin
            if (((data_ARREADY == 1'b1) & (1'b1 == ap_CS_fsm_state5))) begin
                ap_NS_fsm = ap_ST_fsm_state6;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end
        end
        ap_ST_fsm_state6 : begin
            ap_NS_fsm = ap_ST_fsm_state7;
        end
        ap_ST_fsm_state7 : begin
            ap_NS_fsm = ap_ST_fsm_state8;
        end
        ap_ST_fsm_state8 : begin
            ap_NS_fsm = ap_ST_fsm_state9;
        end
        ap_ST_fsm_state9 : begin
            ap_NS_fsm = ap_ST_fsm_state10;
        end
        ap_ST_fsm_state10 : begin
            ap_NS_fsm = ap_ST_fsm_state11;
        end
        ap_ST_fsm_state11 : begin
            if (((data_RVALID == 1'b1) & (1'b1 == ap_CS_fsm_state11))) begin
                ap_NS_fsm = ap_ST_fsm_state12;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state11;
            end
        end
        ap_ST_fsm_state12 : begin
            if (((data_RVALID == 1'b1) & (1'b1 == ap_CS_fsm_state12))) begin
                ap_NS_fsm = ap_ST_fsm_state13;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state12;
            end
        end
        ap_ST_fsm_state13 : begin
            ap_NS_fsm = ap_ST_fsm_state14;
        end
        ap_ST_fsm_state14 : begin
            if (((data_WREADY == 1'b1) & (1'b1 == ap_CS_fsm_state14))) begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state14;
            end
        end
        ap_ST_fsm_state15 : begin
            ap_NS_fsm = ap_ST_fsm_state16;
        end
        ap_ST_fsm_state16 : begin
            ap_NS_fsm = ap_ST_fsm_state17;
        end
        ap_ST_fsm_state17 : begin
            ap_NS_fsm = ap_ST_fsm_state18;
        end
        ap_ST_fsm_state18 : begin
            if ((~((data_BVALID == 1'b0) & (icmp_ln32_reg_247 == 1'd0)) & (1'b1 == ap_CS_fsm_state18))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state18;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln32_1_fu_155_p2 = ($signed(sext_ln32_fu_151_p1) + $signed(p_cast_reg_222));

assign add_ln32_2_fu_170_p2 = ($signed(sext_ln32_fu_151_p1) + $signed(p_cast7_reg_217));

assign add_ln32_fu_190_p2 = (data_addr_1_read_reg_251 + data_addr_2_read_reg_256);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state11 = ap_CS_fsm[32'd10];

assign ap_CS_fsm_state12 = ap_CS_fsm[32'd11];

assign ap_CS_fsm_state13 = ap_CS_fsm[32'd12];

assign ap_CS_fsm_state14 = ap_CS_fsm[32'd13];

assign ap_CS_fsm_state18 = ap_CS_fsm[32'd17];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

always @ (*) begin
    ap_block_state18 = ((data_BVALID == 1'b0) & (icmp_ln32_reg_247 == 1'd0));
end

always @ (*) begin
    ap_rst_n_inv = ~ap_rst_n;
end

assign empty_fu_124_p1 = $signed(y);

assign i_fu_145_p2 = ($signed(i_0_reg_113) + $signed(32'd1));

assign icmp_ln31_fu_140_p2 = ((i_0_reg_113 == length_read_reg_204) ? 1'b1 : 1'b0);

assign icmp_ln32_fu_185_p2 = ((length_read_reg_204 == 32'd0) ? 1'b1 : 1'b0);

assign p_cast7_fu_134_p1 = $signed(b_read_reg_194);

assign p_cast_fu_137_p1 = $signed(a_read_reg_199);

assign sext_ln32_1_fu_160_p1 = $signed(add_ln32_1_fu_155_p2);

assign sext_ln32_2_fu_175_p1 = $signed(add_ln32_2_fu_170_p2);

assign sext_ln32_fu_151_p1 = i_0_reg_113;

endmodule //adder