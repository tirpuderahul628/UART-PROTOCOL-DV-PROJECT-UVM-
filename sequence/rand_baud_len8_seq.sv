class rand_baud_len8 extends uvm_sequence#(transaction);
    `uvm_object_utils(rand_baud_len8)

    transaction tr;

    function new(string name="rand_baud_len8");
        super.new(name);
    endfunction

    virtual task body();
        repeat(5)
        begin
            tr=transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize);
            tr.op=length8wop;
            tr.rst=1'b0;
            tr.length=8;
            tr.tx_data=tr.tx_data[7:0];
            tr.tx_start=1'b1;
            tr.rx_start=1'b1;
            tr.parity_en=1'b0;
            tr.stop2=1'b0;
            finish_item(tr);
        end
    endtask
endclass
