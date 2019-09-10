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
module MMU #
(
  parameter MEM_LEN_BITS = 8,
  parameter MEM_ADDR_BITS = 64,
  parameter MEM_DATA_BITS = 64,
  parameter HOST_DATA_BITS = 32
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
  output    [MEM_DATA_BITS-1:0] a_data,
  output                        b_valid,
  output    [MEM_DATA_BITS-1:0] b_data,
  input     [MEM_DATA_BITS-1:0] c_data
);

  typedef enum logic [2:0] {IDLE,
                            READ_REQ,
                            READ_DATA,
                            WRITE_REQ,
                            WRITE_DATA} state_t;

  state_t state_n, state_r;

  logic               [31:0] cnt;
  logic                      rd_done;
  logic [HOST_DATA_BITS-1:0] raddr_a;
  logic [HOST_DATA_BITS-1:0] raddr_b;
  logic [HOST_DATA_BITS-1:0] waddr_c;

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
        if (launch) begin
          state_n = READ_REQ;
        end
      end

      READ_REQ: begin
        state_n = READ_DATA;
      end

      READ_DATA: begin
        if (mem_rd_valid) begin
          if (rd_done) begin
            state_n = WRITE_REQ;
          end else begin
            state_n = READ_REQ;
          end
        end else begin
          state_n = READ_DATA;
        end
      end

      WRITE_REQ: begin
        state_n = WRITE_DATA;
      end

      WRITE_DATA: begin
        if (cnt == (length - 1'b1)) begin
          state_n = IDLE;
        end else begin
          state_n = READ_REQ;
        end
      end

      default: begin
      end
    endcase
  end

  always_ff @(posedge clock) begin
    if (reset | state_r == IDLE | state_r == WRITE_DATA) begin
      rd_done <= 1'b0;
    end else if (state_r == READ_DATA & mem_rd_valid) begin
      rd_done <= 1'b1;
    end
  end

  logic last;
  assign last = (state_r == WRITE_DATA) & (cnt == (length - 1'b1));

  // cycle counter
  logic [HOST_DATA_BITS-1:0] cycle_counter;
  always_ff @(posedge clock) begin
    if (reset | state_r == IDLE) begin
      cycle_counter <= '0;
    end else begin
      cycle_counter <= cycle_counter + 'd1;
    end
  end

  assign event_counter_valid = last;
  assign event_counter_value = cycle_counter;

  // calculate next address
  always_ff @(posedge clock) begin
    if (reset | state_r == IDLE) begin
      raddr_a <= a_addr;
      raddr_b <= b_addr;
      waddr_c <= c_addr;
    end else if (state_r == WRITE_DATA) begin
      raddr_a <= raddr_a + 'd1;
      raddr_b <= raddr_b + 'd1;
      waddr_c <= waddr_c + 'd1;
    end
  end

  // create request
  assign mem_req_valid = (state_r == READ_REQ) | (state_r == WRITE_REQ);
  assign mem_req_opcode = state_r == WRITE_REQ;
  assign mem_req_len = 'd0; // one-word-per-request
  assign mem_req_addr = (state_r == READ_REQ & ~rd_done)? {32'd0, raddr_a}
                      : (state_r == READ_REQ & rd_done)? {32'd0, raddr_b}
                      : {32'd0, waddr_c};

  // read
  assign a_valid = (state_r == READ_DATA) & mem_rd_valid & ~rd_done;
  assign a_data = mem_rd_bits;
  assign b_valid = (state_r == READ_DATA) & mem_rd_valid & rd_done;
  assign b_data = mem_rd_bits;
  assign mem_rd_ready = state_r == READ_DATA;

  // write
  assign mem_wr_valid = state_r == WRITE_DATA;
  assign mem_wr_bits = c_data;

  // count read/write
  always_ff @(posedge clock) begin
    if (reset | state_r == IDLE) begin
      cnt <= 'd0;
    end else if (state_r == WRITE_DATA) begin
      cnt <= cnt + 1'b1;
    end
  end

  // done when read/write are equal to length
  assign finish = last;
endmodule
