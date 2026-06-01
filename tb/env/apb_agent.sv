`ifndef APB_AGENT__SV
`define APB_AGENT__SV

// apb_agent_mst
class apb_agent_mst extends uvm_agent;
	`uvm_component_utils(apb_agent_mst)

	apb_imonitor    apb_imon;
	apb_driver      apb_drv;
	apb_sequencer   apb_sqr;

	uvm_analysis_port #(apb_transaction) ap;

	function new(string name = "apb_agent_mst", uvm_component parent);
			super.new(name, parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
endclass

function void apb_agent_mst::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ap = new("ap", this);

	if(is_active == UVM_ACTIVE) begin
			apb_drv = apb_driver::type_id::create("apb_drv", this);
			apb_sqr = apb_sequencer::type_id::create("apb_sqr", this);
	end
	
	apb_imon = apb_imonitor::type_id::create("apb_imon", this);
endfunction

function void apb_agent_mst::connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	if(is_active == UVM_ACTIVE) begin
			apb_drv.seq_item_port.connect(apb_sqr.seq_item_export);
	end

	apb_imon.ap.connect(ap);
endfunction

// apb_agent_slv
class apb_agent_slv extends uvm_agent;
	`uvm_component_utils(apb_agent_slv)

	apb_omonitor  apb_omon;

	uvm_analysis_port #(apb_transaction) ap;

	function new (string name="apb_agent_slv",uvm_component parent);
			super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
endclass

function void apb_agent_slv::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ap = new("ap",this);
	
	if(is_active == UVM_ACTIVE) begin
	end
    
	apb_omon = apb_omonitor::type_id::create("apb_omon",this);
endfunction

function void apb_agent_slv::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	apb_omon.ap.connect(ap);
endfunction

`endif
