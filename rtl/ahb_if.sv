interface ahb_if(input bit clk);
	bit resetn;
    bit hwrite;
	bit[2:0]hsize;
	bit [2:0]hburst;
	bit [1:0]htrans;
	bit hreadyout;
	bit hreadyin;
	
	bit [31:0]haddr;
	bit [31:0]hwdata;
	bit [31:0]hrdata;
	bit [1:0]hresp;

//hresp missing
	
	clocking ahb_drv_cb@(posedge clk);
		default input #1 output #1;
		output resetn,hwrite, hsize, hburst, htrans, hreadyin, haddr, hwdata;
		input hreadyout;
	endclocking
	
	clocking ahb_mon_cb@(negedge clk);
		default input #1 output #1;
		input hwrite, htrans, hreadyout, haddr, hwdata, hrdata,hsize,hburst;
	endclocking
	
	modport HDR_MP(clocking ahb_drv_cb);
	modport HMON_MP(clocking ahb_mon_cb);

endinterface
