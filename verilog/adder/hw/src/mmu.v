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

/** MMU
  *
  * Procedure:
  *
  * 1. Wait for launch to be asserted
  * 2. Issue a read request for a operand
  * 3. Wait for the value
  * 4. Issue a read request for b operand
  * 5. Wait for the value
  * 4. Issue a write request for c
  * 5. Increment read-address and write-address for next values
  * 6. Check if counter (cnt) is equal to length to assert finish,
  *    otherwise go to step 2.
  */
module mmu #
(
  parameter MEM_LEN_BITS = 8,
  parameter MEM_ADDR_BITS = 64,
  parameter MEM_DATA_BITS = 64,
  parameter HOST_DATA_BITS = 32,
  parameter ADDER_BITS = 8
)
(
  input                         clock,
  input                         reset,

  output                        mem_req_valid,
  output                        mem_req_opcode,
  output     [MEM_LEN_BITS-1:0] mem_req_len,
  output    [MEM_ADDR_BITS-1:0] mem_req_addr,
  output                        mem_wr_valid,
  output    [MEM_DATA_BITS-1:0] mem_wr_bits,
  input                         mem_rd_valid,
  input     [MEM_DATA_BITS-1:0] mem_rd_bits,
  output                        mem_rd_ready,

  input                         launch,
  output                        finish,

  output                        event_counter_valid,
  output   [HOST_DATA_BITS-1:0] event_counter_value,

  input    [HOST_DATA_BITS-1:0] length,
  input    [HOST_DATA_BITS-1:0] a_addr,
  input    [HOST_DATA_BITS-1:0] b_addr,
  input    [HOST_DATA_BITS-1:0] c_addr,

  output                        a_valid,
  output       [ADDER_BITS-1:0] a_data,
  output                        b_valid,
  output       [ADDER_BITS-1:0] b_data,
  input        [ADDER_BITS-1:0] c_data
);

  typedef enum logic [2:0] {IDLE,
                            READ_REQ,
                            READ_DATA,
                            WRITE_REQ,
                            WRITE_DATA} state_t;

  state_t nstate, cstate;

  logic               [31:0] cnt;
  logic                      rd_done;
  logic [HOST_DATA_BITS-1:0] raddr_a;
  logic [HOST_DATA_BITS-1:0] raddr_b;
  logic [HOST_DATA_BITS-1:0] waddr_c;

  always_ff @(posedge clock)
    if (reset)
      cstate <= IDLE;
    else
      cstate <= nstate;

  always_comb begin
    nstate = cstate;
    case (cstate)
      IDLE: begin
        if (launch)
          nstate = READ_REQ;
      end

      READ_REQ: begin
        nstate = READ_DATA;
      end

      READ_DATA: begin
        if (mem_rd_valid)
          if (rd_done)
            nstate = WRITE_REQ;
          else
            nstate = READ_REQ;
      end

      WRITE_REQ: begin
        nstate = WRITE_DATA;
      end

      WRITE_DATA: begin
        if (cnt == (length - 1'b1))
          nstate = IDLE;
        else
          nstate = READ_REQ;
      end

      default: begin
      end
    endcase
  end

  always_ff @(posedge clock)
    if (reset | cstate == IDLE | cstate == WRITE_DATA)
      rd_done <= 1'b0;
    else if (cstate == READ_DATA & mem_rd_valid)
      rd_done <= 1'b1;

  logic last;
  assign last = (cstate == WRITE_DATA) & (cnt == (length - 1'b1));

  // cycle counter
  logic [HOST_DATA_BITS-1:0] cycle_counter;
  always_ff @(posedge clock)
    if (reset | cstate == IDLE)
      cycle_counter <= '0;
    else
      cycle_counter <= cycle_counter + 'd1;

  assign event_counter_valid = last;
  assign event_counter_value = cycle_counter;

  // calculate next address
  always_ff @(posedge clock)
    if (reset | cstate == IDLE) begin
      raddr_a <= a_addr;
      raddr_b <= b_addr;
      waddr_c <= c_addr;
    end else if (cstate == WRITE_DATA) begin
      raddr_a <= raddr_a + 'd1;
      raddr_b <= raddr_b + 'd1;
      waddr_c <= waddr_c + 'd1;
    end

  // create request
  assign mem_req_valid = (cstate == READ_REQ) | (cstate == WRITE_REQ);
  assign mem_req_opcode = cstate == WRITE_REQ;
  assign mem_req_len = 'd0; // one-word-per-request
  assign mem_req_addr = (cstate == READ_REQ & ~rd_done)? {32'd0, raddr_a}
                      : (cstate == READ_REQ & rd_done)? {32'd0, raddr_b}
                      : {32'd0, waddr_c};

  // read
  assign a_valid = (cstate == READ_DATA) & mem_rd_valid & ~rd_done;
  assign a_data = mem_rd_bits[ADDER_BITS-1:0];
  assign b_valid = (cstate == READ_DATA) & mem_rd_valid & rd_done;
  assign b_data = mem_rd_bits[ADDER_BITS-1:0];
  assign mem_rd_ready = cstate == READ_DATA;

  // write
  assign mem_wr_valid = cstate == WRITE_DATA;
  assign mem_wr_bits = {{(MEM_DATA_BITS-ADDER_BITS){1'b0}}, c_data};

  // count read/write
  always_ff @(posedge clock)
    if (reset | cstate == IDLE)
      cnt <= 'd0;
    else if (cstate == WRITE_DATA)
      cnt <= cnt + 1'b1;

  // done when read/write are equal to length
  assign finish = last;

endmodule
