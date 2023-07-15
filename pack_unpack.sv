class packet extends uvm_sequence_item;
  rand bit [31:0] sa,da;
  rand bit [15:0] len;
  rand bit [7:0] payload[$];
  rand bit [31:0] fcs;
  `uvm_object_utils_begin(packet)
  `uvm_field_int(sa,UVM_ALL_ON |UVM_NOPRINT)
  `uvm_field_int(da,UVM_ALL_ON)
  `uvm_field_queue_int(payload, UVM_ALL_ON)
  `uvm_field_int(fcs,UVM_ALL_ON);
  `uvm_object_utils_end
  function new(string name="packet");
    super.new(name);
    this.fcs.rand_mode(0);
  endfunction
endclass

module test;
  import uvm_pkg::*;
packet pkt0,pkt1,pkt2;
  bit bit_stream[];
  initial begin
  pkt0 = packet::type_id::create("pkt0");
  pkt1 = packet::type_id::create("pkt1");
  pkt0.da = 10;
  pkt0.print();
  pkt0.copy(pkt1);
    pkt1.print();
  $cast(pkt2,pkt1.clone());
    pkt2.print();
    pkt2.randomize();
    pkt0.pack(bit_stream);
     $display("the packed arrray = %0p",bit_stream);
  pkt2.unpack(bit_stream);
    $display("the unpacked arrray = %0p",bit_stream);
    if(pkt1.compare(pkt2)) begin
     `uvm_fatal("MISMATCH",{"\n",pkt0.sprint(),pkt2.sprint()});   
    end
  end
endmodule
  
  
