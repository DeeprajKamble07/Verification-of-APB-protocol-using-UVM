interface intf;
  logic pclk,prst,pwrite,penable,psel;
  logic [31:0] pwdata,paddr;
  logic [31:0] prdata;
  logic pready,pslverr;
endinterface
