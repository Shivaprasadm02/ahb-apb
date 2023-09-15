module top;

    import bridge_test_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";

	bit clock;  
	always 
	#10 clock=!clock;     
			  
	ahb_if hvif(clock); 
	apb_if pvif(clock);
	
	rtl_top DUT(.Hclk(clock),
            .Hresetn(hvif.resetn),
            .Haddr(hvif.haddr),
			.Hreadyin(hvif.hreadyin),
			.Hreadyout(hvif.hreadyout),
			.Hresp(hvif.hresp),
			.Hsize(hvif.hsize),
			.Htrans(hvif.htrans),
			.Hwdata(hvif.hwdata),
			.Hwrite(hvif.hwrite),
			.Hrdata(hvif.hrdata),
			
			.Paddr(pvif.paddr),
			.Penable(pvif.penable),
			.Prdata(pvif.prdata),
			.Pselx(pvif.pselx),
			.Pwdata(pvif.pwdata),
			.Pwrite(pvif.pwrite)); 
	
    initial
	begin

  	uvm_config_db #(virtual ahb_if)::set(null,"*","vif_0",hvif);
  	uvm_config_db #(virtual apb_if)::set(null,"*","vif_1",pvif);
 
	//test=new(sin,din_0,din_1,din_2);
	run_test();
    end  
endmodule


  
   
  
 
