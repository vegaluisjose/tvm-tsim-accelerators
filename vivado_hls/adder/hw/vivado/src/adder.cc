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

 #include <stdint.h>

void adder(uint32_t length, uint8_t *a, uint8_t *b, uint8_t* y) {
#pragma HLS INTERFACE m_axi port = a offset = slave bundle = data
#pragma HLS INTERFACE m_axi port = b offset = slave bundle = data
#pragma HLS INTERFACE m_axi port = y offset = slave bundle = data
#pragma HLS INTERFACE s_axilite port = length bundle = control
#pragma HLS INTERFACE s_axilite port = a bundle = control
#pragma HLS INTERFACE s_axilite port = b bundle = control
#pragma HLS INTERFACE s_axilite port = y bundle = control
#pragma HLS INTERFACE s_axilite port = return bundle = control
    for (int i = 0; i < length; i++) {
        y[i] = a[i] + b[i];
    }
}