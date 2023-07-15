class transaction extends uvm_sequence_item;
  rand bit [3:0] sa,da;
  rand bit [7:0] payload[$];
  constraint valid{payload.size inside {[2:100]};}
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(sa,UVM_ALL_ON)
  `uvm_field_int(da,UVM_ALL_ON)
  `uvm_field_queue_int(payload, UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name ="transaction");
    super.new(name);
  endfunction
endclass

class initiator extends uvm_component;
  `uvm_component_utils(initiator)
  uvm_analysis_port #(transaction) analysis_port;
  function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
  virtual function void build();
    super.build();
    analysis_port = new("analysis_port",this);
  endfunction
  
  virtual task run();
    repeat(10) begin
      transaction tr = transaction::type_id::create("tr",this);
      tr.randomize();
      analysis_port.write(tr);
    end
  endtask
endclass

class subscriber0 extends uvm_component;
  `uvm_component_utils(subscriber0)
  uvm_analysis_imp #(transaction,subscriber0) analysis_export;
  function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
  virtual function void build();
    super.build();
    analysis_export = new("analysis_export",this);
  endfunction
  virtual function void write(transaction tr);
        $display("Data received by subscriber0");
    $display("Write data is %0d",tr.sa);
  endfunction
    endclass 
class subscriber1 extends uvm_component;
  `uvm_component_utils(subscriber1)
  uvm_analysis_imp #(transaction,subscriber1) analysis_export;
  function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
  virtual function void build();
    super.build();
    analysis_export = new("analysis_export",this);
  endfunction
  
  virtual function void write(transaction tr);
    $display("Data received by subscriber1");
    $display("Write data is %0d",tr.sa);
  endfunction
    endclass
class subscriber2 extends uvm_component;
  `uvm_component_utils(subscriber2)
  uvm_analysis_imp #(transaction,subscriber2) analysis_export;
  function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
  virtual function void build();
    super.build();
    analysis_export = new("analysis_export",this);
  endfunction
  
  virtual function void write(transaction tr);
     $display("Data received by subscriber2");
    $display("Write data is %0d",tr.sa);
  endfunction
    endclass
      
      
    class environment extends uvm_env;
       `uvm_component_utils(environment)
          initiator intr;
          subscriber0 s0;
          subscriber1 s1;
          subscriber2 s2;
          function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
          virtual function void build();
            super.build();
            intr=initiator::type_id::create("intr",this);
            s0=subscriber0::type_id::create("s0",this);
            s1=subscriber1::type_id::create("s1",this);
            s2=subscriber2::type_id::create("s2",this);
            endfunction
          virtual function void connect();
            intr.analysis_port.connect(s0.analysis_export);
            intr.analysis_port.connect(s1.analysis_export);
            intr.analysis_port.connect(s2.analysis_export);
          endfunction
        endclass
    
     class test_base extends uvm_test;
          environment env;
          `uvm_component_utils(test_base)
          function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
          virtual function void build();
            super.build();
            env=environment::type_id::create("env",this);
          endfunction
        endclass
     
 module top;
   initial begin
     run_test();
   end
 endmodule
