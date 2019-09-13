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
import vta.dpi._

/** Adder accelerator.
  *
  * ___________      ___________
  * |         |      |         |
  * | HostDPI | <--> |   CSR   | <----->|
  * |_________|      |_________|        |
  *                                 |----------
  *                                 |  Adder  |
  * ___________      ___________    |----------
  * |         |      |         |        |
  * | MemDPI  | <--> |  MUnit  | <----->|
  * |_________|      |_________|
  *
  */
/** CSR.
  *
  *
  * -------------------------------
  *  Register description    | addr
  * -------------------------|-----
  *  Control status register | 0x00
  *  Cycle counter           | 0x04
  *  Vector length           | 0x08
  *  a pointer               | 0x0c
  *  b pointer               | 0x10
  *  c pointer               | 0x14
  * -------------------------------
  */
case class AccelConfig() {
  val nCtrl = 1
  val nECnt = 1
  val nVals = 1
  val nPtrs = 3
  val adderBits = 8
  val regBits = 32
  val ptrBits = regBits
  assert(regBits == 32, s"support only for 32-bit registers")
  assert(ptrBits == 32 || ptrBits == 64,
         s"support only for 32-bit or 64-bit pointers")
}

class Accel extends Module {
  val io = IO(new Bundle {
    val host = new VTAHostDPIClient
    val mem = new VTAMemDPIMaster
  })
  implicit val config = AccelConfig()
  val csr = Module(new CSR)
  val mu = Module(new MemoryUnit)
  val adder = Module(new Adder)
  csr.io.host <> io.host
  io.mem <> mu.io.mem
  mu.io.launch := csr.io.launch
  csr.io.finish := mu.io.finish
  csr.io.ecnt <> mu.io.ecnt
  mu.io.vals <> csr.io.vals
  mu.io.ptrs <> csr.io.ptrs
  adder.io.a <> mu.io.a
  adder.io.b <> mu.io.b
  mu.io.c <> adder.io.c
}
