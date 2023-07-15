interface fifo_inf();
    logic clk;
  bit [7:0] sa,da;
  endinterface

class monitor;
  virtual fifo_inf vif;
  function new(virtual fifo_inf vif);
    this.vif=vif;
  endfunction
  task run();
    repeat(20) begin
      @(vif.clk)
      $display($time," Dispaly the value of sa is %0d",vif.sa);
      $display($time," Dispaly the value of da is %0d",vif.da);
    end
  endtask
endclass

module testbench( fifo_inf vif);
   monitor m;
  initial begin
    vif.clk=0;
    forever begin
      #5 vif.clk=~vif.clk;
    end
  end
  initial begin
    vif.sa=0;vif.da=0;
    #10 vif.sa=1;
    #5 vif.sa=5;
    #15 vif.da=1;
    #4 vif.da=7;
    #20 vif.da=10;
    #2 vif.sa=3;
    #2000 $finish;
  end
  initial begin
 m = new(vif);
    m.run();
  end
endmodule

module top;
  fifo_inf vif();
  testbench tb(vif);
endmodule
  


      
