`include "uvm_macros.svh"
 import uvm_pkg::*;
`include "interface.sv"
`include "seq_item.sv"
`include  "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "enivornment.sv"
`include "test.sv"

module tb;
  intf intff();
  apb dut(.pclk(intff.pclk),.prst(intff.prst),.psel(intff.psel),.penable(intff.penable),.pwrite(intff.pwrite),.pwdata(intff.pwdata),.paddr(intff.paddr),.prdata(intff.prdata),.pready(intff.pready),.pslverr(intff.pslverr));
  
  always #10 intff.pclk=~intff.pclk;
  initial begin
    intff.pclk=0;
  end
  
  initial begin
    uvm_config_db #(virtual intf)::set(null,"*","vif",intff);
    run_test("test");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule
