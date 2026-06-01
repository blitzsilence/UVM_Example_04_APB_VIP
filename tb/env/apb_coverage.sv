`ifndef APB_COVERAGE__SV
`define APB_COVERAGE__SV

class apb_coverage extends uvm_subscriber#(apb_transaction);
	real cov_result;
	bit cov_enable;
	
	apb_transaction pkt;

	covergroup apb_cg with function sample(apb_transaction pkt);
		option.comment = "APB Coverage";
		coverpoint pkt.paddr;
	endgroup

	`uvm_component_utils_begin(apb_coverage)
			`uvm_field_int(cov_enable, UVM_DEFAULT)
	`uvm_component_utils_end

	function new(string name = "apb_coverage", uvm_component parent);
		super.new(name, parent);  
		uvm_config_db#(bit)::get(this, "", "cov_enable", cov_enable);
		if(cov_enable == 1) begin
			`uvm_info("COV", "Coverage enabled", UVM_MEDIUM)
			apb_cg = new;
		end      
	endfunction

	virtual function void write(T t);
		if(!$cast(pkt, t.clone))begin
				`uvm_fatal("COV", "Transaction is NULL")
		end

		if(cov_enable == 1) begin
			apb_cg.sample(pkt);
			cov_result = apb_cg.get_coverage();
			`uvm_info("COV", $sformatf("Coverage=%3.2f", cov_result), UVM_MEDIUM)
		end
	endfunction

	virtual function void extract_phase(uvm_phase phase);
			uvm_config_db#(real)::set(null, "uvm_test_top.env", "cov_result", cov_result);
	endfunction

endclass

`endif