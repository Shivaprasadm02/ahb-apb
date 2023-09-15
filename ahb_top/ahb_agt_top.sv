class ahb_agt_top extends uvm_env;

	`uvm_component_utils(ahb_agt_top)
  
    ahb_agent ahb_agth[];
	env_cfg m_cfg;
	
	function new(string name = "ahb_agt_top" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
    function void build_phase(uvm_phase phase);
     	super.build_phase(phase);
		if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",m_cfg))
			`uvm_fatal(get_full_name,"err in ahb agent top");
		ahb_agth=new[m_cfg.no_of_Hagent];
		foreach(ahb_agth[i])
			ahb_agth[i]=ahb_agent::type_id::create($sformatf("ahb_agth[%0d]",i),this);
	endfunction
	
endclass
