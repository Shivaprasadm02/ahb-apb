//------------------------base sequence class---------------------------------
class ahb_base_seq extends uvm_sequence#(ahb_xtn);
	`uvm_object_utils(ahb_base_seq)
	
	//var for local use
	int i,addr,size,burst,write,length;
	
	function new(string name="ahb_base_seq");
		super.new(name);
	endfunction
endclass

//------------------single sequence extends--------------------------------- frm base seqs
class ahb_single_seq extends ahb_base_seq;
	`uvm_object_utils(ahb_single_seq)
	function new(string name="ahb_single_seq");
		super.new(name);
	endfunction
	task body();
	//repeating 10 times so that all possibility of hsize is covered,
	//constraint for hsize is written in trans class so no need to add constraint for it here
	repeat(10)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b10;Hburst==3'b000;});
	finish_item(req);
	end
//including IDLE Transfer
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Htrans==2'b00;});
	finish_item(req);
	end
	endtask
endclass

//----------------------unspecified sequence---------------------------
class ahb_unspecified_seq extends ahb_base_seq;
	`uvm_object_utils(ahb_unspecified_seq)
	
	function new(string name="ahb_unspecified_seq");
		super.new(name);
	endfunction
	
	task body();
	//int i,addr,size,burst;
	//1st transfer is non-seq so trans is 10, 
	//for unspecified burst is 001
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b10;Hburst==3'b001;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	length=req.length;
	finish_item(req);
	end
	
	//sequential Transfer
	for(i=0;i<length-1;i++)
	begin
	//1byte
	if(size==0)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b001;Haddr==addr+1'b1;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//2bytes
	if(size==1)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b001;Haddr==addr+2'd2;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//4byte
	if(size==2)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b001;Haddr==addr+3'd4;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	end
	//including IDLE Transfer
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Htrans==2'b00;});
	finish_item(req);
	end
	
	endtask
endclass

//-----------------incremental sequence ----------------------------

class ahb_incremental_seq extends ahb_base_seq;
	`uvm_object_utils(ahb_incremental_seq)
	
	function new(string name="ahb_incremental_seq");
		super.new(name);
	endfunction
	
	task body();
	//int i,addr,size,burst;
	
	//1st transfer is non-seq so trans is 10, 
	//for incremental burst is 3/5/7
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b10;Hburst inside{3,5,7};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	write=req.Hwrite;
	finish_item(req);
	end
	//sequential Transfer
	//-----Increment 4---------
	if(burst==3)
	begin
	for(i=0;i<3;i++)
	begin
	//1byte
	if(size==0)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b011;Haddr==addr+1;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//2bytes
	if(size==1)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b011;Haddr==addr+2;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//4byte
	if(size==2)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b011;Haddr==addr+4;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	end
	end
	
	//-------------Increment 8----------------
	if(burst==5)
	begin
	for(i=0;i<7;i++)
	begin
	//1byte
	if(size==0)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b101;Haddr==addr+1'b1;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//2bytes
	if(size==1)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b101;Haddr==addr+2;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//4byte
	if(size==2)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b101;Haddr==addr+4;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	end
	end
	
	//------------------------Increment 16---------------------------------
	if(burst==7)
	begin
	for(i=0;i<15;i++)
	begin
	//1byte
	if(size==0)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b111;Haddr==addr+1;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//2bytes
	if(size==1)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b111;Haddr==addr+2;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//4byte
	if(size==2)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==3'b111;Haddr==addr+4;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	end
	end
	
	//-------------including IDLE Transfer-----------------
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Htrans==2'b00;});
	finish_item(req);
	end

	endtask
endclass

//---------------------------------------wrapping sequence---------------------------


class ahb_wrapping_seq extends ahb_base_seq;
	`uvm_object_utils(ahb_wrapping_seq)
	
	function new(string name="ahb_wrapping_seq");
		super.new(name);
	endfunction
	
	task body();
	int i,addr,size,burst;
	//1st transfer is non-seq so trans is 10, 
	//for wrapping burst is 2/4/6
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b10;Hburst inside{2,4,6};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	
	
	//sequential Transfer
	//-----------Wrapp 4----------------
	if(burst==2)
	begin
	for(i=0;i<3;i++)
	begin
	//1byte
	if(size==0)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==2;Haddr=={addr[31:2],addr[1:0]+1};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//2bytes
	if(size==1)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==2;Haddr=={addr[31:3],addr[2:0]+2};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//4byte
	if(size==2)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==2;Haddr=={addr[31:4],addr[3:0]+4};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	end
	end
	//-------------Wrapp 8----------------
	if(burst==4)
	begin
	for(i=0;i<7;i++)
	begin
	//1byte
	if(size==0)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==4;Haddr=={addr[31:3],addr[2:0]+1};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//2bytes
	if(size==1)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==4;Haddr=={addr[31:4],addr[3:0]+2};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//4byte
	if(size==2)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==4;Haddr=={addr[31:5],addr[4:0]+4};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	end
	end
	//------------------------Wrapp 16---------------------------------
	if(burst==6)
	begin
	for(i=0;i<15;i++)
	begin
	//1byte
	if(size==0)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==6;Haddr=={addr[31:4],addr[3:0]+1};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//2bytes
	if(size==1)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==6;Haddr=={addr[31:5],addr[4:0]+2};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//4byte
	if(size==2)
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b1;soft Htrans==2'b11;Hburst==6;Haddr=={addr[31:6],addr[5:0]+4};});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	burst=req.Hburst;
	finish_item(req);
	end
	end
	end
	//-------------including IDLE Transfer-----------------
	begin
	//req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Htrans==2'b00;});
	finish_item(req);
	end
	end
	endtask
		
endclass

////////////---single sequence for read-----/////

//------------------single sequence extends--------------------------------- frm base seqs
class ahb_single_rseq extends ahb_base_seq;
	`uvm_object_utils(ahb_single_rseq)
	function new(string name="ahb_single_rseq");
		super.new(name);
	endfunction
	task body();
	//repeating 10 times so that all possibility of hsize is covered,
	//constraint for hsize is written in trans class so no need to add constraint for it here
	repeat(10)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==1'b0;soft Htrans==2'b10;Hburst==3'b000;});
	finish_item(req);
	end
//including IDLE Transfer
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Htrans==2'b00;});
	finish_item(req);
	end
	endtask
endclass

//----------------------unspecified read sequence---------------------------
class ahb_unspecified_rseq extends ahb_base_seq;
	`uvm_object_utils(ahb_unspecified_rseq)
	
	function new(string name="ahb_unspecified_rseq");
		super.new(name);
	endfunction
	
	task body();
	//int i,addr,size,burst;
	//1st transfer is non-seq so trans is 10, 
	//for unspecified burst is 001
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==0;soft Htrans==2'b10;Hburst==3'b001;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	length=req.length;
	finish_item(req);
	end
	
	//sequential Transfer
	for(i=0;i<length-1;i++)
	begin
	//1byte
	if(size==0)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==0;soft Htrans==2'b11;Hburst==3'b001;Haddr==addr+1'b1;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//2bytes
	if(size==1)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==0;soft Htrans==2'b11;Hburst==3'b001;Haddr==addr+2'd2;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	
	//4byte
	if(size==2)
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Hwrite==0;soft Htrans==2'b11;Hburst==3'b001;Haddr==addr+3'd4;});
	addr=req.Haddr;
	size=req.Hsize;
	burst=req.Hburst;
	finish_item(req);
	end
	end
	//including IDLE Transfer
	begin
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with{Htrans==2'b00;});
	finish_item(req);
	end
	
	endtask
endclass
