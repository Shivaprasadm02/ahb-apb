class bridge_env extends uvm_env;

    `uvm_component_utils(bridge_env)

	ahb_agt_top hagt_top;	
	apb_agt_top pagt_top;
	
	virtual_sequencer v_seqrh;
	scoreboard sb;
	
	env_cfg m_cfg;
	
	function new(string name = "bridge_env", uvm_component parent);
		super.new(name,parent);
	endfunction

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_cfg))
			`uvm_fatal(get_full_name,"error at get config////");
		if(m_cfg.has_Hagent)
		begin
			hagt_top=ahb_agt_top::type_id::create("hagt_top",this);
			foreach(m_cfg.ahb_cfg[i])
				uvm_config_db #(ahb_agt_cfg)::set(this,"*","ahb_agt_cfg",m_cfg.ahb_cfg[i]);
		end

		if(m_cfg.has_Pagent)
		begin   
			pagt_top=apb_agt_top::type_id::create("pagt_top",this);
			foreach(m_cfg.apb_cfg[i])
			uvm_config_db #(apb_agt_cfg)::set(this,"*","apb_agt_cfg",m_cfg.apb_cfg[i]);
		end
  
		if(m_cfg.has_virtual_sequencer)
			v_seqrh=virtual_sequencer::type_id::create("v_seqrh",this);
	 
		if(m_cfg.has_scoreboard)
			sb=scoreboard::type_id::create("sb",this);    
             
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(m_cfg.has_virtual_sequencer) 
		begin
			if(m_cfg.has_Hagent)
			foreach(m_cfg.ahb_cfg[i])
				v_seqrh.ahb_seqrh[i]=hagt_top.ahb_agth[i].seqrh;
			//if(m_cfg.has_Pagent)
			//foreach(m_cfg.apb_cfg[i])
			//	v_seqrh.apb_seqr[i]=pagt_top.apb_agth[i].seqrh;
		end 
		
		if(m_cfg.has_scoreboard) 
		begin
			if(m_cfg.has_Hagent)
				for(int i=0;i<m_cfg.no_of_Hagent;i++)
					hagt_top.ahb_agth[i].monh.analysis_port.connect(sb.fifo_ahb.analysis_export);		
			if(m_cfg.has_Pagent)
				for(int i=0;i<m_cfg.no_of_Pagent;i++) 
					pagt_top.apb_agth[i].monh.analysis_port.connect(sb.fifo_apb.analysis_export);
		end
	endfunction  
	
  task run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask
endclass
