class test extends uvm_test;
  `uvm_component_utils(test)
  enivornment env;
  write_data seq1;
  read_data seq2;
  write_read_data seq3;
  
  function new(string name="test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = enivornment::type_id::create("env",this);
    seq1 = write_data::type_id::create("seq1");
    seq2 = read_data::type_id::create("seq2");
    seq3 = write_read_data::type_id::create("seq3");
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq1.start(env.agen.sqnr);
    seq2.start(env.agen.sqnr);
    seq3.start(env.agen.sqnr);
    #20;
    phase.drop_objection(this);
  endtask
endclass
