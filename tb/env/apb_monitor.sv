`ifndef APB_MONITOR__SV
`define APB_MONITOR__SV

// apb_imonitor
class apb_imonitor extends uvm_monitor;
	`uvm_component_utils(apb_imonitor)

	virtual apb_intf.i_mon vif;

	uvm_analysis_port#(apb_transaction) ap;

	protected apb_transaction tr;
	function new(string name = "apb_imonitor", uvm_component parent);
		super.new(name, parent);
	endfunction
	extern virtual task run_phase(uvm_phase phase);
	extern virtual function void build_phase(uvm_phase phase);
endclass

function void apb_imonitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if (!uvm_config_db #(virtual apb_intf.i_mon)::get(get_parent(), "", "imon_vif", vif)) begin
		`uvm_fatal("CFGERR", "iMonitor DUT interface not set");
	end

	ap = new ("ap", this);
endfunction

task apb_imonitor::run_phase(uvm_phase phase);
	super.run_phase(phase);

	forever begin
		do 
		@(vif.cb_imon);
		while (vif.cb_imon.psel !== 1 || vif.cb_imon.penable !== 0);
		tr = apb_transaction::type_id::create("tr", this);
		tr.paddr = vif.cb_imon.paddr;
		tr.mode = vif.cb_imon.pwrite == 1 ? WRITE : READ;
		@(vif.cb_imon);
		
		if(vif.cb_imon.penable != 1) begin
			`uvm_fatal("Violation","APB Protocol Violation :: Setup Phase not followed by Access Phase");
		end

		if(tr.mode == WRITE) begin
			tr.pwdata = vif.cb_imon.pwdata;
			`uvm_info("iMon",tr.convert2string(),UVM_LOW);
			ap.write(tr);
		end
			
	end
endtask

// apb_omonitor
class apb_omonitor extends uvm_monitor;
	`uvm_component_utils(apb_omonitor)

	virtual apb_intf.o_mon vif;
	uvm_analysis_port#(apb_transaction) ap;

	protected apb_transaction tr;
	function new(string name = "apb_omonitor", uvm_component parent);
			super.new(name, parent);
	endfunction

	extern virtual task run_phase(uvm_phase phase);
	extern virtual function void build_phase(uvm_phase phase);
endclass

function void apb_omonitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if (!uvm_config_db #(virtual apb_intf.o_mon)::get(get_parent(), "", "omon_vif", vif)) begin
			`uvm_fatal("CFGERR", "oMonitor DUT interface not set");
	end

	ap = new("ap",this);
endfunction

task apb_omonitor::run_phase(uvm_phase phase);
	super.run_phase(phase);

	forever begin
		@(vif.cb_omon.prdata);
		if (vif.cb_omon.prdata === 'bz || vif.cb_omon.prdata === 'bx) begin
				continue;
		end

		tr = apb_transaction::type_id::create("tr", this);
		tr.pwdata = vif.cb_omon.prdata;
		tr.paddr = vif.cb_omon.paddr;
		`uvm_info("oMon",tr.convert2string(),UVM_MEDIUM);
		ap.write(tr);
	end
endtask

`endif