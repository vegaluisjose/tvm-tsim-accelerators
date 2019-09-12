/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

module accel #
(
  parameter HOST_ADDR_BITS = 8,
  parameter HOST_DATA_BITS = 32,
  parameter MEM_LEN_BITS = 8,
  parameter MEM_ADDR_BITS = 32,
  parameter MEM_DATA_BITS = 64
)
(
  input                         clock,
  input                         reset,

  input                         host_req_valid,
  input                         host_req_opcode,
  input    [HOST_ADDR_BITS-1:0] host_req_addr,
  input    [HOST_DATA_BITS-1:0] host_req_value,
  output                        host_req_deq,
  output                        host_resp_valid,
  output   [HOST_DATA_BITS-1:0] host_resp_bits,

  output                        mem_req_valid,
  output                        mem_req_opcode,
  output     [MEM_LEN_BITS-1:0] mem_req_len,
  output    [MEM_ADDR_BITS-1:0] mem_req_addr,
  output                        mem_wr_valid,
  output    [MEM_DATA_BITS-1:0] mem_wr_bits,
  input                         mem_rd_valid,
  input     [MEM_DATA_BITS-1:0] mem_rd_bits,
  output                        mem_rd_ready
);

  localparam HOST_AXI_ADDR_BITS = 6;
  localparam HOST_AXI_DATA_BITS = 32;
  localparam HOST_AXI_STRB_BITS = HOST_AXI_DATA_BITS / 8;
  localparam MEM_AXI_DATA_BITS = 64;
  localparam MEM_AXI_ADDR_BITS = 32;
  localparam MEM_AXI_ID_BITS = 1;
  localparam MEM_AXI_USER_BITS = 1;
  localparam MEM_AXI_STRB_BITS = MEM_AXI_DATA_BITS / 8;

  logic                               s_axi_control_AWVALID;
  logic                               s_axi_control_AWREADY;
  logic      [HOST_AXI_ADDR_BITS-1:0] s_axi_control_AWADDR;
  logic                               s_axi_control_WVALID;
  logic                               s_axi_control_WREADY;
  logic      [HOST_AXI_DATA_BITS-1:0] s_axi_control_WDATA;
  logic      [HOST_AXI_STRB_BITS-1:0] s_axi_control_WSTRB;
  logic                               s_axi_control_ARVALID;
  logic                               s_axi_control_ARREADY;
  logic      [HOST_AXI_ADDR_BITS-1:0] s_axi_control_ARADDR;
  logic                               s_axi_control_RVALID;
  logic                               s_axi_control_RREADY;
  logic      [HOST_AXI_DATA_BITS-1:0] s_axi_control_RDATA;
  logic                         [1:0] s_axi_control_RRESP;
  logic                               s_axi_control_BVALID;
  logic                               s_axi_control_BREADY;
  logic                         [1:0] s_axi_control_BRESP;

  logic                               m_axi_data_AWVALID;
  logic                               m_axi_data_AWREADY;
  logic       [MEM_AXI_ADDR_BITS-1:0] m_axi_data_AWADDR;
  logic         [MEM_AXI_ID_BITS-1:0] m_axi_data_AWID;
  logic                         [7:0] m_axi_data_AWLEN;
  logic                         [2:0] m_axi_data_AWSIZE;
  logic                         [1:0] m_axi_data_AWBURST;
  logic                         [1:0] m_axi_data_AWLOCK;
  logic                         [3:0] m_axi_data_AWCACHE;
  logic                         [2:0] m_axi_data_AWPROT;
  logic                         [3:0] m_axi_data_AWQOS;
  logic                         [3:0] m_axi_data_AWREGION;
  logic       [MEM_AXI_USER_BITS-1:0] m_axi_data_AWUSER;
  logic                               m_axi_data_WVALID;
  logic                               m_axi_data_WREADY;
  logic       [MEM_AXI_DATA_BITS-1:0] m_axi_data_WDATA;
  logic       [MEM_AXI_STRB_BITS-1:0] m_axi_data_WSTRB;
  logic                               m_axi_data_WLAST;
  logic         [MEM_AXI_ID_BITS-1:0] m_axi_data_WID;
  logic       [MEM_AXI_USER_BITS-1:0] m_axi_data_WUSER;
  logic                               m_axi_data_ARVALID;
  logic                               m_axi_data_ARREADY;
  logic       [MEM_AXI_ADDR_BITS-1:0] m_axi_data_ARADDR;
  logic         [MEM_AXI_ID_BITS-1:0] m_axi_data_ARID;
  logic                         [7:0] m_axi_data_ARLEN;
  logic                         [2:0] m_axi_data_ARSIZE;
  logic                         [1:0] m_axi_data_ARBURST;
  logic                         [1:0] m_axi_data_ARLOCK;
  logic                         [3:0] m_axi_data_ARCACHE;
  logic                         [2:0] m_axi_data_ARPROT;
  logic                         [3:0] m_axi_data_ARQOS;
  logic                         [3:0] m_axi_data_ARREGION;
  logic       [MEM_AXI_USER_BITS-1:0] m_axi_data_ARUSER;
  logic                               m_axi_data_RVALID;
  logic                               m_axi_data_RREADY;
  logic       [MEM_AXI_DATA_BITS-1:0] m_axi_data_RDATA;
  logic                               m_axi_data_RLAST;
  logic         [MEM_AXI_ID_BITS-1:0] m_axi_data_RID;
  logic       [MEM_AXI_USER_BITS-1:0] m_axi_data_RUSER;
  logic                         [1:0] m_axi_data_RRESP;
  logic                               m_axi_data_BVALID;
  logic                               m_axi_data_BREADY;
  logic                         [1:0] m_axi_data_BRESP;
  logic         [MEM_AXI_ID_BITS-1:0] m_axi_data_BID;
  logic       [MEM_AXI_USER_BITS-1:0] m_axi_data_BUSER;

  host_axi #
  (
    .HOST_ADDR_BITS          (HOST_ADDR_BITS),
    .HOST_DATA_BITS          (HOST_DATA_BITS),
    .HOST_AXI_ADDR_BITS      (HOST_AXI_ADDR_BITS),
    .HOST_AXI_DATA_BITS      (HOST_AXI_DATA_BITS),
    .HOST_AXI_STRB_BITS      (HOST_AXI_STRB_BITS)
  )
  host
  (
    .clock                   (clock),
    .reset                   (reset),

    .host_req_valid          (host_req_valid),
    .host_req_opcode         (host_req_opcode),
    .host_req_addr           (host_req_addr),
    .host_req_value          (host_req_value),
    .host_req_deq            (host_req_deq),
    .host_resp_valid         (host_resp_valid),
    .host_resp_bits          (host_resp_bits),

    .s_axi_control_AWVALID   (s_axi_control_AWVALID),
    .s_axi_control_AWREADY   (s_axi_control_AWREADY),
    .s_axi_control_AWADDR    (s_axi_control_AWADDR),
    .s_axi_control_WVALID    (s_axi_control_WVALID),
    .s_axi_control_WREADY    (s_axi_control_WREADY),
    .s_axi_control_WDATA     (s_axi_control_WDATA),
    .s_axi_control_WSTRB     (s_axi_control_WSTRB),
    .s_axi_control_ARVALID   (s_axi_control_ARVALID),
    .s_axi_control_ARREADY   (s_axi_control_ARREADY),
    .s_axi_control_ARADDR    (s_axi_control_ARADDR),
    .s_axi_control_RVALID    (s_axi_control_RVALID),
    .s_axi_control_RREADY    (s_axi_control_RREADY),
    .s_axi_control_RDATA     (s_axi_control_RDATA),
    .s_axi_control_RRESP     (s_axi_control_RRESP),
    .s_axi_control_BVALID    (s_axi_control_BVALID),
    .s_axi_control_BREADY    (s_axi_control_BREADY),
    .s_axi_control_BRESP     (s_axi_control_BRESP)
  );

  mem_axi #
  (
    .MEM_LEN_BITS            (MEM_LEN_BITS),
    .MEM_ADDR_BITS           (MEM_ADDR_BITS),
    .MEM_DATA_BITS           (MEM_DATA_BITS),
    .MEM_AXI_DATA_BITS       (MEM_AXI_DATA_BITS),
    .MEM_AXI_ADDR_BITS       (MEM_AXI_ADDR_BITS),
    .MEM_AXI_ID_BITS         (MEM_AXI_ID_BITS),
    .MEM_AXI_USER_BITS       (MEM_AXI_USER_BITS)
  )
  mem
  (
    .clock                   (clock),
    .reset                   (reset),

    .mem_req_valid           (mem_req_valid),
    .mem_req_opcode          (mem_req_opcode),
    .mem_req_len             (mem_req_len),
    .mem_req_addr            (mem_req_addr),
    .mem_wr_valid            (mem_wr_valid),
    .mem_wr_bits             (mem_wr_bits),
    .mem_rd_valid            (mem_rd_valid),
    .mem_rd_bits             (mem_rd_bits),
    .mem_rd_ready            (mem_rd_ready),

    .m_axi_data_AWVALID      (m_axi_data_AWVALID),
    .m_axi_data_AWREADY      (m_axi_data_AWREADY),
    .m_axi_data_AWADDR       (m_axi_data_AWADDR),
    .m_axi_data_AWID         (m_axi_data_AWID),
    .m_axi_data_AWLEN        (m_axi_data_AWLEN),
    .m_axi_data_AWSIZE       (m_axi_data_AWSIZE),
    .m_axi_data_AWBURST      (m_axi_data_AWBURST),
    .m_axi_data_AWLOCK       (m_axi_data_AWLOCK),
    .m_axi_data_AWCACHE      (m_axi_data_AWCACHE),
    .m_axi_data_AWPROT       (m_axi_data_AWPROT),
    .m_axi_data_AWQOS        (m_axi_data_AWQOS),
    .m_axi_data_AWREGION     (m_axi_data_AWREGION),
    .m_axi_data_AWUSER       (m_axi_data_AWUSER),
    .m_axi_data_WVALID       (m_axi_data_WVALID),
    .m_axi_data_WREADY       (m_axi_data_WREADY),
    .m_axi_data_WDATA        (m_axi_data_WDATA),
    .m_axi_data_WSTRB        (m_axi_data_WSTRB),
    .m_axi_data_WLAST        (m_axi_data_WLAST),
    .m_axi_data_WID          (m_axi_data_WID),
    .m_axi_data_WUSER        (m_axi_data_WUSER),
    .m_axi_data_ARVALID      (m_axi_data_ARVALID),
    .m_axi_data_ARREADY      (m_axi_data_ARREADY),
    .m_axi_data_ARADDR       (m_axi_data_ARADDR),
    .m_axi_data_ARID         (m_axi_data_ARID),
    .m_axi_data_ARLEN        (m_axi_data_ARLEN),
    .m_axi_data_ARSIZE       (m_axi_data_ARSIZE),
    .m_axi_data_ARBURST      (m_axi_data_ARBURST),
    .m_axi_data_ARLOCK       (m_axi_data_ARLOCK),
    .m_axi_data_ARCACHE      (m_axi_data_ARCACHE),
    .m_axi_data_ARPROT       (m_axi_data_ARPROT),
    .m_axi_data_ARQOS        (m_axi_data_ARQOS),
    .m_axi_data_ARREGION     (m_axi_data_ARREGION),
    .m_axi_data_ARUSER       (m_axi_data_ARUSER),
    .m_axi_data_RVALID       (m_axi_data_RVALID),
    .m_axi_data_RREADY       (m_axi_data_RREADY),
    .m_axi_data_RDATA        (m_axi_data_RDATA),
    .m_axi_data_RLAST        (m_axi_data_RLAST),
    .m_axi_data_RID          (m_axi_data_RID),
    .m_axi_data_RUSER        (m_axi_data_RUSER),
    .m_axi_data_RRESP        (m_axi_data_RRESP),
    .m_axi_data_BVALID       (m_axi_data_BVALID),
    .m_axi_data_BREADY       (m_axi_data_BREADY),
    .m_axi_data_BRESP        (m_axi_data_BRESP),
    .m_axi_data_BID          (m_axi_data_BID),
    .m_axi_data_BUSER        (m_axi_data_BUSER)
  );

  adder #
  (
    .C_S_AXI_DATA_WIDTH(64)
  )
  a
  (
    .ap_clk                  (clock),
    .ap_rst_n                (~reset),
    .s_axi_control_AWVALID   (s_axi_control_AWVALID),
    .s_axi_control_AWREADY   (s_axi_control_AWREADY),
    .s_axi_control_AWADDR    (s_axi_control_AWADDR),
    .s_axi_control_WVALID    (s_axi_control_WVALID),
    .s_axi_control_WREADY    (s_axi_control_WREADY),
    .s_axi_control_WDATA     (s_axi_control_WDATA),
    .s_axi_control_WSTRB     (s_axi_control_WSTRB),
    .s_axi_control_ARVALID   (s_axi_control_ARVALID),
    .s_axi_control_ARREADY   (s_axi_control_ARREADY),
    .s_axi_control_ARADDR    (s_axi_control_ARADDR),
    .s_axi_control_RVALID    (s_axi_control_RVALID),
    .s_axi_control_RREADY    (s_axi_control_RREADY),
    .s_axi_control_RDATA     (s_axi_control_RDATA),
    .s_axi_control_RRESP     (s_axi_control_RRESP),
    .s_axi_control_BVALID    (s_axi_control_BVALID),
    .s_axi_control_BREADY    (s_axi_control_BREADY),
    .s_axi_control_BRESP     (s_axi_control_BRESP),

    .m_axi_data_AWVALID      (m_axi_data_AWVALID),
    .m_axi_data_AWREADY      (m_axi_data_AWREADY),
    .m_axi_data_AWADDR       (m_axi_data_AWADDR),
    .m_axi_data_AWID         (m_axi_data_AWID),
    .m_axi_data_AWLEN        (m_axi_data_AWLEN),
    .m_axi_data_AWSIZE       (m_axi_data_AWSIZE),
    .m_axi_data_AWBURST      (m_axi_data_AWBURST),
    .m_axi_data_AWLOCK       (m_axi_data_AWLOCK),
    .m_axi_data_AWCACHE      (m_axi_data_AWCACHE),
    .m_axi_data_AWPROT       (m_axi_data_AWPROT),
    .m_axi_data_AWQOS        (m_axi_data_AWQOS),
    .m_axi_data_AWREGION     (m_axi_data_AWREGION),
    .m_axi_data_AWUSER       (m_axi_data_AWUSER),
    .m_axi_data_WVALID       (m_axi_data_WVALID),
    .m_axi_data_WREADY       (m_axi_data_WREADY),
    .m_axi_data_WDATA        (m_axi_data_WDATA),
    .m_axi_data_WSTRB        (m_axi_data_WSTRB),
    .m_axi_data_WLAST        (m_axi_data_WLAST),
    .m_axi_data_WID          (m_axi_data_WID),
    .m_axi_data_WUSER        (m_axi_data_WUSER),
    .m_axi_data_ARVALID      (m_axi_data_ARVALID),
    .m_axi_data_ARREADY      (m_axi_data_ARREADY),
    .m_axi_data_ARADDR       (m_axi_data_ARADDR),
    .m_axi_data_ARID         (m_axi_data_ARID),
    .m_axi_data_ARLEN        (m_axi_data_ARLEN),
    .m_axi_data_ARSIZE       (m_axi_data_ARSIZE),
    .m_axi_data_ARBURST      (m_axi_data_ARBURST),
    .m_axi_data_ARLOCK       (m_axi_data_ARLOCK),
    .m_axi_data_ARCACHE      (m_axi_data_ARCACHE),
    .m_axi_data_ARPROT       (m_axi_data_ARPROT),
    .m_axi_data_ARQOS        (m_axi_data_ARQOS),
    .m_axi_data_ARREGION     (m_axi_data_ARREGION),
    .m_axi_data_ARUSER       (m_axi_data_ARUSER),
    .m_axi_data_RVALID       (m_axi_data_RVALID),
    .m_axi_data_RREADY       (m_axi_data_RREADY),
    .m_axi_data_RDATA        (m_axi_data_RDATA),
    .m_axi_data_RLAST        (m_axi_data_RLAST),
    .m_axi_data_RID          (m_axi_data_RID),
    .m_axi_data_RUSER        (m_axi_data_RUSER),
    .m_axi_data_RRESP        (m_axi_data_RRESP),
    .m_axi_data_BVALID       (m_axi_data_BVALID),
    .m_axi_data_BREADY       (m_axi_data_BREADY),
    .m_axi_data_BRESP        (m_axi_data_BRESP),
    .m_axi_data_BID          (m_axi_data_BID),
    .m_axi_data_BUSER        (m_axi_data_BUSER)
  );

endmodule
