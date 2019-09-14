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

/** Accelerator.
  *
  * ___________      ___________
  * |         |      |         |
  * | HostDPI | <--> |   CSR   | <----->|
  * |_________|      |_________|        |
  *                                 |-------|
  *                                 | adder |
  * ___________      ___________    |-------|
  * |         |      |         |        |
  * | MemDPI  | <--> |   MMU   | <----->|
  * |_________|      |_________|
  *
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

  localparam ADDER_BITS = 8;

  logic                      launch;
  logic                      finish;

  logic                      event_counter_valid;
  logic [HOST_DATA_BITS-1:0] event_counter_value;

  logic [HOST_DATA_BITS-1:0] length;
  logic [HOST_DATA_BITS-1:0] a_addr;
  logic [HOST_DATA_BITS-1:0] b_addr;
  logic [HOST_DATA_BITS-1:0] c_addr;
  logic                      a_valid;
  logic     [ADDER_BITS-1:0] a_data;
  logic                      b_valid;
  logic     [ADDER_BITS-1:0] b_data;
  logic     [ADDER_BITS-1:0] c_data;

  csr #
  (
    .HOST_ADDR_BITS(HOST_ADDR_BITS),
    .HOST_DATA_BITS(HOST_DATA_BITS)
  )
  c
  (
    .clock               (clock),
    .reset               (reset),

    .host_req_valid      (host_req_valid),
    .host_req_opcode     (host_req_opcode),
    .host_req_addr       (host_req_addr),
    .host_req_value      (host_req_value),
    .host_req_deq        (host_req_deq),
    .host_resp_valid     (host_resp_valid),
    .host_resp_bits      (host_resp_bits),

    .launch              (launch),
    .finish              (finish),

    .event_counter_valid (event_counter_valid),
    .event_counter_value (event_counter_value),

    .length              (length),
    .a_addr              (a_addr),
    .b_addr              (b_addr),
    .c_addr              (c_addr)

  );

  adder #
  (
    .ADDER_BITS(ADDER_BITS)
  )
  a
  (
    .clock               (clock),
    .reset               (reset),

    .a_valid             (a_valid),
    .a_data              (a_data),
    .b_valid             (b_valid),
    .b_data              (b_data),
    .c_data              (c_data)
  );

  mmu #
  (
    .MEM_LEN_BITS(MEM_LEN_BITS),
    .MEM_ADDR_BITS(MEM_ADDR_BITS),
    .MEM_DATA_BITS(MEM_DATA_BITS),
    .HOST_DATA_BITS(HOST_DATA_BITS),
    .ADDER_BITS(ADDER_BITS)
  )
  m
  (
    .clock               (clock),
    .reset               (reset),

    .mem_req_valid       (mem_req_valid),
    .mem_req_opcode      (mem_req_opcode),
    .mem_req_len         (mem_req_len),
    .mem_req_addr        (mem_req_addr),
    .mem_wr_valid        (mem_wr_valid),
    .mem_wr_bits         (mem_wr_bits),
    .mem_rd_valid        (mem_rd_valid),
    .mem_rd_bits         (mem_rd_bits),
    .mem_rd_ready        (mem_rd_ready),

    .launch              (launch),
    .finish              (finish),

    .event_counter_valid (event_counter_valid),
    .event_counter_value (event_counter_value),

    .length              (length),
    .a_addr              (a_addr),
    .b_addr              (b_addr),
    .c_addr              (c_addr),

    .a_valid             (a_valid),
    .a_data              (a_data),
    .b_valid             (b_valid),
    .b_data              (b_data),
    .c_data              (c_data)
  );

endmodule
