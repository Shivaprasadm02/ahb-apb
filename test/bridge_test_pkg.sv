package bridge_test_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "ahb_xtn.sv"
	`include "apb_xtn.sv"

	`include "ahb_agt_cfg.sv"
	`include "apb_agt_cfg.sv"
	`include "env_cfg.sv"

	`include "ahb_drv.sv"
	`include "ahb_mon.sv"
	`include "ahb_seqr.sv"
	`include "ahb_agent.sv"
	`include "ahb_agt_top.sv"
	`include "ahb_seqs.sv"

	`include "apb_drv.sv"
	`include "apb_mon.sv"
	`include "apb_seqr.sv"
	`include "apb_agent.sv"
	`include "apb_agt_top.sv"

	`include "scoreboard.sv"

	`include "virtual_seqr.sv"
	`include "virtual_seqs.sv"

	`include "bridge_env.sv"
	`include "test.sv"

endpackage
