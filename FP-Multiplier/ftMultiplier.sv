module multiplier #(parameter N = 23)(input logic [N-1:0] mantissa1, mantissa2,output logic [47:0] m);
logic [N:0] m1, m2;
assign m1 = {1'b1,mantissa1};
assign m2 = {1'b1,mantissa2};
assign m = m1 * m2;
endmodule

module addition #(parameter N = 8)(input logic [N-1:0] exponent1, exponent2, output logic [N-1:0] y);
assign y = exponent1 + exponent2 - 127;
endmodule

module signCalculation #(parameter N = 1)(input logic sign1, sign2, output logic y);
assign y = sign1 ^ sign2;
endmodule
    
module normalize #(parameter N = 8)(input logic [47:0] mantissa, input logic [N-1:0] exponent, output logic [22:0] m,output logic [N-1:0] exponentRes);
assign m = mantissa[47]? mantissa[46:24]:mantissa[45:23];
assign exponentRes = exponent - 1;
endmodule 	

module fpMultiplication(input logic [31:0] x, y,output logic [31:0] fpmult);
logic [7:0] expx, expy, exponent, expoRes;
logic [22:0] mantix, mantiy, mant;
logic signx, signy, sign;
logic [47:0] mantissa;
assign {expx, mantix} = {x[30:23], x[22:0]};
assign {expy, mantiy} = {y[30:23], y[22:0]};
assign signx = x[31];
assign signy = y[31];
multiplier mult(mantix, mantiy, mantissa);
addition add(expx, expy, exponent);
signCalculation signcalc(signx, signy, sign);
normalize norm(mantissa, exponent, mant, expoRes);
assign fpmult = {sign,expoRes,mant};
endmodule 

module testbench();
logic [31:0] x, y, out;
fpMultiplication multiplication(x,y,out);
initial begin
assign x = 32'b00111111100001100110011001100110; 
assign y = 32'b00111111100001100110011001100110; #10;
if(out == 32'b00111111100011010001111010111000) $display("correct.");
end
endmodule
