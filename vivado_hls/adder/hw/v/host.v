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

module host #
( parameter HOST_ADDR_BITS = 8,
  parameter HOST_DATA_BITS = 32,
  parameter HOST_AXI_ADDR_BITS = 6,
  parameter HOST_AXI_DATA_BITS = 32,
  parameter HOST_AXI_STRB_BITS = (HOST_AXI_DATA_BITS / 8)
)
(
  input                               clock,
  input                               reset,

  input                               host_req_valid,
  input                               host_req_opcode,
  input          [HOST_ADDR_BITS-1:0] host_req_addr,
  input          [HOST_DATA_BITS-1:0] host_req_value,
  output                              host_req_deq,
  output                              host_resp_valid,
  output         [HOST_DATA_BITS-1:0] host_resp_bits,

  output                              s_axi_control_AWVALID,
  input                               s_axi_control_AWREADY,
  output     [HOST_AXI_ADDR_BITS-1:0] s_axi_control_AWADDR,
  output                              s_axi_control_WVALID,
  input                               s_axi_control_WREADY,
  output     [HOST_AXI_DATA_BITS-1:0] s_axi_control_WDATA,
  output     [HOST_AXI_STRB_BITS-1:0] s_axi_control_WSTRB,
  output                              s_axi_control_ARVALID,
  input                               s_axi_control_ARREADY,
  output     [HOST_AXI_ADDR_BITS-1:0] s_axi_control_ARADDR,
  input                               s_axi_control_RVALID,
  output                              s_axi_control_RREADY,
  input      [HOST_AXI_DATA_BITS-1:0] s_axi_control_RDATA,
  input                         [1:0] s_axi_control_RRESP,
  input                               s_axi_control_BVALID,
  output                              s_axi_control_BREADY,
  input                         [1:0] s_axi_control_BRESP
);

  typedef enum logic [2:0] {IDLE,
                            READ_REQ,
                            READ_DATA,
                            WRITE_REQ,
                            WRITE_DATA,
                            WRITE_ACK} state_t;

  state_t state_n, state_r;

  always_ff @(posedge clock) begin
    if (reset) begin
      state_r <= IDLE;
    end else begin
      state_r <= state_n;
    end
  end

  always_comb begin
    state_n = IDLE;
    case (state_r)

      IDLE: begin
        if (host_req_valid) begin
          if (host_req_opcode) begin
            state_n = WRITE_REQ;
          end else begin
            state_n = READ_REQ;
          end
        end
      end

      READ_REQ: begin
        if (s_axi_control_ARREADY) begin
          state_n = READ_DATA;
        end
      end

      READ_DATA: begin
        if (s_axi_control_RVALID) begin
          state_n = IDLE;
        end
      end

      WRITE_REQ: begin
        if (s_axi_control_AWREADY) begin
          state_n = WRITE_DATA;
        end
      end

      WRITE_DATA: begin
        if (s_axi_control_WREADY) begin
          state_n = WRITE_ACK;
        end
      end

      WRITE_ACK: begin
        if (s_axi_control_BVALID) begin
          state_n = IDLE;
        end
      end

      default: begin
      end
    endcase
  end

  logic [HOST_ADDR_BITS-1:0] addr;
  logic [HOST_DATA_BITS-1:0] data;

  always_ff @(posedge clock) begin
    if (reset) begin
      addr <= 'd0;
      data <= 'd0;
    end else if (state_r == IDLE && host_req_valid) begin
      addr <= host_req_addr;
      data <= host_req_value;
    end
  end

  assign s_axi_control_AWVALID = state_r == WRITE_REQ;
  assign s_axi_control_AWADDR = addr[HOST_AXI_ADDR_BITS-1:0];
  assign s_axi_control_WVALID = state_r == WRITE_DATA;
  assign s_axi_control_WDATA = data;
  assign s_axi_control_WSTRB = 'hf;
  assign s_axi_control_BREADY = state_r == WRITE_ACK;

  assign host_req_deq = (state_r == READ_REQ & s_axi_control_ARREADY)
                      | (state_r == WRITE_REQ & s_axi_control_AWREADY);
  assign host_resp_valid = s_axi_control_RVALID;
  assign host_resp_bits = s_axi_control_RDATA;

endmodule