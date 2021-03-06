`timescale 1ns/10ps
 
/* MODIFY THIS LINE WITH THE HIERARCHICAL PATH TO YOUR REGFILE ARRAY INDEXED WITH reg_number */
`define REGFILE_ARRAY_PATH fpga.cpu.rf.registers[reg_number]

module assembly_wg_testbench();
    reg clk, rst;
    reg [3:0] buttons;
    reg [1:0] switches;
    wire FPGA_SERIAL_RX, FPGA_SERIAL_TX;
    wire [5:0] leds;
    wire aud_pwm, aud_sd;
    parameter CPU_CLOCK_PERIOD = 8;
    parameter CPU_CLOCK_FREQ = 125_000_000;

    initial clk = 0;
    always #(CPU_CLOCK_PERIOD/2) clk <= ~clk;

    z1top fpga (
        .CLK_125MHZ_FPGA(clk),
        .BUTTONS(buttons),
        .SWITCHES(switches),
        .LEDS(leds),
        .FPGA_SERIAL_RX(FPGA_SERIAL_RX),
        .FPGA_SERIAL_TX(FPGA_SERIAL_TX),
        .aud_pwm(aud_pwm),
        .aud_sd(aud_sd)
    );
    // A task to check if the value contained in a register equals an expected value
    task check_reg;
        input [4:0] reg_number;
        input [31:0] expected_value;
        input [10:0] test_num;
        if (expected_value !== `REGFILE_ARRAY_PATH) begin
            $display("FAIL - test %d, got: %d, expected: %d for reg %d", test_num, `REGFILE_ARRAY_PATH, expected_value, reg_number);
         
        end
        else begin
            $display("PASS - test %d, got: %d for reg %d", test_num, expected_value, reg_number);
        end
    endtask

    // A task that runs the simulation until a register contains some value
    task wait_for_reg_to_equal;
        input [4:0] reg_number;
        input [31:0] expected_value;
        while (`REGFILE_ARRAY_PATH !== expected_value) @(posedge clk);
    endtask

    reg done = 0;
    initial begin
        $readmemh("../../software/assembly_wg_tests/assembly_tests.hex", fpga.cpu.bios_mem.mem, 0, 4095);

        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("assembly_wg_testbench.fst");
            $dumpvars(0,assembly_wg_testbench);
            //$dumpvars(0,fpga.cpu.handshake_tx.rf.registers[1]);
            //$dumpvars(0,CPU.rf.registers[2]);
        `endif

        buttons[0] = 0;

        // Reset the CPU
        buttons[0] = 1;
        repeat (30) @(posedge clk);             // Hold reset for 30 cycles
        buttons[0] = 0;

        fork
            begin
                repeat (500000) @(posedge clk);
                if (!done) begin
                    $display("Failed: timing out");
                    $finish();
                end
            end
        join

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
