`ifndef APB_BASE_TEST__SV
`define APB_BASE_TEST__SV

class apb_base_test extends uvm_test;
	`uvm_component_utils(apb_base_test)
	
	int unsigned pkt_count;
	
	virtual apb_intf.master	drv_vif;
	virtual apb_intf.i_mon  imon_vif;
	virtual apb_intf.o_mon  omon_vif;

	apb_env env;

	function new(string name = "apb_base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void end_of_elaboration_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	extern virtual function void final_phase(uvm_phase phase);
endclass

function void apb_base_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	pkt_count = 10;
	
	uvm_config_db#(bit)::set(this, "env.apb_cov", "cov_enable", 1'b1);

	env = apb_env::type_id::create("env", this);

	uvm_config_db #(virtual apb_intf.master)::get(this, "", "drv_vif", drv_vif);
	uvm_config_db #(virtual apb_intf.i_mon)::get(this, "", "imon_vif", imon_vif);
	uvm_config_db #(virtual apb_intf.o_mon)::get(this, "", "omon_vif", omon_vif);
							  
	uvm_config_db #(int unsigned)::set(this, "env.agt_mst.apb_sqr", "item_count", pkt_count);
							  
	uvm_config_db #(virtual apb_intf.master)::set(this, "env.agt_mst", "drv_vif", drv_vif);
	uvm_config_db #(virtual apb_intf.i_mon)::set(this, "env.agt_mst", "imon_vif", imon_vif);
	uvm_config_db #(virtual apb_intf.o_mon)::set(this, "env.agt_slv", "omon_vif", omon_vif);
	uvm_config_db #(uvm_object_wrapper)::set(this, "env.agt_mst.apb_sqr.main_phase", "default_sequence", apb_sequence::get_type());
endfunction

function void apb_base_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction

task apb_base_test::main_phase(uvm_phase phase);
	super.main_phase(phase);
	
	phase.raise_objection(this);
	#10000;
	phase.drop_objection(this);

endtask

function void apb_base_test::final_phase(uvm_phase phase);
	super.final_phase(phase);
endfunction

`endif