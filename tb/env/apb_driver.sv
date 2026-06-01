`ifndef APB_DRIVER__SV
`define APB_DRIVER__SV

class apb_driver extends uvm_driver #(apb_transaction);
	`uvm_component_utils(apb_driver)

	virtual apb_intf.master vif;

	function new(string name = "apb_driver", uvm_component parent);
		super.new(name, parent);
	endfunction

	extern virtual task run_phase (uvm_phase phase);
	extern virtual task reset_phase (uvm_phase phase);
	extern virtual function void build_phase (uvm_phase phase);
	extern virtual task write (input apb_transaction tr);
	extern virtual task read (input apb_transaction tr);
	extern virtual task drive (input apb_transaction tr);
endclass 

function void apb_driver::build_phase (uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(virtual apb_intf.master)::get(get_parent(), "", "drv_vif", vif))begin
		`uvm_fatal(get_type_name(), "virtual interface in apb_driver is null.")
	end
endfunction

task apb_driver::run_phase (uvm_phase phase);

	forever begin
		@(vif.cb_master);
		
		seq_item_port.get_next_item(req);
		`uvm_info("driver", $sformatf("receive transaction %0d from tlm port.", req.get_transaction_id()), UVM_LOW)

		drive(req);
		rsp = apb_transaction::type_id::create("rsp", this);
		rsp.set_id_info(req);
		rsp.status_e = OK;
		seq_item_port.item_done();
		seq_item_port.put_response(rsp);
		`uvm_info("driver", $sformatf("Transaction %0d done.", req.get_transaction_id()), UVM_LOW)
	end

endtask 

task apb_driver::drive (input apb_transaction tr);
	write(tr);
	read(tr);
endtask

task apb_driver::write (input apb_transaction tr);
	`uvm_info("driver", $sformatf("APB write transaction start."), UVM_LOW)
	`uvm_info("driver", $sformatf("write %s.", tr.convert2string()), UVM_LOW)
	vif.cb_master.psel   <= 1;
	vif.cb_master.pwrite <= 1;
	vif.cb_master.paddr  <= tr.paddr;
	vif.cb_master.pwdata <= tr.pwdata;    
	@vif.cb_master;    
	vif.cb_master.penable <= 1;
	@vif.cb_master;
	vif.cb_master.penable <= 0;
	vif.cb_master.psel <= 0; 
	`uvm_info("driver", $sformatf("APB write transaction end."), UVM_LOW)
endtask

task apb_driver::read (input apb_transaction tr);
	`uvm_info("driver", "APB read transaction start.", UVM_LOW)
	`uvm_info("driver", $sformatf("read %s.", tr.convert2string()), UVM_LOW)
	vif.cb_master.psel <= 1;
	vif.cb_master.pwrite <= 0;
	vif.cb_master.paddr <= tr.paddr;
	@vif.cb_master;
	vif.cb_master.penable <= 1;
	@vif.cb_master;
	`uvm_info("Read",$sformatf("APB Read data=%0d at addr=%0x",vif.cb_master.prdata,tr.paddr),UVM_LOW);
	vif.cb_master.penable <= 0;
	vif.cb_master.psel <= 0;
	`uvm_info("driver", "APB read transaction end.", UVM_LOW)
endtask

task apb_driver::reset_phase(uvm_phase phase);
	super.reset_phase(phase);

	`uvm_info("driver", "APB reset start.", UVM_LOW)

	phase.raise_objection(this);
	vif.cb_master.psel <= 0;
	vif.cb_master.penable <= 0;
	vif.cb_master.pready <= 0;
	vif.presetn <= 0;
	`uvm_info("driver", "clk before.", UVM_LOW)
	@vif.cb_master;
	`uvm_info("driver", "clk after.", UVM_LOW)
	vif.presetn <= 1;
	@vif.cb_master;
	phase.drop_objection(this);
	`uvm_info("driver", "APB reset end.", UVM_LOW)
endtask

`endif