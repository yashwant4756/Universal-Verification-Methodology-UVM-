interface fifo_inf();
    logic clk;
    bit [3:0] sa,da;
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

class driver;
  virtual fifo_inf vif;
  function new(virtual fifo_inf vif);
    this.vif=vif;
  endfunction
    task test();
      @(vif.clk)
         vif.sa=0;vif.da=0;
                vif.sa=1;
                vif.da=5;
                vif.sa=1;
                vif.da=7;
                vif.da=10;
                vif.sa=3;
    endtask
endclass

module top;
  fifo_inf vif();
  driver dr0;
  monitor m0;
  always  #5  vif.clk=~vif.clk;
  initial begin
    vif.clk=0;
    dr0=new(vif);
    dr0.test();
    m0= new(vif);
    m0.run();
    #100 $finish;
  end  
endmodule
  
