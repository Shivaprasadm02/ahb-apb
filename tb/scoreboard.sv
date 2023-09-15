class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	
	uvm_tlm_analysis_fifo #(ahb_xtn)fifo_ahb;
	uvm_tlm_analysis_fifo #(apb_xtn)fifo_apb;
	
	ahb_xtn Hxtn;
	ahb_xtn ahb_cov;
	apb_xtn Pxtn;
	ahb_xtn hq[$];
	apb_xtn pq[$];
	
covergroup ahb_fcov;
   option.per_instance=1;
   
   C1:coverpoint ahb_cov.Hwrite{ bins read = {0}; bins write= {1};}
   
   C2:coverpoint ahb_cov.Haddr{
      bins S1 = {[32'h 8000_0000:32'h 8000_03ff]};
	  bins S2 = {[32'h 8400_0000:32'h 8400_03ff]};
	  bins S3 = {[32'h 8800_0000:32'h 8800_03ff]};
	  bins S4 = {[32'h 8c00_0000:32'h 8c00_03ff]};}
   
   C3:coverpoint ahb_cov.Hwdata{option.auto_bin_max=8; }
	  
   C4:coverpoint ahb_cov.Hrdata{option.auto_bin_max=1; }
	  
   C5: coverpoint ahb_cov.Hsize{bins add[]={0,2};}
		
   C6:coverpoint ahb_cov.Htrans{bins trans[]={[0:3]};}
   
   C7:cross C1,C2,C5;
endgroup  
	
	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
		ahb_fcov=new();
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		fifo_ahb=new("fifo_ahb",this);
	    fifo_apb=new("fifo_apb",this);
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
	  fork
		  begin
			forever
			begin
			//$display("before getting frm fifo to ahb xtn %p",Hxtn);
			fifo_ahb.get(Hxtn);
		//$display("getting frm fifo to ahb xtn %p",Hxtn);
			`uvm_info(get_type_name,$sformatf("printing ahb from scoreboard \n %s",Hxtn.sprint),UVM_MEDIUM); 
			hq.push_back(Hxtn);
		//$display("ahb q after pushing %p",hq);
			ahb_cov=Hxtn;
			//end
		 // end
			
		  //begin
			//forever
			//begin
			fifo_apb.get(Pxtn);
			pq.push_back(Pxtn);
			`uvm_info(get_type_name,$sformatf("printing apb from scoreboard \n %s",Pxtn.sprint),UVM_MEDIUM);
			//apb_cov=Pxtn;
			check_data();
			end
		  end
		  //check_data();
		join
		
	endtask
	
	function void check_data();
		Hxtn=ahb_xtn::type_id::create("Hxtn");
		Pxtn=apb_xtn::type_id::create("Pxtn");
		
		Hxtn=hq.pop_front();
		//$display("ahb popped %p",Hxtn);
		Pxtn=pq.pop_front();
		//$display("apb popped %p",Pxtn);
		
	  if(Hxtn.Hwrite)
		begin
			case(Hxtn.Hsize)
			2'b00:
			begin
				if(Hxtn.Haddr[1:0]==2'b00)
					compare(Hxtn.Hwdata[7:0],Pxtn.Pwdata[7:0]);
				if(Hxtn.Haddr[1:0]==2'b01)
					compare(Hxtn.Hwdata[15:8],Pxtn.Pwdata[7:0]);
				if(Hxtn.Haddr[1:0]==2'b10)
					compare(Hxtn.Hwdata[23:16],Pxtn.Pwdata[7:0]);
				if(Hxtn.Haddr[1:0]==2'b11)
					compare(Hxtn.Hwdata[31:24],Pxtn.Pwdata[7:0]);
			end
			2'b01:
			begin
				if(Hxtn.Haddr[1:0]==2'b00)
					compare(Hxtn.Hwdata[15:0],Pxtn.Pwdata[15:0]);
				if(Hxtn.Haddr[1:0]==2'b01)
					compare(Hxtn.Hwdata[31:16],Pxtn.Pwdata[15:0]);	
			end
			2'b10:
			begin
				if(Hxtn.Haddr[1:0]==2'b00)
					compare(Hxtn.Hwdata[31:0],Pxtn.Pwdata[31:0]);	
			end
			endcase
		end
	  else
		begin
			case(Hxtn.Hsize)
			2'b00:
			begin
				if(Hxtn.Haddr[1:0]==2'b00)
					compare(Hxtn.Hrdata[7:0],Pxtn.Prdata[7:0]);
				if(Hxtn.Haddr[1:0]==2'b01)
					compare(Hxtn.Hrdata[15:8],Pxtn.Prdata[7:0]);
				if(Hxtn.Haddr[1:0]==2'b10)
					compare(Hxtn.Hrdata[23:16],Pxtn.Prdata[7:0]);
				if(Hxtn.Haddr[1:0]==2'b11)
					compare(Hxtn.Hrdata[31:24],Pxtn.Prdata[7:0]);
			end
			2'b01:
			begin
				if(Hxtn.Haddr[1:0]==2'b00)
					compare(Hxtn.Hrdata[15:0],Pxtn.Prdata[15:0]);
				if(Hxtn.Haddr[1:0]==2'b01)
					compare(Hxtn.Hrdata[31:16],Pxtn.Prdata[15:0]);	
			end
			2'b10:
			begin
				if(Hxtn.Haddr[1:0]==2'b00)
					compare(Hxtn.Hrdata[31:0],Pxtn.Prdata[31:0]);	
			end
			endcase
		end
		
	endfunction
		
	function void compare(int Hdata,Pdata);

		if(Hxtn.Haddr==Pxtn.Paddr)
		`uvm_info("SB","Address compared successfully",UVM_LOW)  
		else
		`uvm_info("SB","Address not compared successfully",UVM_LOW)

		if(Hxtn.Hwrite)
		 begin
			if(Hdata==Pdata)
				`uvm_info("SB","write data matched successfully",UVM_LOW)
			else
				`uvm_info("SB","write data mismatched",UVM_LOW)
		 end

		else
		 begin
			if(Hdata==Pdata)
				`uvm_info("SB","Read data matched successfully",UVM_LOW)
			else
				`uvm_info("SB","Read data mismatched",UVM_LOW)
		 end

//data_verified_count++;
  
		ahb_fcov.sample();
	//apb_fcov.sample(); 

endfunction
	
endclass