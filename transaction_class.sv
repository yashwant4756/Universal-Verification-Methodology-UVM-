class packet extends uvm_sequence_item;
  rand bit [3:0] sa,da;
  rand bit [7:0] payload[$];
  constraint valid{payload.size inside {[2:100]};}
  `uvm_object_utils_begin(packet)
  `uvm_field_int(sa,UVM_ALL_ON)
  `uvm_field_int(da,UVM_ALL_ON)
  `uvm_field_queue_int(payload, UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name ="packet");
    super.new(name);
  endfunction
endclass

module test;
  initial begin
  packet obj0;
  obj0=new();
  obj0.randomize();
  obj0.print();
  end
  initial begin
    packet obj1;
    packet obj2;
    obj1=new();
    obj2=new();
    obj1.randomize();
    obj1.print();
    //copy method
    obj2.copy(obj1);
    obj2.print();
     //matching case 
    if(obj1.compare(obj2))
       `uvm_info("","obj1 is matching with obj2",UVM_LOW)
    else
      `uvm_error("","obj1 is not matching with obj2")
  end
  initial begin
    packet obj3;
    packet obj4;
    obj3=new();
    obj4=new();
    obj3.randomize();
    obj4.randomize();
    obj3.print();
    obj4.print();
    
    //compare method
    if(obj3.compare(obj4))
      `uvm_info("","obj3 is matching with obj4",UVM_LOW)
    else
      `uvm_error("","obj3 is not matching with obj4")
  end
endmodule
  
