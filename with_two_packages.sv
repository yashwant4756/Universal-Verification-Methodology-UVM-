package p1;
class trans;
  int data=5;
  function void display();
    $display("Display the value of data is",data);
  endfunction
endclass
endpackage
  
  package p2;
class trans;
  int data=10;
  function void display();
    $display("Display the value of data is",data);
  endfunction
endclass
endpackage
  
  module test;
    initial begin
      p1::trans obj1;
      p2::trans obj2;
      obj1=new();
      obj2=new();
      //obj1=p1::trans::type_id::create("obj1");
      //obj2=p2::trans::type_id::create("obj2");/////because we use create in class
      obj1.display();
      obj2.display();
    end
  endmodule
