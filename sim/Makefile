#Makefile for UVM Testbench
RTL= ../rtl/*
work= work #library name
SVTB1= ../tb/top.sv
INC = +incdir+../tb +incdir+../test +incdir+../ahb_top +incdir+../apb_top
SVTB2 = ../test/bridge_test_pkg.sv
#COVOP = -coveropt 3 +cover=bcft
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"
VSIMBATCH5= -c -do  " log -r /* ;coverage save -onexit mem_cov5;run -all; exit"
VSIMBATCH6= -c -do  " log -r /* ;coverage save -onexit mem_cov6;run -all; exit"
help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                             											!"
	@echo "! clean      =>  clean the earlier log and intermediate files.       				!"
	@echo "! sv_cmp    	=>  Create library and compile the code.                   			!"
	@echo "! run_sim    =>  run the simulation in batch mode.                   				!"
	@echo "! run_test	  =>  clean, compile & run the simulation for single_test in batch mode.            !"
	@echo "! run_test1	=>  clean, compile & run the simulation for unspecified_test in batch mode.            !"  
	@echo "! run_test2	=>  clean, compile & run the simulation for increment_test in batch mode.            !"  
	@echo "! run_test3	=>  clean, compile & run the simulation for wrapping_test in batch mode.            !"  
	@echo "! run_test4	=>  clean, compile & run the simulation for single_rtest in batch mode.            !"  
	@echo "! run_test5	=>  clean, compile & run the simulation for unspecified_rtest in batch mode.            !"  
	@echo "! view_wave1 =>  To view the waveform of signle_test	    					                            !" 
	@echo "! view_wave2 =>  To view the waveform of unspecified_test                                      !"
	@echo "! view_wave3 =>  To view the waveform of increment_test                                      !"
	@echo "! view_wave4 =>  To view the waveform of wrapping_test                                      !"
	@echo "! view_wave5 =>  To view the waveform of single_rtest                                      !"
	@echo "! view_wave6 =>  To view the waveform of unspecified_rtest                                      !"
	@echo "! regress    =>  clean, compile and run all testcases in batch mode.		    	                  !"
	@echo "! report     =>  To merge coverage reports for all testcases and  convert to html format.			!"
	@echo "! cov        =>  To open merged coverage report in html format.	            !"
	@echo ====================================================================================================================

sv_cmp:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1) 

run_test:sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -wlf wave_file1.wlf -l test1.log  -sv_seed 4029272016 work.top +UVM_TESTNAME=single_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1

run_test1:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -wlf wave_file2.wlf -l test2.log  -sv_seed 1867024723  work.top +UVM_TESTNAME=unspecified_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov2

run_test2:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3)  -wlf wave_file3.wlf -l test3.log  -sv_seed 1390751523  work.top +UVM_TESTNAME=increment_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov3
 
run_test3:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4)  -wlf wave_file4.wlf -l test4.log  -sv_seed random  work.top +UVM_TESTNAME=wrapping_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov4

run_test4:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH5)  -wlf wave_file5.wlf -l test5.log  -sv_seed 1450140179  work.top +UVM_TESTNAME=single_rtest
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov5

run_test5:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH6)  -wlf wave_file6.wlf -l test6.log  -sv_seed 2234456813  work.top +UVM_TESTNAME=unspecified_rtest
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov6

view_wave1:
	vsim -view wave_file1.wlf
	
view_wave2:
	vsim -view wave_file2.wlf
 
view_wave3:
	vsim -view wave_file3.wlf

view_wave4:
	vsim -view wave_file4.wlf

view_wave5:
	vsim -view wave_file5.wlf

view_wave6:
	vsim -view wave_file6.wlf

report:
	vcover merge mem_cov mem_cov1 mem_cov2 mem_cov3 mem_cov4 mem_cov5 mem_cov6 
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

regress: clean run_test run_test1 run_test2 run_test3 run_test4 run_test5 report cov

cov:
	firefox covhtmlreport/index.html&
 
clean:
	rm -rf transcript* *log*  vsim.wlf fcover* covhtml* mem_cov* *.wlf modelsim.ini
	clear


