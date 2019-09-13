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

package accel

import chisel3._
import chisel3.util._

class Adder(implicit config: AccelConfig) extends Module {
  val io = IO(new Bundle {
    val a = Flipped(ValidIO(UInt(config.adderBits.W)))
    val b = Flipped(ValidIO(UInt(config.adderBits.W)))
    val c = Output(UInt(config.adderBits.W))
  })
  val a_reg = RegInit(0.U(config.adderBits.W))
  val b_reg = RegInit(0.U(config.adderBits.W))
  when (io.a.valid) { a_reg := io.a.bits }
  when (io.b.valid) { b_reg := io.b.bits }
  io.c := a_reg + b_reg
}
