class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item) ;
   
	`uvm_component_utils(virtual_sequencer)	

	ahb_sequencer ahb_seqrh[];
	apb_sequencer apb_seqrh[];
	env_cfg m_cfg;

	function new(string name = "virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_cfg))
			`uvm_fatal(get_full_name,"get config error");
		apb_seqrh=new[m_cfg.no_of_Pagent];
		ahb_seqrh=new[m_cfg.no_of_Hagent];
		foreach(ahb_seqrh[i])
			ahb_seqrh[i]=ahb_sequencer::type_id::create($sformatf("ahb_seqrh[%0d]",i),this);
		foreach(ahb_seqrh[i])
			apb_seqrh[i]=apb_sequencer::type_id::create($sformatf("apb_seqrh[%0d]",i),this);	
	endfunction
	
endclass




