<!--- Licensed to the Apache Software Foundation (ASF) under one -->
<!--- or more contributor license agreements.  See the NOTICE file -->
<!--- distributed with this work for additional information -->
<!--- regarding copyright ownership.  The ASF licenses this file -->
<!--- to you under the Apache License, Version 2.0 (the -->
<!--- "License"); you may not use this file except in compliance -->
<!--- with the License.  You may obtain a copy of the License at -->

<!---   http://www.apache.org/licenses/LICENSE-2.0 -->

<!--- Unless required by applicable law or agreed to in writing, -->
<!--- software distributed under the License is distributed on an -->
<!--- "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY -->
<!--- KIND, either express or implied.  See the License for the -->
<!--- specific language governing permissions and limitations -->
<!--- under the License. -->

TSIM
====

TSIM is a cycle-accurate hardware simulation environment that can be invoked and managed directly from TVM.
This simulation environment can be used in both OSX and Linux. 

TSIM depends on [Verilator](https://www.veripool.org/wiki/verilator) to work (version 4.00 and above).

There are three accelerators designed in three languages:

* Verilog
* Chisel3 requires [sbt](https://www.scala-sbt.org/) for accelerators designed in [Chisel3](https://github.com/freechipsproject/chisel3)
* Xilinx Vivado HLS requires [vivado](https://docs.tvm.ai/vta/install.html#vta-fpga-toolchain-installation)

## OSX

Install `sbt` and `verilator` using [Homebrew](https://brew.sh/).

```bash
brew install verilator sbt
```

## Linux

Add `sbt` to package manager (Ubuntu).

```bash
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
```

Install `sbt` and `verilator`.

```bash
sudo apt install verilator sbt
``` 

## Setup in TVM

1. Install all dependencies as described above
2. Get tvm submodule `git submodule update --init --recursive`
3. Build [tvm](https://docs.tvm.ai/install/from_source.html#build-the-shared-library)
4. Run examples, for example
    * Verilog accelerator `cd verilog/adder && make`
    * Chisel3 accelerator `cd chisel/adder && make`
    * HLS accelerator `cd vivado_hls/adder && make`
