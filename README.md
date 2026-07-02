# Elevator Controller FSM in Verilog

A finite state machine (FSM) based elevator controller designed in Verilog HDL. This project simulates the control logic of a 4-floor elevator using a Moore FSM architecture. The controller handles floor requests, movement control, door sequencing, emergency stop functionality, and request validation.

---

## Features

- Moore FSM implementation
- 4-floor elevator controller (Floor 0–3)
- Upward and downward movement control
- Door Open and Door Close states
- Configurable door open delay using a timer
- Emergency stop support
- Internal request latching using `target_floor`
- Request validation using `request_valid`
- Single-request servicing (new requests ignored while busy)
- Busy and Idle status outputs
- Synchronous reset
- Verified using a custom Verilog testbench
- Simulated with Icarus Verilog and GTKWave

---

## FSM States

| State | Description |
|--------|-------------|
| IDLE | Waits for a valid floor request |
| MOTOR_UP | Elevator moves upward |
| MOTOR_DOWN | Elevator moves downward |
| DOOR_OPEN | Opens door and waits for a fixed delay |
| DOOR_CLOSE | Closes door before returning to IDLE |
| EMERGENCY | Stops elevator immediately and opens the door |

---

## Block Diagram

```
                  request_floor
                        │
                request_valid
                        │
                        ▼
               Target Floor Register
                        │
                        ▼
                 Elevator FSM Controller
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
    motor_up      motor_down        door_open
        │               │                │
        └───────────────┼────────────────┘
                        ▼
                  present_floor
```

---

## Project Architecture

The controller is implemented using three major blocks:

### 1. State Register

Updates the current state on every positive clock edge.

```verilog
always @(posedge clk)
```

---

### 2. Next-State Logic

Determines the next state based on

- Current state
- Present floor
- Target floor
- Emergency stop
- Door timer
- Pending request

Implemented using combinational logic.

```verilog
always @(*)
```

---

### 3. Output Logic

Generates

- motor_up
- motor_down
- door_open
- door_close
- idle
- busy

Outputs depend only on the current state (Moore FSM).

---

## Internal Registers

| Register | Purpose |
|-----------|---------|
| state | Current FSM state |
| next_state | Next FSM state |
| present_floor | Elevator's current floor |
| target_floor | Accepted destination floor |
| door_timer | Holds door open for fixed clock cycles |
| request_pending | Indicates an active request |

---

## Inputs

| Signal | Description |
|---------|-------------|
| clk | System clock |
| reset | Synchronous reset |
| request_floor[1:0] | Requested floor |
| request_valid | Indicates a valid request |
| emergency_stop | Emergency stop input |

---

## Outputs

| Signal | Description |
|---------|-------------|
| motor_up | Elevator moving upward |
| motor_down | Elevator moving downward |
| door_open | Door open signal |
| door_close | Door close signal |
| idle | Elevator not moving |
| busy | Elevator servicing a request |

---

## Simulation

Simulation performed using:

- Icarus Verilog
- GTKWave

Compile

```bash
iverilog -Wall -o elevator_sim fsm_elevator3.v fsm_elevator3_tb.v
```

Run

```bash
vvp elevator_sim
```

View waveform

```bash
gtkwave elevator_test.vcd
```

---

## Testbench Coverage

The testbench verifies:

- Reset operation
- Idle state
- Upward movement
- Downward movement
- Door open delay
- Door closing
- Emergency stop during movement
- Emergency recovery
- Request validation
- Ignoring requests while busy
- Busy and Idle status

---

## Design Flow

```
User presses button
        │
        ▼
request_valid = 1
        │
        ▼
target_floor <= request_floor
        │
        ▼
request_pending = 1
        │
        ▼
FSM decides direction
        │
        ▼
Motor moves elevator
        │
        ▼
Door opens
        │
        ▼
Door timer expires
        │
        ▼
Door closes
        │
        ▼
Request completed
        │
        ▼
Return to IDLE
```

---

## Limitations

Current implementation services one request at a time.

Not implemented:

- Request queue
- Multiple simultaneous requests
- Door obstruction sensor
- Weight overload detection
- Fire mode
- Maintenance mode
- Floor display
- Parameterized number of floors

---

## Future Improvements

- FIFO-based floor request queue
- Configurable number of floors
- Door obstruction detection
- Weight overload protection
- Maintenance mode
- Fire emergency mode
- Seven-segment floor display
- UART interface for monitoring
- SystemVerilog Assertions (SVA)
- Functional coverage

---

## Learning Outcomes

This project demonstrates understanding of:

- Verilog HDL
- Moore FSM Design
- Sequential Logic
- Combinational Logic
- Register Transfer Level (RTL) Design
- State Machine Modeling
- Testbench Development
- Digital System Verification
- GTKWave Debugging

---

## Author

**Arpan**  
Electrical Engineering Undergraduate  
Interested in RTL Design, Digital Design and VLSI
