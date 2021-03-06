module sine_lut (
    input clk,
    input ena,
    input [7:0] addra,
    output reg [20:0] douta,
    input enb,
    input [7:0] addrb,
    output reg [20:0] doutb
);
    reg [20:0] mem [256-1:0];
    
    `ifdef SYNTHESIS
    initial begin
        $readmemh("../../../scripts/sine_lut.hex", mem);
    end
    `endif
    
    always @(posedge clk) begin
        if (ena)
            douta <= mem[addra];
        if (enb)
            doutb <= mem[addrb];
    end
    
    
endmodule
