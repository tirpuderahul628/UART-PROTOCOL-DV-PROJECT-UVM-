class rand_baud_len5p extends uvm_sequence#(transaction);
    `uvm_object_utils(rand_baud_len5p)
    transaction tr;

    function new(string name="rand_baud_len5p");
        super.new(name);
    endfunction

    virtual task body();
        repeat(5)
        begin
            tr=transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize);
            tr.op=length5wp;
            tr.rst=1'b0;
            tr.tx_data={3'b000,tr.tx_data[7:3]};
            tr.length=5;
            tr.tx_start=1'b1;
            tr.rx_start=1'b1;
            tr.parity_en=1'b1;
            tr.stop2=1'b0;
            finish_item(tr);
        end
    endtask
endclass
