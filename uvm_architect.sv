 //squence item

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


        //sequencer

class packet_sequencer extends uvm_sequencer #(packet);
  `uvm_sequencer_utils(packet_sequencer)
     function new(string name, uvm_component parent);
       super.new(name,parent);
        // `uvm_update_sequence_lib_and_item(packet)
          endfunction
     endclass


        //driver extends

 class driver extends uvm_driver #(packet);
   `uvm_component_utils(driver)
    function new(string name, uvm_component parent);
       super.new(name,parent);
     endfunction
       virtual task run();
         `uvm_info("Trace","driver receive the sequence",UVM_MEDIUM)
        forever begin
              seq_item_port.get_next_item(req);
              req.print();
              seq_item_port.item_done();
            end
          endtask
        endclass


        //environment extends

        class router_env extends uvm_env;
          `uvm_component_utils(router_env)
          packet_sequencer seqr;
          driver drv;
          function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
          virtual function void build();
            super.build();
            seqr=packet_sequencer::type_id::create("seqr",this);
            drv=driver::type_id::create("drv",this);
            endfunction
          virtual function void connect();
            drv.seq_item_port.connect(seqr.seq_item_export);
          endfunction
        endclass


        //testcase extends
        class test_base extends uvm_test;
          router_env env;
          `uvm_component_utils(test_base)
          function new(string name,uvm_component parent);
            super.new(name,parent);
          endfunction
          virtual function void build();
            super.build();
            env=router_env::type_id::create("env",this);
            set_config_string("*.seqr","default_sequence","packet_sequence");
          endfunction
        endclass


        //user sequence
        class packet_sequence extends uvm_sequence #(packet);
          `uvm_sequence_utils(packet_sequence,packet_sequencer)
          function new(string name="packet_sequence");
            super.new(name);
          endfunction
          virtual task body();
            begin
              `uvm_info("","give sequence to sequencer",UVM_MEDIUM);
              `uvm_do(req);
              `uvm_do(req);
              `uvm_do(req);
              `uvm_do_with(req,{sa==3;})
            end
          endtask
        endclass

 module top;
   initial begin
     run_test();
   end
 endmodule
         
        
