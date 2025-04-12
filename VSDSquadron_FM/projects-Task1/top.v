/* Corrected top.v */
`include "uart_tx_8n1.v" // Ensure correct file inclusion

module top (
  output wire led_red,
  output wire led_blue,
  output wire led_green,
  output wire uarttx,
  input wire hw_clk
);

  wire int_osc;
  reg [27:0] frequency_counter_i;
  reg clk_9600 = 0;
  reg [31:0] cntr_9600 = 32'b0;
  parameter period_9600 = 625;

  // Instantiate UART TX module
  uart_tx_8n1 DanUART (
    .clk(clk_9600),
    .txbyte(8'd68), // ASCII 'D'
    .senddata(frequency_counter_i[24]),
    .tx(uarttx)
  );

  // Internal Oscillator
  SB_HFOSC #(.CLKHF_DIV("0b10")) u_SB_HFOSC (
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(int_osc)
  );

  // Clock Divider for 9600Hz
  always @(posedge int_osc) begin
    frequency_counter_i <= frequency_counter_i + 1'b1;
    cntr_9600 <= cntr_9600 + 1;
    if (cntr_9600 == period_9600) begin
      clk_9600 <= ~clk_9600;
      cntr_9600 <= 32'b0;
    end
  end

  // RGB LED Driver
  SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1),
    .RGB0PWM(frequency_counter_i[24] & frequency_counter_i[23]),
    .RGB1PWM(frequency_counter_i[24] & ~frequency_counter_i[23]),
    .RGB2PWM(~frequency_counter_i[24] & frequency_counter_i[23]),
    .CURREN(1'b1),
    .RGB0(led_green),
    .RGB1(led_blue),
    .RGB2(led_red)
  );
  defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule
