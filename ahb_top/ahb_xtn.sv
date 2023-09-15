class ahb_xtn extends uvm_sequence_item;
 `uvm_object_utils(ahb_xtn)
 
	rand logic Hwrite;
	rand logic [2:0]Hburst;
	rand logic [2:0]Hsize;
	rand logic [1:0] Htrans;
	rand logic [31:0] Haddr;
	rand logic [31:0] Hwdata;
	logic [31:0] Hrdata;
	rand logic [7:0]length;
	
//1
constraint h_addr{soft Haddr inside {[32'h 8000_0000:32'h 8000_03ff],
								[32'h 8400_0000:32'h 8400_03ff],
								[32'h 8800_0000:32'h 8800_03ff],
								[32'h 8c00_0000:32'h 8c00_03ff]};}

//2
constraint data_width{Hsize inside {[0:2]};}

//3
constraint valid_length{2^^Hsize*length <=1024;}
//constraint valid_length{length ==3;}

//4
constraint valid_Haddr{Hsize==1 -> Haddr%2==0;
                       Hsize==2 -> Haddr%4==0;}
					   
extern function new(string name="ahb_xtn");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs,uvm_comparer comparer);
extern function void do_print(uvm_printer printer);

endclass

function ahb_xtn::new(string name="ahb_xtn");
  super.new(name);
endfunction

function void ahb_xtn::do_copy(uvm_object rhs);
 ahb_xtn xtnh;
 
 if(!$cast(xtnh,rhs))
    `uvm_fatal(get_full_name,"casting error///////////");
 	
 super.do_copy(rhs);	

 this.Hwrite=xtnh.Hwrite;
 this.Haddr=xtnh.Haddr;
 this.Hwdata=xtnh.Hwdata;
 this.length=xtnh.length;
 this.Hburst=xtnh.Hburst;
 this.Hsize=xtnh.Hsize;
 this.Htrans=xtnh.Htrans;
 this.Hrdata=xtnh.Hrdata;
 
endfunction

function bit ahb_xtn::do_compare(uvm_object rhs,uvm_comparer comparer);
 ahb_xtn xtnh;
 
 if(!$cast(xtnh,rhs))
 begin
   `uvm_fatal(get_full_name,"casting error///////////");
   return 0;   
 end 
 
 return super.do_compare(rhs,comparer)&&
 
 this.Hwrite==xtnh.Hwrite &&
 this.Haddr==xtnh.Haddr &&
 this.Hwdata==xtnh.Hwdata &&
 this.length==xtnh.length &&
 this.Hburst==xtnh.Hburst &&
 this.Hsize==xtnh.Hsize &&
 this.Htrans==xtnh.Htrans &&
 this.Hrdata==xtnh.Hrdata;

endfunction

function void ahb_xtn::do_print(uvm_printer printer);
super.do_print(printer);
$display("\n-------------------------------------------------------------");
printer.print_field("Hwrite",    this.Hwrite,    1,      UVM_DEC);
printer.print_field("Haddr",     this.Haddr ,    32,     UVM_HEX);
printer.print_field("Hsize",     this.Hsize,     3,      UVM_DEC);
printer.print_field("Hburst",    this.Hburst,    3,      UVM_DEC);
printer.print_field("length",    this.length,    8,      UVM_DEC);
printer.print_field("Htrans",    this.Htrans,    2,      UVM_DEC);
printer.print_field("Hwdata",    this.Hwdata,    32,     UVM_HEX);
printer.print_field("Hrdata",    this.Hrdata,    32,     UVM_HEX);
$display("------------------------------------------------------------- \n");
endfunction
