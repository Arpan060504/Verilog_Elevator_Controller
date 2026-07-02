// implemented 
module fsm_elevator3(request_floor, request_valid, emergency_stop , motor_up , motor_down , door_open , door_close , idle , busy , reset , clk);

input [1:0]request_floor ;
output reg motor_up , motor_down , door_open , door_close , idle , busy ;
input reset , emergency_stop , clk , request_valid;

reg request_pending;
reg [2:0] state , next_state ;
reg [1:0]present_floor , target_floor ;
reg[2:0] door_timer ;

parameter   IDLE = 3'b000 , 
            MOTOR_UP= 3'b001 , 
            MOTOR_DOWN= 3'b010 , 
            DOOR_OPEN= 3'b011 , 
            DOOR_CLOSE= 3'b100 ,
            EMERGENCY  = 3'b101,
            DOOR_DELAY = 3;

always @(posedge clk) 
begin
   if(reset)
        state <= IDLE;
    else 
        state <=next_state;
end

always @( * ) 
begin
    motor_up = 0 ;
    motor_down=0 ; 
    door_open = 0;
    door_close = 0 ;
    idle =  0;
    busy = 0;
        case(state)
            IDLE:
                begin
                    idle =  1;
                end
            MOTOR_UP:
                begin
                    motor_up = 1 ;
                    busy = 1;
                end   
            MOTOR_DOWN:
                begin
                    motor_down = 1 ; 
                    busy = 1;
                end
            DOOR_CLOSE:
                begin
                    door_close = 1 ;
                    idle       = 1;
                    busy = 1;
                end     
            DOOR_OPEN:
                begin
                    door_open = 1;
                    idle =  1;
                    busy = 1;
                end     
            EMERGENCY :      
                begin
                        door_open = 1;
                        busy = 1;
                end         
        endcase
end

always @( * ) 
begin
    if(emergency_stop)
        next_state = EMERGENCY;
    else
    case(state)
        IDLE:
            begin
                if(!request_pending)
                    next_state = IDLE;
                else if(present_floor == target_floor)
                    next_state = DOOR_OPEN;
                else if(present_floor < target_floor)
                    next_state = MOTOR_UP;
                else
                    next_state = MOTOR_DOWN;
            end
        MOTOR_UP :    
            begin
                if(present_floor == target_floor)
                    next_state = DOOR_OPEN;
                else
                    next_state = MOTOR_UP ;    
            end
        MOTOR_DOWN :    
            begin
                if(present_floor == target_floor)
                    next_state = DOOR_OPEN;
                else
                    next_state = MOTOR_DOWN ;
            end    
        DOOR_OPEN:
            if(door_timer >= DOOR_DELAY)
                next_state = DOOR_CLOSE;
            else
                next_state = DOOR_OPEN;
        DOOR_CLOSE : 
            next_state = IDLE;
        EMERGENCY  : 
            begin
                if(emergency_stop )
                    next_state = EMERGENCY;
                else
                    next_state = IDLE;    
            end
        default :      next_state = IDLE;         
    endcase    
end

always @(posedge clk) 
begin
    if(reset)
        present_floor <= 0;
    else    
    case(state)
        MOTOR_UP:
            begin
                if(present_floor != target_floor)
                    present_floor <= present_floor + 1;
                else
                    present_floor <= present_floor;
            end
        MOTOR_DOWN: 
            if(present_floor != target_floor)
                present_floor <=  present_floor - 1 ;
            else
                present_floor <= present_floor;    
        default:  present_floor <= present_floor;
    endcase    
end

always @(posedge clk ) 
begin   
    if(reset)
        door_timer <= 0;
    else       
        case(state)
        DOOR_OPEN : door_timer <= door_timer + 1;
        default : door_timer <= 0;
        endcase
end

always @(posedge clk)
begin
    if(reset)
        target_floor <= 0;

    else if(emergency_stop)
        target_floor <= 0;

    else if(request_valid && !busy)
        target_floor <= request_floor;
end

always @(posedge clk)
begin
    if(reset)
        request_pending <= 0;

    else if(emergency_stop)
        request_pending <= 0;

    else if(request_valid && !busy)
        request_pending <= 1;

    else if(state == DOOR_CLOSE)
        request_pending <= 0;
end
endmodule