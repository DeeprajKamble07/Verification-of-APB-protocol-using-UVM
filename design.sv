module apb(input pclk,prst,psel,penable,pwrite,
           input [31:0] pwdata,paddr,
           output reg [31:0] prdata,
           output reg pready, pslverr);
  
  reg [31:0] mem [0:31];
  
  typedef enum {idle,setup,access,transfer} state_type;
  state_type state=idle;
  
  always@(posedge pclk)
    begin
      if(prst)
        begin
          state<=idle;
          prdata=32'h0;
          pready<=0;
          pslverr<=0;
          for(int i=0;i<32;i++)
            begin
              mem[i]<=0;
            end
        end
      
      else
        begin
          case(state)
            
            idle: begin
              prdata=32'h0;
              pready<=0;
              pslverr<=0;
              state<=setup;
            end
            
            setup: begin
              if(psel)
                state<=access;
              else
                state<=setup;
            end
            
            access: begin
              if(pwrite && penable)
                begin
                  if(paddr<32)
                    begin
                      mem[paddr]<=pwdata;
                      state<=transfer;
                      pready<=1;
                      pslverr<=0;
                    end
                  else
                    begin
                      state<=transfer;
                      pready<=1;
                      pslverr<=1;
                    end
                end
              
              else if(!pwrite && penable)
                begin
                  if(paddr<32)
                    begin
                      prdata<=mem[paddr];
                      state<=transfer;
                      pready<=1;
                      pslverr<=0;
                    end
                  else
                    begin
                      state<=transfer;
                      pready<=1;
                      pslverr<=1;
                      prdata<=32'hx;
                    end
                end
              
              else
                begin
                  state<=setup;
                end
            end
            
            transfer: begin
              state<=setup;
              pready<=0;
              pslverr<=0;
            end
            
            default: begin
              state<=idle;
            end
            
          endcase
        end
    end
endmodule
