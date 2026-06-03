# UVM_Example_APB_VIP

## Intro

UVM testbench environment practice for a simple APB VIP

## Verification Environment
```
    Project_root
    │
    ├── README.md
    │    
    ├── doc
    │   └── xxxx
    │
    ├── rtl
    │   └── dut.sv
    │
    ├── sim
    │   └── Makefile
    │ 
    └── tb
        ├── env
        │   ├── apb_agent.sv
        │   ├── apb_coverage.sv
        │   ├── apb_driver.sv
        │   ├── apb_env.sv
        │   ├── apb_monitor.sv
        │   ├── apb_ref_model.sv
        │   ├── apb_scoreboard.sv
        │   ├── apb_sequencer.sv
        │   ├── apb_sequence.sv
        │   └── apb_transaction.sv
        │ 
        ├── interface
        │   └── apb_interface.sv
        │
        ├── package
        │   └── apb_pkg.sv
        │ 
        ├── testcase
        │   └── base_test.sv
        │        
        └── top
            ├── rtl.f
            ├── tb.f
            └── tb_top.sv
```

## Makefile excution
make comp 

make sim TESTNAME=basetest


## UVM testbench topology
```
------------------------------------------------------------------
Name                       Type                        Size  Value
--------------------------------------------------------------------------
uvm_test_top               apb_base_test                       -     @470 
  env                      apb_env                             -     @482 
    agt_mst                apb_agent_mst                       -     @507 
      ap                   uvm_analysis_port                   -     @553 
      apb_drv              apb_driver                          -     @562 
        rsp_port           uvm_analysis_port                   -     @579 
        seq_item_port      uvm_seq_item_pull_port              -     @570 
      apb_imon             apb_imonitor                        -     @711 
        ap                 uvm_analysis_port                   -     @721 
      apb_sqr              apb_sequencer                       -     @588 
        rsp_export         uvm_analysis_export                 -     @596 
        seq_item_export    uvm_seq_item_pull_imp               -     @702 
        arbitration_queue  array                               0     -    
        lock_queue         array                               0     -    
        num_last_reqs      integral                            32    'd1  
        num_last_rsps      integral                            32    'd1  
    agt_slv                apb_agent_slv                       -     @515 
      ap                   uvm_analysis_port                   -     @734 
      apb_omon             apb_omonitor                        -     @743 
        ap                 uvm_analysis_port                   -     @752 
    apb_cov                apb_coverage                        -     @531 
      analysis_imp         uvm_analysis_imp                    -     @539 
      cov_enable           integral                            1     'h1  
    apb_scb                apb_socreboard                      -     @523 
      m_comp               uvm_in_order_class_comparator #(T)  -     @763 
        after              uvm_tlm_analysis_fifo #(T)          -     @851 
          analysis_export  uvm_analysis_imp                    -     @895 
          get_ap           uvm_analysis_port                   -     @886 
          get_peek_export  uvm_get_peek_imp                    -     @868 
          put_ap           uvm_analysis_port                   -     @877 
          put_export       uvm_put_imp                         -     @859 
        after_export       uvm_analysis_export                 -     @780 
        before             uvm_tlm_analysis_fifo #(T)          -     @798 
          analysis_export  uvm_analysis_imp                    -     @842 
          get_ap           uvm_analysis_port                   -     @833 
          get_peek_export  uvm_get_peek_imp                    -     @815 
          put_ap           uvm_analysis_port                   -     @824 
          put_export       uvm_put_imp                         -     @806 
        before_export      uvm_analysis_export                 -     @771 
        pair_ap            uvm_analysis_port                   -     @789 
      mon_in               uvm_analysis_export                 -     @904 
      mon_out              uvm_analysis_export                 -     @913 
--------------------------------------------------------------------------
```


