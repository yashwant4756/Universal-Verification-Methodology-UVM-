program automatic simple_test;
  import uvm_pkg::*;
  class hello_world extends uvm_test;
    `uvm_component_utils(hello_world)
    function new(string name,uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual task run();
      `uvm_info("Normal","Hello world!",UVM_MEDIUM);
    endtask
  endclass
  initial 
    run_test();
  
endprogram
