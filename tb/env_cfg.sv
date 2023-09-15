class env_cfg extends uvm_object;
`uvm_object_utils(env_cfg)

bit has_virtual_sequencer=1;
bit has_Hagent=1;
bit has_Pagent=1;
bit has_scoreboard=1;

ahb_agt_cfg ahb_cfg[];
apb_agt_cfg apb_cfg[];

int no_of_Hagent=1;
int no_of_Pagent=4;

function new(string name="bridge_env_config");
	super.new(name);
endfunction

endclass

