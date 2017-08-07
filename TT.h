// original tentec defines for pinmode setup
// various defines
#define SDATA_BIT                           10          //  keep!
#define SCLK_BIT                            8           //  keep!
#define FSYNC_BIT                           9           //  keep!
#define RESET_BIT                           11          //  keep!
#define FREQ_REGISTER_BIT                   12          //  keep!
#define AD9834_FREQ0_REGISTER_SELECT_BIT    0x4000      //  keep!
#define AD9834_FREQ1_REGISTER_SELECT_BIT    0x8000      //  keep!
#define FREQ0_INIT_VALUE                    0x01320000  //  ?

// flashes when button pressed  for testing  keep!
#define UNO_LED                             13
#define PSEL_PIN                            13   

#define Side_Tone                           3           // maybe to be changed to a logic control
                                                        // for a separate side tone gen
#define TX_Dah                              33          //  keep!
#define TX_Dit                              32          //  keep!
#define TX_OUT                              38          //  keep!

#define Band_End_Flash_led                  24          // // also this led will flash every 100/1khz/10khz is tuned
#define Band_Select                         41          // if shorting block on only one pin 20m(1) on both pins 40m(0)
#define Band_Select2                        42          // the A pin used as digital  ( A is a/d reference ).
#define Multi_Function_Button               2           //
#define Multi_function_Green                34          // For now assigned to BW (Band width)
#define Multi_function_Yellow               35          // For now assigned to STEP size
#define Multi_function_Red                  36          // For now assigned to USER

#define Select_Button                       5           // 
#define Select_Green                        37          // Wide/100/USER1
#define Select_Yellow                       39          // Medium/1K/USER2
#define Select_Red                          40          // Narrow/10K/USER3

#define Medium_A8                           22          // Hardware control of I.F. filter Bandwidth
#define Narrow_A9                           23          // Hardware control of I.F. filter Bandwidth

#define encoder0PinA                         7
#define encoder0PinB                         6
#define PSK_MOD_PIN                          4

