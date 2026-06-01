`ifndef APB_SEQUENCE__SV
`define APB_SEQUENCE__SV

class apb_sequence extends uvm_sequence#(apb_transaction);
	`uvm_object_utils(apb_sequence)

	int unsigned pkt_count;

	function new(string name = "apb_sequence");
			super.new(name);
	endfunction

	virtual task pre_body();
		if (!uvm_config_db#(int unsigned)::get(m_sequencer, "", "item_count", pkt_count)) begin
				`uvm_warning("SEQ", "item count is 0");
				pkt_count = 10;
		end
	endtask

	virtual task body();
		int unsigned pkt_id;
		`uvm_info("SEQ", $sformatf("pkt_count: %0d", pkt_count), UVM_LOW)
		
		repeat(pkt_count) begin
			`uvm_do_with(req, {paddr inside {[0:255]};});
			pkt_id ++;
			`uvm_info("SEQ", $sformatf("transaction %0d generation Done.", pkt_id), UVM_LOW)
			get_response(rsp);
		end
    endtask
endclass

`endif