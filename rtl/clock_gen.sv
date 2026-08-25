//////////////////////Clock Generator////////////////////////
module clk_gen(
input clk,rst,
  input [16:0] baud, // maximum baud rate for uart is 921000 after that there will be high bit error rate according to texas instruments
output reg tx_clk,rx_clk
);

int rx_max=0, tx_max=0; 
int rx_count=0, tx_count=0; 

// Storing rx_max and tx_max (Values halved to account for full clock period toggles)
always@(posedge clk) begin
    if(rst) begin
        rx_max<=0;
        tx_max<=0;
    end
    else begin
        case(baud)
            4800 : begin
                rx_max <=11'd325;
                tx_max <=14'd5208;
            end
            9600 : begin
                rx_max <=11'd162;
                tx_max <=14'd2604;
            end
            14400 : begin
                rx_max <=11'd108;
                tx_max <=14'd1736;
            end
            19200 : begin
                rx_max <=11'd81;
                tx_max <=14'd1302;
            end
            38400: begin
                rx_max <=11'd40;
                tx_max <=14'd651;
            end
            57600 : begin
                rx_max <=11'd27;
                tx_max <=14'd434;
            end
            115200: begin
                rx_max<=11'd13;
                tx_max<=14'd217;
            end
            128000: begin
                rx_max <=11'd12;
                tx_max <=14'd196;
            end
            default: begin
                rx_max <=11'd162;
                tx_max <=14'd2604;
            end
        endcase
    end
end

//////////////////////rx_clk////////////////////////
always@(posedge clk)
begin
    if(rst)
    begin
        rx_count<=0;
        rx_clk<=0;
    end
    else
    begin
        if(rx_count<rx_max)
        begin
            rx_count<=rx_count+1;
        end
        else
        begin
            rx_clk<=~rx_clk;
            rx_count<=0;
        end
    end
end

//////////////////////tx_clk////////////////////////
always@(posedge clk)
begin
    if(rst)
    begin
        tx_count<=0;
        tx_clk<=0;
    end
    else
    begin
        if(tx_count<tx_max)
        begin
            tx_count<=tx_count+1;
        end
        else
        begin
            tx_clk<=~tx_clk;
            tx_count<=0;
        end
    end
end

endmodule

