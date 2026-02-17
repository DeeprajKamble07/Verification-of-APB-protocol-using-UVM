class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_analysis_imp #(seq_item,scoreboard) scb_port;
  bit [31:0] arr [0:31];
  bit [31:0] addr;
  bit [31:0] data_r;
  
  function new(string name="scoreboard",uvm_component parent);
    super.new(name,parent);
    scb_port=new("scb_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  function void write(seq_item item);
    if(item.op==RST)
      begin
        `uvm_info("SCB","system reset detected",UVM_NONE);
      end
    
    else if(item.op==WRITE)
      begin
        if(item.pslverr)
          begin
            `uvm_info("SCB","slave error during write",UVM_NONE);
          end
        else
          begin
            arr[item.paddr]=item.pwdata;
            `uvm_info("SCB",$sformatf("write: addr=%0h wdata=%0h arr_write %0h",item.paddr,item.pwdata,arr[item.paddr]),UVM_NONE);
          end
      end
    
    else if(item.op==READ)
      begin
        if(item.pslverr)
          begin
            `uvm_info("SCB","slave error during read",UVM_NONE);
          end
        else
          begin
            data_r=arr[item.paddr];
            if(data_r==item.prdata) begin
              `uvm_info("SCB",$sformatf("DATA MATCH: addr=%0h actual rdata=%0h expected rdata=%0h",item.paddr,item.prdata,data_r),UVM_NONE); end
            else if(data_r==0) begin
              `uvm_info("SCB",$sformatf("data is not present in %0h addr",item.paddr),UVM_NONE);
            end
            else begin
              `uvm_error("SCB",$sformatf("DATA MISS MATCH: addr=%0h actual rdata=%0h expected rdata=%0h",item.paddr,item.prdata,data_r)); end
          end
      end
  endfunction 
endclass
