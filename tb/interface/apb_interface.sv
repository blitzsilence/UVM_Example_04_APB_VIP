`ifndef APB_INTERFACE__SV
`define APB_INTERFACE__SV

interface apb_intf(input pclk);

    logic           presetn;
    logic [31:0]    paddr;
    logic           pwrite;
    logic           psel;
    logic           pready;
    logic           penable;
    logic [31:0]    pwdata;
    logic [31:0]    prdata;
    logic           pslvERR;

    // Master clocking
    clocking cb_master @(posedge pclk);
			default input #1ns output #1ns;
			
			input prdata;
			input pslvERR;
			
			output paddr;
			output psel;
			output penable;
			output pwrite;
			output pwdata;
			output pready;
    endclocking

    // Slave clocking
    clocking cb_slave @(posedge pclk);
			default input #1ns output #1ns;
			
			input paddr;
			input psel;
			input penable;
			input pwrite;
			input pwdata;
			input pready;
			
			output prdata;
			output pslvERR;
    endclocking

    // input monitor
    clocking cb_imon @(posedge pclk);
			default input #1ns output #1ns;
			
			input paddr;
			input psel;
			input penable;
			input pwrite;
			input pwdata;
			input pready;
			input prdata;
    endclocking

    // output monitor
    clocking cb_omon @(posedge pclk);
			default input #1ns output #1ns;
			
			input paddr;
			input psel;
			input penable;
			input pwrite;
			input pwdata;
			input pready;
			input prdata;
    endclocking

    modport master (clocking cb_master, output presetn);
    modport slave  (clocking cb_slave, output presetn);
    modport i_mon   (clocking cb_imon);
    modport o_mon   (clocking cb_omon);
endinterface

`endif