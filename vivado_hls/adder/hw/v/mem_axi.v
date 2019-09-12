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

module mem_axi #
(
  parameter MEM_LEN_BITS = 8,
  parameter MEM_ADDR_BITS = 32,
  parameter MEM_DATA_BITS = 64,
  parameter MEM_AXI_DATA_BITS = 64,
  parameter MEM_AXI_ADDR_BITS = 32,
  parameter MEM_AXI_ID_BITS = 1,
  parameter MEM_AXI_USER_BITS = 1,
  parameter MEM_AXI_STRB_BITS = MEM_AXI_DATA_BITS / 8
)
(
  input                          clock,
  input                          reset,

  output                         mem_req_valid,
  output                         mem_req_opcode,
  output      [MEM_LEN_BITS-1:0] mem_req_len,
  output     [MEM_ADDR_BITS-1:0] mem_req_addr,
  output                         mem_wr_valid,
  output     [MEM_DATA_BITS-1:0] mem_wr_bits,
  input                          mem_rd_valid,
  input      [MEM_DATA_BITS-1:0] mem_rd_bits,
  output                         mem_rd_ready,

  input                          m_axi_data_AWVALID,
  output                         m_axi_data_AWREADY,
  input  [MEM_AXI_ADDR_BITS-1:0] m_axi_data_AWADDR,
  input    [MEM_AXI_ID_BITS-1:0] m_axi_data_AWID,
  input                    [7:0] m_axi_data_AWLEN,
  input                    [2:0] m_axi_data_AWSIZE,
  input                    [1:0] m_axi_data_AWBURST,
  input                    [1:0] m_axi_data_AWLOCK,
  input                    [3:0] m_axi_data_AWCACHE,
  input                    [2:0] m_axi_data_AWPROT,
  input                    [3:0] m_axi_data_AWQOS,
  input                    [3:0] m_axi_data_AWREGION,
  input  [MEM_AXI_USER_BITS-1:0] m_axi_data_AWUSER,
  input                          m_axi_data_WVALID,
  output                         m_axi_data_WREADY,
  input  [MEM_AXI_DATA_BITS-1:0] m_axi_data_WDATA,
  input  [MEM_AXI_STRB_BITS-1:0] m_axi_data_WSTRB,
  input                          m_axi_data_WLAST,
  input    [MEM_AXI_ID_BITS-1:0] m_axi_data_WID,
  input  [MEM_AXI_USER_BITS-1:0] m_axi_data_WUSER,
  input                          m_axi_data_ARVALID,
  output                         m_axi_data_ARREADY,
  input  [MEM_AXI_ADDR_BITS-1:0] m_axi_data_ARADDR,
  input    [MEM_AXI_ID_BITS-1:0] m_axi_data_ARID,
  input                    [7:0] m_axi_data_ARLEN,
  input                    [2:0] m_axi_data_ARSIZE,
  input                    [1:0] m_axi_data_ARBURST,
  input                    [1:0] m_axi_data_ARLOCK,
  input                    [3:0] m_axi_data_ARCACHE,
  input                    [2:0] m_axi_data_ARPROT,
  input                    [3:0] m_axi_data_ARQOS,
  input                    [3:0] m_axi_data_ARREGION,
  input  [MEM_AXI_USER_BITS-1:0] m_axi_data_ARUSER,
  output                         m_axi_data_RVALID,
  input                          m_axi_data_RREADY,
  output [MEM_AXI_DATA_BITS-1:0] m_axi_data_RDATA,
  output                         m_axi_data_RLAST,
  output   [MEM_AXI_ID_BITS-1:0] m_axi_data_RID,
  output [MEM_AXI_USER_BITS-1:0] m_axi_data_RUSER,
  output                   [1:0] m_axi_data_RRESP,
  output                         m_axi_data_BVALID,
  input                          m_axi_data_BREADY,
  output                   [1:0] m_axi_data_BRESP,
  output   [MEM_AXI_ID_BITS-1:0] m_axi_data_BID,
  output [MEM_AXI_USER_BITS-1:0] m_axi_data_BUSER
);

  // this is a timeout counter needed because the hls generated
  // code has a buggy implementation of the protocol. For example,
  // after reset the adder generates a write request but never
  // generates valid data over the bus.
  localparam TIMEOUT = 1024;
  logic [32-1:0] timeout_cnt;

  logic [MEM_LEN_BITS-1:0] len;

  typedef enum logic [2:0] {IDLE,
                            READ_DATA,
                            WRITE_DATA,
                            WRITE_ACK} state_t;

  state_t state_n, state_r;

  always_ff @(posedge clock)
    if (reset)
      state_r <= IDLE;
    else
      state_r <= state_n;

  always_comb begin
    state_n = IDLE;
    case (state_r)

      IDLE: begin
        // $display("IDLE");
        if (m_axi_data_ARVALID)
          state_n = READ_DATA;
        else if (m_axi_data_AWVALID)
          state_n = WRITE_DATA;
        else
          state_n = IDLE;
      end

      READ_DATA: begin
        // $display("READ_DATA");
        if (m_axi_data_RREADY & mem_rd_valid & len == 'd0)
          state_n = IDLE;
        else
          state_n = READ_DATA;
      end

      WRITE_DATA: begin
        // $display("WRITE_DATA");
        if (m_axi_data_WVALID & m_axi_data_WLAST)
          state_n = WRITE_ACK;
        else if (timeout_cnt == TIMEOUT)
          state_n = IDLE;
        else
          state_n = WRITE_DATA;
      end

      WRITE_ACK: begin
        // $display("WRITE_ACK");
        if (m_axi_data_BREADY)
          state_n = IDLE;
        else
          state_n = WRITE_ACK;
      end

      default: begin
      end
    endcase
  end

  always_ff @(posedge clock)
    if (state_r == IDLE)
      timeout_cnt <= 'd0;
    else if (state_r == WRITE_DATA & ~m_axi_data_WVALID)
      timeout_cnt <= timeout_cnt + 1'b1;

  always_ff @(posedge clock)
    if (reset)
      len <= 'd0;
    else if ((state_r == READ_DATA)
            & m_axi_data_RREADY
            & mem_rd_valid
            & len != 'd0)
      len <= len - 'd1;

  assign mem_req_valid = ((state_r == IDLE) & m_axi_data_ARVALID)
                       | ((state_r == IDLE) & m_axi_data_AWVALID);

  assign mem_req_opcode = ~m_axi_data_ARVALID;
  assign mem_req_len = m_axi_data_ARVALID? m_axi_data_ARLEN : m_axi_data_AWLEN;
  assign mem_req_addr = m_axi_data_ARVALID? m_axi_data_ARADDR : m_axi_data_AWADDR;

  assign m_axi_data_ARREADY = state_r == IDLE;
  assign m_axi_data_AWREADY = state_r == IDLE;

  assign m_axi_data_RVALID = (state_r == READ_DATA) & mem_rd_valid;
  assign m_axi_data_RDATA = mem_rd_bits;
  assign m_axi_data_RLAST = len == 'd0;
  assign m_axi_data_RRESP = 'd0;
  assign m_axi_data_RUSER = 'd0;
  assign m_axi_data_RID = 'd0;

  assign mem_rd_ready = (state_r == READ_DATA) & m_axi_data_RREADY;
  assign mem_wr_valid = (state_r == WRITE_DATA) & m_axi_data_WVALID;
  assign mem_wr_bits = m_axi_data_WDATA;
  assign m_axi_data_WREADY = state_r == WRITE_DATA;

  assign m_axi_data_BVALID = state_r == WRITE_ACK;
  assign m_axi_data_BRESP = 'd0;
  assign m_axi_data_BUSER = 'd0;
  assign m_axi_data_BID = 'd0;

  if (1) begin
    always_ff @(posedge clock) begin
      if (m_axi_data_AWVALID)
        $display("[mem] waddr:%x len:%d", m_axi_data_AWADDR, m_axi_data_AWLEN);
      if (m_axi_data_ARVALID & m_axi_data_ARREADY)
        $display("[mem] raddr:%x len:%d", m_axi_data_ARADDR, m_axi_data_ARLEN);
      if (m_axi_data_RVALID & m_axi_data_RREADY)
        $display("[mem] rdata:%x", m_axi_data_RDATA);
    end
  end

endmodule