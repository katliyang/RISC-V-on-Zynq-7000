module buttons (
    input clk,
    input [3:0] buttons,
    output reg wr_en,
    output reg [3:0] din,
    input full  
);

    always @ (posedge clk) begin
        if (rst) begin
            wr_en <= 1'b0;
            din <= 4'b0;
        end else if (|buttons == 1'b1 && full == 1'b0) begin
            wr_en <= 1'b1;
            din <= buttons;
        end else begin
            wr_en <= 1'b0;
            din <= 4'b0;
        end
    end
endmodule