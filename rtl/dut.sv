module slave_ip #(
    parameter AWIDTH=32,
    parameter DWIDTH=32
)(
    paddr,
    psel,
    penable,
    pwrite,
    prdata,
    pwdata,
    pclk,
    presetn
);

    input bit   [AWIDTH-1:0]   paddr;
    input bit                   psel;
    input bit                   penable;
    input bit                   pwrite;
    output reg  [DWIDTH-1:0]   prdata;
    input logic [DWIDTH-1:0]   pwdata;
    input bit                   pclk;
    input wire                  presetn;
		
		logic apb_access;
		assign apb_access = psel && penable;

    bit [DWIDTH-1:0] ram[0:255];

    always @(posedge pclk or negedge presetn) begin
			if(presetn === 0) 
				ram <= '{256{'b0}};
			else if(apb_access && pwrite) 
				ram[paddr] <= pwdata;
    end

    always @(posedge pclk) begin
			if(apb_access && !pwrite)
					prdata <= ram[paddr];
    end
    
endmodule
