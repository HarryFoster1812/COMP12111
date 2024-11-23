; Begin program at reset address. Acc, pc, and ir should all be 0 after reset
        ORG 0

JMP reset
main
JMP write_play


write_play
LDA P_Segment
STA Digit3
LDA L_Segment
STA Digit2
LDA A_Segment
STA Digit1
LDA Y_Segment
STA Digit0
JMP DISPLAY_YES_NO_LIGHTS

DISPLAY_YES_NO_LIGHTS
LDA PEDCROSS_RED
ADD PEDCROSSPED_RED
ADD TRAFFICUP_GREEN
ADD TRAFFICLEFT_GREEN
STA TrafficLights
JMP wait_play_input

wait_play_input
LDA Simple
JNE parse_input
JMP wait_play_input

parse_input
; 4 options
; 1000 or 0100 is no
; 0010 or 0001 is yes
STA ToCheck
SUB PEDCROSSPED_RED ; this is the most significant bit or 0b1000
JGE end
; the button pressed was not the mist sogniignificant bit
LDA ToCheck
SUB PEDCROSS_RED
JGE end
; At this point is must be either of the least significant bits so we can just jump to yes


JMP write_wait

write_wait
LDA W_Segment
STA Digit3
LDA A_Segment
STA Digit2
LDA I_Segment
STA Digit1
LDA T_Segment
STA Digit0

; turn all LEDS red

LDA Zero
STA TrafficLights ; turn off all LEDS
ADD PEDCROSS_RED
ADD PEDCROSSPED_RED
ADD TRAFFICLEFT_RED
ADD TRAFFICUP_RED
STA TrafficLights

; FIGURE OUT HOW THE BUZZER WORKS

; pseudo random one
random_one
LDA mul
Multiply_loop
STA temp
LDA seed
ADD seed
STA seed
LDA temp
SUB one
JNE Multiply_loop

LDA seed
ADD inc
STA seed

mod_loop
LDA seed
SUB mod
JGT mod_loop

; if we are here the number is negative and is modulused we only need to convert it to positive

LDA Zero
STA temp
Convert_pos
LDA seed
ADD one
STA seed
LDA temp
ADD one
STA seed
JNE Convert_pos
LDA temp
STA seed

; at this point seed should be a pseudo random num between 0 and 10000

; to have a semi accurate delay i am using a double nested loop where the random number will be the time in ms that the delay should be
; this will be initialising the loop
LDA seed
STA temp
LDA Delay 
STA tempOne

inner_loop
LDA tempOne
SUB one
STA tempOne
JNE inner_loop 
; at this point we should of hade a (roughly 1ms delay)

LDA Delay ; reinitialise the loop
STA tempOne

LDA temp
SUB one
STA temp
JNE inner_loop

; At this point we need to add amber to the LEDS
LDA TrafficLights
ADD PEDCROSS_AMBER
ADD TRAFFICLEFT_AMBER
ADD TRAFFICUP_AMBER
STA TrafficLights

; AGAIN FIGURE OUT HOW THE BUZZER WORKS

; generate another random delay and apply it

; pseudo random one
random_two
LDA mul
Multiply_loop_two
STA temp
LDA seed
ADD seed
STA seed
LDA temp
SUB one
JNE Multiply_loop_two

LDA seed
ADD inc
STA seed

mod_loop_two
LDA seed
SUB mod
JGT mod_loop_two

; if we are here the number is negative and is modulused we only need to convert it to positive

LDA Zero
STA temp
Convert_pos_two
LDA seed
ADD one
STA seed
LDA temp
ADD one
STA seed
JNE Convert_pos_two
LDA temp
STA seed

; at this point seed should be a pseudo random num between 0 and 10000

; to have a semi accurate delay i am using a double nested loop where the random number will be the time in ms that the delay should be
; this will be initialising the loop
LDA seed
STA temp
LDA Delay 
STA tempOne

inner_loop_two
LDA tempOne
SUB one
STA tempOne
JNE inner_loop_two 
; at this point we should of hade a (roughly 1ms delay)

LDA Delay ; reinitialise the loop
STA tempOne

LDA temp
SUB one
STA temp
JNE inner_loop_two


; here we need to randomly generate which button should be the correct input (and which LED to set to  green)


JMP end

reset
LDA Zero
STA Digit0
STA Digit1
STA Digit2
STA Digit3
STA Digit4
STA Digit5
STA TrafficLights
LDA game_end
JNE endAfterReset
JMP main

end
JMP reset
endAfterReset
LDA B_Segment
STA Digit2
LDA Y_Segment
STA Digit1
LDA E_Segment
STA Digit0

STP

; value storage area
W_Segment DEFW &2836
A_Segment DEFW &F7
I_Segment DEFW &1209
T_Segment DEFW &1201

P_Segment DEFW 0xF3
L_Segment DEFW 0x38
Y_Segment DEFW 0x1500

Zero DEFW &0
One DEFW 1
Counter DEFW 0
Delay DEFW 750 ; This is the delay for 1ms uning the given formula on the exercise sheet and a 3Mhz clock
delayLoop DEFW 0; this is how many times the delay counter should run in order to produce a 1ms delay
ToCheck DEFW 0
RedDelay DEFW 97
game_end DEFW 0
temp DEFW 0
; These are values for for the pseudo random generator which uses Linear Congruential Generator
mod DEFW 10000 ; max is 10000ms = 10s
mod_two DEFW 3 ; max is 3 since there are 4 buttons
inc DEFW 63
mul DEFW 21
seed DEFW 827 ; This is the starting value

; formula is seed = (mul*seed + inc) % mod 


PEDCROSS_GREEN DEFW 0b1
PEDCROSS_AMBER DEFW 0b10
PEDCROSS_RED DEFW 0b100
PEDCROSSPED_RED DEFW 0b1000
PEDCROSSPED_GREEN DEFW 0b10000
TRAFFICUP_GREEN DEFW 0b100000
TRAFFICUP_AMBER DEFW 0b1000000
TRAFFICUP_RED DEFW 0b10000000
TRAFFICLEFT_GREEN DEFW 0b100000000
TRAFFICLEFT_AMBER DEFW 0b1000000000
TRAFFICLEFT_RED DEFW 0b10000000000


ORG &FF0
Simple DEFW &0
Buttons DEFW &0
Keypad DEFW &0
BuzzerStatus DEFW &0
LEDS DEFW &0
Digit0 DEFW &0
Digit1 DEFW &0
Digit2 DEFW &0
Digit3 DEFW &0
Digit4 DEFW &0
Digit5 DEFW &0

ORG &FFD
Buzzer DEFW &FFD

ORG &FFF
TrafficLights DEFW &0

