TSIM Installation
=================

*TSIM* is a cycle-accurate hardware simulation environment that can be invoked and managed directly from TVM. It aims to enable cycle accurate simulation of deep learning accelerators including VTA.
This simulation environment can be used in both OSX and Linux.
There are two dependencies required to make *TSIM* works: [Verilator](https://www.veripool.org/wiki/verilator) and [sbt](https://www.scala-sbt.org/) for accelerators designed in [Chisel3](https://github.com/freechipsproject/chisel3).

## OSX Dependencies

Install `sbt` and `verilator` using [Homebrew](https://brew.sh/).

```bash
brew install verilator sbt
```

## Linux Dependencies

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

Verilator version check

```bash
verilator --version
```

the supported version of Verilator should be at least 4.012, 
if homebrew (OSX) or package-manager (Linux) does not support that version,
please install Verilator 4.012 or later from binary or source base on following
instruction of Verilator wiki.  

https://www.veripool.org/projects/verilator/wiki/Installing

## Setup in TVM

1. Install `verilator` and `sbt` as described above
2. Get tvm submodule `git submodule update --init --recursive`
3. Build [tvm](https://docs.tvm.ai/install/from_source.html#build-the-shared-library)
