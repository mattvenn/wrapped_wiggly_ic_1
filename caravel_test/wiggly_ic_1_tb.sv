// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

`include "uprj_netlists.v" // this file gets created automatically by multi_project_tools from the source section of info.yaml
`include "caravel_netlists.v"
`include "spiflash.v"

module wiggly_ic_1_tb;
    initial begin
        $dumpfile ("wiggly_ic_1_tb.vcd");
        $dumpvars (0, wiggly_ic_1_tb);
        #1;
    end

	reg clk;
    reg RSTB;
	reg power1, power2;
	reg power3, power4;

    wire gpio;
    wire [37:0] mprj_io;

    ///// convenience signals that match what the cocotb test modules are looking for
    wire        kbd_clk;
    wire        kbd_data;
    wire        mouse_clk;
    wire        mouse_data;
    assign mprj_io[ 8] = kbd_clk;
    assign mprj_io[ 9] = kbd_data;
    assign mprj_io[10] = mouse_clk;
    assign mprj_io[11] = mouse_data;
    wire        vga_clk_pix;
    assign clk = vga_clk_pix;

    wire [1:0] vga_r = mprj_io[13:12];
    wire [1:0] vga_g = mprj_io[15:14];
    wire [1:0] vga_b = mprj_io[17:16];
    wire       vga_hsync = mprj_io[18];
    wire       vga_vsync = mprj_io[19];

    /////
    

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3 = power1;
	wire VDD1V8 = power2;
	wire USER_VDD3V3 = power3;
	wire USER_VDD1V8 = power4;
	wire VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (USER_VDD3V3),
		.vdda2    (USER_VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (USER_VDD1V8),
		.vccd2	  (USER_VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock	  (clk),
		.gpio     (gpio),
        	.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("wiggly_ic_1.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
