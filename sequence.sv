class write_data extends uvm_sequence#(seq_item);
  `uvm_object_utils(write_data)
  seq_item item;
  
  function new(string name="write_data");
    super.new(name);
    `uvm_info("write_data seq","inside the constructor",UVM_HIGH);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        item=seq_item::type_id::create("item");
        start_item(item);
        item.randomize();
        item.op=WRITE;
        finish_item(item);
      end
  endtask
endclass

class read_data extends uvm_sequence#(seq_item);
  `uvm_object_utils(read_data)
  seq_item item;
  
  function new(string name="read_data");
    super.new(name);
    `uvm_info("read_data seq","inside the constructor",UVM_HIGH);
  endfunction
  
  task body();
    repeat(15)
      begin
        item=seq_item::type_id::create("item");
        start_item(item);
        item.randomize();
        item.op=READ;
        finish_item(item);
      end
  endtask
endclass


class write_read_data extends uvm_sequence#(seq_item);
  `uvm_object_utils(write_read_data)
  seq_item item;
  
  function new(string name="write_read_data");
    super.new(name);
    `uvm_info("write_read_data seq","inside the constructor",UVM_HIGH);
  endfunction
  
  task body();
    repeat(15)
      begin
        item=seq_item::type_id::create("item");
        start_item(item);
        item.randomize();
        item.op=WRITE;
        finish_item(item);
        
        start_item(item);
        item.randomize();
        item.op=READ;
        finish_item(item);
      end
  endtask
endclass
