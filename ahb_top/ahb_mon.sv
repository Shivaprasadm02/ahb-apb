class ahb_monitor extends uvm_monitor;
	
	`uvm_component_utils(ahb_monitor)
//declaring analysis port
	uvm_analysis_port#(ahb_xtn) analysis_port;
//config class
	ahb_agt_cfg ahb_cfg;
//interface instance
	virtual ahb_if.HMON_MP vif;
//2 trans class to collect data frm DUT and compare
	ahb_xtn xtnh;
	
	function new(string name ="ahb_monitor",uvm_component parent);
		super.new(name,parent);
		analysis_port=new("analysis_port",this);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(ahb_agt_cfg)::get(this,"","ahb_agt_cfg",ahb_cfg))
			`uvm_fatal(get_full_name,"err in ahb mon in get//");
		xtnh=ahb_xtn::type_id::create("xtnh");
    endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif = ahb_cfg.vif;
    endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
			collect_data();
	endtask

	task collect_data();
//waiting for hreadyout from apb i.e waiting for apb to complete transaction 
//hreadyout indicates ahb has completed transfer successfully
		wait(vif.ahb_mon_cb.hreadyout && (vif.ahb_mon_cb.htrans==2'b10 ||vif.ahb_mon_cb.htrans==2'b11));
		begin
			xtnh.Haddr = vif.ahb_mon_cb.haddr;
			xtnh.Hburst = vif.ahb_mon_cb.hburst;
			xtnh.Htrans = vif.ahb_mon_cb.htrans;
			xtnh.Hsize = vif.ahb_mon_cb.hsize;
			xtnh.Hwrite = vif.ahb_mon_cb.hwrite;
		end
//we will have either hwdata or hrdata based on hwrite so we collect them accordingly
		@(vif.ahb_mon_cb);
		wait(vif.ahb_mon_cb.hreadyout && (vif.ahb_mon_cb.htrans==2'b10 ||vif.ahb_mon_cb.htrans==2'b11));
			if(vif.ahb_mon_cb.hwrite==1)
			xtnh.Hwdata = vif.ahb_mon_cb.hwdata;
			//xtnh.Hrdata=0;
			else
			xtnh.Hrdata = vif.ahb_mon_cb.hrdata;
			//xtnh.Hwdata=0;
//creating a copy of data to write to analysis port
	analysis_port.write(xtnh);
	`uvm_info(get_type_name,$sformatf("printing from ahb monitor \n %s",xtnh.sprint),UVM_MEDIUM);

	endtask
			
endclass
