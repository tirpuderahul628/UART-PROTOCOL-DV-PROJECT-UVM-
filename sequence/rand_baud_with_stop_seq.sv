//////////////////////////////////////////////////////////////
class rand_baud_with_stop extends uvm_sequence#(transaction);
    `uvm_object_utils(rand_baud_with_stop)

    transaction tr;

    function new(string name="rand_baud_with_stop");
        super.new(name);
    endfunction

    virtual task body();
        repeat(5)
        begin
            tr=transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize);
            tr.op=rand_baud_2_stop;
            tr.rst=1'b0;
            tr.length=8;
            tr.tx_start=1'b1;
            tr.rx_start=1'b1;
            tr.parity_en=1'b1;
            tr.stop2=1'b1;
            finish_item(tr);
        end
    endtask
endclass