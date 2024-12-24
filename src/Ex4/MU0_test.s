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

; load buzzer
; get bit 0
; check if bit 0 is 0
; if yes then configure buzzer
; finish

; pseudo random One
random_one
        LDA mul
        LDA tempOne
                Multiply_loop
                STA temp
                LDA seed
                ADD tempOne
                STA seed
                LDA temp
                SUB One
                JNE Multiply_loop

        LDA seed
        ADD inc
        STA seed

                mod_loop
                LDA seed
                SUB mod
                JGE mod_loop

        ; if we are here the number is negative, adding mod will correct it

        ADD mod
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
                SUB One
                STA tempOne
                JNE inner_loop 
                ; at this point we should of hade a (roughly 1ms delay)

        LDA Delay ; reinitialise the loop
        STA tempOne

        LDA temp
        SUB One
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
        STA tempOne
                Multiply_loop_two
                STA temp
                LDA seed
                ADD tempOne
                STA seed
                LDA temp
                SUB One
                JNE Multiply_loop_two

        LDA seed
        ADD inc
        STA seed

                mod_loop_two
                LDA seed
                SUB mod
                JGT mod_loop_two

        ; if we are here the number is negative and is modulused we only need to convert it to positive

        ADD mod
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
                SUB One
                STA tempOne
                JNE inner_loop_two 
                ; at this point we should of hade a (roughly 1ms delay)

        LDA Delay ; reinitialise the loop
        STA tempOne

        LDA temp
        SUB One
        STA temp
        JNE inner_loop_two


; here we need to randomly generate which button should be the correct input (and which LED to set to  green)

; check if useOne is One
LDA useOne
JNE gen_using_one; is useOne is not zero (True) then use One 
; use One is 0 so change it to One
ADD One
STA useOne

; useOne was true so we need to flip it to false (store 0)
LDA Zero
STA useOne

; pseudo random two
random_button_two
        LDA mul_two
        STA tempOne
        Multiply_loop_button_two
                STA temp
                LDA seed_two
                ADD tempOne
                STA seed_two
                LDA temp
                SUB One
                JNE Multiply_loop_button_two

        LDA seed_two
        ADD inc_two
        STA seed_two

        mod_loop_button_two
                LDA seed_two
                SUB mod_button
                JGT mod_loop_button_two

        ; if we are here the number is negative and is modulused we only need to convert it to positive

        ADD mod_button
        STA seed_two
        STA temp

        JMP calculate_button_bit_pattern 

gen_using_one
        ; useOne was true so we need to flip it to false (store 0)
        LDA Zero
        STA useOne
        
        ; pseudo random One
        random_button_one
                LDA mul_one
                STA tempOne
                Multiply_loop_button_one
                        STA temp
                        LDA seed_one
                        ADD tempOne
                        STA seed_one
                        LDA temp
                        SUB One
                        JNE Multiply_loop_button_one

                LDA seed_one
                ADD inc_one
                STA seed_one

                mod_loop_button_one
                        LDA seed_one
                        SUB mod_button
                        JGT mod_loop_button_one

                ; if we are here the number is negative and is modulused we only need to convert it to positive

                ADD mod_button
                STA seed_one
                STA temp

calculate_button_bit_pattern
; the button number should be stored in temp we are going to logical shift One by this number
LDA One
STR tempOne
shift_left
        LDA tempOne
        ADD tempOne
        STR tempOne
        LDA temp
        SUB One
        STR temp
        JNE shift_left

; temp One now contains the bit pattern that we need to check
; reset the lights



LDA Zero
STA TrafficLights

; figure out which set of lights to set
LDA temp
STA ToCheck
SUB PEDCROSSPED_RED ; this is the most significant bit or 0b1000
JGE show_four_green
; the button pressed was not the most significant bit
LDA ToCheck
SUB PEDCROSS_RED ; 0100
JGE show_three_green
LDA ToCheck
SUB PEDCROSS_AMBER ; 0010
JGE show_two_green
; the bit pattern must be 0001
LDA TRAFFICLEFT_GREEN
STA TrafficLights
JMP buzz_go

show_two_green
LDA TRAFFICUP_GREEN
STA TrafficLights
JMP buzz_go

show_three_green
LDA PEDCROSSPED_GREEN
STA TrafficLights
JMP buzz_go

show_four_green
LDA PEDCROSS_GREEN
STA TrafficLights

buzz_go

show_press
LDA P_Segment
STA Digit4
LDA R_Segment
STA Digit3
LDA E_Segment
STA Digit2
LDA S_Segment
STA Digit1
LDA S_Segment
STA Digit0

LDA Zero
STA Counter
STA TenMsCounter

wait_for_input
        LDA Counter
        ADD One
        STA Counter
        SUB MaxPos
        JGE ms_counter
        get_input
        LDA Simple
        JNE validate_input
        JMP wait_for_input

ms_counter
      LDA TenMsCounter
      ADD One
      STA TenMsCounter
      LDA Zero
      STA Counter
      JMP get_input

wrong_buzz
        JMP wait_for_input

validate_input
        SUB ToCheck
        JNE wrong_buzz

; the input was correct
; the TenMsCounter holds the (rough) time. 
; divide by 100 to get time in seconds

; get 10ms units(MOD 10)
; get 100 ms    (/10)   (MOD 100 - units)
; get second    (/100)  (MOD 1000 - MOD 100 - MOD10)
; get 10 second (/1000) (MOD 10000 - MOD 1000 - MOD 100 - MOD10)

