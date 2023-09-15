class ahb_agt_cfg extends uvm_object;

`uvm_object_utils(ahb_agt_cfg)

virtual ahb_if vif;

uvm_active_passive_enum is_active=UVM_ACTIVE;

function new(string name="ahb_agt_cfg");
  super.new(name);
endfunction

endclass
