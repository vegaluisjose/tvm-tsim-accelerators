# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

ifeq (, $(shell which verilator))
 $(error "No Verilator in $(PATH), consider doing apt-get install verilator")
endif

# Change VERILATOR_INC_DIR if Verilator is installed on a different location
ifeq (, $(VERILATOR_INC_DIR))
  ifeq (, $(wildcard /usr/local/share/verilator/include/*))
    ifeq (, $(wildcard /usr/share/verilator/include/*))
      $(error "Verilator include directory is not set properly")
    else
      VERILATOR_INC_DIR := /usr/share/verilator/include
    endif
  else
      VERILATOR_INC_DIR := /usr/local/share/verilator/include
  endif
endif

ifeq (, $(TVM_HOME))
  $(error "TVM_HOME not set")
endif

TOP = test_accel
BUILD_NAME = build
USE_TRACE = 0
LIBNAME = libhw

vta_dir = $(TVM_HOME)/vta
build_dir = $(abspath .)/$(BUILD_NAME)

verilator_opt = --cc
verilator_opt += +define+RANDOMIZE_GARBAGE_ASSIGN
verilator_opt += +define+RANDOMIZE_REG_INIT
verilator_opt += +define+RANDOMIZE_MEM_INIT
verilator_opt += --x-assign unique
verilator_opt += --output-split 20000
verilator_opt += --output-split-cfuncs 20000
verilator_opt += --top-module ${TOP}
verilator_opt += -Mdir ${build_dir}
verilator_opt += -Wno-STMTDLY -Wno-PINMISSING
verilator_opt += -Wno-WIDTH -Wno-LITENDIAN
verilator_opt += -Wno-CASEINCOMPLETE

cxx_flags = -O2 -Wall -fPIC -shared
cxx_flags += -fvisibility=hidden -std=c++11
cxx_flags += -DVL_TSIM_NAME=V$(TOP)
cxx_flags += -DVL_PRINTF=printf
cxx_flags += -DVL_USER_FINISH
cxx_flags += -DVM_COVERAGE=0
cxx_flags += -DVM_SC=0
cxx_flags += -Wno-sign-compare
cxx_flags += -include V$(TOP).h
cxx_flags += -I$(build_dir)
cxx_flags += -I$(VERILATOR_INC_DIR)
cxx_flags += -I$(VERILATOR_INC_DIR)/vltstd
cxx_flags += -I$(vta_dir)/include
cxx_flags += -I$(TVM_HOME)/include
cxx_flags += -I$(TVM_HOME)/3rdparty/dlpack/include

cxx_files = $(VERILATOR_INC_DIR)/verilated.cpp
cxx_files += $(VERILATOR_INC_DIR)/verilated_dpi.cpp
cxx_files += $(wildcard $(build_dir)/*.cpp)
cxx_files += $(vta_dir)/hardware/dpi/tsim_device.cc

v_files = $(wildcard $(abspath .)/sv/*.sv)
v_files += $(wildcard $(vta_dir)/hardware/chisel/src/main/resources/verilog/*.v)
v_files += $(abspath .)/vivado/build/vadd/soln/impl/verilog/vadd_control_s_axi.v
v_files += $(abspath .)/vivado/build/vadd/soln/impl/verilog/vadd_gmem_m_axi.v
v_files += $(abspath .)/vivado/build/vadd/soln/impl/verilog/vadd.v
v_files += $(abspath .)/vivado/build/vadd/soln/impl/verilog/vadd_v1_buffer.v

ifneq ($(USE_TRACE), 0)
  verilator_opt += --trace
  cxx_flags += -DVM_TRACE=1
  cxx_flags += -DTSIM_TRACE_FILE=$(build_dir)/$(TOP).vcd
  cxx_files += $(VERILATOR_INC_DIR)/verilated_vcd_c.cpp
else
  cxx_flags += -DVM_TRACE=0
endif

# The following is to be consistent with cmake
ifeq ($(shell uname), Darwin)
  lib_path = $(build_dir)/$(LIBNAME).dylib
else
  lib_path = $(build_dir)/$(LIBNAME).so
endif

default: hls lib

hls: $(abspath .)/vivado/build/vadd/soln/impl/verilog/vadd.v
$(abspath .)/vivado/build/vadd/soln/impl/verilog/vadd.v:
	make -C vivado

lib: $(lib_path)
$(lib_path): $(build_dir)/V$(TOP).cpp
	g++ $(cxx_flags) $(cxx_files) -o $@

verilator: $(build_dir)/V$(TOP).cpp
$(build_dir)/V$(TOP).cpp: $(v_files) | $(build_dir)
	verilator $(verilator_opt) $(v_files)

$(build_dir):
	mkdir -p $@

clean:
	-rm -rf $(build_dir)
	make -C vivado clean
