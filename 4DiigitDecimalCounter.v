module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,  // Fixed from [3:1] to [3:0]
    output [15:0] q
);

    bcd_counter bcd1(clk, 1'b1, reset, q[3:0]);  
    assign ena[1] = (q[3:0] == 4'd9) ? 1 : 0;

    bcd_counter bcd2(clk, ena[1], reset, q[7:4]);
    assign ena[2] = (q[7:4] == 4'd9) && (q[3:0] == 4'd9) ? 1 : 0;

    bcd_counter bcd3(clk, ena[2], reset, q[11:8]);
    assign ena[3] = (q[11:8] == 4'd9) && (q[7:4] == 4'd9) && (q[3:0] == 4'd9) ? 1 : 0;

    bcd_counter bcd4(clk, ena[3], reset, q[15:12]);

endmodule


module bcd_counter (
    input clk,
    input slowena,
    input reset,
    output [3:0] q
  );
  
  always@(posedge clk)begin
      if(reset | (slowena & q==9))
          q <= 0;
      else if(slowena)
          q <= q + 1'b1;
      else
          q <= q;
  end

endmodule
