
class rand_baud_len6 extends uvm_sequence#(transaction);
    `uvm_object_utils(rand_baud_len6)

    transaction tr;

    function new(string name="rand_baud_len6");
        super.new(name);
    endfunction

    virtual task body();
        repeat(5)
        begin
            tr=transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize);
            tr.op=length6wop;
            tr.rst=1'b0;
            tr.length=6;
            tr.tx_data={2'b00,tr.tx_data[7:2]};
            tr.tx_start=1'b1;
            tr.rx_start=1'b1;
            tr.parity_en=1'b0;
            tr.stop2=1'b0;
            finish_item(tr);
        end
    endtask
endclass
