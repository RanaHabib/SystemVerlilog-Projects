
module ALU(input logic [7:0] a, b, input logic [3:0] ALUControl, output logic [7:0] result);
    logic [7:0] cond_invert_b;
    logic [8:0] sum;
    assign cond_invert_b = ALUControl[0] ? b : ~b;
    assign sum = a + cond_invert_b + ALUControl[0];

    always_comb
        casex (ALUControl[3:0])
        4'b000?: result = sum;
        4'b0010: result = a * b;
        4'b0011: result = a/b;
        4'b0100: result = a<<1;
        4'b0101: result = a>>1;
        4'b0110: result = {a[6:0],a[7]};
        4'b0111: result = {a[0],a[7:1]};
        4'b1000: result = a & b;
        4'b1001: result = a | b;
        4'b1010: result = a ^ b;
        4'b1011: result = ~(a | b);
        4'b1100: result = ~(a & b);
        4'b1101: result = ~(a ^ b);
        4'b1110: result = (a>b)? 8'd1: 8'd0 ;
        4'b1111: result = (a==b)? 8'd1: 8'd0 ;
        default: result = 8'd0 ; 
    endcase
endmodule

module testbench();
logic [7:0] a, b, result;
logic [3:0] instruction;
ALU alu(a, b, instruction, result);
    
    initial begin
        assign a = 4'b0001; 
        assign b = 4'b0001;
        assign instruction = 4'b0000; 
        if(result == 4'b0010) $display("correct.");
        assign instruction = 4'b0001; 
        if(result == 4'b0000) $display("correct.");
        assign instruction = 4'b0010;
        if(result == 4'b0001) $display("correct.");
        assign instruction = 4'b0011;
        if(result == 4'b0001) $display("correct.");
        assign instruction = 4'b0100;
        if(result == 4'b0010) $display("correct.");
        assign instruction = 4'b0101;
        if(result == 4'b0000) $display("correct.");
        assign instruction = 4'b0111;
        if(result == 4'b0010) $display("correct.");
        assign instruction = 4'b1000;
        if(result == 4'b1000) $display("correct.");
        assign instruction = 4'b1001;
        if(result == 4'b0001) $display("correct.");
        assign instruction = 4'b1010;
        if(result == 4'b0001) $display("correct.");
        assign instruction = 4'b1011;
        if(result == 4'b0000) $display("correct.");
        assign instruction = 4'b1100;
        if(result == 4'b1110) $display("correct.");
        assign instruction = 4'b1101;
        if(result == 4'b1110) $display("correct.");
        assign instruction = 4'b1110;
        if(result == 4'b0001) $display("correct.");
        assign instruction = 4'b1111 ;
        if(result == 4'b0001) $display("correct.");
    end
endmodule