class singleton_class;
  import uvm_pkg::*;
  int var1;
  
  static singleton_class single;
  
  protected function new();
  endfunction
  
  static function singleton_class create();
    if(single==null) begin
      $display("Object single is null, so creating new object");
      single=new();
    end
    return single;
  endfunction
endclass

module test;
  singleton_class s1,s2;
  initial begin
     s1 = singleton_class :: create();
    $display (" 1 : s1.var1 = %0d", s1.var1);
    s1.var1 = 10;
    $display (" 2 : s1.var1 = %0d", s1.var1);
  
    s2 = singleton_class :: create();
    $display (" 3 : s2.var1 = %0d", s2.var1);
    
    s2.var1 = 20;
    $display (" 4 : s2.var1 = %0d", s2.var1);
    $display (" 5 : s1.var1 = %0d", s1.var1);
    
  end
endmodule
  
