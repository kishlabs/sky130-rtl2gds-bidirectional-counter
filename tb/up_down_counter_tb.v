`timescale 1ns/1ps
module up_down_counter_tb;
    reg         clk;
    reg         rst_n;
    reg         en;
    reg         up_down;
    wire [7:0]  count;
    wire        tc;

    up_down_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .up_down(up_down),
        .count(count),
        .tc(tc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("---------------------------------------------------------------");
        $display(" Time\tclk\trst_n\ten\tup_down\tcount\t tc");
        $display("---------------------------------------------------------------");
        $monitor("%4t\t%b\t%b\t%b\t%b\t%3d\t %b",
                 $time, clk, rst_n, en, up_down, count, tc);
    end

    initial begin
    	$dumpfile("counter.vcd");
    	$dumpvars(0, up_down_counter_tb);
    end

    initial begin
        rst_n   = 0;
        en      = 0;
        up_down = 1;
        #20;
        rst_n = 1;

        $display("\n===== TEST 1 : COUNT UP =====");
        en = 1;
        up_down = 1;
        repeat (10)
            @(posedge clk);

        $display("\n===== TEST 2 : ENABLE = 0 =====");
        en = 0;
        repeat (5)
            @(posedge clk);

        $display("\n===== TEST 3 : COUNT DOWN =====");
        en = 1;
        up_down = 0;
        repeat (10)
            @(posedge clk);

        $display("\n===== TEST 4 : OVERFLOW =====");
        @(negedge clk);
        uut.count = 8'hFE;
        up_down = 1;
        en = 1;
        repeat (3)
            @(posedge clk);

        $display("\n===== TEST 5 : UNDERFLOW =====");
        @(negedge clk);
        uut.count = 8'h01;
        up_down = 0;
        en = 1;
        repeat (3)
            @(posedge clk);

        $display("\n===== TEST 6 : TERMINAL COUNT (255) =====");
        @(negedge clk);
        uut.count = 8'hFF;
        up_down = 1;
        en = 1;
        @(posedge clk);

        $display("\n===== TEST 7 : TERMINAL COUNT (0) =====");
        @(negedge clk);
        uut.count = 8'h00;
        up_down = 0;
        en = 1;
        @(posedge clk);

        #20;
        $display("\nSimulation Completed Successfully.");
        $finish;
    end
endmodule
