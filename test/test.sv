///base test------///////////////////////
class bridge_base_test extends uvm_test;
	`uvm_component_utils(bridge_base_test)
	
	bridge_env envh;
	env_cfg m_cfg;
	ahb_agt_cfg ahb_cfg[];
	apb_agt_cfg apb_cfg[];
	
	vbase_seq vseqh;
		
	bit has_Hagent = 1;
	bit has_Pagent = 1;
	bit has_virtual_sequencer = 1;
	bit has_scoreboard = 1;
	int no_of_Hagent = 1;
	int no_of_Pagent = 1;
	
	function new(string name="bridge_base_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		
		m_cfg = env_cfg :: type_id :: create("m_cfg");
		//creating instances of ahb and apb cnfgs of env cfg
		if(has_Hagent)
			m_cfg.ahb_cfg = new[no_of_Hagent];
		if(has_Pagent)
			m_cfg.apb_cfg = new[no_of_Pagent];

		bridge_config();
		
		//setting the env cfg after getting all vif to ahb_cfg and apb_cfg of env_cfg
		uvm_config_db #(env_cfg) :: set(this,"*","env_cfg",m_cfg);
		super.build_phase(phase);
		envh=bridge_env::type_id::create("envh",this);
	endfunction
	
	function void bridge_config();
	//creating local ahb cfg to get vif 
	if(has_Hagent)
	begin
		ahb_cfg = new[no_of_Hagent];

		foreach(ahb_cfg[i])
		begin
			ahb_cfg[i] = ahb_agt_cfg::type_id::create($sformatf("ahb_cfg[%0d]",i));

			if(!uvm_config_db #(virtual ahb_if) :: get(this,"","vif_0",ahb_cfg[i].vif))
				`uvm_fatal(get_type_name,"Unable to GET");

			ahb_cfg[i].is_active = UVM_ACTIVE;
			//assigning local ahb_cfg to ahb_cfg of env
			m_cfg.ahb_cfg[i] = ahb_cfg[i];
		end
	end
	
	//creating local apb cfg to get vif 
	if(has_Pagent)
	begin
		apb_cfg = new[no_of_Pagent];

		foreach(apb_cfg[i])
		begin
			apb_cfg[i] = apb_agt_cfg::type_id::create($sformatf("apb_cfg[%0d]",i));

			if(!uvm_config_db #(virtual apb_if) :: get(this,"","vif_1",apb_cfg[i].vif))
				`uvm_fatal(get_type_name,"Unable to GET");

			apb_cfg[i].is_active = UVM_ACTIVE;
			//assigning local apb_cfg to apb_cfg of env
			m_cfg.apb_cfg[i] = apb_cfg[i];
		end
	end

	m_cfg.no_of_Hagent = no_of_Hagent;
	m_cfg.no_of_Pagent = no_of_Pagent;
	m_cfg.has_Hagent = has_Hagent;
	m_cfg.has_Pagent = has_Pagent;
	
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		vseqh = vbase_seq::type_id::create("vseqh");
		vseqh.start(envh.v_seqrh);
		#50;
		phase.drop_objection(this);

	endtask
	
endclass
/////////////---------single test-//////////////////

class single_test extends bridge_base_test;

`uvm_component_utils(single_test)
single_vseq vseq1;

function new (string name = "single_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
vseq1 = single_vseq ::type_id::create("vseq1");
vseq1.start(envh.v_seqrh);
#100;
phase.drop_objection(this);
endtask

endclass

///--------unspecified test----------///////////
class unspecified_test extends bridge_base_test;

`uvm_component_utils(unspecified_test)
unspecified_vseq vseq2;

function new (string name = "unspecified_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
vseq2 = unspecified_vseq ::type_id::create("vseq2");
vseq2.start(envh.v_seqrh);
#100;
phase.drop_objection(this);
endtask

endclass

///////////----Increment test---///////////////

class increment_test extends bridge_base_test;

`uvm_component_utils(increment_test)
incr_vseq vseq3;

function new (string name = "increment_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
vseq3 = incr_vseq ::type_id::create("vseq3");
vseq3.start(envh.v_seqrh);
#100;
phase.drop_objection(this);
endtask

endclass

///////////----Wrapping test---///////////////

class wrapping_test extends bridge_base_test;

`uvm_component_utils(wrapping_test)
wrapping_vseq vseq4;

function new (string name = "wrapping_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
vseq4 = wrapping_vseq ::type_id::create("vseq4");
vseq4.start(envh.v_seqrh);
#100;
phase.drop_objection(this);
endtask
endclass

/////////////---------single read test-//////////////////

class single_rtest extends bridge_base_test;

`uvm_component_utils(single_rtest)
single_vrseq vrseq1;

function new (string name = "single_rtest",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
vrseq1 = single_vrseq ::type_id::create("vrseq1");
vrseq1.start(envh.v_seqrh);
#100;
phase.drop_objection(this);
endtask

endclass
/*
/////////////---------unspecified read test-//////////////////

class unspecified_rtest extends bridge_base_test;

`uvm_component_utils(unspecified_rtest)
unspecified_vrseq vrseq2;

function new (string name = "unspecified_rtest",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
vrseq2 = unspecified_vrseq ::type_id::create("vrseq2");
vrseq2.start(envh.v_seqrh);
#100;
phase.drop_objection(this);
endtask

*/

class unspecified_rtest extends bridge_base_test;

`uvm_component_utils(unspecified_rtest)
unspecified_vrseq vrseq2;

function new (string name = "unspecified_rtest",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
vrseq2 = unspecified_vrseq ::type_id::create("vrseq2");
vrseq2.start(envh.v_seqrh);
#100;
phase.drop_objection(this);
endtask

endclass
