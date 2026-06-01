`include "uvm_macros.svh"
`include "apb_pkg.sv"

import uvm_pkg::*;
import apb_pkg::*;

`include "apb_interface.sv"
`include "apb_base_test.sv"

module tb_top;

  parameter simulation_cycle = 100;		// 100ns: clk=10MHz
	
	bit clk;
	//logic rst_n;

	apb_intf apb_if (clk);
	
	slave_ip u_dut(
			.pclk			(clk),
    	.presetn  (apb_if.presetn),
			.paddr		(apb_if.paddr),
			.psel			(apb_if.psel),
			.penable	(apb_if.penable),
			.pwrite		(apb_if.pwrite),
			.pwdata		(apb_if.pwdata),
			.prdata		(apb_if.prdata)
	);

	// CLOCK generation
	initial begin
		clk = 0;
		forever
			#(simulation_cycle/2) clk = ~clk;	// 10MHz
	end
	
	// RESET trigger
	//initial begin
	//	rst_n = 1'b0;
	//	#1000;
	//	rst_n = 1'b1;
	//end
	
	// Configuration
	initial begin
		// Format of time display
		$timeformat(-9, 2, "ns", 10);
	 
		uvm_config_db#(virtual apb_intf.master)::set(null, "uvm_test_top", "drv_vif", apb_if.master);
		uvm_config_db#(virtual apb_intf.i_mon)::set(null, "uvm_test_top", "imon_vif", apb_if.i_mon);
		uvm_config_db#(virtual apb_intf.o_mon)::set(null, "uvm_test_top", "omon_vif", apb_if.o_mon);
	end
	
	initial begin
		run_test("apb_base_test");
	end
	
	
	// Dump fsdb
	`ifdef DUMP_FSDB
	initial begin : FSDB_generation
		string testname;
		
		$display("DUMP FSDB START!");
		if ($value$plusargs("UVM_TESTNAME=%s", testname) && testname != "") begin
			$fsdbDumpfile({testname, "_sim_dir/", testname, ".fsdb"});
		end else begin
			$fsdbDumpfile("tb.fsdb");
		end
		
		$fsdbDumpvars(0, tb_top);
		$fsdbDumpvars(0, tb_top.dut);
	end
	`endif
	
endmodule 