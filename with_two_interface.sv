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
module testbench(fifo_inf vif0, fifo_inf vif1);
   monitor m0;
  monitor m1;
  initial begin
    vif0.clk=0;
    vif1.clk=0;
    forever begin
      #5 vif0.clk=~vif0.clk;
      #7 vif1.clk=~vif1.clk;
    end
  end
  initial begin
    vif0.sa=0;vif0.da=0;
    #10 vif0.sa=1;
    #5 vif0.sa=5;
    #15 vif0.da=1;
    #4 vif0.da=7;
    #20 vif0.da=10;
    #2 vif0.sa=3;
  end
    initial begin
    vif1.sa=0;vif1.da=0;
    #11 vif1.sa=2;
    #5 vif1.sa=6;
    #14 vif1.da=1;
    #4 vif1.da=9;
    #18 vif1.da=12;
    #2 vif1.sa=4;
  end
  initial begin
    m0 = new(vif0);
    m0.run();
    m1= new(vif1);
    m1.run();
    #3000 $finish;
  end
endmodule

module top;
  fifo_inf vif0();
  fifo_inf vif1();
  testbench tb0(vif0, vif1);
endmodule
  
