class apb_driver extends uvm_driver #(apb_xtn);
	
	`uvm_component_utils(apb_driver)
	
	virtual apb_if.PDR_MP vif;
	
    apb_agt_cfg apb_cfg;
	
	function new(string name ="apb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase); 
		if(!uvm_config_db #(apb_agt_cfg)::get(this,"","apb_agt_cfg",apb_cfg))
			`uvm_fatal(get_full_name,"err in apd driver get//");
    endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=apb_cfg.vif;
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
			send_to_dut();
	endtask

	task send_to_dut();
	//wait for pselx non-zero
	//@(vif.apb_drv_cb);
		wait(vif.apb_drv_cb.pselx!=0);
			if(vif.apb_drv_cb.pwrite==0)
				vif.apb_drv_cb.prdata<=$random;
`uvm_info("APB_DRIVER",$sformatf("printing from apb driver \n ----------------\n %h \n ----------------",vif.apb_drv_cb.prdata),UVM_MEDIUM);
		repeat(2)
		@(vif.apb_drv_cb);
		wait(vif.apb_drv_cb.penable);
	endtask
	
	
endclass

 
 






 


	


