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

class producer extends uvm_component;
  `uvm_component_utils(producer)
  uvm_blocking_put_port #(transaction) put_port;
  function new(string name="producer",uvm_component parent);
            super.new(name,parent);
          endfunction
  virtual function void build();
    super.build();
  put_port = new("put_port", this);
 endfunction
 virtual task run();
   repeat(5) begin
     transaction tr = transaction::type_id::create("tr",this);
     if(!tr.randomize())
       `uvm_fatal("FATAL","Failed randomization");
     put_port.put(tr);
  end
 endtask
endclass
  

class consumer extends uvm_component;
  transaction tr;
  `uvm_component_utils(consumer)
  uvm_blocking_put_imp #(transaction,consumer) put_export;
  function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
  virtual function void build();
    put_export=new("put_export",this);
  endfunction
    virtual task put(transaction tr);
      $display("Recieved packet  = %0d",tr.sa);
 endtask
endclass


        //environment extends

     class environment extends uvm_env;
       `uvm_component_utils(environment)
          producer p;
          consumer c;
          function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
          virtual function void build();
            super.build();
            p=producer::type_id::create("p",this);
            c=consumer::type_id::create("c",this);
            endfunction
          virtual function void connect();
            p.put_port.connect(c.put_export);
          endfunction
        endclass


        //testcase extends
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
         
