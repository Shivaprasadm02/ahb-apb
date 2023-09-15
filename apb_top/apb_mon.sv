class apb_monitor extends uvm_monitor;
	
	`uvm_component_utils(apb_monitor)
	//declaring analysis port
	uvm_analysis_port#(apb_xtn) analysis_port;
	//config instance 
	apb_agt_cfg apb_cfg;
	//virtual interface
	virtual apb_if.PMON_MP vif;
	//transaction class to store the sampled data
	apb_xtn xtnh;
	
	function new(string name ="apb_monitor",uvm_component parent);
		super.new(name,parent);
		analysis_port=new("analysis_port",this);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(apb_agt_cfg)::get(this,"","apb_agt_cfg",apb_cfg))
			`uvm_fatal(get_full_name,"err in apb mon get");
		xtnh=apb_xtn::type_id::create("xtnh");
    endfunction
			
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=apb_cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
			collect_data();
	endtask

	task collect_data();
		@(vif.apb_mon_cb);
		wait(vif.apb_mon_cb.penable);
			xtnh.Paddr=vif.apb_mon_cb.paddr;
			xtnh.Pselx=vif.apb_mon_cb.pselx;
			xtnh.Penable=vif.apb_mon_cb.penable;
			xtnh.Pwrite=vif.apb_mon_cb.pwrite;
		//@(vif.apb_mon_cb);
		if(xtnh.Pwrite)
			begin
				xtnh.Pwdata=vif.apb_mon_cb.pwdata;
				xtnh.Prdata=0;
			end
		else
			begin
			xtnh.Prdata=vif.apb_mon_cb.prdata;
			xtnh.Pwdata=0;
			end
		`uvm_info(get_full_name,$sformatf("printing from apb monitor \n %s",xtnh.sprint),UVM_MEDIUM);
		//write to analysis port
		analysis_port.write(xtnh);
		@(vif.apb_mon_cb);
	endtask

endclass
