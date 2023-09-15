class apb_agt_top extends uvm_env;

	`uvm_component_utils(apb_agt_top)
  
    apb_agent apb_agth[];
	env_cfg m_cfg;
	
	function new(string name = "apb_agt_top" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
    function void build_phase(uvm_phase phase);
     	super.build_phase(phase);
		if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",m_cfg))
			`uvm_fatal(get_full_name,"err in apb agent top");
		apb_agth=new[m_cfg.no_of_Pagent];
		foreach(apb_agth[i])
			apb_agth[i]=apb_agent::type_id::create($sformatf("apb_agth[%0d]",i),this);
	endfunction
	
endclass
