module fsm_elevator3_tb;

reg clk;
reg reset;
reg emergency_stop;
reg request_valid;
reg [1:0] request_floor;

wire motor_up;
wire motor_down;
wire door_open;
wire door_close;
wire idle;
wire busy;

fsm_elevator3 DUT(
    request_floor,
    request_valid,
    emergency_stop,
    motor_up,
    motor_down,
    door_open,
    door_close,
    idle,
    busy,
    reset,
    clk
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    reset = 1;
    emergency_stop = 0;
    request_valid = 0;
    request_floor = 0;

    #20;
    reset = 0;
    #40;

    request_floor = 3;
    request_valid = 1;
    #10;
    request_valid = 0;

    #120;

    // Request ignored while busy
    request_floor = 1;
    request_valid = 1;
    #10;
    request_valid = 0;

    #20;

    request_floor = 2;
    request_valid = 1;
    #10;
    request_valid = 0;

    #120;


    //------------------------------------
    // TEST 4
    // Move Down
    //------------------------------------
    request_floor = 0;
    request_valid = 1;
    #10;
    request_valid = 0;

    #120;


    //------------------------------------
    // TEST 5
    // Emergency while moving
    //------------------------------------
    request_floor = 3;
    request_valid = 1;
    #10;
    request_valid = 0;

    #25;

    emergency_stop = 1;

    #40;

    emergency_stop = 0;

    #60;


    //------------------------------------
    // TEST 6
    // New request after emergency
    //------------------------------------
    request_floor = 2;
    request_valid = 1;
    #10;
    request_valid = 0;

    #120;


    //------------------------------------
    // TEST 7
    // Emergency while door open
    //------------------------------------
    request_floor = 1;
    request_valid = 1;
    #10;
    request_valid = 0;

    #80;

    emergency_stop = 1;

    #30;

    emergency_stop = 0;

    #50;


    //------------------------------------
    // TEST 8
    // Reset while moving
    //------------------------------------
    request_floor = 3;
    request_valid = 1;
    #10;
    request_valid = 0;

    #25;

    reset = 1;

    #20;

    reset = 0;

    #40;


    //------------------------------------
    // TEST 9
    // Immediate request after reset
    //------------------------------------
    request_floor = 2;
    request_valid = 1;
    #10;
    request_valid = 0;

    #120;

    $finish;

end


//---------------- Dump ----------------//

initial begin

    $dumpfile("elevator_test.vcd");
    $dumpvars(0,fsm_elevator3_tb);

    $monitor(
    "t=%0t state=%0d next=%0d floor=%0d target=%0d timer=%0d pending=%b req=%0d valid=%b EMG=%b up=%b down=%b open=%b close=%b idle=%b busy=%b",
    $time,
    DUT.state,
    DUT.next_state,
    DUT.present_floor,
    DUT.target_floor,
    DUT.door_timer,
    DUT.request_pending,
    request_floor,
    request_valid,
    emergency_stop,
    motor_up,
    motor_down,
    door_open,
    door_close,
    idle,
    busy
    );

end

endmodule