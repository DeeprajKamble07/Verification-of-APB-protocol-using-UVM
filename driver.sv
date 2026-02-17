class driver extends uvm_driver#(seq_item);
  `uvm_component_utils(driver)
  virtual intf vif;
  seq_item item;
  function new(string name="driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item=seq_item::type_id::create("item");
    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
 `uvm_error("MON","Unable to access Interface");
  endfunction
  
  task run();
    forever begin
      seq_item_port.get_next_item(item);
      if(item.op==RST)
        begin
          vif.prst<=1'b1;
          vif.psel<=1'b0;
          vif.penable<=1'b0;
          vif.paddr<='h0;
          vif.pwdata<='h0;
          vif.pwrite<=0;
          vif.prdata<='h0;
          @(posedge vif.pclk);
        end
      
      else if(item.op==WRITE)
        begin
          vif.prst<=1'b0;
          vif.psel<=1'b1;
          vif.paddr<=item.paddr;
          vif.pwdata<=item.pwdata;
          vif.pwrite<=1;
          @(posedge vif.pclk);
          vif.penable<=1'b1;
          @(negedge vif.pready);
          vif.penable<=1'b0;
        end
      
      else if(item.op==READ)
        begin
          vif.prst<=1'b0;
          vif.psel<=1'b1;
          vif.paddr<=item.paddr;
          vif.pwrite<=0;
          @(posedge vif.pclk);
          vif.penable<=1'b1;
          @(negedge vif.pready);
          vif.penable<=1'b0;
        end
      seq_item_port.item_done();
    end
  endtask
endclass
