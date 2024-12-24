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
        LDA PEDCROSS_GREEN
        ADD PEDCROSSPED_GREEN
        ADD TRAFFICUP_RED
        ADD TRAFFICLEFT_RED
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
check_buzzer
LDA BuzzerStatus
JNE check_buzzer

buzzer_one
LDA BuzzerNoiseOne
STA Buzzer

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


check_buzzer_one
LDA BuzzerStatus
JNE check_buzzer_one

LDA BuzzerNoiseTwo
STA Buzzer

; At this point we need to add amber to the LEDS
LDA TrafficLights
ADD PEDCROSS_AMBER
ADD TRAFFICLEFT_AMBER
ADD TRAFFICUP_AMBER
STA TrafficLights




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
                SUB mod
                JGE mod_loop_two

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

        mod_loop_button_two
                SUB mod_button
                JGE mod_loop_button_two

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
                        SUB mod_button
                        JGE mod_loop_button_one

                ; if we are here the number is negative and is modulused we only need to convert it to positive

                ADD mod_button
                STA seed_one
                STA temp

calculate_button_bit_pattern


; the button number should be stored in temp we are going to logical shift One by this number
LDA One
STA tempOne
LDA temp
JNE shift_left
JMP show_correct_green
shift_left
        LDA tempOne
        ADD tempOne
        STA tempOne
        LDA temp
        SUB One
        STA temp
        JNE shift_left

; tempOne now contains the bit pattern that we need to check
; reset the lights

show_correct_green

LDA Zero
STA TrafficLights

; figure out which set of lights to set
LDA tempOne
STA ToCheck
SUB PEDCROSSPED_RED ; this is the most significant bit or 0b1000
JGE show_four_green
; the button pressed was not the most significant bit
LDA ToCheck
SUB PEDCROSS_RED ; 0100
JGE show_three_green
LDA ToCheck
SUB PEDCROSS_AMBER  ; 0010
JGE show_two_green
; the bit pattern must be 0001
LDA PEDCROSS_GREEN
STA TrafficLights
JMP buzz_go

show_two_green
LDA PEDCROSSPED_GREEN
STA TrafficLights
JMP buzz_go

show_three_green
LDA TRAFFICUP_GREEN
STA TrafficLights
JMP buzz_go

show_four_green
LDA TRAFFICLEFT_GREEN
STA TrafficLights

buzz_go
check_buzzer_two
LDA BuzzerStatus
JNE check_buzzer_two

LDA BuzzerNoiseThree
STA Buzzer

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
        LDA Simple
        JNE validate_input
        LDA Counter
        ADD Ten ; add more
        STA Counter
        SUB MaxPos
        JGE ms_counter
        JMP wait_for_input

ms_counter
      LDA TenMsCounter
      ADD Ten
      ADD Ten
      STA TenMsCounter
      LDA Zero
      STA Counter
      JMP wait_for_input

wrong_buzz
        check_buzzer_three
        LDA BuzzerStatus
        JNE check_buzzer_three
        LDA BuzzerNoiseFour 
        STA Buzzer
        JMP wait_for_input

validate_input
        SUB ToCheck
        JNE wrong_buzz

; the input was correct
; the TenMsCounter holds the (rough) time. 
; divide by 100 to get time in seconds

; get 10ms units(MOD 10)
LDA TenMsCounter
tenth_loop
SUB Ten
JGE tenth_loop
ADD Ten
STA Tenths


