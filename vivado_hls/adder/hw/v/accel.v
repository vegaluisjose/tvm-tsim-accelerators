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
( parameter HOST_ADDR_BITS = 8,
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
  localparam HOST_AXI_STRB_BITS = (HOST_AXI_DATA_BITS / 8);

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

  host_axi #
  (
    .HOST_ADDR_BITS(HOST_ADDR_BITS),
    .HOST_DATA_BITS(HOST_DATA_BITS),
    .HOST_AXI_ADDR_BITS(HOST_AXI_ADDR_BITS),
    .HOST_AXI_DATA_BITS(HOST_AXI_DATA_BITS)
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
    .s_axi_control_BRESP     (s_axi_control_BRESP)
  );

endmodule
