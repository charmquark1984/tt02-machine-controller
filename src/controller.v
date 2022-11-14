`default_nettype none

module charmquark1984_controller #( parameter MAX_COUNT = 1000 ) (
  input [7:0] io_in,
  output [7:0] io_out
);
    
    wire clk = io_in[0];
    wire reset = io_in[1];
    wire [7:0] led_out;
    assign io_out[7:0] = led_out;

    // external clock is 1000Hz, so need 10 bit counter
    reg [9:0] second_counter;
    reg [3:0] digit;

    reg [1:0] x; 
    reg [1:0] y;
    reg [1:0] z;
    reg [1:0] e;

    assign io_out[0:1] = x;
    assign io_out[2:3] = y;
    assign io_out[4:5] = z;
    assign io_out[6:7] = e;



    always @(posedge clk) begin
        // if reset, set counter to 0
        if (reset) begin
            second_counter <= 0;
            digit <= 0;
            x <= 0;
            y <= 0;
            z <= 0;
            e <= 0;
        end else begin
            // if up to 16e6
            if (second_counter == MAX_COUNT) begin
                // reset
                second_counter <= 0;

                // increment digit
                digit <= digit + 1'b1;

                case(x)
                    2'b00: x <= 2'b01;
                    2'b01: x <= 2'b11;
                    2'b11: x <= 2'b10;
                    2'b10: x <= 2'b00;
                    default: ;
                endcase





                // only count from 0 to 9
                if (digit == 9)
                    digit <= 0;

            end else
                // increment counter
                second_counter <= second_counter + 1'b1;
        end
    end

    // instantiate segment display
    // seg7 seg7(.counter(digit), .segments(led_out));

endmodule