; get 100 ms    (//10)   (MOD 100 - units)
LDA TenMsCounter
hundreths_loop
SUB Hundred
JGE hundreths_loop
ADD Hundred
SUB Tenths
STA temp

LDA Zero
STA Hundreths
LDA temp
JNE hundred_loop_div
JMP seconds

hundred_loop_div
LDA Hundreths
ADD One
STA Hundreths
LDA temp
SUB Hundred 
JGE hundred_loop_div

seconds
; get seconds    (//100)  (MOD 1000 - MOD 100 - MOD10)
LDA TenMsCounter
units_loop
SUB Thousand
JGE units_loop
ADD Thousand
SUB Hundreths
SUB Tenths
STA temp
; get 10 seconds (//1000) (MOD 10000 - MOD 1000 - MOD 100 - MOD10)

thousand_loop_div
LDA Units
ADD One
STA Units
LDA temp
SUB Thousand 
JGE thousand_loop_div

LDA TenMsCounter
tens_loop
SUB TenThousand
JGE tens_loop
ADD TenThousand
SUB Units
SUB Hundreths
SUB Tenths
STA temp

ten_thousand_loop_div
LDA Tens
ADD One
STA Tens
LDA temp
SUB TenThousand 
JGE ten_thousand_loop_div

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


LDA Thousand
STA temp
LDA Delay 
STA tempOne

                inner_loop_one_second_again
                LDA tempOne
                SUB One
                STA tempOne
                JNE inner_loop_one_second_again 
                ; at this point we should of hade a (roughly 1ms delay)

        LDA Delay ; reinitialise the loop
        STA tempOne

        LDA temp
        SUB One
        STA temp
        JNE inner_loop_one_second_again


; some how figure out how to convert decimal to segment display
; the units were extracted before do 10 if statements and copy and paste
; SHOULD BE TEN UNIT . TENTHS HUNDRETHS
;       Digit3 Digit2  Digit1  Digit0

LDA Tens

        SUB Nine
        JNE NotNine
        LDA Nine_Segment
        JMP write_digit3

        NotNine
        ADD Nine
        SUB Eight
        JNE NotEight
        LDA Eight_Segment
        JMP write_digit3

        NotEight
        ADD Eight
        SUB Seven
        JNE NotSeven
        LDA Seven_Segment
        JMP write_digit3

        NotSeven
        ADD Seven
        SUB Six
        JNE NotSix
        LDA Six_Segment
        JMP write_digit3

        NotSix
        ADD Six
        SUB Five
        JNE NotFive
        LDA Five_Segment
        JMP write_digit3

        NotFive
        ADD Five
        SUB Four
        JNE NotFour
        LDA Four_Segment
        JMP write_digit3

        NotFour
        ADD Four
        SUB Three
        JNE NotThree
        LDA Three_Segment
        JMP write_digit3

        NotThree
        ADD Three
        SUB Two
        JNE NotTwo
        LDA Two_Segment
        JMP write_digit3

        NotTwo
        ADD Two
        SUB One
        JNE NotOne
        LDA One_Segment
        JMP write_digit3

        NotOne
        LDA Zero_Segment

        write_digit3
        STA Digit3

LDA Units

        SUB Nine
        JNE NotNine_one
        LDA Nine_Segment
        JMP write_digit2

        NotNine_one
        ADD Nine
        SUB Eight
        JNE NotEight_one
        LDA Eight_Segment
        JMP write_digit2

        NotEight_one
        ADD Eight
        SUB Seven
        JNE NotSeven_one
        LDA Seven_Segment
        JMP write_digit2

        NotSeven_one
        ADD Seven
        SUB Six
        JNE NotSix_one
        LDA Six_Segment
        JMP write_digit2

        NotSix_one
        ADD Six
        SUB Five
        JNE NotFive_one
        LDA Five_Segment
        JMP write_digit2

        NotFive_one
        ADD Five
        SUB Four
        JNE NotFour_one
        LDA Four_Segment
        JMP write_digit2

        NotFour_one
        ADD Four
        SUB Three
        JNE NotThree_one
        LDA Three_Segment
        JMP write_digit2

        NotThree_one
        ADD Three
        SUB Two
        JNE NotTwo_one
        LDA Two_Segment
        JMP write_digit2

        NotTwo_one
        ADD Two
        SUB One
        JNE NotOne_one
        LDA One_Segment
        JMP write_digit2

        NotOne_one
        LDA Zero_Segment

        write_digit2
        ADD DP
        STA Digit2

LDA Tenths

        SUB Nine
        JNE NotNine_two
        LDA Nine_Segment
        JMP write_digit1

        NotNine_two
        ADD Nine
        SUB Eight
        JNE NotEight_two
        LDA Eight_Segment
        JMP write_digit1

        NotEight_two
        ADD Eight
        SUB Seven
        JNE NotSeven_two
        LDA Seven_Segment
        JMP write_digit1

        NotSeven_two
        ADD Seven
        SUB Six
        JNE NotSix_two
        LDA Six_Segment
        JMP write_digit1

        NotSix_two
        ADD Six
        SUB Five
        JNE NotFive_two
        LDA Five_Segment
        JMP write_digit1

        NotFive_two
        ADD Five
        SUB Four
        JNE NotFour_two
        LDA Four_Segment
        JMP write_digit1

        NotFour_two
        ADD Four
        SUB Three
        JNE NotThree_two
        LDA Three_Segment
        JMP write_digit1

        NotThree_two
        ADD Three
        SUB Two
        JNE NotTwo_two
        LDA Two_Segment
        JMP write_digit1

        NotTwo_two
        ADD Two
        SUB One
        JNE NotOne_two
        LDA One_Segment
        JMP write_digit1

        NotOne_two
        LDA Zero_Segment

        write_digit1
        STA Digit1

LDA Hundreths

        SUB Nine
        JNE NotNine_three
        LDA Nine_Segment
        JMP write_digit0
        
        NotNine_three
        ADD Nine
        SUB Eight
        JNE NotEight_three
        LDA Eight_Segment
        JMP write_digit0
        
        NotEight_three
        ADD Eight
        SUB Seven
        JNE NotSeven_three
        LDA Seven_Segment
        JMP write_digit0
        
        NotSeven_three
        ADD Seven
        SUB Six
        JNE NotSix_three
        LDA Six_Segment
        JMP write_digit0
        
        NotSix_three
        ADD Six
        SUB Five
        JNE NotFive_three
        LDA Five_Segment
        JMP write_digit0
        
        NotFive_three
        ADD Five
        SUB Four
        JNE NotFour_three
        LDA Four_Segment
        JMP write_digit0
        
        NotFour_three
        ADD Four
        SUB Three
        JNE NotThree_three
        LDA Three_Segment
        JMP write_digit0
        
        NotThree_three
        ADD Three
        SUB Two
        JNE NotTwo_three
        LDA Two_Segment
        JMP write_digit0
        
        NotTwo_three
        ADD Two
        SUB One
        JNE NotOne_three
        LDA One_Segment
        JMP write_digit0
        
        NotOne_three
        LDA Zero_Segment
        
        write_digit0
        STA Digit0

; add pause for two seconds 

LDA Thousand
STA temp
LDA Delay 
STA tempOne

                inner_loop_two_seconds
                LDA tempOne
                SUB One
                STA tempOne
                JNE inner_loop_two_seconds 
                ; at this point we should of hade a (roughly 1ms delay)

        LDA Delay ; reinitialise the loop
        STA tempOne

        LDA temp
        SUB One
        STA temp
        JNE inner_loop_two_seconds

reset
        LDA Zero
        STA Digit0
        STA Digit1
        STA Digit2
        STA Digit3
        STA Digit4
        STA Digit5
        STA TrafficLights
        STA TenMsCounter

        LDA game_end
        JNE endAfterReset
        JMP main

end
        LDA game_end
        ADD One
        STA game_end
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

A_Segment DEFW &F7   
B_Segment DEFW &128F  
C_Segment DEFW &39   
D_Segment DEFW &120F  
E_Segment DEFW &F9   
F_Segment DEFW &F1   
G_Segment DEFW &BD   
H_Segment DEFW &F6   
I_Segment DEFW &1209
J_Segment DEFW &1E   
K_Segment DEFW &2470
L_Segment DEFW &38  
M_Segment DEFW &536  
N_Segment DEFW &2136 
O_Segment DEFW &3F   
P_Segment DEFW &F3  
Q_Segment DEFW &203F 
R_Segment DEFW &20F3 
S_Segment DEFW &18D  
T_Segment DEFW &1201 
U_Segment DEFW &3E   
V_Segment DEFW &C30  
W_Segment DEFW &2836 
X_Segment DEFW &2D00 
Y_Segment DEFW &1500 
Z_Segment DEFW &C09  

Zero_Segment    DEFW &C3F  
One_Segment     DEFW &406  
Two_Segment     DEFW &DB  
Three_Segment   DEFW &8F  
Four_Segment    DEFW &E6  
Five_Segment    DEFW &ED  
Six_Segment     DEFW &FD  
Seven_Segment   DEFW &1401 
Eight_Segment   DEFW &FF  
Nine_Segment    DEFW &E7  
DP              DEFW 0b100000000000000

Zero    DEFW 0  
One     DEFW 1  
Two     DEFW 2  
Three   DEFW 3  
Four    DEFW 4  
Five    DEFW 5  
Six     DEFW 6  
Seven   DEFW 7  
Eight   DEFW 8  
Nine    DEFW 9  


Time            DEFW 0
Ten             DEFW 10
Hundred             DEFW 100
Thousand        DEFW 1000
TenThousand        DEFW 10000
TenMsCounter    DEFW 0

Tens            DEFW 0 
Units           DEFW 0
Tenths          DEFW 0
Hundreths       DEFW 0

Counter         DEFW 0 ; this will store the time taken for them to click the correct button
MaxPos          DEFW 32766
Delay           DEFW 750 ; This is the delay for 1ms using the given formula on the exercise sheet and a 3Mhz clock
delayLoop       DEFW 0; this is how many times the delay counter should run in order to produce a 1ms delay
ToCheck         DEFW 0
game_end        DEFW 0

temp            DEFW 0
tempOne         DEFW 0

BuzzerNoiseOne  DEFW 0x8A53
BuzzerNoiseTwo  DEFW 0x8A51
BuzzerNoiseThree  DEFW 0x8A50
BuzzerNoiseFour DEFW 0xAFF


; These are values for for the pseudo random generator which uses Linear Congruential Generator
mod     DEFW 600
inc     DEFW 63
mul     DEFW 21
seed    DEFW 472 ; This is the starting value

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
Buzzer DEFW 0

ORG &FFF
TrafficLights DEFW &0



; From running the formula in a python instance, seed should be 7430 so the delay between red and amber should be roughly 7.4 seconds
; Next, seed should be 6093 so delay between amber and green should be 6 seconds

; for the button the chosen One should be 0

; on second run of the game pause between red and amber should be 63 ms
; amber and green should be 1.3 seconds
; the button to press should be 0 again

