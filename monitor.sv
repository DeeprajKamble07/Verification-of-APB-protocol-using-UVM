class monitor extends uvm_monitor;
  `uvm_component_utils(monitor);
  seq_item item;
  virtual intf vif;
  uvm_analysis_port #(seq_item) monitor_port;
  function new(string name="monitor",uvm_component parent);
    super.new(name,parent);
    monitor_port=new("monitor_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item=seq_item::type_id::create("item");
    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
 `uvm_error("MON","Unable to access Interface");
 endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.pclk);
      if(vif.prst)
        begin
          item.op=RST;
          monitor_port.write(item);
        end
      
      else if(!vif.prst && vif.pwrite)
        begin
          @(negedge vif.pready);
          item.op=WRITE;
          item.pwdata=vif.pwdata;
          item.paddr=vif.paddr;
          item.pslverr=vif.pslverr;
          monitor_port.write(item);
        end
      
      else if(!vif.prst && !vif.pwrite)
        begin
          @(negedge vif.pready);
          item.op=READ;
          item.prdata=vif.prdata;
          item.paddr=vif.paddr;
          item.pslverr=vif.pslverr;
          monitor_port.write(item);
        end
    end
  endtask
endclass
