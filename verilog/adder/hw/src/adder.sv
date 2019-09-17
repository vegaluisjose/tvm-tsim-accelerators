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

 module adder #
(
  parameter ADDER_BITS = 8
)
(
  input                         clock,
  input                         reset,
  input                         a_valid,
  input        [ADDER_BITS-1:0] a_data,
  input                         b_valid,
  input        [ADDER_BITS-1:0] b_data,
  output       [ADDER_BITS-1:0] c_data
);

  logic [ADDER_BITS-1:0] a_reg;
  logic [ADDER_BITS-1:0] b_reg;

  always_ff @(posedge clock)
    if (reset)
      a_reg <= 'd0;
    else if (a_valid)
      a_reg <= a_data;

  always_ff @(posedge clock)
    if (reset)
      b_reg <= 'd0;
    else if (b_valid)
      b_reg <= b_data;

  assign c_data = a_reg + b_reg;

endmodule