show_you
        LDA Zero
        STA Digit4
        STA Digit3
        LDA Y_Segment
        STA Digit2
        LDA O_Segment
        STA Digit1
        LDA U_Segment
        STA Digit0

;wait 1s 
LDA Thousand
STA temp
LDA Delay 
STA tempOne

                inner_loop_one_second 
                LDA tempOne
                SUB One
                STA tempOne
                JNE inner_loop_one_second 
                ; at this point we should of hade a (roughly 1ms delay)

        LDA Delay ; reinitialise the loop
        STA tempOne

        LDA temp
        SUB One
        STA temp
        JNE inner_loop_one_second

show_took
        LDA T_Segment
        STA Digit3
        LDA O_Segment
        STA Digit2
        LDA O_Segment
        STA Digit1
        LDA K_Segment
        STA Digit0

; some how figure out how to convert decimal to segment display
; the units were extracted before do 10 if statements and copy and paste
; SHOULD BE TEN UNIT . TENTHS HUNDRETHS
;       Digit3 Digit2  Digit1  Digit0




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
        LDA game_end
        ADD One
        STR game_end
        JMP reset

endAfterReset
        LDA B_Segment
        STA Digit2
        LDA Y_Segment
        STA Digit1
        LDA E_Segment
        STA Digit0

STP

;  ################       value storage area        ####################

A_Segment EQU &F7   
B_Segment EQU &128F  
C_Segment EQU &39   
D_Segment EQU &120F  
E_Segment EQU &F9   
F_Segment EQU &F1   
G_Segment EQU &BD   
H_Segment EQU &F6   
I_Segment EQU &1209
J_Segment EQU &1E   
K_Segment EQU &2470
L_Segment EQU &38  
M_Segment EQU &536  
N_Segment EQU &2136 
O_Segment EQU &3F   
P_Segment EQU &F3  
Q_Segment EQU &203F 
R_Segment EQU &20F3 
S_Segment EQU &18D  
T_Segment EQU &1201 
U_Segment EQU &3E   
V_Segment EQU &C30  
W_Segment EQU &2836 
X_Segment EQU &2D00 
Y_Segment EQU &1500 
Z_Segment EQU &C09  

0_Segment EQU &C3F  
1_Segment EQU &406  
2_Segment EQU &DB  
3_Segment EQU &8F  
4_Segment EQU &E6  
5_Segment EQU &ED  
6_Segment EQU &FD  
7_Segment EQU &1401 
8_Segment EQU &FF  
9_Segment EQU &E7  
DP                      DEFW 0b100000000000000

Time            DEFW 0
Zero            DEFW &0
One             DEFW 1
Ten             DEFW 10
Thousand        DEFW 1000
TenMsCounter    DEFW 0

Tens            DEFW 0 
Units           DEFW 0
Tenths          DEFW 0
Hundreths       DEFW 0

Counter         DEFW 0 ; this will store the time taken for them to click the correct button
MaxPos          DEFW 32766
Delay           EQU 750 ; This is the delay for 1ms uning the given formula on the exercise sheet and a 3Mhz clock
delayLoop       DEFW 0; this is how many times the delay counter should run in order to produce a 1ms delay
ToCheck         DEFW 0
game_end        DEFW 0
temp            DEFW 0
; These are values for for the pseudo random generator which uses Linear Congruential Generator
mod     DEFW 10000 ; max is 10000ms = 10s
inc     DEFW 63
mul     DEFW 21
seed    DEFW 827 ; This is the starting value

; these are the values for the button random number generator

useOne DEFW 0 ; if this is the flag which will alternate between which random number should be used

mod_button      DEFW 4 ; max is 3 since there are 4 buttons
inc_one         DEFW 3
mul_one         DEFW 1
seed_one        DEFW 0; This is the starting value

inc_two         DEFW 0
mul_two         DEFW 3
seed_two        DEFW 1; This is the starting value

; formula is seed = (mul*seed + inc) % mod 


PEDCROSS_GREEN          DEFW 0b1
PEDCROSS_AMBER          DEFW 0b10
PEDCROSS_RED            DEFW 0b100
PEDCROSSPED_RED         DEFW 0b1000
PEDCROSSPED_GREEN       DEFW 0b10000
TRAFFICUP_GREEN         DEFW 0b100000
TRAFFICUP_AMBER         DEFW 0b1000000
TRAFFICUP_RED           DEFW 0b10000000
TRAFFICLEFT_GREEN       DEFW 0b100000000
TRAFFICLEFT_AMBER       DEFW 0b1000000000
TRAFFICLEFT_RED         DEFW 0b10000000000


; 0001 - light is 1 - PEDCROSS_GREEN
; 0010 - light is 10000 - PEDCROSSPED_GREEN
; 0100 - light is 100000 - TRAFFICUP_GREEN
; 1000 - light is 100000000 - TRAFFICLEFT_GREEN
;

ORG &FF0
Simple          DEFW &0
Buttons         DEFW &0
Keypad          DEFW &0
BuzzerStatus    DEFW &0
LEDS            DEFW &0
Digit0          DEFW &0
Digit1          DEFW &0
Digit2          DEFW &0
Digit3          DEFW &0
Digit4          DEFW &0
Digit5          DEFW &0

ORG &FFD
Buzzer DEFW &FFD

ORG &FFF
TrafficLights DEFW &0



; From running the formula in a python instance, seed should be 7430 so the delay between red and amber should be roughly 7.4 seconds
; Next, seed should be 6093 so delay between amber and green should be 6 seconds

; for the button the chosen One should be 0

; on second run of the game pause between red and amber should be 63 ms
; amber and green should be 1.3 seconds
; the button to press should be 0 again

