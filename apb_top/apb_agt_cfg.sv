class apb_agt_cfg extends uvm_object;

`uvm_object_utils(apb_agt_cfg)

virtual apb_if vif;

uvm_active_passive_enum is_active=UVM_ACTIVE;

function new(string name="apb_agt_cfg");
  super.new(name);
endfunction

endclass
