`ifndef APB_ENV__SV
`define APB_EVN__SV

class apb_env extends uvm_env;
	`uvm_component_utils(apb_env)

	int unsigned exp_pkt_count;
	int unsigned m_matches, mis_matches;
	real cov_result;

	apb_agent_mst 	agt_mst;
	apb_agent_slv  	agt_slv;
	apb_socreboard  apb_scb;
	apb_coverage    apb_cov;

	function new(string name = "apb_env", uvm_component parent = null);
			super.new(name, parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual function void report_phase(uvm_phase phase);
	extern virtual function void extract_phase(uvm_phase phase);
endclass

function void apb_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	agt_mst = apb_agent_mst::type_id::create("agt_mst", this);
	agt_slv = apb_agent_slv::type_id::create("agt_slv", this);
	apb_scb = apb_socreboard::type_id::create("apb_scb", this);
	apb_cov = apb_coverage::type_id::create("apb_cov", this);
endfunction

function void apb_env::connect_phase(uvm_phase phase);
	agt_mst.ap.connect(apb_scb.mon_in);
	agt_mst.ap.connect(apb_cov.analysis_export);
	agt_slv.ap.connect(apb_scb.mon_out);
endfunction

function void apb_env::extract_phase(uvm_phase phase);
	uvm_config_db #(int unsigned)::get(this, "agt_mst.apb_sqr", "item_count", exp_pkt_count);
	uvm_config_db #(int unsigned)::get(this, "", "matches", m_matches);
	uvm_config_db #(int unsigned)::get(this, "", "mis_matches", mis_matches);
	uvm_config_db #(real)::get(this, "", "cov_result", cov_result);
endfunction

function void apb_env::report_phase(uvm_phase phase);
	int unsigned act_pkt_count;
	
	super.report_phase(phase);
	act_pkt_count = m_matches + mis_matches;
	
	if (exp_pkt_count != act_pkt_count) begin		
		`uvm_info("FAIL","Test Failed due to packet count MIS_MATCH",UVM_NONE); 
		`uvm_info("FAIL",$sformatf("exp_pkt_count=%0d, act_pkt_count=%0d ", exp_pkt_count, act_pkt_count),UVM_NONE); 
		`uvm_fatal("FAIL","******************Test FAILED ***************");
	end
	else if (mis_matches != 0) begin
		`uvm_info("FAIL","Test Failed due to mis_matched packets in scoreboard",UVM_NONE); 
    `uvm_info("FAIL",$sformatf("matched_pkt_count=%0d, mis_matched_pkt_count=%0d ", m_matches, mis_matches),UVM_NONE); 
		`uvm_fatal("FAIL","******************Test FAILED ***************");
	end
	else begin
		`uvm_info("PASS",$sformatf("exp_pkt_count=%0d, act_pkt_count=%0d ",exp_pkt_count, act_pkt_count),UVM_NONE); 
    `uvm_info("PASS",$sformatf("Coverage=%0f%%", cov_result),UVM_NONE); 
		`uvm_info("PASS","******************Test PASSED ***************",UVM_NONE);
	end

endfunction

`endif