//////////////////////Uart_receiver////////////////////////
module uart_rx(
    input rx_clk, rx_start,
    input rst, rx,
    input [3:0] length,
    input parity_type, parity_en,
    input stop2,
    output reg [7:0] rx_out,
    output logic rx_done, rx_error
);

logic parity = 0;
logic [7:0] datard = 0;
int count = 0;
int bit_count = 0;

typedef enum bit [2:0] {
    idle             = 0,
    start_bit        = 1,
    recv_data        = 2,
    check_parity     = 3,
    check_first_stop = 4,
    check_sec_stop   = 5,
    done             = 6
} state_type;

state_type state = idle, next_state = idle;

//////////////////////reset detector////////////////////////
always @(posedge rx_clk) begin
    if(rst)
        state <= idle;
    else
        state <= next_state;
end

//////////////////////next_state decoder + output////////////////////////
always @(*) begin
    case(state)
        idle: begin
            rx_done  = 0;
            rx_error = 0;
            if(rx_start && !rx)
                next_state = start_bit;
            else
                next_state = idle;
        end

//////////////////////start_bit////////////////////////
        start_bit: begin
            if(count == 7 && rx) begin
                next_state = idle;
            end
            else if(count == 15) begin
                next_state = recv_data;
            end
            else begin
                next_state = start_bit;
            end
        end

//////////////////////recv_data////////////////////////
        recv_data: begin
            if(count == 15 && bit_count == (length - 1)) begin
                case(length)
                    4'd5: rx_out = {3'b000, datard[7:3]};
                    4'd6: rx_out = {2'b00,  datard[7:2]};
                    4'd7: rx_out = {1'b0,   datard[7:1]};
                    4'd8: rx_out = datard[7:0];
                    default: rx_out = 8'h00;
                endcase

                // Fixed: Calculate parity only on the received bits
                case(length)
                    4'd5: parity = parity_type ? ^datard[7:3] : ~^datard[7:3];
                    4'd6: parity = parity_type ? ^datard[7:2] : ~^datard[7:2];
                    4'd7: parity = parity_type ? ^datard[7:1] : ~^datard[7:1];
                    default: parity = parity_type ? ^datard[7:0] : ~^datard[7:0];
                endcase

                if(parity_en)
                    next_state = check_parity;
                else
                    next_state = check_first_stop;
            end
            else
                next_state = recv_data;
        end

//////////////////////check_parity////////////////////////
        check_parity: begin
            if(count == 7) begin
                if(rx == parity)
                    rx_error = 1'b0;
                else
                    rx_error = 1'b1;
            end
            else if(count == 15) begin
                next_state = check_first_stop;
            end
            else begin
                next_state = check_parity;
            end
        end

//////////////////////check_first_stop////////////////////////
        check_first_stop: begin
            if(count == 7) begin
                if(rx != 1'b1)
                    rx_error = 1'b1;
                else
                    rx_error = 1'b0;
            end
            else if(count == 15) begin
                if(stop2)
                    next_state = check_sec_stop;
                else
                    next_state = done;
            end
            else begin
                next_state = check_first_stop;
            end
        end

//////////////////////check_sec_stop////////////////////////
        check_sec_stop: begin
            if(count == 7) begin
                if(rx != 1'b1)
                    rx_error = 1'b1;
                else
                    rx_error = 1'b0;
            end
            else if(count == 15) begin
                next_state = done;
            end
            else begin
                next_state = check_sec_stop;
            end
        end
 
//////////////////////done////////////////////////
        done: begin
            rx_done    = 1'b1;
            next_state = idle;
            rx_error   = 1'b0;
        end

        default: next_state = idle;
    endcase
end

//////////////////////rx count ////////////////////////
always @(posedge rx_clk) begin
    case(state)
        idle: begin
            count     <= 0;
            bit_count <= 0;
            datard    <= 8'h00; // Reset stale bits between packets
        end

        start_bit: begin
            if(count < 15)
                count <= count + 1;
            else
                count <= 0;
        end

        recv_data: begin
            if(count < 15) begin
                count <= count + 1;
                if(count == 7) begin
                    datard[7:0] <= {rx, datard[7:1]}; 
                end
            end
            else begin
                count     <= 0;
                bit_count <= bit_count + 1;
            end
        end

        check_parity: begin
            if(count < 15)
                count <= count + 1;
            else
                count <= 0;
        end

        check_first_stop: begin
            if(count < 15)
                count <= count + 1;
            else
                count <= 0;
        end

        check_sec_stop: begin
            if(count < 15)
                count <= count + 1;
            else
                count <= 0;
        end

        done: begin
            count     <= 0;
            bit_count <= 0;
        end
    endcase
end
endmodule
