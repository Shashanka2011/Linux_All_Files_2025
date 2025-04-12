`include "uart_trx.v"

module top (
  output wire led_red,    // Red LED
  output wire led_blue,   // Blue LED
  output wire led_green,  // Green LED
  output wire uarttx,     // UART Transmission pin
  input wire uartrx,      // UART Reception pin
  input wire hw_clk       // Hardware clock
);

  wire int_osc;
  reg [27:0] frequency_counter_i;

  // Internal Oscillator
  SB_HFOSC #(.CLKHF_DIV("0b10")) u_SB_HFOSC (
    .CLKHFPU(1'b1), 
    .CLKHFEN(1'b1), 
    .CLKHF(int_osc)
  );

  assign uarttx = uartrx;

  // Counter
  always @(posedge int_osc) begin
    frequency_counter_i <= frequency_counter_i + 1'b1;
  end

  // Assigning LED outputs directly to be always ON
  assign led_red = 1'b1;   // Turn ON Red
  assign led_green = 1'b1; // Turn ON Green
  assign led_blue = 1'b1;  // Turn ON Blue

  // Instantiate RGB LED Driver
  SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1),
    .RGB0PWM (1'b1),  // Green always ON
    .RGB1PWM (1'b1),  // Blue always ON
    .RGB2PWM (1'b1),  // Red always ON
    .CURREN  (1'b1),
    .RGB0    (led_green), 
    .RGB1    (led_blue),
    .RGB2    (led_red)
  );
  
  defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule
