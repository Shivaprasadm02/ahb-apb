interface apb_if(input bit clk);
	bit pwrite;
	bit penable;
	bit [3:0]pselx;
	bit [31:0]paddr;
	bit [31:0]pwdata;
	bit [31:0]prdata;
	
	clocking apb_drv_cb@(posedge clk);
		default input #1 output #1;
		output prdata;
		input penable,paddr,pwrite,pwdata,pselx;
	endclocking
	
	clocking apb_mon_cb@(negedge clk);
		default input #1 output #1;
		input prdata,penable,paddr,pwrite,pwdata,pselx;
	endclocking
	
	modport PDR_MP(clocking apb_drv_cb);
	modport PMON_MP(clocking apb_mon_cb);

endinterface
