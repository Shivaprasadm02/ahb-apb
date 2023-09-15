class apb_xtn extends uvm_sequence_item;
 
 `uvm_object_utils(apb_xtn)
 
    logic  Penable;
	logic  Pwrite;
	logic [3:0]Pselx;
	logic [31:0]Pwdata;
	logic [31:0]Prdata;
	logic [31:0]Paddr; 
 
function new(string name="apb_xtn");
	super.new(name);
endfunction

function void do_print(uvm_printer printer);
  
	super.do_print(printer);

	$display("\n-------------------------------------------------------------");
	printer.print_field("Penable",   this.Penable,   1,      UVM_DEC);
	printer.print_field("Pselx",     this.Pselx,     4,      UVM_DEC);
	printer.print_field("Pwrite",    this.Pwrite,    1,      UVM_DEC);
	printer.print_field("Paddr",     this.Paddr ,    32,     UVM_HEX);
	printer.print_field("Pwdata",    this.Pwdata,    32,     UVM_HEX);
	printer.print_field("Prdata",    this.Prdata,    32,     UVM_HEX);
	$display("-------------------------------------------------------------\n");
endfunction

endclass
