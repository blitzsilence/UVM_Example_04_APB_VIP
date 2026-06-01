`ifndef APB_TRANSACTION__SV
`define APB_TRANSACTION__SV

typedef enum {
	IDEL,
	RESET,
	READ,
	WRITE,
	RAL_READ,
	RAL_WRITE
} mode_e;

typedef enum bit [1:0] {
	NOT_OK,
	OK,
	PENDING,
	ERROR
} response_e;

class apb_transaction extends uvm_sequence_item;

	rand bit[31:0] paddr;
	rand bit[31:0] pwdata;

	response_e status_e;
	mode_e mode;

	`uvm_object_utils_begin(apb_transaction)
		`uvm_field_int(paddr, UVM_ALL_ON)
		`uvm_field_int(pwdata, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "apb_transaction");
		super.new(name);    
	endfunction

	virtual function string convert2string();
		return $sformatf("addr=%0x, data=%0x", paddr, pwdata);
	endfunction
endclass 

`endif

