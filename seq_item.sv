typedef enum bit[1:0] {READ,WRITE,RST} mode;
class seq_item extends uvm_sequence_item;
  `uvm_object_utils(seq_item)
  
  rand mode op;
  rand logic pwrite;
  rand logic [31:0] pwdata,paddr;
  
  logic pready,pslverr;
  logic [31:0] prdata;
  
  constraint c1{paddr inside {[0:31]};}
  
  
  function new(string name="seq_item");
    super.new(name);
    `uvm_info("seq_item","inside the constructor",UVM_HIGH);
  endfunction
endclass
