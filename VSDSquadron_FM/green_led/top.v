module top (
    output reg led_red,
    output reg led_blue,
    output reg led_green,
    input hw_clk
);

always @(posedge hw_clk) begin
    led_red <= 1'b1;    // Red LED OFF
    led_blue <= 1'b1;   // Blue LED OFF
    led_green <= 1'b0;  // Green LED ON
end

endmodule
