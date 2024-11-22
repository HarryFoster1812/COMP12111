;       Begin program at reset address. Acc, pc, and ir should all be 0 after reset
        ORG  0

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

write_wait
LDA W_Segment
STA Digit3
LDA A_Segment
STA Digit2
LDA I_Segment
STA Digit1
LDA T_Segment
STA Digit0

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
Delay DEFW 0
ToCheck DEFW 0
RedDelay DEFW 97
game_end DEFW 0

PEDCROSS_GREEN 		DEFW 0b1
PEDCROSS_AMBER 		DEFW 0b10
PEDCROSS_RED 		DEFW 0b100
PEDCROSSPED_RED 	DEFW 0b1000
PEDCROSSPED_GREEN 	DEFW 0b10000
TRAFFICUP_GREEN 	DEFW 0b100000
TRAFFICUP_AMBER 	DEFW 0b1000000
TRAFFICUP_RED 		DEFW 0b10000000
TRAFFICLEFT_GREEN 	DEFW 0b100000000
TRAFFICLEFT_AMBER 	DEFW 0b1000000000
TRAFFICLEFT_RED  	DEFW 0b10000000000


ORG &FF0
Simple  DEFW &0
Buttons DEFW &0
Keypad  DEFW &0
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
