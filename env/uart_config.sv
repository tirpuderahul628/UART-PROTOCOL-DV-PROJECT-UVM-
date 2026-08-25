`include "uvm_macros.svh"
import uvm_pkg::*;

//configuration of env
class uart_config extends uvm_object;
    `uvm_object_utils(uart_config)

    function new(string name="uart_config");
        super.new(name);
    endfunction

    uvm_active_passive_enum is_active=UVM_ACTIVE;
endclass

//////////////////////////////////////////////////////////////

typedef enum bit[3:0] {
    rand_baud_1_stop=0,
    rand_length_1_stop=1,
    length5wp=2, 
    length6wp=3,
    length7wp=4,
    length8wp=5,
    length5wop=6, 
    length6wop=7,
    length7wop=8,
    length8wop=9,
    rand_baud_2_stop=11,
    rand_length_2_stop=12
} oper_mode;
