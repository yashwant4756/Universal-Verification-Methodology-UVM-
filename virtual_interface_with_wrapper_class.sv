interface intf();
  logic clk;
  bit [3:0] sa,da;
endinterface

class wrapper;
  virtual intf vif;
  function new(virtual intf vif);
    this.vif=vif;
  endfunction
endclass

class monitor;
  wrapper wr;
  function new(wrapper obj);
    wr=obj;
  endfunction
  task run();
    repeat(20) begin
      @(wr.vif.clk)
      $display($time," Dispaly the value of sa is %0d",wr.vif.sa);
      $display($time," Dispaly the value of da is %0d",wr.vif.da);
    end
  endtask
endclass

class driver;
  wrapper wr;
   function new(wrapper obj);
    wr=obj;
  endfunction
  task test();
    @(wr.vif.clk)
         wr.vif.sa=0; wr.vif.da=0;
                wr.vif.sa=1;
                wr.vif.da=5;
                wr.vif.sa=1;
                wr.vif.da=7;
                wr.vif.da=10;
                wr.vif.sa=3;
    endtask
endclass

module top();
  intf vif();
  wrapper wr;
  monitor m;;
  driver dr;
  always #5 vif.clk=~vif.clk;
  initial begin
    vif.clk=0;
    wr=new(vif);
    dr=new(wr);
    m=new(wr);
    
    dr.test();
    m.run();
    #100 $finish;
  end
endmodule
