class vbase_seq extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(vbase_seq)
	
	ahb_sequencer ahb_seqrh[];
	apb_sequencer apb_seqrh[];
	
	virtual_sequencer vsqrh;
	
	env_cfg m_cfg;
	
 	function new(string name = "vbase_seq");
		super.new(name);
	endfunction
	
	task body();
		if(!uvm_config_db #(env_cfg) ::get(null,get_full_name(),"env_cfg",m_cfg))
			`uvm_fatal("VBASE CONFIG","unable to GET");

		apb_seqrh = new[m_cfg.no_of_Pagent];
		ahb_seqrh = new[m_cfg.no_of_Hagent];
 
		if(!($cast(vsqrh,m_sequencer)))
			`uvm_error("BODY", "Error in $cast of virtual sequencer")
		foreach(ahb_seqrh[i])  
			ahb_seqrh[i] = vsqrh.ahb_seqrh[i];
		foreach(apb_seqrh[i])
			apb_seqrh[i] = vsqrh.apb_seqrh[i];
	endtask

endclass 


//-------------single sequence----------

class single_vseq extends vbase_seq;

`uvm_object_utils(single_vseq)
ahb_single_seq seq1;

	function new(string name = "single_vseq");
		super.new(name);
	endfunction

	task body();
		super.body;
		seq1 = ahb_single_seq :: type_id :: create("seq1");
		if(m_cfg.has_Hagent)
		begin
			for(int i=0;i<m_cfg.no_of_Hagent;i++)
			begin
				seq1.start(ahb_seqrh[i]);
			end
		end
	endtask
 
endclass 

//--unspecified sequence-------//

class unspecified_vseq extends vbase_seq;

`uvm_object_utils(unspecified_vseq)
ahb_unspecified_seq seq2;

	function new(string name = "unspecified_vseq");
		super.new(name);
	endfunction

	task body();
		super.body;
		seq2 = ahb_unspecified_seq :: type_id :: create("seq2");
		if(m_cfg.has_Hagent)
		begin
			for(int i=0;i<m_cfg.no_of_Hagent;i++)
			begin
				seq2.start(ahb_seqrh[i]);
			end
		end
	endtask
 
endclass 

//----incremental
class incr_vseq extends vbase_seq;

`uvm_object_utils(incr_vseq)
ahb_incremental_seq seq3;

	function new(string name = "incr_vseq");
		super.new(name);
	endfunction

	task body();
		super.body;
		seq3 = ahb_incremental_seq :: type_id :: create("seq3");
		if(m_cfg.has_Hagent)
		begin
			for(int i=0;i<m_cfg.no_of_Hagent;i++)
			begin
				seq3.start(ahb_seqrh[i]);
			end
		end
	endtask
 
endclass 

//------wrapping----
class wrapping_vseq extends vbase_seq;

`uvm_object_utils(wrapping_vseq)
ahb_wrapping_seq seq4;

	function new(string name = "wrapping_vseq");
		super.new(name);
	endfunction

	task body();
		super.body;
		seq4 = ahb_wrapping_seq :: type_id :: create("seq4");
		if(m_cfg.has_Hagent)
		begin
			for(int i=0;i<m_cfg.no_of_Hagent;i++)
			begin
				seq4.start(ahb_seqrh[i]);
			end
		end
	endtask
 
endclass 

//-------------single read sequence----------

class single_vrseq extends vbase_seq;

`uvm_object_utils(single_vrseq)
ahb_single_rseq rseq1;

	function new(string name = "single_vrseq");
		super.new(name);
	endfunction

	task body();
		super.body;
		rseq1 = ahb_single_rseq :: type_id :: create("rseq1");
		if(m_cfg.has_Hagent)
		begin
			for(int i=0;i<m_cfg.no_of_Hagent;i++)
			begin
				rseq1.start(ahb_seqrh[i]);
			end
		end
	endtask
 
endclass


///////--unspecified read sequence-------//////

class unspecified_vrseq extends vbase_seq;

`uvm_object_utils(unspecified_vrseq)
ahb_unspecified_rseq rseq2;

	function new(string name = "unspecified_vrseq");
		super.new(name);
	endfunction

	task body();
		super.body;
		rseq2 = ahb_unspecified_rseq :: type_id :: create("rseq2");
		if(m_cfg.has_Hagent)
		begin
			for(int i=0;i<m_cfg.no_of_Hagent;i++)
			begin
				rseq2.start(ahb_seqrh[i]);
			end
		end
	endtask
 
endclass 
