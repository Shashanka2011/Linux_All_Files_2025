module top (
    output led_red,
    output led_blue,
    output led_green,
    input hw_clk
);

// Turn on only the blue LED
assign led_red = 1'b0;    // Red LED OFF
assign led_green = 1'b0;  // Green LED OFF
assign led_blue = 1'b1;   // Blue LED ON

endmodule
