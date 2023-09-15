class ahb_driver extends uvm_driver #(ahb_xtn);
	
	`uvm_component_utils(ahb_driver)
	
	ahb_agt_cfg ahb_cfg;
	
	virtual ahb_if.HDR_MP vif;
	
	function new(string name ="ahb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase); 
		if(!uvm_config_db #(ahb_agt_cfg)::get(this,"","ahb_agt_cfg",ahb_cfg))
			`uvm_fatal(get_full_name,"err in ahb mon in get//");
    endfunction
	
	function void connect_phase(uvm_phase phase);
		 super.connect_phase(phase);
		vif = ahb_cfg.vif;
		//$display("ahb drv %p",vif);
    endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.resetn <=0;
		@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.resetn <=1;
		wait(vif.ahb_drv_cb.hreadyout);
		forever
		begin
		seq_item_port.get_next_item(req);
		//$display("req in drv %p",req);
		send_to_dut(req);
		seq_item_port.item_done();
		end
	endtask

	task send_to_dut(ahb_xtn xtn);
		vif.ahb_drv_cb.hwrite<=xtn.Hwrite;
		vif.ahb_drv_cb.htrans<=xtn.Htrans;
		vif.ahb_drv_cb.hsize<=xtn.Hsize;
		vif.ahb_drv_cb.hburst<=xtn.Hburst;
		vif.ahb_drv_cb.haddr<=xtn.Haddr;
		vif.ahb_drv_cb.hreadyin<=1;
		
        @(vif.ahb_drv_cb);     
		wait(vif.ahb_drv_cb.hreadyout);
		//vif.ahb_drv_cb.hreadyin<=1'b0;
		if(req.Hwrite)
			vif.ahb_drv_cb.hwdata<=xtn.Hwdata;
		else
			vif.ahb_drv_cb.hwdata<='dz;	
	  `uvm_info("BRIDGE AHB DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 
   	 
	endtask

endclass


 


	


