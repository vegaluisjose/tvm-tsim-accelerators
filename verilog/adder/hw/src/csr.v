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

/** CSR.
  *
  * -------------------------------
  *  Register description    | addr
  * -------------------------|-----
  *  Control status register | 0x00
  *  Cycle counter           | 0x04
  *  Vector length           | 0x08
  *  a addr                  | 0x0c
  *  b addr                  | 0x10
  *  c addr                  | 0x14
  * -------------------------------

  * ------------------------------
  *  Control status register | bit
  * ------------------------------
  *  Launch                  | 0
  *  Finish                  | 1
  * ------------------------------
  */
module csr #
 (parameter HOST_ADDR_BITS = 8,
  parameter HOST_DATA_BITS = 32
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

  output                        launch,
  input                         finish,

  input                         event_counter_valid,
  input    [HOST_DATA_BITS-1:0] event_counter_value,

  output   [HOST_DATA_BITS-1:0] length,
  output   [HOST_DATA_BITS-1:0] a_addr,
  output   [HOST_DATA_BITS-1:0] b_addr,
  output   [HOST_DATA_BITS-1:0] c_addr
);

  localparam NUM_REG = 8;

  typedef enum logic {IDLE, READ} state_t;
  state_t nstate, cstate;

  always_ff @(posedge clock)
    if (reset)
      cstate <= IDLE;
    else
      cstate <= nstate;

  always_comb begin
    nstate = cstate;
    case (cstate)
      IDLE: begin
        if (host_req_valid & ~host_req_opcode)
          nstate = READ;
      end

      READ: begin
        nstate = IDLE;
      end
    endcase
  end

  assign host_req_deq = (cstate == IDLE) ? host_req_valid : 1'b0;

  logic [HOST_DATA_BITS-1:0] rf [NUM_REG-1:0];

  genvar i;
  for (i = 0; i < NUM_REG; i++) begin

    logic wen = (cstate == IDLE)? host_req_valid & host_req_opcode & i*4 == host_req_addr : 1'b0;

    if (i == 0) begin

      always_ff @(posedge clock)
        if (reset)
          rf[i] <= 'd0;
        else if (finish)
          rf[i] <= 'd2;
        else if (wen)
          rf[i] <= host_req_value;

    end else if (i == 1) begin

      always_ff @(posedge clock)
        if (reset)
          rf[i] <= 'd0;
        else if (event_counter_valid)
          rf[i] <= event_counter_value;
        else if (wen)
          rf[i] <= host_req_value;

    end else begin

      always_ff @(posedge clock)
        if (reset)
          rf[i] <= 'd0;
        else if (wen)
          rf[i] <= host_req_value;

    end

  end

  logic [HOST_DATA_BITS-1:0] rdata;
  always_ff @(posedge clock)
    if (reset)
      rdata <= 'd0;
    else if ((cstate == IDLE) & host_req_valid & ~host_req_opcode)
      if (host_req_addr == 'h00)
        rdata <= rf[0];
      else if (host_req_addr == 'h04)
        rdata <= rf[1];
      else if (host_req_addr == 'h08)
        rdata <= rf[2];
      else if (host_req_addr == 'h0c)
        rdata <= rf[3];
      else if (host_req_addr == 'h10)
        rdata <= rf[4];
      else if (host_req_addr == 'h14)
        rdata <= rf[5];
      else
        rdata <= 'd0;

  assign host_resp_valid = (cstate == READ);
  assign host_resp_bits = rdata;

  assign launch = rf[0][0];
  assign length = rf[2];
  assign a_addr = rf[3];
  assign b_addr = rf[4];
  assign c_addr = rf[5];

endmodule
