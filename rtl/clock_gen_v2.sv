//////////////////////Clock Generator////////////////////////
module clk_gen(
    input clk, rst,
    input [19:0] baud,
    output reg tx_clk, rx_clk
);

int rx_max = 0, tx_max = 0; 
int rx_count = 0, tx_count = 0; 
logic [19:0] baud_prev;

// Storing rx_max and tx_max locked to a 16:1 ratio for 0% relative drift
always @(posedge clk) begin
    if(rst) begin
        rx_max <= 0;
        tx_max <= 0;
    end
    else begin
        case(baud)
            4800   : begin rx_max <= 11'd325; tx_max <= 14'd5215; end
            9600   : begin rx_max <= 11'd162; tx_max <= 14'd2607; end
            14400  : begin rx_max <= 11'd108; tx_max <= 14'd1743; end
            19200  : begin rx_max <= 11'd81;  tx_max <= 14'd1311; end
            38400  : begin rx_max <= 11'd40;  tx_max <= 14'd655;  end
            57600  : begin rx_max <= 11'd26;  tx_max <= 14'd431;  end 
            115200 : begin rx_max <= 11'd13;  tx_max <= 14'd223;  end
            128000 : begin rx_max <= 11'd11;  tx_max <= 14'd191;  end
            230400 : begin rx_max <= 11'd6;   tx_max <= 14'd111;  end 
            256000 : begin rx_max <= 11'd5;   tx_max <= 14'd95;   end 
            460800 : begin rx_max <= 11'd2;   tx_max <= 14'd47;   end 
            500000 : begin rx_max <= 11'd2;   tx_max <= 14'd47;   end 
            576000 : begin rx_max <= 11'd2;   tx_max <= 14'd47;   end 
            921600 : begin rx_max <= 11'd1;   tx_max <= 14'd31;   end 
            default: begin rx_max <= 11'd162; tx_max <= 14'd2607; end
        endcase
    end
end

// Reset counters when baud rate changes on-the-fly
always @(posedge clk) begin
    if(rst) begin
        baud_prev <= '0;
    end else begin
        baud_prev <= baud;
        if(baud != baud_prev) begin
            rx_count <= 0;
            tx_count <= 0;
            rx_clk   <= 0;
            tx_clk   <= 0;
        end
    end
end

//////////////////////rx_clk////////////////////////
always @(posedge clk) begin
    if(rst) begin
        rx_count <= 0;
        rx_clk   <= 0;
    end
    else begin
        if(rx_count < rx_max) begin
            rx_count <= rx_count + 1;
        end
        else begin
            rx_clk   <= ~rx_clk;
            rx_count <= 0;
        end
    end
end

//////////////////////tx_clk////////////////////////
always @(posedge clk) begin
    if(rst) begin
        tx_count <= 0;
        tx_clk   <= 0;
    end
    else begin
        if(tx_count < tx_max) begin
            tx_count <= tx_count + 1;
        end
        else begin
            tx_clk   <= ~tx_clk;
            tx_count <= 0;
        end
    end
end

endmodule
