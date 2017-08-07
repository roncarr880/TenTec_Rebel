
/* uno32 program for the TenTec REBEL with some hardware mods */
/* use at your own risk */

/* before using: */
/* change the call sign in the CQ message */
/* change the WSPR message before transmitting WSPR */
/* change the macro's */

/* by K1URC */


/*  

Hardware mods:
 The code read function has been changed to the cw speed pot.  The center of the pot is connected to the output
 of the AGC op amp( junction of C97 and R48) via a 1k resister and 0.1uf cap in series.  The pot is centered.
 The signal level on the original code read pin is too low to be useful.  The mod gives the signal more gain.
 If this mod is not done, the code read function and band scope will not work.  All else will be ok.
 
 PSK31 AM modulator:
                                           /
 0----------\/\/\/\/----------0-----------0  0------------- to center of R21 the Final FET Bias Pot
 pin 4       Ra               |                             you can wire this on the top of the board
                              |         Rb                  no need to remove the bottom case
                              --------/\/\/\/\------|
                                                    |
                                                   ---
                                                  / / / 
 For the switch, I repurposed the on/off switch.  It enables the modulator and provides low power for WSPR, RTTY, JT65.
 You could use a jumper in place of the switch if you normally leave the cover off.
 For Ra and Rb you would be best served with a couple of 1k trim pots.  Rb will set the power out and
 Ra should be adjusted for best IMD.   For fixed values I have tried Ra = 330 and Rb = 510 which provided about
 1/2 watt or so out.  Ra = 270 and Rb = 820 provided about 1 watt or so out.  The value of Ra is fairly critical
 for example with Rb at 510; Ra = 330 gave -33 IMD, 300 gave -20 IMD.  There are two software parameters for tweaking the IMD,
 the mimimum pwm duty cycle and the modulation delay count.  I put these in the menu system for easy testing.
 Their effect is minimal, you may gain 2 to 5 db in IMD with adjustment. I am using the 330,510 resistor pair which I 
 think may be ok to use without a heatsink mod.  I am getting -30 or better IMD readings.
 
 
 The code read and bandscope needs the nokia display in order to be useful.  Coderead will work without 
 the display but it will be extremely difficult to tune the signal in correctly without the bandscope. An
 alternate to the nokia display would be to run the radio audio to a waterfall display like in fldigi 
 and use the serial terminal and serial menu options. 

***************************************************************************************
 for buttons 
   tap = forward
   double tap = back
   long press = select for user - toggles an option on or off
   long press function = frequency announce   
   8 options for user functions - long press of select will toggle the function on/off
      mode menu - cw or rtty or one of the added modes ( psk,mfsk,hell,wspr,jt65,memory tuning )
      CodeRead  ( or turns on the LED s meter if no display )
      Spot auto tune
      Send CQ
      Band Change 
      Split mode
      VFO B mode
      Lock VFO's
   The LED's blank when not pressing buttons to save rx current.

     
The basic idea of this program for the rebel is it can be used portable without the display, or used in the 
shack with the display and computer control.  The default is currently field mode with battery saving 80 ma current.
On startup, the mode menu will display and one can easily change to display mode when in the shack.

The nokia display contrast adjustment or Macro menu is a long press of select when the function is BW.
The keyer speed adjustment is a long press of select when the function is STEP.
Make adjustments using the tuning encoder.
Press the function button to exit. 
The nokia display has help text on the S meter line as what you will get with a long press of select.
  
 Changes:
  Rev 4.3   3/11/16
    MFSK16 modem and decoder.
      Moved the MFSK offset to 878 hz so it can be close to a multiple of 15.625 when mixed to lower tones.
      The decoder will only work when the narrow bandwidth filter is selected.
  Rev 4.2   2/20/16
    Fixed some issues with the new terminal code - rtty carriage return and hellschreiber idle characters.
    Added a software scope debug tool to allow viewing the waveforms in the decoders and digitial filters.
      (Set up the probes ( ch1 and ch2 ). Compile and upload.  Enable with long press of function.)
    RTTY Decoder - reworked the clock recovery code.  Previous code was more suitable for syncronous clock
       recovery. 
    PSK31 decoder - wrote a 2nd decoder and some functions so it could be compared to the original.  The new
       decoder is active when the bandwidth selected is narrow.  It is sometimes better but not always depending upon
       the signal being recieved, fading, noise, distortion etc.
    Removed the mode specific nature of the macro's.  We now we have a pool of 20 general purpose macro's.   
  Rev 4.1   2/10/16
    Added a PSK31 decoder.  It works ok when signals are in the clear( more than 100 hz away ).
    Added MFSK16 mode transmit.  Got lazy with the mode specific macro's and MFSK and RTTY share the same macro's.
      The offset is 878 (900) hz to the low tone which centers the signal at 995(1017) hz in the narrow bandwidth filter.
      If set up in a memory channel for 60 meters, the channel offset should be specified as -995(1017) to transmit
        in the center of the channel.   This is a USB mode.
      Use FLDIGI, Airlink Express or similar program for receive.
      Did not include the extended character set ( values above 127 ) as the auto_tx routine uses bit 7 for something else.
    Changed some memory channels to have 3 W1AW digital channels, one each for RTTY, PSK31 and MFSK16. 
    Changed the WSPR timing to 1.46484375 baud.  Previously 1.4648.
    Played around with user help to display the mode and sideband when function is user and select is menu.
      Memory channel tuning also displays this info.
    Added a menu to allow user to override the sideband in use for some modes.  Default is the most used option.  
    When in serial terminal mode, enabled the decoders to always write to the terminal even if not writing to the nokia.
    In terminal mode, Control Q or Control S will toggle the receive decode stream on and off.  Characters are 
      discarded when the stream is off.
    To summarize the terminal mode commands:
        Control T - start transmit.  CW and Hellschreiber do not need this command, just start typing.
        Control R - change to receive when buffer is empty.  CW and Hellschreiber do not need this command.
        Control U - flush buffer and return to receive quickly.
        Control Q or Control S - toggles quiet mode on and off.  Decoded text is discarded.
    Pulled the serial terminal code out of loop() and re-wrote it so the logic is easier to understand.
    Made the S meter a bit more conservative in the readings it displays.    
    (Thinking about removing the mode specific nature of the macro's and just having a pool of 16 or 20.)
  Rev 4.0   1/21/16
    PSK31 mode transmit - proof of concept.  The offset is 1000 hz.  40 meters tunes on LSB, so you will need to tune above 
    the normal frequency by 2 khz.  For now, use FLDigi or Digipan type programs to receive.
    Enabled the PSK mod pin and driving it high for JT65 and RTTY modes to provide about 1/2 watt out on those modes
    where before it was 1/4 watt when using the 510 resistor low power mod as explained below somewhere.
  Rev 3.7   1/16/16
    Enabled sending Hellschreiber via the key jack.  In using the key jack an external program would provide all the timing,
       and fonts needed to transmit the characters via a hardware interace. ( much like using the keyjack for rtty sending ).
       Basically the key jack is forced to be in straight key mode.
    Changes to the save restore feature to hopefully not save memory tuning information.  Added saving the band we were on.
    Added AE6RQ memory setups to the memory stucture array. Fixed some setup issues, mine and his.   
  Rev 3.6   1/08/16
    Added preset memory channels.  They are general purpose.  They are enabled in the mode menu.  There are more menu choices
       in the mode menu than lines available on the nokia display, so keep going past JT65 in the menu and the Memory Tuning mode
       will appear.
    Made RTTY mode always USB and removed the rty_invert code.
    Swapped the position of RTTY and HELL in the menu's.  Adjusted *menu[15] array to account for this change.
    Added a sliding offset where upon turning RIT fully clockwise the signal will center in the middle of the passband.
       Turn back to middle to use the RIT at the new offset.
       Turn back to fully counterclockwise to return the offset to the value chosen in the menu.
       This is a CW mode only feature.       
  Rev 3.5   1/07/16
    Adding tx macro's over the display contrast option.  Macro's available for CW, Hell, and RTTY modes.  The contrast adjust
    is only available when in WSPR or JT65 modes as macro's have no use in those modes.
    I notice HFWST hangs on loading FSK values sometimes.  I tried the original Skunk Werx sketch and it also hung.  The issue
    could be my very old slow laptop.  Renamed my morse header file as it conflicted with the morse library file.
  Rev 3.4   1/04/16
    Changed the frequency calculation method from a VFO +- IF to a VFO +-BFO +- Offset type.  I think this will make the
       offsets for WSPR and JT65 easier to understand and manipulate. 
       It is easier to calibrate the radio.  See some discussion below where Reference and bfo are defined. 
       When in CW mode and narrow or medium bandwidth the display will show actual CW frequency, else SSB carrier freq.
    Add to the menu's a choice of CW offset tone/pitch.  Many like a low tone but the use of a low tone puts the desired signal
       on the edge of the IF filter passband.  I think we can go as low as 600 but the center of the passband is about 1K Hz.
    Corrected an assumption I had about the center of the JT65 waterfall - the center is at 1270 hz and not 1500. 
    Fix missing start bit on rtty transmit characters.  
  Rev 3.3  12/28/15
    Fixed the CR/LF behavior of the SERIAL MENU's.  Fixed the cq message not transmitting when in RTTY mode with the key
       interface selected.
    Add JT65 mode.  Use in conjuction with the HFWST program provided by the Skunk Werks group.   
       This implementation is somewhat different as the Rebel controls the band and frequency of operation.  Keep HFWST thinking it is
       on 20 meters at 14076.   HFWST did not decode for me until I moved it to a simple directory \hfwst and created a shortcut on
       the desktop.  I did not investigate why, perhaps the former path was too long or the spaces in the path were an issue.
       (Have experienced some crashes during debug which seem to be related to itoa() or prints to the screen.)
    Disabled RIT when in WSPR or JT65 modes.
    JT65 uses the split vfo feature but the tuning is in lock step keeping the same offset as original.  The VFO is originally locked
       but you can unlock and tune around and still stay frequency netted to what you see on the JT65 waterfall.  Useful for when
       the band is busy and users spread out.
    Returning to CW,Hell,RTTY from WSPR or JT65 was annoying as the split setup was still in place - so saving the setup and restoring it
    before and after the menu's for the non-split modes.   
  Rev 3.2  12/18/15
    See no reason why the dumb terminal send method shouldn't also work for CW and Hellschreiber. 
    New send methods are using the key jack, Perl GUI program, or a plain dumb terminal program ( like hyperterm or putty ).
      Dumb terminal control:
        For RTTY: Control T enables the transmitter.   Control R to return to receive.  Control U flushes the buffer and aborts.
        For Hell: control T and control R enable and stop idle characters.  Otherwise for Hell and CW the keyboard is always live.
      When using the terminal method, no CAT emulation is possible as the serial port is in use.
      The terminal baud rate is 1200 but you can change it to whatever you want and recompile.  Look in top_menu() for the 
      hardcoded number.
    If the user doesn't have a nokia display, the menu's can be viewed in a terminal screen.  If you don't want this feature
    you can disable it at compile time with defining SERIAL_MENUS as zero.  
    Added WSPR mode.  Tuning is via the split feature.  The 40 meters display will look odd as the split is wide in order to tune USB.
    Added a time sync up to WWV for WSPR.  Runs about every 40 minutes for 20 seconds.
    Initial time sync up is via pressing a button at the correct time in the menu's.
    See below for some instructions for setting up the WSPR message and defaults for other menu items.
  Rev 3.1  12/14/15
    Converted the mode power up menu to a general menu'ing system and went crazy with putting all the compile time options 
    into the menu's making them run time options - Cat Control Emulation, band limits, serial decode,etc.
    Make menu selections by turning the tuning knob and pressing select or function when choice is highlighted.
    Re-enter the menu's with user function zero - function led red and select led's blank.
    Added RTTY send via a dumb terminal program for example hyperterm ( default baud is 1200 )
  Rev 3.0  12/03/15
    Add RTTY decoder and send via the paddle inputs.  Dah input will key the transmitter and Dit input will alter the tone
    transmitted.
    
    *** IMPORTANT - you must do a heat sink mod if you wish to send RTTY at full power *** 
    
    Implemented a top menu at powerup. Use the Tuning knob to make a choice.  Press select or function to exit.
    The selection will timeout in 20 seconds if there is no activity on the knob or buttons. 
    The default selection is CW in the field mode without a display as this choice will be blind if not using a display.
    The display on/off selection ( user selection 0 - no LED's lit ) has been changed to show the menu.
    The transmit indicator has been removed from the TenTec LED and a RIT active indicator(dimly lit) has been added.
    Transmit indicator is change in nokia display and the battery status that is displayed in the select LED's
  Rev 2.2  12/20/14
    Changed the refresh rate of the bandscope from 100 frames/sec to about 12.  This was an attempt to reduce the
    noise generated by the lcd writes to the nokia display.  Also some types of signals were difficult to see with
    the fast refresh rate. 
  Rev 2.1  11/22/14
    Add 30 and 17 meter bands to the bandswitching routines.  The extra bands can be easily skipped-look for comment(++band) in the code.
    Add auto spot function in place of the s meter on/off function.
    Use the dsp signal for the s meter when the display is active.
    Add battery reading and low battery warning.
    Swap positions of the band change and spot functions in the user rotation.
    Fix some Rebels not powering up in receive dds mode.
  Rev 2.0  11/01/14
    The cut numbers option is now a home/portable option called DISPLAY.  When enabled, the display code runs. 
    When display is disabled the cut numbers are active and the battery saver mode is also active.
    Hardware mod for coderead.  Connected the output of the AGC op-amp to a 1k resistor and .1uf cap in series.  The cap is
    connected to the CW speed pot center connection.  The pot is centered.  CodeRead is assigned to this input instead of the original.
    (The signal level on the original CodeRead input is too low)
    Add DFT spectrum display of the passband.   Add coderead function as a user option.( user option 1-green )
  Rev 1.9  10/16/14
    Nokia 5110 display code added.
    Removed choice of tuning digits to display in the LED's.  Changed that menu function to code read for future use.
  Rev 1.8  9/30/14
    Keyer code speed adjust on longpress select when in the Step function and adjust using the tuning encoder knob.
    Exit with a function button press.
  Rev 1.7  8/26/14
    Code support for the band switch module.  If the unit boots up with the jumper detect low, this feature is 
    disabled to avoid driving the output pin with a jumper in place.
  Rev 1.6  5/24/14
    Battery saver mode with cpu sleep/idle and LED's out when not pushing buttons or tuning.
    Rx current about 80ma as opposed to 150ma or so.
    Added choice of tuning digits to display in the LED's ( see user functions below )
  Rev 1.5  4/20/14
    Add hellschreiber and cw keyboard transmit with a windows gui written in perl.  
    Add .7 volts to the battery reading to compensate for the protection diode voltage drop.
  Rev 1.4 
    Add a battery low indication on the red select led.
    Add no tuning zones to prevent hearing damage when using headphones.
  Rev 1.3
    Added a choice of TenTec Argonaut cat emulation at 1200 baud in addition to the K3 emulation.
    Keep CTS,RTS and DTR off as it helps with the reset issue mentioned below.
  Rev 1.2
    Add Elecraft style K3 cat emulation at 38400 baud.  HRD works but sometimes fails to start - 
    the radio is sometimes held in reset. There is mention of an etch cut on the Uno32 board to avoid this.
    I didn't cut, I just try it again and it works.
    All indications are that serial.print blocks.  Added serial write staging buffer to maintain the loop timing.
  Rev 1.1
    Change split indication from the function leds to the tentec led, blinks twice or once depending
    upon swap or not.  User split is set to on when changing swap split, enter split with either option.    
  Rev 1.0  3/21/14 
*/

#include "TT.h"      // original TT defines for pinmode setup
#include "K1_morse.h"   // also has baudot table.  Renamed as conflicts with Library with name morse.h  
#include "helldefs.h"
#include "sine_cosine.h"
#include "varicode1.h"
#include "fec_table.h"

/* !!!! change this to your call or whatever message you wish to auto transmit */
const char cq_msg[] = "CQ CQ CQ CQ DE K1URC K1URC K1URC K";    /* must use capital letters here */

/*  !!! change this if you will use the WSPR transmitting feature */
//      Download WSPRcode.exe from  http://physics.princeton.edu/pulsar/K1JT/WSPRcode.exe   and run it in a dos window 
//      Type (for example):   WSPRcode "K1ABC FN33 37"    37 is 5 watts, 30 is 1 watt, 33 is 2 watts, 27 is 1/2 watt
//      ( Use capital letters in your call and locator when typing in the message string.  No extra spaces )
//      Using the editing features of the dos window, mark and copy the last group of numbers
//      Paste into notepad and replace all 3 with "3,"  all 2 with "2," all 1 with "1," all 0 with "0,"
//      Remove the comma on the end
//      Paste the result below in place of this group of numbers
//  WSPR is a high duty cycle mode with a key down time of almost 2 minutes.  You will need a heat sink mod or reduce power.
//  the current message is   "K1URC FN54 23"
const char wspr_msg[] = { 
 3, 3, 2, 2, 2, 0, 0, 2, 1, 2, 0, 2, 1, 1, 1, 2, 2, 2, 3, 0, 0, 1, 0, 1, 1, 3, 3, 2, 2, 0,
 2, 2, 0, 0, 3, 2, 0, 3, 0, 1, 2, 0, 2, 0, 0, 2, 3, 0, 1, 3, 2, 0, 1, 1, 2, 1, 0, 2, 0, 3,
 3, 2, 3, 2, 2, 2, 2, 1, 3, 2, 3, 0, 3, 0, 3, 0, 3, 2, 0, 3, 2, 0, 3, 0, 3, 1, 0, 2, 0, 1,
 1, 2, 1, 2, 3, 0, 2, 2, 3, 2, 2, 0, 2, 2, 1, 0, 2, 1, 2, 0, 3, 3, 1, 2, 3, 1, 2, 2, 3, 1,
 2, 1, 2, 0, 0, 1, 1, 3, 2, 2, 2, 2, 0, 1, 0, 1, 2, 0, 3, 1, 0, 2, 0, 0, 2, 2, 0, 1, 3, 0,
 1, 2, 3, 1, 0, 2, 2, 1, 3, 0, 2, 2
 };

/* Macro's  -  Enable with long press of select when function is bandwidth, exit with a press of function */
/* a tap of select will send the text */
// Put whatever you wish in these but keep in mind the tx buffer is 128 characters long without any overfill checking.
const char mmc0[] = "CQ CQ CQ CQ de K1URC K1URC K1URC k \r\x12";   
const char mmc1[] = "de K1URC K1URC K1URC k \r\x12 ";                 // ( x12 is control R, back to RX mode )
const char mmc2[] = "ur rst is ";
const char mmc3[] = "Name is Ron Ron  QTH is China, Me. China, Me. ";
const char mmc4[] = "Rig hr is a TenTec Rebel - 5 watts to G5RV ant up 30 ft. \r"; 
const char mmh0[] = "TKS fer qso - 73 ES GL ";
const char mmh1[] = "";
const char mmh2[] = "...CQ CQ CQ FELD HELL SPRINT DE K1URC K1URC K1URC...\r\x12";
const char mmh3[] = "TU 599 599 ME ME #4630 #4630 FN54 FN54 ";
const char mmh4[] = "73 AND GOOD LUCK DE K1URC\x12";
const char mmp0[] = "";     
const char mmp1[] = "Hello OM and Thanks for the call/report\r ";
const char mmp2[] = "Name is Ron Ron, QTH is China,Me. China,Me.\r ";
const char mmp3[] = "Locator FN54fk FN54fk ";
const char mmp4[] = "\rMY STATION:\r   TenTec Rebel at 1/2 watt\r   G5RV antenna up 30 feet\r ";
const char mmr0[] = "";
const char mmr1[] = "QTH is Liberty, Me.  Liberty, Me.";
const char mmr2[] = "Running portable with TenTec Rebel and BuddiStick Antenna \r";
const char mmr3[] = "";
const char mmr4[] = "SOTA summit is ";

 // edit the above and leave this alone
const char *macro[20] = { mmc0,mmc1,mmc2,mmc3,mmc4,mmh0,mmh1,mmh2,mmh3,mmh4,mmp0,mmp1,mmp2,mmp3,mmp4,mmr0,mmr1,mmr2,mmr3,mmr4}; 

#define WSPR_TX_OFFSET  38      // enter a number between -100 and 100 ( compile time option )

#define SERIAL_MENUS 0      // define as 1 if wanted.  Useful if you don't have a nokia display. May interfer with CAT control.

/******* menu defaults - set to what you use the most but can always change via the menu when operating *******/
/* leave the defines alone and just change what is assigned to the variables */

/* computer control emulation */
#define NO_EMU 0          
#define ARGO_EMU 1
#define K3_EMU  2
int cat_emu = ARGO_EMU;     // must use Argonaut V emulation if running the Perl control program, otherwise your preference

/* tx lockout by license class, allow general coverage receive */
#define EXTRA 0
#define ADVANCED 1
#define GENERAL 2
#define NOVICE 3
#define EUROPE 4
int band_limits = ADVANCED;        // change this line for a different default  


int serial_decode = 0;    // when enabled sends the decoded morse or rtty on the serial line 
                          // one can use hyperterm (for example) to see the text on a larger screen than the nokia display
                          // this might interfer with CAT control but am alowing both to be enabled at the same time.

#define JUMPERS 0
#define TWO_BAND 1
#define FOUR_BAND 2
int band_switch = FOUR_BAND;    // type of  band switch module installed
                                // you probably will want to change this to TWO_BAND

int cut_num_enable = 0;   // cut_num_enable = 1 may be useful for when using the radio without a display
                          // when enabled each change of 10 khz is announced in morse
                          // this is not a menu item as it is most useful when lacking a display 
                          
int rtty_on_leds = 0;     // when enabled the green led's will flash with the decoded rtty signal

/* sending method - for rtty one can use a hardware interface wired to the key jack, or use a terminal program */
/* this also allows CW and Hellschreiber to be sent via a terminal program */
/* the key jack will always send CW if not using RTTY with the hardware interface wired to the key jack */
#define CRH_TX_KEY 0
#define CRH_TX_TERM 1
#define CRH_TX_PERL 2      // using the Perl GUI - I don't think many users have tried this
int crh_tx_method = CRH_TX_KEY; 

//  CW offset tone must be 600 or above or the bandscope/auto spot/decode will be broken I think
//  the tones need to be on multiples of 100 because of the way the fft and cw decoder works.
//  if you really want a different pitch that is not a multiple of 100 and don't care about the decoder,
//  look in top_menu() at how the mode_offset for CW is calculated.  Changing stuff here won't do anything.
#define  CW_TONE_600 0
#define  CW_TONE_700 1
#define  CW_TONE_800 2
#define  CW_TONE_900 3
#define  CW_TONE_1000 4
int cw_offset_tone = CW_TONE_900;      // 1000 or 1100 is the center of the narrow filter

/* modes */
#define CW 0        
#define HELL 1
#define PSK31 2
#define RTTY 3     // rtty and above always tune USB
#define MFSK 4
#define WSPR 5
#define JT65 6
#define WEFAX  7
#define MEM_TUNE 7     // overlays WEFAX as a mode
#define SSB 7          // sort of a dummy mode for the memory channels

int wpm = 12;          /* default paddle speed - you may want to change this */

const int sliding_offset_enable = 1;   // The offset change via RIT control feature ( compile time option )

/****************   End of user options and default values - remember can always change in menu at runtime  *****************/

#define LSB 0
#define USB 1

struct MEMORY {
  char name[15];
  long freq;
  int band;  // use only 0 and 2 for a 2 bandswitching module, 0=40 1=30 2=20 3=17
  int sideband;
  int offset;
  int mode;  // JT65 and WSPR not allowed as memory tune modes
};
//  Edit the below for your needs.  If you have a 2 band module you will want to pick frequencies close to 20 and 40 meters
//  The TenTec filters are pretty sharp in the Rebel, so your choices may be limited.
//  Frequencies close to 9 mhz tuned USB will have poor image rejection. 
//  The channels can be used for any general purpose.  I just loaded them with WEFAX cause I like to watch paint dry.
//  You can add more or remove some by changing the NOMEM definition and the memory structure array below.
//  USB offsets should normally be negative and LSB positive.
//  The combination of the freq and offset specify the suppressed carrier freq the radio is tuned to.
//    As an example you can tune 60 meter SSB memory channel two ways 
//    { "60 Meters 1",  5332000, 0, USB, -1500 , SSB },  here the memory channed center is specified and an offset of 1500
//    { "60 Meters 1",  5330500, 0, USB, 0 , SSB },      here the suppressed carrier freq is entered directly 
//    The first way is handy when channel centers are specified as in WEFAX and 60 meters
//    The 2nd way is handy when you know the ssb suppressed carrier frequency directly as in net frequecies or tuning WWV.
//    For CW you need an offset or your transmit freq will result in a zero freq tone in the other guys receiver, he won't hear you.
//  You can tune around a memory channel by unlocking the VFO.
#define NOMEM 52
const struct MEMORY memory[NOMEM] = {
   { "40m QRP",        7030000, 0, LSB, 800, CW },   
   { "40m QRP",        7040000, 0, LSB, 800, CW },   
   { "40m QRP",        7060000, 0, LSB, 800, CW },   
   { "TT 40m CW Net",  7063000, 0, LSB, 800, CW },  
   { "TT 40m SSB Net", 7263000, 0, LSB, 0, SSB },  
   { "20m QRP",     14060000, 2, USB, 800, CW },   
   { "20m Beacon",  14100000, 2, USB, 800, CW },   
   { "TT 20m SSB Net", 14325000, 2, USB, 0, SSB },     
   { "W1AW PSK31",   7095000, 0, LSB,  1000 , PSK31 },  
   { "W1AW MFSK16",  7095000, 0, USB, -995 , MFSK },
   { "W1AW RTTY",    7095000, 0, USB, -1000 , RTTY }, 
   { "W1AW Code"   , 7047500, 0, LSB, 900, CW },   
   { "60 Meters 1",  5332000, 0, USB, -1500 , SSB },    // way down on the 40 meters passband
   { "60 Meters 2",  5348000, 0, USB, -1500 , SSB },    // but may hear very load stations
   { "60 Meters 3",  5358500, 0, USB, -1500 , SSB },
   { "60 Meters 4",  5373000, 0, USB, -1500 , SSB },
   { "60 Meters 5",  5405000, 0, USB, -1500 , SSB },
   { "60 Meters CW 1",  5332000, 0, LSB, 900 , CW },    
   { "60 Meters CW 2",  5348000, 0, LSB, 900 , CW },    
   { "60 Meters CW 3",  5358500, 0, LSB, 900 , CW },
   { "60 Meters CW 4",  5373000, 0, LSB, 900 , CW },
   { "60 Meters CW 5",  5405000, 0, LSB, 900 , CW },
   { "Boston",       6340500, 0, USB, -1900 , WEFAX },
   { "Halifax",      6496400, 0, USB, -1900 , WEFAX },    // may not be active according to my list
   { "Sydney NS",    6915100, 0, USB, -1900 , WEFAX },  
   { "Murmansk USSR",6444500, 0, USB, -1900 , WEFAX },
   { "New Orleans",  8503900, 1, USB, -1900 , WEFAX },
   { "Pt. Reyes",    8682000, 1, USB, -1900 , WEFAX },
   { "Northwood UK", 8040000, 1, USB, -1900 , WEFAX },
   { "Boston",       9110000, 1, USB, -1900 , WEFAX },    // the dds will be 110 khz for this one, image on 8890000
   { "Boston",      12750000, 1, USB, -1900 , WEFAX },
   { "New Orleans", 12789900, 1, USB, -1900 , WEFAX },
   { "Pt. Reyes",   12786000, 1, USB, -1900 , WEFAX },
   { "Kodiak",      12412500, 1, USB, -1900 , WEFAX },
   { "Honolulu",    11090000, 1, USB, -1900 , WEFAX },
   { "Tokoyo",      13988500, 2, USB, -1900 , WEFAX },
   { "Hamburg",     13882500, 2, USB, -1900 , WEFAX },
   { "New Orleans", 17146400, 3, USB, -1900 , WEFAX },   
   { "Pt. Reyes",   17151200, 3, USB, -1900 , WEFAX },
   { "Taipei",      18560000, 3, USB, -1900 , WEFAX },
   { "Air Volmet",   6604000, 0, USB, 0 , SSB },
   { "Air NY E",     6628000, 0, USB, 0 , SSB },
   { "Air Carib A",  6577000, 0, USB, 0 , SSB },
   { "Air Carib B",  6586000, 0, USB, 0 , SSB },
   { "Air LDOC",     6640000, 0, USB, 0 , SSB },
   { "Air NY A",    13306000, 2, USB, 0 , SSB },
   { "Air NY E",    13354000, 2, USB, 0 , SSB },
   { "Air Carib B", 13297000, 2, USB, 0 , SSB },
   { "Air LDOC",    13330000, 2, USB, 0 , SSB },
   { "CHU Canada",   7850000, 0, USB, 0 , SSB },     // chu is usb with carrier re-inserted  
   { "WWV",         10000000, 1, LSB, 0 , SSB },   
   { "WWV",         15000000, 2, USB, 0 , SSB }   
}; 



int channel = 0;     // current memory channel.
int mem_tune = 0;

// Other mods I have done that do not need to be implemented.
// I implemented a low power feature by removing the wiring from the on/off switch, jumpering the power on the board so 
// that the Rebel is always on.  I wired the switch so that a 510 resistor to ground is added to the center of the final
// FET bias pot.  When the switch is down/off the power out is 250 mw and when up/On it is the normal 5 watts.
// All the wiring was done on the top side of the board, so removal from the case was not required.
// Low power is used for WSPR and JT65 and RTTY if transmission is long.  CW and Hell are low duty cycle modes and high power is OK.
// WSPR does drift a bit so I may be adding a heat sink mod or a temperature stabilization method.
// I have since converted the low power feature into the PSK31 AM modulator.
// AGC - I removed U$91 from the circuit with etch cuts and added an agc controlled attenuator in front of the 1st mixer.
// Power out - I added and since removed a 8.2 k resistor from the power out test point to ground.  The power out voltage exceeds
// 3.3 volts preventing an accurate reading at 5 watts out.  The very small coupling cap also complicates resistor divider calculations.
// I unsoldered one side of C22 and effectivly removed it from the circuit.  This reduces the gain of the LM386 by 20db but more
// importantly it removes all the hiss noise.  The waterfall on fldigi is much cleaner with this mod.

#define PWR_WARN   1  //  set to 1 if you have a low power mod and wish to be notified if the power out is incorrent for the mode in use.

#define NUMBANDS 7                         // general has 6 segments 40 to 17 meters
   const int bandstart[5][NUMBANDS] = {
   {7000,14000,10100,18068,5331,0,0},           //extra
   {7025,14025,14175,10100,18068,5331,0},       //advanced
   {7025,7175,14025,14225,10100,18068,5331},    //general
   {7025,0,0,0,0,0,0},                       //novice
   {7000,14000,10100,18068,0,0,0}            //europe - add 60 meters if you want it enabled   
   };
   const int   bandend[5][NUMBANDS] = {
   {7300,14350,10150,18168,5406,0,0},
   {7300,14150,14350,10150,18168,5406,0},
   {7125,7300,14150,14350,10150,18168,5406},
   {7125,0,0,0,0,0,0},
   {7200,14350,10150,18168,0,0,0}        // I left out enabling 60 meters for Europe 
   };                                    // Set up your channels in the memory struct and enable here


int msec = 0;             // keep time for wspr
int sec  = 0;

#define SAVE 0
#define RESTORE 1

/* LEDs */
#define FGRN  0x20     // all on port D
#define FYEL  0x0800
#define FRED  0x40

#define SGRN  0x80     // on port D
#define SYEL  0x10     // on port F
#define SRED  0x20     // on port F

#define TTLED 0x2000

/* button states */
#define NOTACTIVE 0   // idle is a used constant in lib? - expected unqualified ID before numeric constant error 
#define ARM 1
#define DTDELAY 2
#define FINI 3        // done is a used constant in lib 
#define TAP  4
#define DTAP 5
#define LONGPRESS 6
#define DBOUNCE 60

/* band widths */
#define WIDE 1
#define MEDIUM 2
#define NARROW 3

#define ON 1
#define OFF 0

#define TXENABLE 0x40
#define DDS_SEL  0x80
#define PSEL 0x40        // mask value for bit RG6 
#define PSK_MOD 2        // mask for pin on RF1

#define BATTERYCHK A2
#define POWEROUT A3
#define SIGNAL   A1
#define RIT_PIN A0
// #define CODEREAD_PIN A6
/* coderead changed from A6 to A7 - the cw speed pot.
   it is connected to pin 7 of agc op amp via a 1 k resister and 0.1 uf cap in series.
   The pot is set to center 
*/   
#define CODEREAD_PIN A7
#define NO_DISPLAY_UPDATE 0
#define DISPLAY_UPDATE 1


#define MFSK_LOOPBACK 2      // software loopback for testing mfsk decoder algorithm - normally this should be zero
                             // greater than 1 is the percentage of errors introduced into the bit stream ( 4 bit errors at a time )

/* ************************************************* */

/* globals */

const long Reference           = 50000352L;     //  was 49.99975e6
                                                //  noticed freq was off 200 hz on 20 meters, and 100 hz on 40 meters
                                                //  tuned as 50000468 on a station receiver
                                                //  recent check was 50000352
                                                //  this drifts enough that the 1st JT65 transmission in my testing
                                                //  does not decode 

long bfo = 8999334L;      // the bfo drifts alot with heat and the parts are very close to the final FET 
                          // hot it may be 8999317 or lower, and cool 8999340 or higher.

/*
  Calibrate the rebel with a station receiver.  Allow both to warm up. You should transmit a bit.
  Run the audio of the station receiver to a program like fldigi.  Run a short antenna lead from the 
  station receiver to near the BFO test point.  A direct connection is not wanted nor needed.
  Tune near 9 mhz using USB.  Expand the scale in fldidi to 4X.  Tune the signal in
  so the waterfall trace is on 1K audio.  Add 1 K to the reading on the station receiver.  This is the bfo frequency.
  Repeat with the antenna lead near the Ref test point and tune near 50 Mhz.  This will be the Reference frequency.
  Don't forget to add the 1K audio offset to the reading of the station receiver.
*/

int fleds[] = {FGRN,FYEL,FRED};   // display for function button state 
int sleds[] = {0,SGRN,SYEL,SRED,SGRN+SYEL,SGRN+SRED,SYEL+SRED,SGRN+SYEL+SRED}; // extra for user functions
int sw_state[2] = {NOTACTIVE,NOTACTIVE};   /* state of the two switches */


int wspr_duty = 0;        // good idea to start at zero so tx doesn't take off when unwanted
int wspr_tx_enable = 0;   // tx this next 2 minute interval flag
int wspr_wwv = 3;         // different message depending upon how long ago wwv was successfully found
const char wspr_wwv_msg[4][4] = {
    "WWV", "wwv", "...", "   "
};

/* states of functions and selections and startup defaults */
int fun_selected[]  = {2,1,0};   
 //    2,      bandwidth yel = medium - 3 positions
 //    1,      step 100 - use 0 for step 10 - 4 positions   
 //    0       user function menu ( total of  8 user functions )
 
int function = 2;   /* start out in user - menu */

unsigned long tx_vfo,rx_vfo;
unsigned long tuning_rate;
unsigned long listen_vfo;
int rit_offset = 0;

int tdec, thun, tunits;
unsigned int led_on_timer= 0;

int  tx_inhibit= 0;
int  tdown = 0;
int  split = 0;

                
/* user options - general idea is when red led shows then be careful as it is a special function */
/* long press the select button to toggle the options on and off */
/* when the option is enabled, the function green led will be lit */
#define DISPLAY   0   /* no select LED's lit - this now brings up the menu */
#define CODEREAD  1   /* green - Nokia display of decoded text vs normal freq display */
#define SPOT      2   /* yellow  - auto tune signal */
#define BEACON    3   /* red - auto call CQ  */
#define BAND      4   /* green yellow  - band change */ 
#define SPLIT     5   /* green red -leds are split - extended RIT range */
#define SWAPVFO   6   /* yellow red - swap - tune and listen on TX freq - press again to exit or hit the paddle */
#define LOCK      7   /* green yellow red - lock vfo's */

   /* simple split operation */
   /* longpress 5 = enter split -  listen on RX freq - Tune RX - TX freq fixed - TT led blinks once  */
   /* longpress 6 = swapvfo - listen on TX freq - Tune TX - RX freq fixed - TT led blinks twice  */
   /* press swapvfo again or hit the paddle = swap back to listen on RX - Tune RX - xmit TX */
   

/*
   freq display in LED - turns on when tuning, off after a delay
   display the 100khz and 10khz digits  or the 10khz and 1khz digits depending upon step size
   digits 8 and 9 are displayed in the 3 LED's by dimming the Yellow and Red for 8 and Yellow for 9
   this only runs when no display is selected in the menu's ( what I am calling field mode )
*/


unsigned char user[8] = {0,0,0,0,0,0,0,0};   /* user flags  */

/* announce and beacon buffer - set msb on characters to key xmit */
#define ANNOUNCE_WPM 20     /* hardcoded  */
#define TXQUESIZE 128        /* must be power of two */
unsigned char  tx_queue[TXQUESIZE];
int tx_in= 0;
int tx_out= 0;
int tx_state= 0;
int autotx_timer= 0;

#define STQUESIZE 128
unsigned char stg_buf[STQUESIZE];  /* stage buffer to avoid blocking on serial writes */
int stg_in = 0;
int stg_out = 0;


unsigned char cut_numbers[] = 
{ 0b11000000, 0b01000000, 0b00100000, 0b00010000, 0b00001000, 0b00000100, 0b10000100, 0b10001000, 0b10010000, 0b10100000 };

int straightkey = 0;
int transmitting = 0;
int cel,nel;          /* current element, next element */
int tholdoff;         /* debounce straight key */
int tprotect = 0;     /* are you sitting on the key - enable again by hitting the function button */
long keyuptime = 0;   
unsigned int counter;   // used for paddle timing and idle characters in rtty and hell

#define DIT  0x40
#define DAH  0x80

/* encoder */
int en_lval;
int en_dir;

/* no tune areas - eardrum saver */
#define NUMNOZONE 4
unsigned long nozone[NUMNOZONE] = {9000000,11250000,13500000,18000000};
  

/* a bit of a hack to show 10 numbers in 3 LED's - leds are dim when displaying 8 and 9 to show overflow */
int fled89 = 0;
int sled89 = 0;

int bat_low = 0;
int bat_interlock = 0;

int hchar;        /* single char buffer for hell */
int hflag = 0;
int pchar;        /* same type of buffer for psk31 */
int pflag; 
int psk_dn_count;  // variable to produce steady carrier at end of transmission
int psk_mod_pwr;   // desired power out
int fflag;         // one character buffer for mfsk16
int fchar;

// psk IMD tweaking parameters.  These interact with the resister used for the pwm.
// putting these in the menu's so they can be easily investigated
int psk_min_duty = 600;       // Low power out min duty cycle. 
int psk_min_du = 2;           // menu option for the above
int psk_mod_delay = 4;        // delay in counts of the phase reversal compared to the pwm minimun power out


#define MARK_OFF 85       // rtty offsets from center.  Produce 170 hz shift
#define SPACE_OFF -85

/* band switch variables */
#define MAX_BAND 4
int bandswitch_enable = 1;    /* enabled or disabled */
int band;
long save_tx_vfo[] = {7031000L, 10107000L, 14060000L, 18096000L};    // these are now ssb carrier frequencies
long save_rx_vfo[] = {7031000L, 10107000L, 14060000L, 18096000L};
int save_split[] = {0,0,0,0};

int mode = CW;       /* default is CW and no display - ie field mode */
int sliding_offset;

// flags to modify what the tuning knob does
int wpm_adjust = 0;        /* code speed adjust using the tuning knob */
int contrast_adjust = 0;  /* nokia adjustment on the tuning knob */
int top_active= 0;       /* top menu on the tuning knob */
int select_macro= 0;     /* selecting a macro on the tuning knob */

/* nokia display */
#include <LCD5110_Basic.h>
extern unsigned char SmallFont[];
extern unsigned char MediumNumbers[];
extern unsigned char BigNumbers[];

#define NO_DISPLAY 0
#define NORM_D 1
#define SPLIT_D 2
#define DECODE_D 3
#define WPM_D 4
#define CONTRAST_D 5
#define MACRO_D 6

int nokia = NO_DISPLAY;  // must be zero the first time we put up the menu as the dsp_core isn't running - otherwise weird bug
int contrast = 65;
int timeout_ok = 0;
int save_nokia;           // save display setting when change to contrast or keyer speed screen
int nokia_s_inhibit= 0;   // separate nokia s meter from the LED s meter

LCD5110 LCD( 30,29,28,26,27 );   /* should reset be on I/O or tied to system reset. I used system reset */

/*  dsp variables */
long samples[8];      /* buffer so samples are not lost due to cpu timing */
int s_in, s_out;
int rty_in, rty_out;  /* rtty decode indexes into the same sample array */
int rty_modem_out;

#define OFFSET 16    // cosine offset from sine
#define MOD 63       /* mask for index value */
#define FFTSIZE 64

int sideband = USB;   // radio powers up on 20 meters in order to check for a band switching module
#define NORMAL 0      // sideband selection in menu now, normal is LSB on 40 meters and USB on 20
#define USB_ONLY 1    // can't have LSB only as 20 meters can't tune the vfo that high ( 14 + 9 beyond dds filter cutoff )
int sideband_mode = NORMAL;

// starting CW offset, the filter center is 1000 or 1100.  Below 900 one is on the edge of the passband.
int mode_offset = 900;    // this will change with each mode
int goalpost = 9;       // tuning slightly on the low side of the filter with these settings

int vals[FFTSIZE/2 + 1];    /* sin value */
int valc[FFTSIZE/2 + 1];    /* cos value */
int workval[FFTSIZE/2+1];
int plotval[FFTSIZE/2+1];
int workval1[FFTSIZE/2+1];
int workval2[FFTSIZE/2+1];
int w_max;
int w_max1;
int w_max2;
int mfsk_afc;
int go_plot;
int fast_plot;
int cread_buf[16];          /* code read buffer */
int cread_indx;
int quiet_mode;   // Control S or Q to suppress decoded garbage characters

/*
   With the 64 point fft and 6400 sample frequency we have about 10ms sample time for looking at morse decode.
   Based upon 1200/wpm we get this table for counts
   
                        Speed
              10    15    20   25   30          
element      12     8     6    5    4      dit
3 els        36    24    18   15    12     dah
7 els        84    56    42   34    28     
slicer       18    12     9    7     6

average anything equal to or over 12 counts as dah's to figure speed.  force slicer in bounds of 6 to 24.
Goal is to have it work from 10 to 30 wpm
*/

int dah_table[8] = {20,20,20,20,20,20,20,20};
int dah_in;
int shi5;     /* an attempt to extend the high speed decode above the designed 30 wpm limit


/*
  For RTTY the dsp core sample rate is 4000 ( instead of 6400 as in CW ).
  Each bucket in the DFT will represent 62.5 Hz.  ( In CW mode each DFT bucket is 100 hz )   
  The center is at 1000 hz.  The low tone is 915 hz.  The high tone is 1085 hz.  This puts it nicely in the center
  of the narrow passband.
  RTTY should be tuned with the narrow filter to avoid alias signals due to the low sample rate
*/


/* analogRead does not look re-entrant, so we are reading all analog values in the same core function and storing the 
   results in these global values for general use.  In battery saver mode the core function is disabled so
   in that case each analog routine will need to read the pin and refresh the global value */
int rit_value, power_value, battery_value, smeter_value;
int smeter_value2;     // dsp s meter


/* auto spot vars */
int spot_timer;
int spot[11];

unsigned long oldtime;       // made these global so can sync up the timer for wspr when in the menu's
unsigned long time;          // ( mainly they are loop() variables )

//  for WSPR - try tuning to WWV and syncing up the seconds clock once each 59 minutes
//  using 59 minutes to avoid a possible condition of always tuning when the 1500 hz tone is sent by wwv
//  the actual checking time is 40 minutes not 59
//  two band board will tune to 15 mhz,  4 band board to 10 mhz
#define WWV_TONE_DET  60       // # of counts needed for detection out of a possible 80 counts 
int wwv_tone;                  // the counter


long jt_buf[128];
long jt_fcalc0;       // rx dds word, saved so we can send it back on serial
int jt_tx_on;         // controls transmit
int jt_tx_index;      // where we are in 126 tx tones
int jt_time;          // serial timer to avoid blocking on writes to serial port

#define MFSK_GO  1
#define MFSK_STOP 3
int mfsk_flag = 0;    // mfsk16 transmit control


/*   SoftScopeTM  - a software oscilloscope  */
#define SOFTSCOPE 1     // 1 to enable the overlay of annouce frequency ( long press of function ), 0 for normal operation
int scope_active;       // control flag
int timebase;           // basically a sample decimate factor
int timeb;              // for the menu
int ch1, ch2, ch3;      // probes  ch3 overlays part of ch1
int ch1_data[80];       // sample storage
int ch2_data[80];



/* **************************************************** */
/* **************************************************** */

/* local Nokia routines specific to the Rebel hardware */
/* these are much faster than the Library routines  */

#define SETROW 0x40
#define SETCOL 0x80
#define CLK_B  0x10
#define DAT_B  0x08
#define DC_B   0x04
#define CS_B   0x02

void lcd_write(char dat){    /* write one byte, data or command */
unsigned int mask;

   if( scope_active > 3 ) return;   // stop all writes to the screen
   
   /* signals on port E.  D/C bit has been set as appropriate */
   LATECLR = CLK_B + CS_B;    // CS asserted low
   
   mask= 0x0080;
   while( mask ){
      if( dat & mask ) LATESET = DAT_B;
      else LATECLR = DAT_B;

     /* setup time data to clock */
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");

      LATESET = CLK_B;        // clock high
      mask >>= 1;             // next bit
      
     /* hold time */
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");
     asm("NOP");

      LATECLR = CLK_B;      // clock low

   }

   LATESET = CS_B;  // chip select unasserted
}

void lcd_command( char command ){

   LATECLR = DC_B;
   lcd_write( command );
   LATESET = DC_B;  
}
void lcd_goto( int row, int col ){   // 6 rows, 84 columns

   lcd_command( SETROW | row );
   lcd_command( SETCOL | col );   
}

void lcd_putch( char c ){    /* write one char from small font table */
int offset;
int i;

    offset = 6 * (c - ' ') + 4;
    for( i = 0 ; i < 6; ++i ){
      lcd_write(SmallFont[offset + i]);
    }  
}


void lcd_puts( char * p ){   /* write string using small font */
char c;
    while( c= *p++ ) lcd_putch(c);   
}



void scope_display(){
int active;

   active = scope_active + 1;
   if( active == 4 ) scope_display1();
   else if( active == 5 ) scope_display2();
   else if( active == 6 ) active = 0;
  
   scope_active = active;
   if( active == 0 ){
     LCD.clrScr();
     tuning_display();    
   } 
}

int max1,max2;
int min1,min2;

void scope_display2(){   // graph
int gmax,gmin;

  timeout_ok = 2;
  scope_active = 3;      // allow screen writes for this function
  LCD.clrScr();
//  gmax = ( max1 > max2 ) ? max1 : max2;
//  gmin = ( min1 < min2 ) ? min1 : min2;
//  if( gmin > 0 ) gmin = 0;
//  if( gmax < 0 ) gmax = 0;
  gmax = ( max1 < 0 ) ? 0 : max1;
  gmin = ( min1 > 0 ) ? 0 : min1;
  scope_graph( gmin,gmax,ch1_data,0 );
  
  gmax = ( max2 < 0 ) ? 0 : max2;
  gmin = ( min2 > 0 ) ? 0 : min2;
  scope_graph( gmin,gmax,ch2_data,3 );
}

void scope_display1(){   // data summary
int i;
int ave1,ave2;
char buf[35];

  scope_active = 3;     // sllow screen writes
  LCD.clrScr();
  ave1 = ave2 = 0;
  max1 = max2 = -9999999;
  min1 = min2 =  9999999;
  for( i = 0; i < 80; ++i ){
    ave1 += ch1_data[i];
    ave2 += ch2_data[i];
    if( ch1_data[i] > max1 ) max1 = ch1_data[i];
    if( ch2_data[i] > max2 ) max2 = ch2_data[i];
    if( ch1_data[i] < min1 ) min1 = ch1_data[i];
    if( ch2_data[i] < min2 ) min2 = ch2_data[i];
  }
  ave1 /= 80;
  ave2 /= 80;
  
  lcd_goto(0,0);
  lcd_puts("max ");
  itoa(max1,buf,10);
  lcd_puts(buf);

  lcd_goto(1,0);
  lcd_puts("min ");
  itoa(min1,buf,10);
  lcd_puts(buf);
  
  lcd_goto(2,0);
  lcd_puts("ave ");
  itoa(ave1,buf,10);
  lcd_puts(buf);

  lcd_goto(3,0);
  lcd_puts("max ");
  itoa(max2,buf,10);
  lcd_puts(buf);

  lcd_goto(4,0);
  lcd_puts("min ");
  itoa(min2,buf,10);
  lcd_puts(buf);

  lcd_goto(5,0);
  lcd_puts("ave ");
  itoa(ave2,buf,10);
  lcd_puts(buf);
  
}

void scope_graph( int minv, int maxv, int vals[], int offset ){
int val;
int i;
int zero;
int row, zrow;
int bdata, bzero;
int temp;
   
   if( minv == maxv ) return;    // divide by zero in map ??
   for( i = 0; i < 80; ++i ){
      val = map( vals[i], minv, maxv, 24, 0 );   // inverse map as nokia bits are inverted on screen
      if(val == 24 ) val = 23;
      zero = map( 0, minv,maxv, 24, 0 );
      if( zero == 24 ) zero = 23;
  
      row = ( val >> 3 );
      zrow = ( zero >> 3 );
      temp = val - 8*row;     // bit number
      bdata = 1;
      while( temp-- ) bdata <<= 1;  // bit mask
      temp = zero - 8*zrow;
      bzero = 1;
      while( temp-- ) bzero <<= 1;
      if( row == zrow ) bdata |= bzero;   // same byte on screen
      lcd_goto( row + offset, i );
      lcd_write( (char) bdata );
      if( row != zrow ){
         lcd_goto( zrow + offset, i );
         lcd_write( (char)bzero );
      }
   } 
}

// sampling - called from dsp_core interupt
void scope(){
static int last;
static int i;
static int mod;

   if( scope_active == 1 ){    // trigger on ch1 rising
      if( ch1 > last ) scope_active = 2, i = 0;
      last = ch1;
   }
   else if ( scope_active == 2 ){
      ++mod;
      mod &= (timebase - 1 );
      if( mod == 0 ){                    // decimate samples per timebase
        ch1_data[i] = ch1;
        if( ch3 != 0 && (i < 5 || i > 74)) ch1_data[i] = ch3; 
        ch2_data[i++] = ch2;
        if( i == 80 ) scope_active = 3;  // done
      }           
   }
}


/*
   these are busy LED's 
   have switch status, user function status, freq display, battery and tx power, S meter functions
*/   

void write_fleds( int val, int user_on_off ){  /* set/clear the function Leds */
               
  if( user_on_off && function == 2 && user[fun_selected[2]] ) val |= FGRN;  /* show status of user selection */
  LATDINV = ( val ^ LATD ) & (FGRN + FYEL + FRED);  // xor write bits as a group
}

void write_sleds( int val ){   /* set/clear the select leds */
  /* green on port D, rest on F */
  
  LATDINV = ( val ^ LATD ) & (SGRN);   // bits to change
  LATFINV = ( val ^ LATF ) & (SYEL + SRED);   // bits to change
  bat_interlock = 0;       /* someone changed the LED's */
}


void set_display( int sel, int fun ){  /* display numbers in the LED's */
int val;

   val= 0;
   if( fun & 1 ) val |= FRED;
   if( fun & 2 ) val |= FYEL;
   if( fun & 4 ) val |= FGRN;
   if( fun & 8 ){
      val |= FGRN;  /* show 8 in the 4 position  and dim others */
      fled89 = FYEL;
      if( (fun & 1 ) == 0 ) fled89 |= FRED;
   }
   else fled89 = 0;

   write_fleds( val , 0);
   
   val= 0;
   if( sel & 1 ) val |= SRED;
   if( sel & 2 ) val |= SYEL;
   if( sel & 4 ) val |= SGRN;
   if( sel & 8 ){
      val |= SGRN;  /* show 8 in the 4 position */
      sled89 = SYEL;
      if( (sel & 1 ) == 0 ) sled89 |= SRED;
   }
   else sled89 = 0;
   
   write_sleds( val );
}


void wpm_display(){   /* show code speed in the LED's */
   int fun,sel;
   
   sel = wpm / 10;
   fun = wpm % 10;

   set_display( sel,fun);
   
   if(nokia ){
     timeout_ok= 1;      
     if( nokia != WPM_D ){
        save_nokia = nokia;
        nokia = WPM_D;
        LCD.clrScr();
        LCD.setFont(SmallFont);
        LCD.print("Keyer Speed",CENTER,0);
        LCD.print("Func = Exit",RIGHT,40);
      }
      
      LCD.setFont(MediumNumbers);
      LCD.printNumI(wpm,CENTER,16);
   }
}


void contrast_display(){   /* Nokia display contrast adjustment */
   
   if(nokia ){
      timeout_ok= 1;      
      if( nokia != CONTRAST_D ){
        save_nokia = nokia;
        nokia = CONTRAST_D;
        LCD.clrScr();
        LCD.setFont(SmallFont);
        LCD.print("Nokia Contrast",CENTER,0);
        LCD.print("Func = Exit",RIGHT,40);
      }
      LCD.setContrast(contrast);
      LCD.setFont(MediumNumbers);
      LCD.printNumI(contrast,CENTER,16);
   }
}

int read_buttons(){   /* read switches and return result in bits 0,1 */
int but;

   but= 0;
   if( PORTD & 0x100 ) but= 1;  //function
   but+= ( PORTD & 2);          //select
   return but;
}


void tuning_display(){
int fun,sel;
int x;
char buf[35];
long rc,tx;        // rc ? rx and tx look so alike with this font


   /* change the tuning LED display if the tuning rate is 10 K ( units will not ever change ) */
   if( nokia == NO_DISPLAY ){  /* show tuning in LED's when display is off */
      if( tuning_rate == 10000 ){ /* display thun and tdec */
         fun = tdec;
         sel = thun;
      }
      else{     /* display tdec and tunits */
         fun = tunits;
         sel = tdec;
      }
      set_display(sel,fun);
      return;     /* don't need to run the nokia code in this case */
   }

   timeout_ok= 2;
   
   rc = rx_vfo;
   tx = tx_vfo;
   
   // change the display for CW mode when bandwidth is not wide.  Else we are showing the SSB carrier freq
   if( mode == CW && fun_selected[0] != WIDE ){
      rc = rx_vfo + (( sideband == USB ) ? mode_offset : - mode_offset);
      tx = tx_vfo + (( sideband == USB ) ? mode_offset : - mode_offset);
   } 

   if( nokia == NORM_D && ( split || mem_tune) ){
      nokia = SPLIT_D;     // this is kind of messy
      LCD.clrRow(0);
      LCD.clrRow(1);
      LCD.clrRow(2);
     // LCD.clrRow(3);      
   }
   if( nokia == SPLIT_D && split == 0 && mem_tune == 0 ){
      nokia = NORM_D;
      LCD.clrRow(0);
      LCD.clrRow(1);
      LCD.clrRow(2);
    //  LCD.clrRow(3);      
   }
   
   if( nokia == NORM_D ){    /* big display */
      if( rc < 10000000 ){   /* clear 1st digit */
         LCD.clrRow(0,0,13);
         LCD.clrRow(1,0,13);
         LCD.clrRow(2,0,13);
      }
      LCD.setFont(BigNumbers);
      x= (rc >= 10000000 ) ? 0 : 14 ;
      LCD.printNumI(rc/1000,x,0);
      LCD.setFont(MediumNumbers);
      LCD.printNumI((rc/100)%10,5*14,0);
      LCD.setFont(SmallFont);
   } 

   if( nokia == SPLIT_D ){    /* medium display */
      if( rc < 10000000 ){   /* clear 1st digit */
         LCD.clrRow(0,6,17);
         LCD.clrRow(1,6,17);
         LCD.clrRow(2,6,17);
      }
      if( tx < 10000000 ) LCD.clrRow(0,6,36);
      LCD.setFont(MediumNumbers);
      x= (rc >= 10000000 ) ? 6 : 18 ;
      LCD.printNumI(rc/1000,x,8);
      LCD.setFont(SmallFont);
      LCD.printNumI((rc)%1000,5*12+6,8,3,'0');

      LCD.setFont(SmallFont);
      
      if( mem_tune ){         // first line has memory channel name 
         LCD.clrRow(0);
         LCD.print( memory[channel].name,0,0 );
      }
      else{                        // or it has the tx vfo value
         x= (tx >= 10000000 ) ? 30 : 36 ;
         LCD.printNumI(tx/1000,x,0);
      // LCD.setFont(SmallFont);
         LCD.printNumI((tx)%1000,5*12+6,0,3,'0');

         if( split == 2 ) LCD.print("-->",0,0);
         else LCD.print("   ",0,0);       
      } 
   } 
   
   if( nokia == DECODE_D ){
      itoa( listen_vfo/1000,buf,10);
      lcd_goto(3,0);
      if( listen_vfo < 10000000 ) lcd_putch(' ');
      lcd_puts(buf);
      lcd_puts("   ");     
   }
   
   
   if( nokia == NORM_D || nokia == SPLIT_D ){
      if( rit_offset > 25 ) LCD.print("+",RIGHT,16);
      else if( rit_offset < -25) LCD.print("-",RIGHT,16);
      else if( mode == WSPR ) LCD.print(wspr_wwv_msg[wspr_wwv],RIGHT,16);  // last WWV check was successful 
      else LCD.print(" ",RIGHT,16);
   }
}

//  rtty, psk31, cw decoders use this routine to print the decoded characters
void decode_print( unsigned char c ){
static int row, col;

     if( serial_decode ){
       if( c == '\r' || c == 8 || c >= ' ' ) stage(c);   // don't print most of the control codes
       if( c == '\r' ) stage('\n');                     // windows version of CR LF I think
     }
     if( nokia == DECODE_D ){
       if( c == '\r' || c == '\n' ) c = ' ';  /* no new lines on the small nokia screen */
       if( c < ' ' ) return;                  // skip the control characters and backspacing
       lcd_goto( row, col*6 );
       lcd_putch(c);
       if( ++col == 14 ) ++row, col= 0;
       if( row > 2 ) row= 0;
       if( col != 0 ) lcd_putch('_');
     }   
}


void button_state(){ /* state machine running at 1ms rate */
int sw,st,i;
static int press,nopress;

      sw = read_buttons();      // bit 0 is function, bit 1 is select    
      if( sw ) ++press, nopress= 0;
      else ++nopress, press= 0;
      
      /* switch state machine */
      for( i= 0; i < 2; ++i ){
         st= sw_state[i];      /* temp the array value to save typing */

         if( st == NOTACTIVE && (sw & 0x1) && press >= DBOUNCE ) st= ARM;
         if( st == FINI && nopress >= DBOUNCE ) st = NOTACTIVE;   /* reset state */

         /* double tap detect */
         if( st == ARM && nopress >= DBOUNCE/2 )     st= DTDELAY;
         if( st == ARM && (sw & 0x1 ) && press >= 10*DBOUNCE )  st= LONGPRESS; 
         if( st == DTDELAY && nopress >= 4*DBOUNCE ) st= TAP;
         if( st == DTDELAY && ( sw & 0x1 ) && press >= DBOUNCE )   st= DTAP;
         
         sw_state[i]= st;      
         sw >>= 1;   /* next switch */
      }        
}

int function_action(){     /* handle all function switch presses */
int fun;
char buf[35];
char c;
int i;

  fun = sw_state[0];
  if( fun < TAP ) return 0;
  
  tprotect = 0;   /* function button resets the tx timeout protection */ 
  if( (wpm_adjust || contrast_adjust) && nokia ){
     nokia = save_nokia;
     LCD.clrScr();
     update_frequency(DISPLAY_UPDATE);
  }
  wpm_adjust = 0;  /* function button turns off code speed adjust routine */
  contrast_adjust = 0;
  
  if( select_macro ){
    select_macro = 4;    // queue an exit of the macro select routine
    sw_state[0] = FINI;
    return 0;            //quietly exit the macro screens without changing the function          
  }

  if( scope_active == 1 ) ++scope_active;   // manual trigger
  if( scope_active > 3 ) scope_display();
  
  /* respond to taps only if display is the switch display */
  if( fun == TAP && led_on_timer) { 
    ++function;
    if( function > 2 ) function= 0;
  }  
  if( fun == DTAP && led_on_timer ){
    --function;
    if( function < 0 ) function = 2;
  }
  
  if( fun == LONGPRESS ){    // que up announce
     if( SOFTSCOPE && nokia ) scope_active = 1;
     else{
        itoa( int(listen_vfo/1000), buf, 10);
        i= 0;
        while( c = buf[i++]) {   /* load up the announce buffer */
          load_tx_queue(c);
        }
     }     
  }

  user_help(function); 
  sw_state[0] = FINI;
  return 1;
}


void load_wpm(){   /* put the code speed into the announce buffer */
char c,buf[35];
int i;

   //  itoa( wpm, buf, 10);
   //  i= 0;
   //  while( c = buf[i++]) {   /* load up the announce buffer */
   //    tx_queue[tx_in] = c;
   //    tx_in = (tx_in + 1) & ( TXQUESIZE - 1 );
   //  } 
   // just put in a v character, it is too slow to announce the wpm at slow speeds 
     load_tx_queue('V');
     load_tx_queue(' ');    
     wpm_display();
     led_on_timer = 600;     
}


void set_band_width( int wid ){  /* wide, med rb9,  narrow rb11 */
unsigned int val,ch;

   val= 0;      /* wide for select blank or select green */
   if( wid == MEDIUM ) val= 0x200;
   if( wid == NARROW ) val= 0x800;
    
   ch= ( val ^ LATB ) &  0xa00;   /* change bits */
   LATB ^= ch;
 //  update_frequency(DISPLAY_UPDATE);          // for cw wide vs narrow display
   tuning_display();                           // don't need to load dds words, just a display change 
}


void set_tuning_rate( int val ){    /* addeded an extra rate of 10 for option 0 - blank leds  */
   
   val &= 3;
   tuning_rate = ( mode == MFSK ) ? 1 : 10;   // 10 times slower tuning for mfsk
   while( val-- ) tuning_rate *= 10;
}


void load_tx_queue( unsigned char c ){

       tx_queue[tx_in] = c;        
       tx_in = (tx_in + 1) & ( TXQUESIZE - 1 );  
}

void user_action( int act, unsigned char flag ){   /* set any flags or other options for user flags */
int i;
char c;

  if( act == DISPLAY ){
    top_menu(1);
    if( nokia ) update_frequency(DISPLAY_UPDATE);
    else{
       LCD.clrScr();
       lcd_goto(0,0);
       lcd_puts("Display off");
    }
  }

  if( act == BEACON && flag == 1 ){
    user[BEACON] = 0;     /* one time for now */
    i= 0;
    if( mode == RTTY ) rtty_up();     // rtty preamble and turn on tx
    if( mode == PSK31 ) psk31_up();
    if( mode == MFSK ) mfsk_flag = MFSK_GO;
    while( c = cq_msg[i++]) {         /* load up the buffer */
       load_tx_queue( c | 0x80 );     /* the ms bit set transmits the char.  ms bit clear is the announce feature */
       if( crh_tx_method == CRH_TX_TERM ) stage( c );       
    }
    if( mode == RTTY || mode == PSK31 || mode == MFSK ){
       load_tx_queue( '\r' | 0x80 );   // CR LF
       load_tx_queue(18 | 0x80);      // put in control R at the end of the buffer        
    }
    if( crh_tx_method == CRH_TX_TERM ){ 
       stage( '\r' ); stage( '\n' );
    }
    
  }
  
  if( act == SPLIT ){        /* toggle this option is the only way out of split mode */
     split = flag;
     if( flag == 0 ){
       tx_vfo = rx_vfo = listen_vfo; /* end up on current listen freq-could be rx or tx depending upon swapvfo setting */
       user[SWAPVFO] = 0;
     } 
     update_frequency(DISPLAY_UPDATE);
  }
  if( act == SWAPVFO ){   /* if turn off swap vfo, you are still in split mode but tuning the rx_vfo */
     split = flag + 1;
     user[SPLIT]= 1;      /* still in split mode */
     update_frequency(DISPLAY_UPDATE);  /* listen on selected vfo */
  }

  if( act == BAND && bandswitch_enable == 1 && band_switch > JUMPERS ){      /* band switch */
     save_tx_vfo[band] = tx_vfo;
     save_rx_vfo[band] = rx_vfo;
     save_split[band] = split;

     if( band_switch == TWO_BAND ) ++band;   // skip 30 and 17 meters if have a two band module
     if( ++band >= MAX_BAND ) band= 0;
     tx_vfo= save_tx_vfo[band];
     rx_vfo= save_rx_vfo[band];
     split = save_split[band];    
     
     /* update the user split flags */
     switch ( split ){
        case 0:  user[SWAPVFO] = user[SPLIT] = 0; break;
        case 1:  user[SWAPVFO] = 0; user[SPLIT] = 1; break;
        case 2:  user[SWAPVFO] = user[SPLIT] = 1; break;
     }  
   
     /* switch the relays */
     switch( band ){
       case 0:   /* 40 meters */ 
        digitalWrite( Band_Select,HIGH );
        digitalWrite( Band_Select2,LOW );    //HL
        if( nokia == 0 ) auto_tx( cut_numbers[4] );
        sideband = ( sideband_mode == NORMAL ) ? LSB : USB; 
       break;
       
       case 1:  /* 30 meters */
        digitalWrite( Band_Select2,HIGH );    //HH
        if( nokia == 0 ) auto_tx( cut_numbers[3] );       /* announce the band */  
        sideband = ( sideband_mode == NORMAL ) ? LSB : USB; 
       break;
       
       case 2:  /* 20 meters */
        digitalWrite( Band_Select,LOW );
        digitalWrite( Band_Select2,LOW );    //LL
        if( nokia == 0 ) auto_tx( cut_numbers[2] );       /* announce the band */ 
        sideband = USB;    // usb is the normal sideband
       break;
       
       case 3:  /* 17 meters */
        digitalWrite( Band_Select2,HIGH );    //LH
        if( nokia == 0 ) auto_tx( cut_numbers[1] );       /* announce the band */ 
        sideband = USB;
        break;
     }
     
     update_frequency(DISPLAY_UPDATE);
  }
  
  if( act == CODEREAD ){
    if( user[DISPLAY] ){
       if( flag == 1 ) nokia = DECODE_D;
       else nokia = NORM_D;
      /* clear 3 lines */
       lcd_goto( 0,0 );
       for( i= 0; i < 3*14; ++i ) lcd_putch(' ');
       update_frequency(DISPLAY_UPDATE); 
    }
  }

  if( act == SPOT ){
     spot_timer= 600;
  }
  
}

int select_action(){      /* handle all select switch presses, action will depend upon function */
int but,sel,limit;

   sel = sw_state[1];
   if( sel < TAP ) return 0;
   
   if( select_macro ){    // shortcut the buttons to just do the macro menu when its active
     select_macro = 3;    // queue a selection in the macro_select routine
     sw_state[1] = FINI;
     return 0;                      
   }

   /* change function selected array */
   but= fun_selected[function];
   
   if( sel == TAP && led_on_timer ) ++but;
   if( sel == DTAP && led_on_timer ) --but;
   
   /* selection limit is 3 for bandwidth, 3 for tuning rate, 7 for user */
   /* bandwidth is now a special case as no zero setting */
   limit = 3;
   if( function == 0 && but == 0 ) but= limit;    /* no blank bandwidth function */
   if( function == 0 && but == (limit + 1) ) but = 1;   
   if( function == 2 ) limit = 7;
   if( but > limit ) but = 0;
   if( but < 0 ) but = limit; 
   fun_selected[function] = but;
   
   /* do the action */
   if( function == 0 ){
     if( sel == LONGPRESS && nokia ){     // only allow these if we have a display
       if( mode >= WSPR ){ contrast_adjust = 1; contrast_display(); }
       else select_macro = 1;
     }
     else set_band_width(but);
   }
   if( function == 1 ){
     if( sel == LONGPRESS ) wpm_adjust= 1;
     else set_tuning_rate(but);
   }
   if( function == 2 ){     /* user functions */
     if( sel == LONGPRESS ){    /* toggle the user option on and off */
        user[but] ^= 1;
        user_action(but,user[but]);
     }
   } /* end function 2 - user functions */
   
   user_help(function);
   sw_state[1] = FINI;
   return 1;
}

// changed this to allow displaying the mode - sideband string in the s-meter overlay area
void user_help( int fun ){  /* status on left overlays S meter, long press help text on the right */
int sel;

  if( nokia != NORM_D && nokia != SPLIT_D && nokia != DECODE_D )  return;    /* not correct display screen or display missing */

  sel = fun_selected[function];
  if( fun == 2 && sel == 0 ) fun = 3;   // show mode sideband when function-sel is user-menu
 
  lcd_goto(3,0);
  if( fun == 0 ){
     lcd_puts("BW ");
     switch( sel ){
        case 1:    lcd_puts("Wide ");    break;
        case 2:    lcd_puts("Med  ");    break;
        case 3:    lcd_puts("Nar  ");    break;
     }
  }
  else if( fun == 1 ){
     lcd_puts("Step");
     switch( sel ){
        case 0:    lcd_puts(" 10 ");    break;
        case 1:    lcd_puts("100 ");    break;
        case 2:    lcd_puts(" 1K ");    break;
        case 3:    lcd_puts("10K ");    break;
     }
  }
  else if( fun == 2 ) lcd_puts("User    ");
  else lcd_puts(mode_band());


  switch( function ){   // always display the correct long press help
    case 0:
         if( mode < WSPR ) lcd_puts("Macros");   // tx marco strings 
         else lcd_puts("DspCon");    /* long press on BW is contrast adjustment */
    break;
    case 1:
         lcd_puts("KeySpd");    /* keyer speed */
    break;
    case 2:
       switch( sel ){
         case DISPLAY:    lcd_puts("Menu  ");   break;   /* Disp changed to menu but user[Display] is throughout the code so it remains */
         case CODEREAD:   lcd_puts("CodeRd");   break;   /* just being lazy */
         case BAND:       lcd_puts("Band  ");   break;
         case BEACON:     lcd_puts("Snd CQ");   break;
         case SPOT:       lcd_puts("Spot  ");   break;
         case SPLIT:      lcd_puts("Split ");   break;
         case SWAPVFO:    lcd_puts("VFO B ");   break;
         case LOCK:       lcd_puts("Lock  ");   break;
       }
       if(user[sel]){
         lcd_goto(3,13*6);
         lcd_putch('*');   /* show it is enabled.  this overwrites the last character  */    
       }    
    break;
  }

//  timeout_ok = 2;  not needed as lcd_puts is faster than Library writes to Nokia display
  nokia_s_inhibit = 1;
}


char * mode_band(){    // create string to display mode and sideband
static char msg[9];
int i;
int k;
const char mode_str[] = "CW  Hel PSK RttyMfskWsprJT6 SSB ";

   i = 4*mode;
   if( i == 0 && fun_selected[0] == 1 ) i = 28;   // cw becomes ssb when wide band filter selected
   
   for( k= 0; k < 4; ++k ) msg[k] = mode_str[i++];                                               
  // msg[k++] = ' ';
   if( sideband == LSB ) msg[k++] = 'L';
   else msg[k++] = 'U';
   msg[k++] = 's';
   msg[k++] = 'b';
   msg[k++] = ' ';
   msg[k] = 0;   
                                                  
  return msg;
}


void check_inband(){  
int i;
unsigned int ck;
long chk_vfo;

   chk_vfo = ( sideband == USB ) ? tx_vfo + mode_offset :  tx_vfo - mode_offset;
   ck = chk_vfo / 1000;
   for(i= 0; i < NUMBANDS; ++i ){
      if( ck >= bandstart[band_limits][i] && ck < bandend[band_limits][i] ) break;
   }
   tx_inhibit = ( i == NUMBANDS ) ? TXENABLE : 0;  /* on RF6 */ 
   /* display on TT light */
   if( tx_inhibit ) LATBSET = TTLED;
   else LATBCLR = TTLED;  
}


void show_split(){   /* show on the TT LED */
static int counter = 0;   /* counting in 8ms steps */

   /* add low battery blinking indication here */
   if( counter == 1 ){
      if( bat_low  && led_on_timer == 0 ){
        LATFINV = SRED;
        bat_interlock = 1;   /* flag we changed the LED */
      }
   }
   if( counter == 12 ){
     if( bat_interlock ) LATFINV = SRED;   /* reset the LED unless someone else beat us to it */
     bat_interlock = 0;
   }

   /* check_inband has its own idea of the state of the tt led, modify it for split indication */
   /* this only works because show_split is called immediately after check_inband */
   if( split ){  
      if( counter < 12 ) LATBINV = TTLED;
      if( split == 2 && counter > 24 && counter < 36 ) LATBINV = TTLED;
   }
   
   if( ++counter > 375 ) counter = 0;     /* blink every 3 seconds */  
}

void transmit( int key ){
    
  if( key ){
      /* if transmit when the vfo is swapped, start listening on the rx vfo */
      /* need to push the select button again to listen and change the transmit frequency */
      if( split == 2 ){
         split = 1;           /* back to regular split, listen where we parked the rx vfo */
         user[SWAPVFO] = OFF;
         user[SPLIT] = ON;
         update_frequency(DISPLAY_UPDATE);
      }
      LATGSET = DDS_SEL;  /* change dds */
      LATFSET = ( tx_inhibit ^ TXENABLE );    /* turn on transmitter */
      LATFSET = PSK_MOD;    // extra power for rtty and jt65.  Whether this does anyting is controlled by pinmode
      transmitting = 1;     //   if the pin is an input, nothing happens
  }
  else{
      LATFCLR = TXENABLE;
      /* wait for tx decay and change dds back in main loop */
      tdown= 30;  /* 30 ms delay */
      transmitting = 0;
      LATGCLR = PSEL;       // phase register 0 selected
      LATFCLR = PSK_MOD;    // remove bias from final FET
  }
}

void sidetone( int key ){
  if( key ) LATDSET = 1;
  else LATDCLR = 1;
}


/* auto morse tx also modified for rtty and hellschreiber and the other keyboard modes */
void auto_tx( int cut_num ){   /* beacon and announce */
static int tx_enable;
static unsigned char morse_char;
static unsigned char rtty_char[2];
static int wpm_local;
static int next_char;
static int rtty_shift;
unsigned char elem; 

    if( cut_num ){ /* bypass the lookup and send the cut number as the morse_char */
      tx_enable= 0;
      wpm_local = ANNOUNCE_WPM;
      morse_char = cut_num;
      tx_state = 2;
    }

    switch( tx_state ){
      
      case 0:  /* get next char */
        if( tx_out == tx_in) return;
        next_char = tx_queue[tx_out];
        tx_out = ( tx_out + 1 ) & (TXQUESIZE - 1);
        if( next_char & 0x80 ){     /* bit 7 is set for transmitting, else just announce */
          tx_enable = 1;
          wpm_local = wpm;    
          next_char &= 0x7f;
        }
        else {
          tx_enable = 0;
          wpm_local = (wpm_adjust) ? wpm : ANNOUNCE_WPM;
        } 
        if( mode == HELL && tx_enable ){  /* sending hellschreiber */
           hchar = next_char;   
           hflag = 1;
           tx_state = 5;   /* avoid the morse states */
           return;
        }
        if( mode == PSK31 && tx_enable ){  /* sending psk31 */
           pchar = next_char;   
           pflag = 1;
           tx_state = 8;   /* avoid the morse states */
           return;
        }
        if( mode == MFSK && tx_enable ){
           fchar = next_char;
           fflag = 1;
           tx_state = 9;
           return;
        }
        if( mode == RTTY && tx_enable ){ 
          tx_state = 6;
          return;
        }          
        if( next_char == ' ') autotx_timer = 7 * 1200/wpm_local;  /* word space */
        else tx_state = 1;  
      break;
      
      case 1: /* lookup the morse elements in a table */
         if( next_char >= ',' && next_char <= 'Z' ){
            morse_char = morse[next_char - ','];
            tx_state= 2;
         }
         else tx_state = 0;
      break;
      
      case 2: /* time each element until none left - go to 3 or 4 */
         elem = ( morse_char & 0x80 ) ? 3 : 1;   /* sends a dit if char not defined in the table, for example ';' */
         morse_char <<= 1;
         autotx_timer = elem * 1200/wpm_local;
         if( tx_enable ) transmit( ON );
         sidetone( ON );
         if( morse_char == 0x80 || morse_char == 0 ) tx_state = 4;
         else tx_state = 3;
      break;
      
      case 3: /* time inter element time */
         if( tx_enable ) transmit(OFF);
         sidetone(OFF);
         autotx_timer = 1200/wpm_local;    /* dit time */
         tx_state= 2;
      break;
      
      case 4: /* time inter character time */
         if( tx_enable ) transmit(OFF);
         sidetone(OFF);
         autotx_timer = 3 * 1200/wpm_local;   /* dah time */
         tx_state = 0;   /* get next char */
      break;
      
      case 5:    /* hell, just wait for the send process to consume the character we are holding */
         if( hflag == 0  || mode != HELL) tx_state = 0;
                                    /* don't get stuck in hell if the user changes the mode */
      break;                                /* in the middle of the message */
      
      case 6:    //  start of a new rtty char next_char
         if( transmitting == 0 ){          // Letter typed without Control T to start the transmitter
            tx_state = 0;                  // so drop it.   Or we could call rtty_up here and continue
         }
         else if( next_char == 18 ){       // stop sending on control R
            rtty_down();
            rtty_shift = rtty_char[0] = rtty_char[1] = 0;
            tx_state= 0;
         }
         else if( next_char == 0 ){   // idle null
            rtty_char[0] = 0x60;
            tx_state = 7;
         }
         else if( next_char == '\n' ) tx_state = 0;
         else if( next_char == '\r' ){    // ignore linefeeds and send CR LF on carriage return
            rtty_char[0] =  0x8 + 0x60; 
            rtty_char[1] =  0x2 + 0x60;
            tx_state = 7;
         }
         else{                        // normal char
            rtty_char[0] = baudot_lookup( next_char );
            tx_state= 7;
            if( next_char < 'A' && next_char != ' '  && rtty_shift == 0){
               rtty_char[1] = rtty_char[0];
               rtty_char[0] = 0x1b + 0x60; 
               rtty_shift = 1;
            }
            if( (next_char >= 'A' || next_char == ' ') && rtty_shift == 1){
               rtty_char[1] = rtty_char[0];
               rtty_char[0] = 0x1f + 0x60;
               rtty_shift = 0;
            } 
         }
         // put in the start bit we forgot about
         if( tx_state == 7 ){
            rtty_char[0] <<= 1;
            rtty_char[1] <<= 1;
         }         
      break;
      
      case 7:                         // send mark or spaces
         if( rtty_char[0] & 1 ) LATGSET = DDS_SEL;
         else LATGCLR = DDS_SEL;
         rtty_char[0] >>= 1;
         autotx_timer = 22;
         
         if( rtty_char[0] == 0 ){
             rtty_char[0] = rtty_char[1];
             rtty_char[1] = 0;
         }
         if( rtty_char[0] == 0 ) tx_state = 0;         
      break;
      
      case 8:
         if( pflag == 0  || mode != PSK31) tx_state = 0;      
      break;
      case 9:
         if( fflag == 0  || mode != MFSK) tx_state = 0;      
      break;

    } /* end case */

}

unsigned char baudot_lookup( int letter ){    // tx lookup - find baudot code for a letter
int i;
int shift;

     // letter = toupper(letter);  not needed as making sure its upper case in the buffer
      shift = ( letter < 'A' ) ?  1 : 0;
      for( i = 0; i < 32; ++i ){
        if( baudot_table[shift][i] == letter ) break;
      }
      // if( i == 32 ) i = 0;   // letter not found - transmit idle ( if i is 32 then it is just one of the stop bits ) 
      return (i | 0x60);     // put in 2 stop bits                  ( and we get an idle character anyway )
} 


int readpaddle(){
int val;
//int dit,dah;

   val = (PORTE & ( DIT + DAH )) ^ ( DIT + DAH);
   /* add a swap feature ? */
   // dit = ( val & DAH ) >> 1;
   // dah = ( val & DIT ) << 1;
   // val = dit + dah;
   
   return val;
}

void sk_transmit(){  /* straight key transmit */

   if( tholdoff ) --tholdoff;    /* avoid key bounces */
   else{ 
       cel = readpaddle() & ( DIT + DAH - straightkey );

        /* transmit protect, if key down longer than allowed, tap function to re-enable */
       if( cel ) ++keyuptime;
       else keyuptime = 0;
       if( keyuptime > 15000L ) tprotect = 1;   /* 15 seconds. enable tx again by tapping the function button */
            
       if( tprotect ) cel = 0;   /* force to stop transmitting, comment this line to disable this feature */
        
       if( cel && transmitting == 0 ) t_up();    /* turn on transmitter */
       if( transmitting && cel == 0 ) t_down();  /* turn off transmitter */
   }         
} 

void t_up(){
  
   transmit(ON);
   sidetone(ON);
//   LATBINV = TTLED;   /* toggle TT LED */ /* transmit indicator now bat voltage check in the select LED's */
   tholdoff= 30;      /* 30 ms should be good for 40 wpm straight key speed */
   tx_out = tx_in;    /* abort auto tx message */ 
}

void t_down(){

   transmit(OFF);
   sidetone(OFF);
//   LATBINV = TTLED;   /* toggle TT LED */
   tholdoff= 30;      /* 30 ms should be good for 40 wpm straight key speed */  
}


void rtty_up(){
int mode_off;

   mode_off = ( sideband == USB ) ? mode_offset : -mode_offset;
   program_freq0( tx_vfo + mode_off + SPACE_OFF );
   program_freq1( tx_vfo + mode_off + MARK_OFF );
  
   transmit(ON);

 // rtty preamble
    load_tx_queue( 'V' | 0x80 );   // mostly all 1's so receiver can find the start bit easily
    load_tx_queue( ';' | 0x80 );   // figures shift sent with this one
    load_tx_queue( 'V' | 0x80 );   // letters shift sent with this one
    load_tx_queue( '\r' | 0x80 );  // CR LF     
}

void rtty_down(){
  
   transmit(OFF);
   LATGSET=  DDS_SEL;     // just making sure any residuall tx energy is on tx_vfo freq and not out of band with rx_vfo
   update_frequency(NO_DISPLAY_UPDATE);   // set dds back to normal
}

void psk31_up(){
int i;
  
  transmit( ON );
  for( i = 0; i < 8; ++i ) load_tx_queue( 0x80 );    // load up some nulls for preamble
  load_tx_queue( '\r' | 0x80 );  // CR LF     
}


void rtty_key(){   // for when rtty transmit is via the paddle jack
int key;           // dah keys transmitter, dit alters the tone

  if( mode != RTTY  ||  crh_tx_method != CRH_TX_KEY ) return;    // interface not being used 
  
  key = readpaddle();

  if( (key & DAH) == DAH ){     // tx is on or should be
     if( transmitting == 0 ) rtty_up();
     if( (key & DIT ) == DIT ) LATGCLR = DDS_SEL;    // spacing when dit is closed
     else  LATGSET = DDS_SEL;                        // marking 
  }
  else{                         // tx should be off unless sending the cq message
     if( transmitting && tx_in == tx_out && tx_state == 0) rtty_down();
  }    
}

void paddles(){       /* should be close to CMOS mode B */
static int state = 0;
static int halftime;  // now 1/3 time
static int mask;
static int time;

   switch (state){
     case 0:          /* handle next element or get a new one */
       cel = nel,  nel = 0;  
       if( cel == 0 ) cel = readpaddle();
       if( cel == (DIT + DAH) ) cel = DIT;  /* dit wins on a tie */
       if( cel ){     /* key up */
          t_up();
          mask= ( DIT + DAH ) ^ cel;
          time = 1200/wpm;
          if( cel == DAH ) time *= 3;
          halftime= time/3 ;
          state = 1;
          counter = 0;
       } 
     break;
     
     case 1:        /* timing half character */
        if( counter >= halftime ) state = 2;
     break;
        
     case 2:       /* sample opposite paddle */
        if( nel == 0 ) nel= readpaddle() & mask;
        if( counter >= time ){
           t_down();
           state = 3;
           counter = 0;
           time = 1200/wpm;
        }
     break;
        
     case 3:    /* timing inter element gap */
        if( nel == 0 ) nel= readpaddle() & mask;
        if( counter >= time ) state= 0;
     break;        
   }  /* end switch */
}



void mfsk_decode( int val ){
  
   val = 27 - val;     // invert the value as we mixed the signal to the alternate sideband
   val = val ^ ( val >> 1 );  // un-gray code
// if( val < 10 ) stage( '0' + val );
// else stage( 'A' + val - 10 );
   val = mfsk_dinterleave(val);   // de-interleave the data
   // now the hard part, split quad bits into groups of two and get 1 bit for each pair
   mfsk_decode2(val >> 2);
   mfsk_decode2(val & 3 ); 
}

// another original decode algorithm by k1urc.  Will it work?
// each transmitted bit has been spread across 8 bits with the convolution algorithm
void mfsk_decode2(int val){
unsigned static int code;   // our best guess at the current 8 bits decoded
unsigned static int rcv;    // the current received bit stream that may have errors due to noise
static int err[8];          // how many bit errors each decoded bit has accumulated
unsigned int mask;          // a sliding mask as not all the bits in code can effect the complete rcv bit stream
                            // the msb can effect all, the lsb only 2
int i, b;
unsigned int result;        // test results

   mfsk_decode3( (code >> 7) & 1 );   // done with this bit
   code <<= 1;                        // room for a new bit, just leave as a zero for now
   code &= 0xff;
   rcv <<= 2;                         // put new received bits in the bit stream
   rcv |= val;
   rcv &= 0xffff;
   
   for( i = 7; i > 0; --i ) err[i] = err[i-1];  // move the err sums to correspond with the bits in code
   err[0] = 0; 
 
   // ititial test of the new bit.  If all is running 100% this may be useful
   result = (fec_table[code] ^ rcv ) & 3;
   if( result ) code |= 1;    // had some errors as a zero so try one as initial guess  
   
   // test all the bits and sum errors. we start with the msb
   mask = 0xffff;    // set up to test the msb first
   b = 0x80;         // bit under test
   
   for( i = 7; i >= 0; --i ){
      code |= b;   // test bit as a one
      result = ( fec_table[code] ^ rcv ) & mask;
      err[i] -= count_err(result);     // if one is wrong it drives errors negative   
      code ^= b;   // flip bit to a zero and test again
      result = ( fec_table[code] ^ rcv ) & mask;
      err[i] += count_err(result);     // if zero is wrong it drives errors positive
      
      if( err[i] >= 0 ) code ^= b;     // flip bit back to a one as it looks like that is the correct choice
      b >>= 1;                         // set the masks for the next bit to test
      mask >>= 2;
   }      
}

int count_err( unsigned int val ){
int cnt;
int i;

   /* just count how many ones are in val */
   cnt = 0;  
   for( i = 0; i < 16; ++i ){
    if( val & 1 ) ++cnt;
    val >>= 1;     
   }
  
   return cnt;
}

void mfsk_decode3( int val ){
unsigned static int code;
int i;

   if( val == 1 && code && ((code & 3) == 0) ){
      for( i = 0; i < 128; ++i ){
         if( varicode2[i] == code ) break;
      }   
      if( i < 128 ) decode_print(i);
      code = 0;     
   }

   code <<= 1;
   code |= val;  
}



const long pi = 12868;    // pi in q12 format
const long pi2 = 6434;    // pi/2
// fixed point taylor series for sine
// sin(x) =  x - x^3/3! + x^5/5! - x^7/7!
// for fixed point accuracy and avoiding division
//   term x^3/6 can be replaced with (x/2)^3 * 1.333333
//   term x^5/120 can be replaced with (x/2)^5 * 0.2666666
//   term x^7/5040  replaced by (x/2)^7 * 0.0253968
// wonder if this is any faster than floating point sin()
// result valid from -pi/2 to pi/2 or -90 to 90 degrees
long tsin( long val ){
//long sign;
//long val2;
long t2, t3, t4, t5, t7;
long rval;

//  sign = 1;
  if( val >= 2 * pi ) val-= 2 * pi; 
  if( val <= pi2) ;                         // ok 1st quadrant, do nothing
  else if( val >= (pi + pi2)) val -= 2 * pi;  // 4th quadrant - change to negative angle 1st quadrant(4th quadrant previous wave )
//  else val -= pi, sign = -1;                   // mirror 2nd and 3rd quadrants about x axis
  else val = pi - val;                          // mirror 2nd and 3rd about pi/2 (90 deg)

 // val2 = val >> 1;                     // val in q12 is same as val/2 in q13 format, so just assume it's q13
  t2 = (val * val) >> 12;                // q13 * q13 = q26, shift 12 == q14 
  t3 = (t2 * val ) >> 13;                // q14 * q13 = q27, shift 13 == q14
  t4 = (t2 * t2) >> 14;                  // q14 * q14 = q28, shift 14 == q14
  t5 = (t2 * t3 ) >> 14;                 // q14 * q14 = q28, shift 14 == q14
  t7 = (t3 * t4 ) >> 14;
  rval = 4*val - ((t3 * 5461) >> 12);    // q14 * q12 = q26, shift 12 == q14
  rval += ((t5 * 1092) >> 12);           // q14 * q12 = q26, shift 12 == q14
  rval -= ((t7 * 104) >> 12);            // result q14
  // rval >>= 2;                            // back to q12 ?
  //return sign * rval;                    // or return q14 for more fractional part
  return rval;
}

long tcos( long val ){
    return ( tsin( val + pi2 ));  // add 90 degrees and call sin
}

/*
long iroot(long val){   // iterative integer square root
long root,lroot;
int i;

   lroot = root = 100;
   for( i = 0; i < 8; ++i ){
     if( root == 0 ) break;
     root = val/root + root;
     root >>= 1;
     if( root == lroot ) break;
     lroot = root;
   }
   return root;
}
*/

// just playing around with some ideas
// heteradyne the signal to a lower frequency, 1000hz to 300hz
//  will have more samples per cycle of audio, 13.3 vs 4
//  but we have since resampled giving a narrower response to the filtering and are back to 4 per cycle.
// use taylor series instead of table lookups for frequency generation
//  wondering if the table lookups generates noise as it is never exactly correct
// what are we learning
//   the signal amplitude affects greatly the amount of the phase difference calculated
//   the lower frequency of 300 hz needs better lowpass filters than 1000 hz version
//   the first version works pretty well and it is difficult to make this one better
//   more audio into the A/D converter would be a big help for weak signals
//   a good working digital agc system is not easy to implememt
//   the afc helps this version as the response is quite narrow
void psk_modem( long sample ){
static long vfo;
const long pvfo = 8364;    // 1300/4000 * 2pi in q12.  vfo at 1300 to mix 1000hz to 300 hz
long sval, cval;
const long pvco = 1930 * 16 * 4;    // 300 hz phase update, 4 fractional bits, 4 decimate rate change
static long vco;
long prod;
static long agc = 4096;
long power;
static long afc;
static int dcnt;
       
    sample = rtty_bandpass( sample );

    if( fun_selected[0] != NARROW || tuning_rate == 10000 ) {        // run the first try modem that works ok
       psk_modem1(sample);  
       if( tuning_rate < 10000 ) return;    // run both modems in parallel when 10k tuning rate
    }
    
    // this modem runs when narrow bandwidth filter is selected.  
    vfo += pvfo;
    if( vfo >= 2*pi ) vfo -= 2*pi;
    
    sample = sample * tsin(vfo);  // mix with local osc at 1300 hz 
    sample >>= 12;                // still at q14 as tsin is q14. are those 2 bits significant or just noise?
    sample = psk_bandpass(sample);   // 300 hz FIR bandpass filter
//ch1 = sample;
//ch3 = 0;

    
    ++dcnt;        // decimate by 4
    dcnt &= 3;
    if( dcnt != 0 ) return;
 
    sample *= agc;
    sample >>= 12;
    power = ( sample > 0 ) ? sample : -sample;
    if( power > 800 ) agc-= 6;
    else if( agc < 80000 && power < 200 ) ++agc;      // max gain is about 20x

  
  // run the costas loop at 300 hz
    vco = vco + pvco + (afc >> 3);         // >> 5 for 4000 rate, 
    if( vco >= 16*2*pi ) vco -= 16*2*pi;   // 16 multiplier == 4 fractional bits
    
    sval = -tsin(vco>>4);
    cval =  tcos(vco>>4);
    sval *= sample;       // I channel
    cval *= sample;       // Q channel
    sval >>= 14;          // still 2 bits up at q14 from mixer filter steps
    cval >>= 14;
    sval = psk_lowFIR(sval,0);
    cval = psk_lowFIR(cval,1);
    
//ch1 = cval;
//ch3 = sval;

   prod= sval * cval;   // phase error
 //  prod >>= 1;          // >> 1 at 4000 rate
   if( prod > 200*16 ) prod = 200*16;    // avoid extremely large phase changes
   if( prod < -200*16 ) prod = -200*16;
     
   if( prod == 3200 && afc < 32000 ) afc += 2;   // this modem seems to remain in the clip region when locked
   if( prod == -3200 && afc > -32000 ) afc -= 2; // try to use that fact to generate an afc function
   if( prod > -3200 && prod < 3200 ){            // leaky integral 
      if( afc > 0 ) --afc;
      else ++afc;
   }  
     
// ch2 = prod;   
   vco += prod;         // correct the phase of the vco
   
// ch2 = cval;  
   psk_decode10(cval);    // signal ends up on the Q channel of the loop
  
   if( tuning_rate != 10000 ){    
     ch1 = prod;
     ch3 = afc / 10;
   }
   else ch3 = 0;
}

/* research indicates a costas loop is a way to decode psk31 */
// read some papers by Eric Hagemann
// our sine table is 64 entries long per 360 deg.  We have an interpolation function making it seem to be 256 entries long
// at 4 khz sample rate, 1khz will skip 90 degrees in phase for each lookup ( 16 at the table size, 64 at the interpolated table size )
// Scaling that up by a factor of N to allow for a fractional accumulation of phase error.
// the scaling factor will need to be removed for table lookups
void psk_modem1(long sample){
  
static long vco;             // current phase
const long freq = 64 * 256 ;   //  64 * N;  phase update for 1 khz, 8 fractional bits
long sval;         // sin and cos
long cval;
static int agc = 4096;
long prod;
long pow;


   vco += freq;
   vco &= 65535;    // 4 times freq - 1

   sval = -psk_sin_cos(vco >> 8,0);    // lookup with interpolation of 4 places per table, shift out scaling
   cval = psk_sin_cos(vco >> 8,16);

   sample *= agc;
   sample >>= 11;

   sval *= sample;     // I channel
   cval *= sample;     // Q channel
   sval >>= 12;
   cval >>= 12;

   sval = psk_lowpass(sval,0);
   cval = psk_lowpass(cval,1);
  
//  ch2 = cval;
  
   pow = psk_lowpass(cval * cval , 2);    // agc after the loop arm filter for narrow band response
   if( pow > 35000 ) agc -= 6;
   if( pow < 25000 ) agc += 6;    // was 3
   if( agc > 50000 ) agc = 50000;

   prod= sval * cval;   // phase error
   prod >>= 5;          // 5
// ch2 = prod;  
   vco += prod;         // correct the phase of the vco
   psk_decode(cval);    // signal ends up on the Q channel of the loop
}

// simple filter.  more poles seems to kill the lock in range
// maybe the special FIR low intersymbol filter may be an improvement
// but this works surprisingly well
long psk_lowpass(long val, int i ){   // single pole lowpass, x= 0.9
const long a0 = 409L;
const long b1 = 3686L;
static long w[20];        // single delay term for separate filters

     // y(n) = a0*val + b1*y(n-1)
     val = a0 * val + b1 * w[i];
     val >>= 12;
     w[i] = val;

 return val; 
}

// try a FIR filter.  Bandpass 300 hz
long psk_bandpass(long val ){
const long ck[] =     
  { 414,856,1219,1336,1085,442,-492,-1505,-2320,-2681,-2429,-1560,-243,1218,2466,3182 };   // q15 constants
static long w[32];     // delay line
static int in;         // circular index
int i,j,k;

   w[in] = val;    
   j = in;             // forward index
   k = in - 1;         // reverse index
   if( k < 0 ) k = 31;
   ++in;
   in &= 31;
   val = 0;            // sum
   
   for( i = 0; i < 16; ++i ){
     val += ( ck[i] * ( w[j++] + w[k--] ) );     // constants are symmetrical
     j &= 31;
     if( k < 0 ) k = 31;    
   }
   
   val >>= 15;
   return val;
}

// lowpass FIR filter. 
long psk_lowFIR(long val,int n ){
const long ck[] =     
  { 897,1335,1783,2215,2603,2920,3145,3262 };   // q15 constants
static long w[4][16];     // delay lines for 2 filters
static int in[4];         // circular index
int i,j,k;

   j = in[n];             // forward index
   w[n][j] = val;    
   k = j - 1;         // reverse index
   if( k < 0 ) k = 15;
   ++in[n];
   in[n] &= 15;
   val = 0;            // sum
   
   for( i = 0; i < 8; ++i ){
     val += ( ck[i] * ( w[n][j++] + w[n][k--] ) );     // constants are symmetrical
     j &= 15;
     if( k < 0 ) k = 15;    
   }
   
   val >>= 15;
   return val;
}


void psk_decode(long sample){
static int dcnt;
static int sign;
static int counts;
static int counter;

   
   sample = psk_lowpass(sample,3);
         
   ++dcnt;
   dcnt &= 3;
   if( dcnt != 0 ) return;

   // at 1000 hz rate now, filter again
   sample = psk_lowpass(sample,4);

   ch1 = sample;
// ch3 = 0; 
 
    ++counter;

   // attempt to remove noise zero crossings    
   if( sample > 0 && counts < 2 ) ++counts;   // orig 0
   if( sample < 0 && counts > -2 ) --counts;  // orig -20

   if( ( counts == 2 && sign == 0 ) || ( counts == -2 && sign == 1 )) {   // zero cross detected
      psk_decode2(counter);
      sign ^= 1;
      counter = 16;    // half bit count for rounding
   }   

}

// duplicate functions so can run the decoders in parallel to compare
void psk_decode10(long sample){
static int dcnt;
static int sign;
static int counts;
static int counter;

//ch1 = sample;
   sample = psk_lowFIR(sample,2);      
//   ++dcnt;
//   dcnt &= 3;
//   if( dcnt != 0 ) return;

   // at 1000 hz rate now, filter again
   sample = psk_lowFIR(sample,3);
   
ch2 = sample;
    ++counter;

   // attempt to remove noise zero crossings    
   if( sample > 0 && counts < 2 ) ++counts;   // orig 0
   if( sample < 0 && counts > -2 ) --counts;  // orig -20

   if( ( counts == 2 && sign == 0 ) || ( counts == -2 && sign == 1 )) {   // zero cross detected
      psk_decode12(counter);
      sign ^= 1;
      counter = 16;    // half bit count for rounding
   }   

}


// a K1URC original decode algorithm - a zero cross is a zero preceeded by 0 to 9 ones.  Anything else is invalid
// not trying to find the center of the baud time, nor recover a clock
// a phase reversal means we have recieved  0, or 10, 110, 1110, 11110, 111110, 1111110 and so forth
// this works surprisingly well despite its simplicity
void psk_decode2( int count ){
static unsigned int code;

   count >>= 5;               // divide by 32 giving integer number of bauds
   if( count == 0 ) return;   // short zero, maybe can do something with this later.  Or is it just noise?
   count--;                   // remove the zero on the end of a string of 1's
   if( count > 9 ) return;    // too many ones, it won't decode anyway so skip
   while( count-- ){          // shift in the ones
     code <<= 1;
     code |= 1;
   }
   code <<= 1;                // shift in the zero on the end
   
   if( code && (( code & 3 ) == 0 )){  // 2 zero's on the end means character is done
      if( tuning_rate == 10000 ) psk_decode13( code );  // parallel decoders
      else psk_decode3( code );                         // normal decoder 
      code= 0;     
   }
  
}

void psk_decode12( int count ){
static unsigned int code;

   count >>= 5;               // divide by 32 giving integer number of bauds
   if( count == 0 ) return;   // short zero, maybe can do something with this later.  Or is it just noise?
   count--;                   // remove the zero on the end of a string of 1's
   if( count > 9 ) return;    // too many ones, it won't decode anyway so skip
   while( count-- ){          // shift in the ones
     code <<= 1;
     code |= 1;
   }
   code <<= 1;                // shift in the zero on the end
   
   if( code && (( code & 3 ) == 0 )){  // 2 zero's on the end means character is done
      psk_decode3( code );
      code= 0;     
   }
  
}



// lookup the code and print it
void psk_decode3( unsigned int code ){
unsigned char c, c1, c2;
int i;
     
     while( (code & 0x8000) == 0 ) code <<= 1;    // align with the table codes
     if( code == 0xAAC0 ) return;                 // its the null value that I messed with in the table
     c1 = code >> 8;
     c2 = code & 0xff;
     for( i = 0; i < 128; ++i ){
        if( varicode[2*i] == c1 && varicode[2*i+1] == c2 ) break;
     }
     if( i >= 128 ) return;           // not found in the table
     c = (unsigned char )i;
      
     decode_print(c);
     
}

// parallel decode print - buffer some characters and print all when receive a space
void psk_decode13( unsigned int code ){
unsigned char c, c1, c2;
int i;
static  char buf[20];
static int j;

     while( (code & 0x8000) == 0 ) code <<= 1;    // align with the table codes
     if( code == 0xAAC0 ) return;                 // its the null value that I messed with in the table
     c1 = code >> 8;
     c2 = code & 0xff;
     for( i = 0; i < 128; ++i ){
        if( varicode[2*i] == c1 && varicode[2*i+1] == c2 ) break;
     }
     if( i >= 128 ) return;           // not found in the table
     c = (unsigned char )i;
      
     if( c == ' ' ){
       decode_print('.');
       for( i = 0; i < j; ++i ) decode_print(buf[i]);
       decode_print(c);
       j= 0;
     }
     else if( j < 20 ) buf[j++] = c;     
}



long rtty_bandpass( long sample ){
static long y1,y2;   // bandpass filter delay terms
static long z1,z2;
long y0,z0;

       /* eliptic iir bandpass filter if we have enough MIPS */
       /* reject and passband at 700 900 1100 1300  */
       y0 = 1026L * sample - 1094L * y1 - 3470L * y2;
       sample = y0 - 6536L * y1 + 4096L * y2;
       y0 >>= 12;
       sample >>= 12;  
        y2= y1;  y1= y0;   // move delay terms

        // 2nd section looks like first with some sign changes
       z0 = 1026L * sample + 1094L * z1 - 3470L * z2;
       sample = z0 + 6536L * z1 + 4096L * z2;
       z0 >>= 12;
       sample >>= 12;  
        z2= z1;  z1= z0;
        
   return sample;  
  
}

   /*  
     the fsk modem decode algorithm is from a texas instuments ap note from about 1990 with further information
     gathered from a paper by KE3Z
     the incoming signal is multiplied by a 90 degree phase shifted signal and low pass filtered
     the choice of a sample rate of 4000 and center freq of 1000 hz makes the production of the 90 degree
     shifted signal trivial - it is simply the previous sample
     with the low sample rate, the wide crystal filter should not be selected as unwanted signals will alias with the desired signal
        PSK31 decode also comes here for bandpass filtering
   */

void rtty_modem( long sample ){
 
long prod;
static long last_sample;
static int last_result; 
int  result;
static int baud_clock;
static int baud_tick;
static long ppeak,npeak;
static int tenbaud;
static int decode_state;
int i;
static long slicer;
       
       sample = rtty_bandpass( sample );
   
       prod= sample * last_sample;  // this is where the fm happens
       last_sample = sample;

       // low pass filter the data signal 
       // this combination seems to give a nice looking slew rate
       prod = psk_lowpass( prod, 0 );
       prod = psk_lowpass( prod, 1 );
       // prod = psk_lowpass2(prod, 0 );
       // prod = psk_lowpass2(prod, 1 );
  
       // adjust the decision point based upon the peak signal over 10 baud time
       if( prod > ppeak ) ppeak = prod;
       if( prod < npeak ) npeak = prod;
       if( ++tenbaud == 880 ){
         slicer = ( ppeak + npeak ) >> 1;
         slicer = psk_lowpass( slicer, 2 );
         for( i = 0; i < 10; ++i ){          // check if slicer is out of bounds
           if( slicer > ppeak ) slicer = psk_lowpass(0, 2);
           if( slicer < npeak ) slicer = psk_lowpass(0, 2);
         }
         tenbaud= 0;
         ppeak= npeak= 0; 
       }
      
    ch1 = -prod;   // debug - SoftScope channels
    ch3 = -slicer;
      
       if( prod >= slicer ) result = 0;  // decode to zero and 1's
       else result = 1;

       if( decode_state == 0 ){             // look for start bit for clock alignment
          if( result == 1 ) baud_clock= 44; // just keep reseting the clock at 1/2 bit time when no start bit
       }

      // this is more of a syncronous clock recovery but it may help with distorted signals
      if( result != last_result ){   // align clock on center of single bits or 2 bits
        if( baud_tick > 154 && baud_tick < 210 ) baud_tick -= 88;   // 2 baud.  remove one. 
        if( baud_tick > 44 && baud_tick < 120 ){
           baud_tick >>= 1;          // half bit time is where the clock should be now
           baud_tick = baud_tick - baud_clock;      // error
           baud_tick >>= 2;                         // 1/4 the error
           baud_clock+= baud_tick;                  // adjust clock by 1/4 the error
        }
        baud_tick = 0;   
      }
      
      last_result = result;

      ++baud_clock;
      ++baud_tick;
      
    ch2 = baud_clock;    // Soft scope

      if( baud_clock >= 88 ){   // send a bit to the decoder and pick up the decoder current state 
        baud_clock = 0;
        decode_state= baudot_decode( last_result );
      }   
}

/* baudot state machine to assemble  characters */
int baudot_decode( int val ){
static int state = 0;
static int code;
static int bit_count;
static int shift= 0;


  /* debug show result on green LED's */
   if( rtty_on_leds && led_on_timer == 0 ){
      if( val == 0 ) write_sleds(SGRN);
      else write_sleds(0);
      if( val == 1 ) write_fleds(FGRN,0);
      else write_fleds(0,0);
   }

   switch( state ){
     case 0:        // looking for start bit
        if( val == 0 ){
          ++state;
          code= 0;
          bit_count= 0;
        }
     break;
    
     case 1:        // shifting in bits
        code >>= 1;
        if( val == 1 ) code |= 0x10;
        if( ++bit_count == 5) ++state;
     break;
   
     case 2:        // looking for stop bit
        if( val == 1 ){
          if( code == 0x1f ) shift = 0;
          else if( code == 0x1b ) shift = 1;
          else {
            code = baudot_table[shift][code];
            decode_print((unsigned char) code); 
          }
          state= 0;
        }
        else state= 3;
     break;
     
     case 3:    // framing error.  Discard zero's, continue on next one received
        if( val == 1 ) state = 0;
     break;     
   }
   return state;   // the modem needs to know when we are looking for the start bit
}


// not crazy about the random numbers as sometimes transmit 4 times in a row ( almost 8 minutes key down )
// force at most a 50 percent wspr duty cycle with a queue of pending transmits
void wspr_timer(){      
static int last_time;    // alternate receive and transmit
char buf[35];
static int min2;         // two minute intervals count
static int wwv_checking; // wwv sync up variables
static int wwv_max;
static int wwv_max_sec;
static long save_vfo;
static int  save_band;
static int wspr_que;
long wwv_target;

      msec+=  ( time - oldtime );
      if( msec >= 1000 ){      // one second period
         msec -= 1000;
         
         if( ++sec >= 120){    // start of a two minute period
           sec -= 120;
           if( led_on_timer == 0 ) set_display(4,4);
           if( random(100) <  (long)( 5 * wspr_duty )) ++wspr_que;
           if( wspr_que ){
              if( last_time ) last_time = 0;
              else{
                 wspr_tx_enable = last_time = 1;
                 --wspr_que;
              }                 
           }
           ++min2;
         }
         
         lcd_goto(4,66);
         itoa(sec,buf,10);
         if( sec < 100 ) lcd_putch(' ');
         if( sec < 10 ) lcd_putch(' ');
         lcd_puts(buf);
      }
      //  clear the green leds 1/2 second later
      else if( msec == 500 && led_on_timer == 0 && wspr_tx_enable == 0 ) set_display(0,0);

      // wwv sync up starting 
      if( min2 >= 20 && sec == 108 && (band_switch != JUMPERS || band == 2) && transmitting == 0 ){  // startup, 40 meter jumpers can't check
         min2= wwv_max= wwv_max_sec = 0;
         wwv_checking = 1;
         last_time = 1;               // force no tx during wwv check
         save_vfo = rx_vfo;
         save_band = band;
         switch( band_switch ){
            case JUMPERS:  wwv_target = 15000000L;  break;   // we are on 20 meters with jumpers
            case TWO_BAND:                                   // each user may need some fine tuning here to get exact 1000 hz tone
               wwv_target = 15000000L;                       //    from wwv signal.  First get the Reference and bfo close.
               while( band !=2 ) user_action(BAND,1);
            break;
            case FOUR_BAND:
               wwv_target = 10000000L;     
               while( band != 1 ) user_action(BAND,1);
            break;   
         }
         rx_vfo = wwv_target;
         update_frequency(DISPLAY_UPDATE); 
         set_display(2,2);                   // show yellow when tuning to wwv
         led_on_timer = 20000;        
      }

      //  wwv sync ending
      if( wwv_checking && sec == 10 ){
         if( wwv_checking == 2 && wwv_max <= 90 ){    // found a time signal, test for typical value
            if(wwv_max_sec > 0 && wwv_max_sec < 11)  sec -= wwv_max_sec;       // clock fast
            if( wwv_max_sec > 109 ) sec += ( 120 - wwv_max_sec );              // clock slow
            wspr_wwv= 0;                                                       // screen message index
         }
         else{
            ++wspr_wwv;
            if( wspr_wwv > 3 ) wspr_wwv = 3;
         }
         while( band != save_band )  user_action(BAND,1);
         rx_vfo = save_vfo;
         update_frequency(DISPLAY_UPDATE);
         wwv_checking = 0;
      } 
      
      // wwv capture max events
      if( wwv_checking ){
         if( wwv_tone >= WWV_TONE_DET && wwv_checking == 1 ){
           wwv_max_sec = sec;                                // capture when first passes threshold
           ++wwv_checking;                                   // stop looking for this event
         }
         if( wwv_tone > wwv_max ) wwv_max = wwv_tone;        // capture max during interval to detect false signals 
      }                                                      // typical value should be 80 as tone lasts 800 ms
}



void loop(){
static int freq_decade;
static int robin;
static int argo_time;   /* for ARGO_EMU */
static int rtty_baud_clk;
long sample;
// int wt;   // simple rtty weighted window - can't determine if it makes any difference
// int temp;

//  !!!!! below is just a temporary safeguard  
//   digitalWrite(TX_OUT,LOW);       // turn off TX just in case we made a mistake

   
  // very high priority processes  
   if( s_in != s_out ) process_sample();
   else if( rty_in != rty_out ){
     sample = samples[rty_out];
     ++rty_out;
     rty_out &= 7;
     if( mode == RTTY ) rtty_modem(sample);
     if( mode == PSK31 ) psk_modem(sample);
   }    
   else if( mode == JT65 && jt_time ){         // high baud rate
      if( un_stage()== 0 ) jt_serial();
      --jt_time;
   }
   else if( w_max ){
     mfsk_decode(w_max);
     w_max = 0;
   }
   else if( go_plot ) plot_vals();   // keep last as this stalls if nokia is in macro screen
   


   if( scope_active == 3 ) scope_display();   // 1st display after data capture - use function button to continue
   
    /* this code runs at 1ms rate */
   time = millis();
   if( time != oldtime ){
       
      if( mode == WSPR ) wspr_timer();
      
      oldtime= time;
      ++counter;        /* paddle timer */
          
      if( mode == RTTY ) rtty_key();        // check if should transmit
      else if( straightkey || mode == HELL ) sk_transmit();
      else paddles();
      
      if( crh_tx_method == CRH_TX_TERM ) keyboard_input();  
       
      button_state();                                /* read switches */
      if( function_action() || select_action() ){    /* act on switches */
           write_fleds(fleds[function] , 1);
           write_sleds(sleds[fun_selected[function]]);
           led_on_timer = 1000;
           fled89 = sled89 = 0;
      }
      
      /* tx beacon or announce queue */
      if( autotx_timer ) --autotx_timer;  
      if( autotx_timer == 0 && (tx_in != tx_out || tx_state != 0) ) auto_tx(0); 
      if( wpm_adjust && tx_in == tx_out && tx_state == 0 ) load_wpm();          /* code speed adjust in use */
      
      if( tdown ){   /* tx off dds delay for auto tx, straight key and keyer  */
         --tdown;
         if( tdown == 0 ){
            LATGCLR = DDS_SEL;  /* back to rx vfo */
            /* final battery and power out check */
            battery(1);
            power_out();
            led_on_timer = 600;
         }
      }

      if( led_on_timer  ){  /* the 8 or 9 tuning display if needed with low duty cycle */
         if( robin == 0 ){      
            if( fled89 ) LATDSET= fled89;
            if( sled89 ) LATFSET= sled89;    
         }
         if( robin == 1){
            if( fled89 ) LATDCLR= fled89;
            if( sled89 ) LATFCLR= sled89;    
         }
      }

      if( cat_emu == K3_EMU ){      
                    /* 1 char per ms or 1000 cps or 10000 baud */
                    /* must stay at or above 19.2 for this to work */
         if( un_stage() == 0 ) radio_control();     /* nothing to send, get next command, sort of half duplex */
      }

      if( cat_emu == ARGO_EMU ){
      /* throttle down the cps to 100, ie under 1200 baud so the serial does not block */
         if( ++argo_time > 10 ){
            argo_time = 0;
            if( un_stage() == 0 ) radio_control2();
         }
      }      

      if( cat_emu == NO_EMU && serial_decode ){
         if( ++argo_time > 10 ){
            argo_time = 0;
            if( quiet_mode == 0 ) un_stage();
            else stg_out = stg_in;
         }
      }

      // psk tx shutdown counter to produce a steady carrier
      if( psk_dn_count ){
        if( ++psk_dn_count > 700 ){
          rtty_down();
          psk_dn_count = 0;
        }
      }
      
      /* round robin some processing - code runs 8ms rate */
      ++robin;
      robin &= 7;

      /* add a RIT on indication on the TT LED, dimly lit LED */
      if( rit_offset ){
         if( robin == 7 ) LATBSET = TTLED;
         if( robin == 0 ) LATBCLR = TTLED;
      }
       
      switch( robin ){
        case 0:  
           check_inband();      /* both these will change the TT led */
           show_split();   
        break;
        case 1: 
           rit_read();
           if( spot_timer ){
              if(--spot_timer == 0 ) user[SPOT] = 0, update_frequency(DISPLAY_UPDATE);
              else auto_spot();
           }
        break;
       
        case 2:
           if( mem_tune == 3 ) mem_tune= 1, write_sleds(0);  // end of the channel change LED flash
           if( select_macro ) macro_select();
           else if( mem_tune && user[LOCK] ) memory_tune();  // unlock vfo to tune around a memory channel
           else encoder(); 
        break; 
        case 3:     /* cut number announce  and general freq display */         
             tdec = (listen_vfo / 10000) % 10;
             tunits = (listen_vfo / 1000 ) % 10;
             if( tdec != freq_decade ){
                freq_decade= tdec;
                /* calc the 100khz number also for the LED freq display */
                thun = (listen_vfo / 100000) % 10;
                if( cut_num_enable && tx_state == 0  && autotx_timer == 0 && user[DISPLAY] == 0
                    && tuning_rate != 10000) auto_tx( cut_numbers[tdec] );
               // tuning_display();   /* power up sticky in LED's, else not needed */
             }
        break;
        case 4:                     /* end the frequency display or function/select in LED's */ 
             if( led_on_timer ){   /* 5 second timeout and then blank display */
               --led_on_timer;
               if( led_on_timer == 0 ){
                  write_fleds(0,0);
                  write_sleds(0);
                  fled89 = sled89 = 0;
                  nokia_s_inhibit = 0;
               }
             }
        break;
        case 5:  if( transmitting == 0 ) code_read(); break;   
        case 6:  if( transmitting )  power_out(); break;    /* if transmitting show the power out */
        case 7:  if( transmitting ){
                    battery(1);
                 }
                 else{
                    battery(0);
                    if( nokia_s_inhibit == 0 ){
                       if( user[CODEREAD] && nokia == NO_DISPLAY && led_on_timer == 0 ) smeter(1);
                       else  smeter(0);   // with no display the coderead function( GRN led ) turns the LED S meter on and off 
                    }
                 }    
        
        break;
      }

      if( timeout_ok ) --timeout_ok;
      else if( oldtime !=  millis() ) {     /* out of gas.  Display red on the LED's */
         write_fleds(FRED,0);
         write_sleds(SRED);
         led_on_timer = 600;
      }      
      else if( user[DISPLAY] == 0 ) asm("wait");     /* low current feature for field mode, wait for core timer interrupt( millis or Hell ) */
      
   }  // end if new millisecond
   
}  //end loop


void keyboard_input(){        // dumb terminal input mode
static int hell_idle;
static int counter;
static int runaway;
char temp;

  temp = key_input();

  if( temp != 0 ){  
     counter = 0;                       // we are typing so suppress the idle characters
     runaway = 0;                       // we are still typing so no runaway idle characters yet
     stage( temp );                    // loopback
     if( temp == '\r' ) stage('\n');   // ?? needed 

     if( temp == 20 && transmitting == 0 ){
         if( mode == RTTY ) rtty_up();         // control T to transmit
         if( mode == HELL ) hell_idle = 1;     // also starts Hell idle characters
         if( mode == PSK31 ) psk31_up();
         if( mode == MFSK ) mfsk_flag = MFSK_GO;
     }                                         // CW keyboard is always live, doesn't need control T or control R
     else if( temp == 21 ){                    // control U flushes the buffer and aborts
        tx_in = tx_out;
        if( mode == RTTY || mode == PSK31 ) rtty_down();     
        if( mode == MFSK ) mfsk_flag = MFSK_STOP;
        hell_idle = 0;
     }
     else if( temp == 18 ){                  // control R (18) to receive 
        if( mode == RTTY || mode == PSK31 || mode == MFSK ) load_tx_queue( temp | 0x80 );
        hell_idle = 0; 
     }
     else if( temp == 17 || temp == 19 ) quiet_mode ^= 1;   // serial decode to the bit bucket if quiet mode is true
     else load_tx_queue(temp | 0x80);                   // put in buffer with tx bit set h tx bit set  
  }
  
  else if( (transmitting || hell_idle) && tx_in == tx_out ){   //  idle characters if needed
     ++runaway;
     ++counter;
     if( mode ==  RTTY  && counter > 500) {    // load up an idle char
        load_tx_queue('a' + 0x80);                    // a == letters shift in the table
        counter = 0;
     }
     if( hell_idle && counter > 1000 ){
        load_tx_queue('.' + 0x80);
        stage('.');
        counter = 0; 
     }
     // stop a runaway tx in 30 seconds 
     if( runaway > 30000 ){
        if( mode == PSK31 ) psk_dn_count = 1;
        if( mode == MFSK ) mfsk_flag = MFSK_STOP;
        if( mode == RTTY ) rtty_down();
        hell_idle= counter= runaway = 0; 
     }
  }
  else if( transmitting && tx_in != tx_out ) counter= runaway = 0;  // macro is being sent instead of keyboard input  
  
}


int key_input(){   // key input and fix up for the mode in use
char temp;
const char valid[7] = { 8, 13, 17, 18, 19, 20, 21 };
int i;

   if( Serial.available() == 0 ) return 0;

   temp = (char) Serial.read();
   
   if( temp > 126 ) return 0;
   
   // allow any control characters we want to see else delete
   if( temp < 32 ){
      for( i = 0; i < 7; ++i ) if( temp == valid[i] ) break;
      if( i == 7 ) return 0;
   }

   if( mode == HELL || mode == CW || mode == RTTY ){
     temp = toupper(temp);                           // upper case only modes
     if( temp == 8 ) return 0;
     if( temp == '\r' && mode != RTTY ){             // echo but don't allow in the keyboard buffer
        stage('\r');  stage('\n');
        return 0;
     }
   }
   return temp;
}



#define JTBUFSIZE 30
/* since we are running the serial line for several different processes we need a replacement for command messenger */
void jt_serial(){
char temp;
static int row,col;
static char command[JTBUFSIZE];
static int index;
int res;

  if( Serial.available() == 0 ) return;
  temp = Serial.read();
  if( temp == '\r' || temp == '\n' ) return;

  if( temp != ',' && temp != ';' ) command[index++] = temp;

  if( index >= JTBUFSIZE ){    // error - should probably flag the operator somehow
     index = 0;
     return;
  }
  
  command[index] = 0;
  
  if( temp == ';' || temp == ',' ){
    res = do_jt( temp , command);
    
    
  // debug - don't know what it is so print on the top line
     if( res == 0 && col < 14){
        command[index++]= temp;    // put the terminator back in the string
        command[index]= 0; 
        lcd_goto(row,col*6);
        lcd_puts(command);
        col += strlen(command);
        //if( col >= 14 ) col= 0;
     }

    index= 0;    
  }  
}

int do_jt( char term, char *arg ){
static int cmd;
int rval;        // return value and command continue
int temp;
static int rx_off, tx_off;       // hiding these so can control offsets with Rebel, yet want to report back to hfwst that all is ok

  rval = 1;
  if( cmd == 0 ){
    cmd = atoi(arg);
    if( term == ';' ) ++rval;     // command is complete with no commas
  }
  else rval= 2;                   // command continue hopefully
  
  if( rval == 2 ){
     switch( cmd ){
       case 2:  jt_ack(); stage_str("1005");          break;     // version
       case 3:  jt_ack(); stage_str("AD9834");        break;     // dds
       case 4:  jt_ack(); stage_str("49999750");      break;     // send fake reference  
       case 10: rx_off = atoi(arg);           // no break;
       case 8:  jt_ack(); stage_num(rx_off);    break;     // rx fudge factor changed to local dummy vars
       case 11: tx_off = atoi(arg);           // no break;
       case 9:  jt_ack(); stage_num(tx_off);    break;     // tx fudge factor now just local dummy var
       case 12: jt_ack();                                        // band
         // switch(band){
         //    case 0: temp = 40; break;                         // HFWST only works on 40 and 20
         //    case 1: temp = 30; break;                         // faking stuck on 20 so can work 30 and 17 also
         //    case 2: temp = 20; break;                         // only issue should be the logging frequency will
         //    case 3: temp = 17; break;                         // need changing each time contact is saved
         //}
          stage_str( "20" );                                       // always reporting 20 m
       break;
       case 14: jt_fcalc0 = atol(arg); // jt_to_freq0(jt_fcalc0);   // no break  // set rx dds word    
       case 13: jt_ack(); stage_long_str( jt_fcalc0 );   break;  // rx dds word       
       case 15: jt_ack(); stage_num(transmitting);    break;     // tx status
       case 7:  jt_ack(); stage_num(1000);            break;     // loops per second for us is exact
       case 23: jt_ack(); stage_num(23);              break;     // ready to load valuse
       case 26: jt_ack(); jt_dump_vals();             break;     // report the dds words for jt message
       case 22: jt_ack(); stage_num(22); jt_clr_vals();  break;  // clear the buffer
       case 24: jt_load_vals(term,arg);               break;
       case 16: jt_ack(); stage_num(16); jt_tx_on = 1;  jt_tx_index= 0; break;          // start tx  
       case 18: jt_ack(); stage_num(18); if( jt_tx_index < 123) jt_tx_on = 0;  break;   // stop tx unless almost done
       case 19: jt_ack(); stage_num(19);  stage(',');                                   // start with offset
                jt_tx_index = atoi(arg); if( jt_tx_index < 45 && jt_tx_index >= 0 ) jt_tx_on = 1;
                stage_num( jt_tx_index );
       break;         
   
       default: stage('0,'); stage_num(cmd); cmd = 0; rval= 0;  break;   // unknown command      
     }
  }
  
  if( term == ';' ){
    cmd = 0;   // end of the command
    stage_str(";\r\n");
  }
  
  /// debug  only  - show the command if followed by a comma
  // if( rval == 1 && term == ',' ) return 0;
  
  return rval;
}

void jt_ack(){
   stage_str("1,"); 
}

void jt_load_vals( char term, char * arg ){   // blocks of 4
static int state;
static int base;
static int i;
int j;
   
   switch(state){
       case 0:   ++state;  stage_num(24); // no break;               // just got the command
       case 1:   base = atoi(arg);  ++state;  i= 0; stage(',' ); stage_num(base); 
                 //lcd_goto(0,0);    lcd_puts(arg);   lcd_putch(term);  // debug only show base on screen
       break;     // get the base
       case 2: 
         j= 4*(base-1) + i;
         if( j >= 0 && j < 128 ){
            jt_buf[j] = atol( arg );
            stage( ',');
            stage_long_str( jt_buf[j] );
         }
         ++i;
         i &= 3;       // keep in range of 0 to 3         
   }
   
   if( term == ';' ) state = base = i = 0;  
}


void jt_dump_vals(){
int i;

   stage_str("FSK VALUES FOLLOW");
   for( i= 0; i < 126; ++i ){
      stage(',');
      stage_num( jt_buf[i] );
      while(un_stage());                  // too much data for the buffer
   }
   timeout_ok = 3;
}

void jt_clr_vals(){
int i;

  for( i = 0; i < 128; ++i ) jt_buf[i] = 0;  
}


/* run the dft and code decoding algorithms */
/* this is an original algorithm based upon an intermediate equation in the FFT derivation */
/* there is more processing involved than a FFT, but the processing can be spread in time */
void process_sample(){
static int count;
int i,j;
int val;

     val= samples[s_out];
     
     if( count >= 0 ){
     for( i= 0; i <= FFTSIZE/2; ++i){
          j= ( i * count ) & MOD;   /* get sincos index */
          vals[i]+= ( sin_cos[j] * val ) >> 12;          /* sine value */
          valc[i]+= ( sin_cos[j+OFFSET] * val ) >> 12;   /* cosine value */
     }
     }
  

   ++s_out;
   s_out &= 7;

   if( ++count == FFTSIZE){   /* done */
     // count = 0;
      count = merge_vals();   
   }
}

int merge_vals(){
int i;
int retval;
int max_val;

  retval = 0;
  w_max2 = w_max1;
  w_max1 = w_max;
  max_val = 0;
  
  for( i= 0; i <= FFTSIZE/2; ++i ){
       workval2[i] = workval1[i];
       workval1[i] = workval[i];
       workval[i] = vals[i]*vals[i] + valc[i]*valc[i];
       vals[i]= valc[i]= 0;
       if( workval[i] > max_val && i >= 12 && i <= 27 ){
         max_val = workval[i];
         w_max = i;
       }
   }  
   go_plot = 1;
   
   if( fast_plot ){    // find framing for mfsk
      if(w_max1 == w_max2 || w_max1 == w_max ) retval = 0;
      else{
        if( workval2[w_max1] > workval1[w_max2] + 10000) ++retval;
        if( workval[w_max1] >  workval1[w_max] + 10000 ) --retval;
      }
      // afc
      if( workval[w_max + 1] > workval[w_max -1] + 1000 ) mfsk_afc -= 3;
      else if( workval[w_max - 1] > workval[w_max + 1] + 1000 ) mfsk_afc += 3;
      else if( mfsk_afc > 0 ) --mfsk_afc;
      else if( mfsk_afc < 0 ) ++mfsk_afc;
      if( mfsk_afc > 3200 ) mfsk_afc = 3200;
      if( mfsk_afc < -3200 ) mfsk_afc = -3200;
   }
   else w_max = mfsk_afc = 0;
   
ch1 = max_val;
ch2 = mfsk_afc;
   return retval; 
}

/* actual writing to the lcd broken out of plot_vals so it can have a different duty cycle */
void lcd_plot_vals(int val, int indx, int merge, int merge2){
static int duty;
char graph[] = {0x80,0x80,0xc0,0xe0,0xf0,0xf8,0xfc,0xfe,0xff};
int i;

  /* scale up to avoid loosing significant info */
  val <<= 4;
  /* generate a running average for each bucket */
  plotval[indx] =  val + 7 * plotval[indx];
  plotval[indx] >>= 3;
  
  if( val > plotval[indx] ) plotval[indx] = val;  // peak reading, slow decay

  ++duty;
  duty &= 7;
  if( duty && fast_plot == 0 ) return;

  /* get to here 1 out of 8 times */
  i= plotval[indx] >> 4;

  /* one sequence of numbers(duty) is 0 to 7 */
  /* 2nd sequence of numbers(indx) is 0 to 32 */
  /* think screen updates will be index 0,8,16,24,32,7,15,23,31,6,14... */
  
  /* original 100 frames/sec code follows */
  if( i <= 8 ){     /* plot on low line, clear high */
     lcd_goto(4,indx*2);
     lcd_write(0 | merge);  lcd_write(0 | merge2);
     lcd_goto(5,indx*2);
     lcd_write(graph[i] | merge);  lcd_write(graph[i] | merge2);
  }
  else{             /* plot on high line, set/clear low */
     lcd_goto(5,indx*2);
     lcd_write(0xff);   lcd_write(0xff);
     lcd_goto(4,indx*2);
     lcd_write(graph[i-8] | merge);   lcd_write(graph[i-8] | merge2);
  }

}


void plot_vals(){
static int indx;
int val,i;
// char graph[] = {0,0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01};
// char graph[] = {0x80,0x80,0xc0,0x60,0x30,0x18,0x0c,0x06,0x03};
// char graph[] = {0x80,0x80,0xc0,0xe0,0xf0,0xf8,0xfc,0xfe,0xff};
char merge,merge2;
static int decode[5];
static int dcount;
static int smax;

  if( nokia != NORM_D && nokia != SPLIT_D && nokia != DECODE_D ) return;
  
  val = workval[indx] >> 11;  // was 9 before highpass change.  adjust to base value that was found by experiment
  for(i=0; i < 16; ++i ){    // sort of a power of 2 log
     val >>= 1;
     if( val == 0 ) break;
  }
  
  if( 20*i > smax ) smax = 20*i;   // scaled up by 20 to give some hang time
  
  /* merge tuning goalposts and store auto spot information */
  merge= merge2 = 0;
  if( indx == goalpost-5 ) spot[0] = i;
  if( indx == goalpost-4 ) spot[1] = i;
  if( indx == goalpost-3 ) spot[2] = i;
  if( indx == goalpost-2 ) decode[0] = i+2, spot[3]= i;
  if( indx == goalpost-1 ) merge = 0x55, decode[1] = i+1, spot[4]= i;
  if( indx == goalpost ) decode[2] = i, spot[5]= i;
  if( indx == goalpost+1 ) merge2 = 0x55, decode[3] = i+1, spot[6]= i;
  if( indx == goalpost+2 ) decode[4] = i+2, spot[7]= i;
  if( indx == goalpost+3 ) spot[8] = i;
  if( indx == goalpost+4 ) spot[9] = i;
  if( indx == goalpost+5 ) spot[10] = i;

  lcd_plot_vals(i,indx,merge,merge2);   /* lower duty cycle code replaces the original */
  
  if( ++indx > FFTSIZE/2 ){
     indx = 0;
     go_plot = 0;
     smeter_value2 = smax/20;
     smeter_value2 = ( smeter_value2 > 1) ? smeter_value2 - 1 : 0;   // a little stingy on the low end but not below zero
     if( smax ) --smax;       // decay is about 10 counts in .1 seconds or 1 s unit in .2 seconds.

     if( mode == WSPR ) wwv_time();
     
     /* 1st try decode method - check amplitude of center vs either side of singnal, works ok */
     if( decode[2] > decode[0] && decode[2] > decode[1] && decode[2] > decode[3] && decode[2] > decode[4] )
               merge = 1;  /* variable merge reused as mark space decoded */
     /* or use 2nd decode method */
     merge = second_decode_method( merge );
     
     /* decode samples are at approx 10ms intervals */
     if( merge ){           /* marking */
        if( dcount > 0 ){  /* store space count */
           storecount(dcount);
           dcount = 0;
        }
        --dcount;         /* count marking time */
     }
     else{                /* spacing */
       if( dcount < 0 ){  /* store mark count */
        //  if( dcount < -2 ) storecount(dcount);   // noise filter.  must be at least 3 counts
          storecount(dcount);    // decode method two
          dcount = 0;
       }
       ++dcount;                /* count spacing */
       if( dcount == 99 ){      /* force decode each second */
          storecount(dcount);
          dcount = 0;
       }
     }     
  }    
}

int second_decode_method(int signal ){
   /* time delay to remove single mark single spaces in signal stream */
   /* a number of algorithms have been tried but none as good as the first idea */
   /* so this function is not really a 2nd decode method */
static int mark;   
    
   if( signal ){
      mark <<= 1;
      mark |= 1;
   }  
   else mark >>= 1;
   mark &= 7;
   
   if( signal ) return mark & 4;
   else return mark & 2;   
}


void wwv_time(){    // can we detect a 1000 hz tone using the data collected in spot array
                    // this runs at 100 hz rate.  a .8 second tone will produce a max value of 80
                    // in wspr mode the goalposts are at 1500 hz so spot[0] is at 1000 hz
   if( spot[0] <= spot[1] || spot[0] <= spot[2] ) wwv_tone = 0;
   else if( spot[0] <= spot[3] || spot[0] <= spot[4] ) wwv_tone = 0;
   else if( spot[0] <= spot[5] || spot[0] <= spot[6] ) wwv_tone = 0;
   else if( spot[0] <= spot[7] || spot[0] <= spot[8] ) wwv_tone = 0;
   else if( spot[0] <= spot[9] || spot[0] <= spot[10] ) wwv_tone = 0;
   else ++wwv_tone;
 
   //peak_value(0,wwv_tone);   // debug  
  
}

void storecount(int count ){   /* part of code read functions */
static int last_space_count;
//char buf[35];
int dah_lim;

  /* when marking, noise is not a problem */
  /* when spacing, noise will cause multiple space counts.  Sum them here */
  if( count > 0 ){
    if( last_space_count >= 99 ) return;     /* already reported this space */
    last_space_count += count;
  }
  
  if( count < 0 || last_space_count >= 99 ){   /* store the space count */
     /* store last_space_count in buffer */
     cread_buf[cread_indx++] = last_space_count;
     cread_indx &= 15;     // stay in bounds 
  }

  if( count < 0 ){  
     last_space_count= 0;   /* reset space count on marking condition */
     /* store count in buffer */
     cread_buf[cread_indx++] = count;
     cread_indx &= 15;     // stay in bounds
    /* put entrys into the dah table for speed calc */
     count = -count;
     dah_lim = ( shi5 > 10 ) ? 10 : 12;
     if( count >= dah_lim && count < 50 ){
       dah_table[dah_in++] = count;
       dah_in &= 7;
     } 
  }
    
}


void shuffle_down( int count ){    /* consume the stored code read counts */
int i;

  for( i= count; i < cread_indx; ++i ){
    cread_buf[i-count] = cread_buf[i];
  }
  
  cread_indx -= count;
  cread_indx &= 15;     // just in case out of sync  
}


int code_read_scan(int slice){  /* find a letter space */
int ls, i;

/* scan for a letter space */
   ls = -1;
   for( i= 0; i < cread_indx; ++i ){
      if( cread_buf[i] > slice ){
        ls = i;
        break;
      }
   }
   return ls;   
}


unsigned char morse_lookup( int ls, int slicer){
unsigned char m_ch, ch;
int i,elcount;

   /* form morse in morse table format */
   m_ch= 0;  elcount= 1;  ch= 0;
   for( i = 0; i <= ls; ++i ){
     if( cread_buf[i] > 0 ) continue;   /* skip the spaces */
     if( cread_buf[i] < -slicer ) m_ch |= 1;
     m_ch <<= 1;
     ++elcount;
   }
   m_ch |= 1;
   /* left align */
   while( elcount++ < 8 ) m_ch <<= 1;

   /* look up in table */
   for( i = 0; i < 47; ++i ){
      if( m_ch == morse[i] ){
        ch = i+',';
        break;
      }
   }

   return ch;  
}

void code_read(){  /* convert the stored mark space counts to a letter on the screen */
int slicer;
int i;
unsigned char m_ch;
int ls,force;
static int wt;    /* heavy weighting will mess up the algorithm, so this compensation factor */
static int singles;
static int farns,ch_count,fcount;

   if( (user[CODEREAD] == 0 && serial_decode == 0) || cread_indx < 2 || mode != CW ) return;    /* need at least one mark and one space in order to decode something */
   
   /* find slicer from dah table */
   slicer= 0;   force= 0;
   for( i = 0; i < 8; ++i ){
     slicer += dah_table[i];
   }
   slicer >>= 4;   /* divide by 8 and take half the value */

   ls= code_read_scan(slicer + wt);
   
   if( ls == -1 && cread_indx == 15 ){   // need to force a decode
      for(i= 1; i < 30; ++i ){
        ls= code_read_scan(slicer + wt - i);
        if( ls >= 0 ) break;
      } 
      --wt;    /* compensate for short letter spaces */
      force= 1;
   }
   
   if( ls == -1 ) return;
   
   m_ch = morse_lookup( ls, slicer );
   
   /* are we getting just E and T */
   if( m_ch == 'E' || m_ch == 'T' ){   /* less weight compensation needed */
      if( ++singles == 4 ){
         ++wt;
         singles = 0;
      }
   }
   else if( m_ch ) singles = 0;   
 
   /* are we getting just e,i,s,h,5 ?   High speed limit reached.  Attempt to receive above 30 wpm */
   if( m_ch > 0 && ( m_ch == 'S' || m_ch == 'H' || m_ch == 'I' || m_ch == '5' )) ++shi5;
   else if( m_ch > 0 && m_ch != 'E' ) --shi5;   // E could be just noise so ignore
   if( shi5 < 0 ) shi5 = 0;
 
   /* if no char match, see if can get a different decode */
   if( m_ch == 0 && force == 0 ){
     //if( ( slicer + wt ) < 10 ) ls = code_read_scan( slicer + wt -1 );
     //else ls = code_read_scan( slicer + wt -2 );
     ls = code_read_scan( slicer + wt - ( slicer >> 2 ) );
     m_ch = morse_lookup( ls, slicer );
     if( m_ch > 64 ) m_ch += 32;       // lower case for this algorithm
     //if( m_ch ) --wt;     this doesn't seem to be a good idea
   }
 
   if( m_ch ){   /* found something so print it */
      ++ch_count;
      decode_print(m_ch);
      if( cread_buf[ls] > 3*slicer + farns ){   // check for word space
        if( ch_count == 1 ) ++farns;    // single characters, no words printed
        ch_count= 0;
        decode_print(' ');
      }
   }
     
   if( ls < 0 ) ls = 0;   // check if something wrong just in case  
   shuffle_down( ls+1 );  

   /* bounds for weight */
   if( wt > slicer ) wt = slicer;
   if( wt < -(slicer >> 1)) wt= -(slicer >> 1);
   
   if( ch_count > 10 ) --farns;
   
}


/* debug only function 
void pvals(int val, int val2){
char buf[35];

     itoa( val, buf, 10);
     lcd_goto(4,66);
     lcd_puts(buf);
     lcd_putch(' ');

     itoa( val2, buf, 10);
     lcd_goto(5,66);
     lcd_puts(buf);
     lcd_putch(' ');

}  */

void auto_spot(){
int max_val,max1,max2;  // max1 is largest, max2 is 2nd largest dft bucket
int i;
int adj;
int max_val2;           // modified for RTTY also

   /* find position of largest signal */
   max_val = max_val2 = spot[0];
   adj = max2 = max1 = 0;
   
   for( i= 1; i < 11; ++i ){
     if( spot[i] > max_val + 2 ){   // CW algorithm
       max_val2 = max_val;
       max_val = spot[i];
       max2= max1;
       max1= i;
     }
     else if( mode == RTTY ){     // capture 2nd peak also
       if( spot[i] > max_val2 ){
          max_val2 =  spot[i];
          max2 = i;
       } 
     }
   }
   
   if( max1 == 0 ) return;
   if( max_val < 6 && ( max1 - max2 ) > 2 ) return;   // noise
   
   if( mode == RTTY ){
    /* rtty algorithm  - make max at index 4 and 6 */
    if( max1 > 6 ) adj = -5 * ( max1 - 6 );
    else if( max1 < 4 ) adj = 5 * ( 4 - max1 );
    else if( (max1 + max2 ) > 10 ) adj = -1;    // testing if 5 has one of the larger signal
    else if( (max1 + max2 ) < 10 ) adj = 1;
   }
   else{
     /* cw algorithm - make max at index 5 */
      if( max1 > 5 ) adj = -5 * ( max1 - 5 );
      else if ( max1 < 5 ) adj = 5 * ( 5 - max1 );
      else if( spot[4] > spot[6] ) adj = 1;
      else if( spot[6] > spot[4] ) adj = -1;
   }
   
   if( adj == 0 ) return;

   if( rx_vfo > 11000000L ) adj = -adj;
   
   switch( split ){
     case 0: rx_vfo += adj; tx_vfo = rx_vfo; break;
     case 1: rx_vfo += adj;   break;
     case 2: tx_vfo += adj;   break;   // no sure how useful spotting tx is
   }
   update_frequency(NO_DISPLAY_UPDATE);   
}


int battery(int wrt_led){  /* show in select leds , limits are for 10 nimh cells*/
int bat;
int volts;
int val;
static int duty;
char buf[35];

   if( user[DISPLAY] == 0 ) battery_value = analogRead( BATTERYCHK );  // battery saver mode
   bat = battery_value * 10;   /* scaling up by 10 */
   volts = bat/62;
   volts += 7;          /* add in drop due to 1N4007 protection diode */
   
   if( volts > 150 ) val= SGRN+SYEL+SRED;   /* over voltage */
   else if( volts > 121 ) val= SGRN;
   else if( volts > 115 ) val= SYEL;
   else val= SRED;
   
   bat_low = ( volts < 115 ) ? 1 : 0;
   
   if( nokia == NORM_D || nokia == SPLIT_D || nokia == DECODE_D ){
       // don't need to write this every 8 ms 
       if( ++duty == 50 ){
         duty = 0;
         lcd_goto(5,66);
         if( volts < 100 ) lcd_putch(' ');
         if( volts < 10 )  lcd_putch('0');
         itoa(volts,buf,10);
         lcd_puts(buf);
         lcd_goto(5,78);
         lcd_write(0x80);                      // decimal point wedged in
         if( mode != WSPR ){                   // showing wspr timer on this position on nokia screen
            lcd_goto(4,66);
            if( volts < 115 )  lcd_puts("BAT");   // low battery warning
            else lcd_puts("   ");
         }
       }         
   }
   
   if(wrt_led) write_sleds( val );   
   return volts;      
}


int smeter(int wrt_led){   /* show s meter reading in the function leds */
int sig;         /* move signal led up, then all lit coming down for strong signals */
int val;
static int last_val;
int i,led;
char bar;
static int duty;
static int s_cal[12] = {71,72,73,74,76,80,88,104,136,168,222,348}; 

   /* we don't need to do this every 8ms */
   if( wrt_led ){
     if( (++duty & 7) != 7 ) return 0;
   }
   
   if( user[DISPLAY] == 0 ){
      smeter_value = analogRead( SIGNAL );   //battery saver mode 
      sig = smeter_value;
      for( val= 0; val < 12; ++val ){
        if( sig <= s_cal[val] ) break;
      }
   }
   else{
     val = smeter_value2;
     if( val > 12 ) --val;  // compress upper units a bit
     if( val > 9 ) --val;   // stick on these a bit 
     if( val > 7 ) --val;
     if( val > 5 ) --val;
     wrt_led = 0;            // kill led s meter when have display
   }
   
   if( wrt_led){
     led = 0;
     if( val >= 9 ) led = FGRN;
     else if( val >= 7 ) led = FYEL;
     else if( val >= 5 ) led = FRED;
   /* now strong signals add to the green led */
     if( val > 9 ) led |= FYEL;
     if( val > 10 ) led |= FRED;    
     write_fleds(led,0);
   }
       
   if( (nokia == NORM_D || nokia == SPLIT_D) && last_val != val){

      lcd_goto(3,0);
      lcd_putch('s');
      lcd_goto( 3,7 );   // row 3 col 7
      for( i = 1; i < 12; ++i ){
         if( i > val ) break;
         bar= ( i == 5  || i == 9 ) ? 0b01111100 : 0b01111000;
         if( i > 9 ) bar = 0b01111110;
         lcd_write(bar);  lcd_write(bar); lcd_write(0);
      }
      for( ; i < 13; ++ i ){
         lcd_write(0);  lcd_write(0);  lcd_write(0);
      }
      last_val = val;
   }

   return val;   /* for radio cat control */
}



/*   stage buffer to avoid serial.print blocking */

int un_stage(){    /* send a char on serial */
char c;

   if( stg_in == stg_out ) return 0;
   c = stg_buf[stg_out++];
   stg_out &= ( STQUESIZE - 1);
   Serial.write(c);
   return 1;
}


void stage( unsigned char c ){
  
  stg_buf[stg_in++] = c;
  stg_in &= ( STQUESIZE - 1 );
}

void stage_str( String st ){
int i;
char c;

  for( i = 0; i < st.length(); ++i ){
     c= st.charAt( i );
     stage(c);
  }    
}

void stage_num( int val ){   /* send number in ascii */
char buf[35];
char c;
int i;

   itoa( val, buf, 10 );
   i= 0;
   while( c = buf[i++] ) stage(c);  
}

void stage_long_str( long val ){
char buf[35];
char c;
int i;

   ltoa( val, buf, 10 );
   i= 0;
   while( c = buf[i++] ) stage(c);  
}

/************************************************************************/

      //  K3 emulation code
            
void get_freq(unsigned long vfo ){   /* report vfo */

    if( mode == CW && fun_selected[0] != WIDE ) vfo = vfo + (( sideband == USB ) ? mode_offset : - mode_offset);     
    stage_str("000");
    if( vfo < 10000000 ) stage('0');
    stage_num(vfo);  
}

void radio_control() {

static String command = "";
String lcommand;
char c;
int rit;
int sm;
int bat;  /* put battery voltage in front panel revision */

    if (Serial.available() == 0) return;
    
    while( Serial.available() ){
       c = Serial.read();
       command += c;
       if( c == ';' ) break;
    }
    
    if( c != ';' ) return;  /* command not complete yet */
  
    lcommand = command.substring(0,2);
 
    if( command.substring(2,3) == ";" || command.substring(2,4) == "$;" || command.substring(0,2) == "RV" ){      /* it is a get command */
      stage_str(lcommand);  /* echo the command */
      if( command.substring(2,3) == "$") stage('$');
      
      if (lcommand == "IF") {
/*
RSP format: IF[f]*****+yyyyrx*00tmvspbd1*; where the fields are defined as follows:
[f] Operating frequency, excluding any RIT/XIT offset (11 digits; see FA command format)
* represents a space (BLANK, or ASCII 0x20)
+ either "+" or "-" (sign of RIT/XIT offset)
yyyy RIT/XIT offset in Hz (range is -9999 to +9999 Hz when computer-controlled)
r 1 if RIT is on, 0 if off
x 1 if XIT is on, 0 if off
t 1 if the K3 is in transmit mode, 0 if receive
m operating mode (see MD command)
v receive-mode VFO selection, 0 for VFO A, 1 for VFO B
s 1 if scan is in progress, 0 otherwise
p 1 if the transceiver is in split mode, 0 otherwise
b Basic RSP format: always 0; K2 Extended RSP format (K22): 1 if present IF response
is due to a band change; 0 otherwise
d Basic RSP format: always 0; K3 Extended RSP format (K31): DATA sub-mode,
if applicable (0=DATA A, 1=AFSK A, 2= FSK D, 3=PSK D)
*/      
        get_freq(tx_vfo);
        stage_str("     ");
        rit= rit_offset;
        if( rit >= 0 ) stage_str("+0");
        else{
          stage_str("-0"); 
          rit = - rit;
        }
        if( rit < 100 ) stage('0');
        if( rit < 10 ) stage('0');    //IF[f]*****+yyyyrx*00tmvspbd1*;
        stage_num(rit);
        stage_str("10 0003");    /* rit,xit,xmit,cw mode */
        if( split == 2 ) stage_str("10");
        else stage_str("00");
        if( split ) stage('1');
        else stage('0');
        stage_str("001 ");      
      }
      else if(lcommand == "FA") get_freq( rx_vfo );
      else if(lcommand == "FB") get_freq( tx_vfo );
      else if(lcommand == "RT") stage('1');
      else if(lcommand == "FR") stage('0');
      else if(lcommand == "FT"){
         if( split ) stage('1');
         else stage('0');
      }
      else if( lcommand == "KS"){
        stage('0');
        stage_num(wpm);
      }
      else if(lcommand == "XF") stage_num(fun_selected[0]);
      else if(lcommand == "AG") stage_str("030");
      else if(lcommand == "RG") stage_str("250");
      else if(lcommand == "PC") stage_str("005");
      else if(lcommand == "FW") stage_str("0000") , stage_num(fun_selected[0]);
      else if(lcommand == "IS") stage_str("0000");
      else if(lcommand == "AN") stage('1');
      else if(lcommand == "GT") stage_str("004");
      else if(lcommand == "TQ") stage_num(transmitting);
      else if(lcommand == "PA" || lcommand == "XT" || lcommand == "NB" ) stage('0');
      else if(lcommand == "RA") stage_str("00");
      else if(lcommand == "OM") stage_str("-----F------");
      else if(lcommand == "LK") stage_num(user[LOCK]);
      else if(lcommand == "MD") stage('3');
      else if(lcommand == "RV" && command.substring(2,3) == "F"){  /* battery voltage in the revision field */
        stage(command.charAt(2));
        bat = battery(0);
        stage_num(bat/10);
        stage('.');
        stage_num(bat % 10);
        stage('0');
      }
      else if(lcommand == "RV" && command.substring(2,3) == "A"){  /* swap status in revision field */
        stage(command.charAt(2));
        if( split == 2 ) stage_str("SWAP ");
        else stage_str("    ");
      }
      else if(lcommand == "RV"){   // revisions
        stage(command.charAt(2));
        stage_str("     ");
      }
      else if(lcommand == "SM"){
        stage_str("00");
        sm = smeter(0);
        if( sm < 10 ) stage('0');
        stage_num(sm);
      }   
      else{
         stage('0');  /* don't know what it is */
      }
 
    stage(';');   /* response terminator */
    }
    
    else  set_k3(lcommand,command);    /* else it is a set command ? */
   
    command = "";   /* clear for next command */
}


void set_k3(String lcom, String com ){
String arg;
long val;
char buf[25];

 
    if( lcom == "FA" || lcom == "FB" ){    /* set vfo freq */
      arg = com.substring(2,13);
      arg.toCharArray(buf,25);
      val = atol(buf);
      if( mode == CW && fun_selected[0] != WIDE ) val = val - (( sideband == USB ) ? mode_offset : - mode_offset);     
      cat_band_change((unsigned long)val);
      if( lcom == "FB" || split == 0 ) tx_vfo = val;
      if( lcom == "FA" ) rx_vfo = val;
      update_frequency(DISPLAY_UPDATE);  /* listen on new freq */
    }
    else if( lcom == "KS" ){    /* keyer speed */
      arg= com.substring(2,5);
      arg.toCharArray(buf,25);
      val = atol(buf);
      wpm = val;
    }
    else if( lcom == "LK" ){     /* lock vfo's */
      val = com.charAt(2);
      if( val == '$' ) val = com.charAt(3);
      user[LOCK] = val - '0';
    }
    else if( lcom == "FW" ){     /* xtal filter select */
      val = com.charAt(6) - '0';
      if( val < 4 && val != 0 ){
        fun_selected[0] = val;
        set_band_width(val);
      }
    }
    else if( lcom == "FT" ){     /* enter split */
      val = com.charAt(2) - '0';
      if( val == 0 ){
        if( split == 2 ) rx_vfo = tx_vfo;
        else tx_vfo = rx_vfo;        
      }
      split = user[SPLIT] = val;
      user[SWAPVFO] = 0;        
    }
    else if( lcom == "FR" ){    /* cancel split ? */
      val = com.charAt(2);
      if( val == '0' ){
        if( split == 2 ) rx_vfo = tx_vfo;
        else tx_vfo = rx_vfo;
        split = user[SPLIT] = user[SWAPVFO] = 0;
      }
    }
    else if( com == "SWT11;" ){    /* A/B tap. swap (listen) vfo */
      if( split < 2 ){            /* turns on split if off */
        split = 2;
        user[SPLIT]= user[SWAPVFO] = 1;
      }
      else{                        /* back to listen on RX freq, stay in split */
       split = 1;
       user[SWAPVFO] = 0;
      }
      update_frequency(DISPLAY_UPDATE);  /* listen on selected vfo */
    } 
            
    write_sleds(sleds[fun_selected[function]]);
    write_fleds(fleds[function], 1);  /* update on/off status  on FGRN led */
    led_on_timer = 1000;            /* works different now with battery saver mode */
    
}
        /* end of K3 emulation functions */

/***********************************************************************/

      //   TenTec Argonaut V emulation


/* need to use a char array because a String object cannot hold binary data. 
  ( cannot store a zero as it is the string terminator */

#define CMDLEN 20
char command[CMDLEN];


void radio_control2() {
static int expect_len = 0;
static int len = 0;
static char cmd;

char c;
int done;

    if (Serial.available() == 0) return;
    
    done = 0;
    while( Serial.available() ){
       c = Serial.read();
       command[len] = c;
       if(++len >= CMDLEN ) len= 0;  /* something wrong */
       if( len == 1 ) cmd = c;  /* first char */
       /* sync ok ? */
       if( cmd == '?' || cmd == '*' || cmd == '#' );  /* ok */
       else{
          len= 0;
          return;
       }
       if( len == 2  && cmd == '*' ) expect_len = lookup_len(c);    /* for binary data on the link */       
       if( (expect_len == 0 &&  c == '\r') || (len == expect_len) ){
         done = 1;
         break;   
       }
    }
    
    if( done == 0 ) return;  /* command not complete yet */
        
    if( cmd == '?' )  get_cmd();
    if( cmd == '*' )  set_cmd();
    if( cmd == '#' )  pnd_cmd(); 

 /* prepare for next command */
   len = expect_len= 0;
   if( cmd != '?' ){
     stage('G');       /* they are all good commands */
     stage('\r');
   }
}

int lookup_len(char cmd2){     /* just need the length of the command */
int len;

   
   switch(cmd2){     /* get length of argument */
    case 'X': len = 0; break;
    case 'A':
    case 'B': len = 4; break;
    case 'E':
    case 'P':
    case 'M': len = 2; break;
    default:  len = 1; break ;
   }
   
   return len+3;     /* add in *A and cr on the end */
}

void set_cmd(){
char cmd2;
long arg;
char val1;
int  val2;
unsigned long val4;

   cmd2 = command[1];
   switch(cmd2){
    case 'X':   stage_str("RADIO START"); stage('\r'); break; 
    case 'O':   /* split */ 
       val1 = command[2];
     //  if( val1 && user[SPLIT] ) val1 = 0;      /* toggle from HRD instead of zero to shut off? */
       if( val1 ) split= user[SPLIT] = 1;
       else{
         if( split == 2 ) rx_vfo = tx_vfo;
         else tx_vfo = rx_vfo;
         split= user[SPLIT] = user[SWAPVFO] = 0;
       }
    break;
    case 'A':
    case 'B':
       val4 = get_long();
       if( mode == CW && fun_selected[0] != WIDE ) val4 = val4 - (( sideband == USB ) ? mode_offset : - mode_offset);            
       cat_band_change(val4);    // check for band change
       if( cmd2 == 'B' ) tx_vfo = val4;
       else{
           rx_vfo = val4;
           if( split == 0 ) tx_vfo = val4;
       }       
    break;
    case 'E':    /* vfo select - allow only if split */
       if( split && command[2] == 'V' ){
          if( command[3] == 'A' ) split = 1, user[SWAPVFO] = 0;
          if( command[3] == 'B' ) split = 2, user[SWAPVFO] = 1;
       }
    break;
    case 'W':    /* bandwidth */
       val1 = command[2];
       if( val1 < 12 ) fun_selected[0] = NARROW;   /* narrow */
       else if( val1 > 23 ) fun_selected[0] = WIDE;  /* wide */
       else fun_selected[0] = MEDIUM;
       set_band_width(fun_selected[0]);
    break;
    case 'K':            /* putting keying speed on the Noise Blanker slider. Range is 10 to 19 */
                         /* or could be easily doubled for a range of 10 to 28 - if so change the get cmd also*/
       wpm = command[2] + 10;
    break;
    case 'T':            /* added tuning rate as a command */
       set_tuning_rate(command[2]);
       fun_selected[1] = command[2];
    break;       
    
   }  /* end switch */

   update_frequency(DISPLAY_UPDATE);
   
   write_sleds(sleds[fun_selected[function]]);
   write_fleds(fleds[function], 1);  /* update on/off status  on FGRN led */
   led_on_timer = 1000;  
   
}

void get_cmd(){
char cmd2;
long arg;
int bat;
int len;

   cmd2 = command[1];
   stage(cmd2);
   switch(cmd2){
    case 'A':  arg= rx_vfo;
    case 'B': 
       if( cmd2 == 'B' ) arg= tx_vfo;
       if( mode == CW && fun_selected[0] != WIDE ) arg = arg + (( sideband == USB ) ? mode_offset : - mode_offset);           
       stage_long(arg);
    break;
    case 'V':           /* version */
       stage(' ');
       bat = battery(0);
       stage_num(bat/10);
       stage('.');
       stage_num(bat % 10);
       if( user[SWAPVFO] ) stage_str(" SWAP"); 
    break;
    case 'W':          /* receive bandwidth */
       stage(40 - fun_selected[0] * 10 );
    break;
    case 'M':          /* mode */
       stage('3'); stage('3');
    break;
    case 'O':          /* split */   
       if( split ) stage(1);
       else stage(0);
    break;
    case 'P':         /* display rit in passband slider */
       stage_int( rit_offset );
    break;
    case 'T':         /* added tuning rate command */
       stage( fun_selected[1] );
    break;   
    case 'E':         /* vfo mode */
       stage('V');
       if( split == 2 ) stage('B');
       else stage('A');
    break;
    case 'S':         /* signal strength */
       stage((smeter(0) * 2) / 3);
       stage(0);
    break;
    case 'C':
       stage(0);
       stage(transmitting);
    break;
    case 'K':   /* wpm on noise blanker slider */
       stage( wpm - 10 );
    break;   
    default:           /* send zeros for unimplemented commands */
       len= lookup_len(cmd2) - 3;
       while( len-- ) stage(0);  
    break;    
   }
  
   stage('\r');
}

void stage_long( long val ){
unsigned char c;
   
   c= val >> 24;
   stage(c);
   c= val >> 16;
   stage(c);
   c= val >> 8;
   stage(c);
   c= val;
   stage(c);
}


unsigned long get_long(){
union{
  unsigned long v;
  unsigned char ch[4];
}val;
int i;

  for( i = 0; i < 4; ++i) val.ch[i] = command[5-i]; // or i+2 for other endian

  return val.v;
}

void stage_int( int val ){
unsigned char c;
   c= val >> 8;
   stage(c);
   c= val;
   stage(c);
}


void pnd_cmd(){
   /* we put the keyer speed on the noise blanker slider */
   /* so shouldn't need to do the keyer command here */
   // these are commands from the perl interface 
char cmd2;
   
   cmd2 = command[1];
   switch(cmd2){
     case 'B':  user_action(BEACON,1);   break;
     case 'C':  
        if( mode == HELL )  detachCoreTimerService( feld_hell_core );
        mode= CW;
        loadbuffer();
     break;
     case 'H':
        if( mode != HELL )  attachCoreTimerService( feld_hell_core );
        mode= HELL;
        loadbuffer();
     break;     
   }

}

void loadbuffer(){     // part of the perl interface
char c;
int i;
  
  i = 2;
  while( c = command[i++]) {              /* load up the buffer */
    if( c == '\r' ) break;
    if( i == CMDLEN ) break;
    load_tx_queue( c | 0x80 );           /* the ms bit set transmits the char.  ms bit clear is the announce feature */       
  }
}


void wspr_to_freq(long fcalc){        // original freq set code does not do fractional freq increments
int flow,fhigh;                       // so this is somewhat duplicated for just wspr with its small freq shifts
static int flip;                      // will work for jt65 also 
int  select_bit;                      // made alternate registers as had ticking sound in transmissions

    if( transmitting == 0 ) flip = 1;  // start on register 1 as transmit function forces this for other modes
    else flip ^= 1;
    select_bit = ( flip ) ? AD9834_FREQ1_REGISTER_SELECT_BIT : AD9834_FREQ0_REGISTER_SELECT_BIT ; 
    flow = fcalc&0x3fff;           
    fhigh = (fcalc>>14)&0x3fff;
    digitalWrite(FSYNC_BIT, LOW);  
    clock_data_to_ad9834(flow  | select_bit );
    clock_data_to_ad9834(fhigh | select_bit ); 
    digitalWrite(FSYNC_BIT, HIGH);
  //  select the freq just loaded
    if( flip ) LATGSET = DDS_SEL;
    else LATGCLR = DDS_SEL;
}  

/*
The mfsk transmit process is:
  A character is removed from the auto_tx buffer and used as the index to the varicode table.  A varicode results.
  The varicode bits are merged in the correct position on the bottom of the current bit stream.
  Two bits from the top of the bit stream are sent to the forward error correction convolution code.  It returns 4 bits.
  The 4 bits are sent to the interleaver which consists of 10 cascaded 4x4 bit arrays.  It returns 4 bits.
  The 4 bits are "gray coded" into 1 of 16 tones to be transmitted. 
*/

#define MFSK_TICK 2560000     // 64 msec
uint32_t mfsk_core( uint32_t timer ){
  
// const int gray_tones[] = { 0, 84, 252, 168, 503, 587, 419, 336,  1007, 1090, 1258, 1174, 839, 923, 755, 671 }; 
// mfsk seems to be using a non-gray gray code that doesn't agree with the specification ( 3-4 day bug )
// hope this one is correct - difficult to tell as the decoders correct errors in the bit stream
const int gray_tones[] = { 0, 84, 252, 168, 587, 503, 336, 419,  1258, 1174, 1007, 1090, 671, 755, 923, 839 };  

static unsigned int bits;
static int bit_count;
int quadbits;
static long fbase;
int i;
unsigned int new_bits;
static int lchar;    // local copy of fchar
int mode_off;

  switch( mfsk_flag ){
   case 0:   break;      // nothing happening
   case 1:               // startup
      bits = 0;   bit_count = 32;
      mfsk_fec(-1);
      mfsk_interleave(-1);
      mfsk_flag = 2;
      lchar = 1;         // using lchar to defeat the idle shortcut for the startup time
      mode_off = ( sideband == USB ) ? mode_offset : -mode_offset;
      fbase = ( tx_vfo + mode_off ) * (268.435456e6 / Reference );   
   break;
   case 2:               // operating
     if( fflag && lchar == 0 && bit_count < 120 && bits == 0 ) bit_count = 3;  // shortcut the idle if we have something in the buffer
     if( bit_count < 4 ){        // we need more bits
        if( fflag ){
          lchar = fchar;
          fflag = 0;   // use the character available
        }
        else lchar = 0;          // else send a null

        if( lchar == 18 ) mfsk_flag = MFSK_STOP, lchar = '\r';
        new_bits = varicode2[lchar];
        i= 16;
        while( (new_bits & 0x8000) == 0) --i, new_bits <<= 1;
        new_bits >>= bit_count;   // align with bits
        bits |= new_bits;
        bit_count += i;
        if( lchar == 0 ) bit_count += 160;     // pad out the null with some zero's  
     }
   break;
   case 3:               // shutdown
     new_bits = 0x8000 >> bit_count;   // send a one to make the last code valid
     bits |= new_bits;
     mfsk_flag = 4;
     bit_count += 149;    // how many zero's needed to flush all in pipeline ?
   break;
   case 4:
     if( bit_count <= 0 ){
        transmit(OFF);
        mfsk_flag = 0;
     }  
   break;
  }
  
  if( mfsk_flag ){
     quadbits = get_quad( bits );
     bit_count -= 2;
     bits <<= 2;
     if( sideband == USB ) wspr_to_freq(fbase + gray_tones[quadbits] );
     else wspr_to_freq(fbase - gray_tones[quadbits] );
     if( MFSK_LOOPBACK ) mfsk_loopback(quadbits);
     if( transmitting == 0 ) transmit(ON);
  }
  
  return timer + MFSK_TICK ;
}

int get_quad( unsigned int bits ){
int b;
int quad;

   b = ( bits & 0x8000 ) ? 1 : 0;
   quad = mfsk_fec( b );
   quad <<= 2;
   b = ( bits & 0x4000 ) ? 1 : 0;
   quad = quad | mfsk_fec( b );
   quad = mfsk_interleave(quad);
   return quad;
}


void mfsk_loopback( int val ){   // debug function only - loopback and add random errors to the bit stream
//const int gray_tones[] = { 0, 84, 252, 168, 587, 503, 336, 419,  1258, 1174, 1007, 1090, 671, 755, 923, 839 };  
const int gray_code[] = { 0, 1, 3, 2, 7, 6, 4, 5,  15, 14, 12, 13, 8, 9, 11, 10 }; 
int code;

   code = gray_code[val];
   if( MFSK_LOOPBACK > 1 ){    // add random 4 bit errors as if the tone was not received correctly 
      if( MFSK_LOOPBACK > random(100) ){
         code = random(16);
         if( code > 15 ) code = 15; 
      }
   }
   
   w_max = 27 - code; 
}

//   4096/11025 * 40000000
#define JT65TICK  14860771      

uint32_t  jt65_core( uint32_t timer ){
static long my_base;
static long his_base;
long delta;


   if( (jt_tx_on == 0 || jt_tx_index > 125) && transmitting ){    // abort received or done
      transmit(OFF);
      update_frequency(NO_DISPLAY_UPDATE);
      jt_tx_on = 0;     
   }
   if( jt_tx_on == 0 )  return timer + JT65TICK;                  // not transmitting
  
   // jt_tx is on
   if( transmitting == 0 ){                                       // just starting up
      my_base = ( tx_vfo + mode_offset ) * (268.435456e6 / Reference );              
      his_base = 14077270 * (268.435456e6 / 49999750 );           // using the fake reference reported
   }
 
   delta = jt_buf[jt_tx_index] - his_base;                         // load the dds before key down
   if( delta > -9000 && delta < 9000 ) wspr_to_freq( my_base + delta );
      
   if( transmitting == 0 ) {
     transmit( ON );
     // LATFCLR = TXENABLE; // debug don't really turn on the transmitter but fool the program in thinking it is
   }
      
   ++jt_tx_index;
   return timer + JT65TICK; 
}

// mode_offset is zero for wspr and jt65 but putting it into the freq calc in case that gets changed

/*   WSPR  core timer function */
// #define WSPRTICK 27307472     // 1 bit time for 1.4648 baud. was a typo here?  seems to work ok
// #define WSPRTICK 27307482     // 1 bit time for 1.4648 baud.  
#define WSPRTICK 27306667        // or should it be 1.46484375 baud.  120000/8192

uint32_t  wspr_core( uint32_t timer ){
static int count;
long dds_freq_base;

  if( wspr_tx_enable == 0 )   return timer + WSPRTICK;   // nothing to do

  if( count == 162 ) {   // stop the transmitter
     transmit(OFF);
     wspr_tx_enable= 0;
     count = 0;
     update_frequency(NO_DISPLAY_UPDATE);
     return timer + WSPRTICK;
  }
    
    // load the correct freq1 word.  It was found that a delta of 8 in the dds word changes freq close to 1.4648
  dds_freq_base = ( tx_vfo + mode_offset ) * (268.435456e6 / Reference );    
  wspr_to_freq( dds_freq_base + 8L * (long)wspr_msg[count] );

  if( count == 0 ) transmit(ON);
  ++count;
   
  return timer + WSPRTICK;    
}


/* FELD HELL core timer function */
/* FELD HELL sending works with the Argonaut emulation using the perl program  */
/*  It also now works with the dumb terminal sending mode */
#define HELLTICK 163265

uint32_t  feld_hell_core( uint32_t timer ){    /* core timer function */

static int row = 0;
static int col = 1;
static int state = 0;
static struct HELFONT hc;

  if( mode != HELL ) return timer + HELLTICK;
  
  switch ( state ){
     case 0:         /* idle a complete column, also idling during receive */
       col <<= 1;
       if( col == ( 1 << 14 ) ){
          row= 0, col = 1;
          if( hflag ){            /* check for next char during the last bit time in the column */
             if( hchar < ' ' || hchar > 'Z' ) hc = heltab[0];     /* no good so "tx" a space */
             else hc = heltab[hchar - ' '];                       /* look up hchar in font table */
             state = 1;
             hflag= 0;
          }
       }
     break;
     
     case 1:         /* tx bit at row and column */
       if( hc.font[row] & col ) transmit(ON) ;  /* tx on */
       else{ transmit(OFF);                      /* tx off */
               //      LATGCLR = DDS_SEL;  /* !!!! temp debug back to rx vfo */
       }
       col <<= 1;
       if( col == ( 1 << 14 )) col= 1,  ++row;
       if( row > 4 ) col = 1, state = 2;
     break;
   
     case 2:      /* idle a complete column */
       col <<= 1;
       if( col == ( 1 << 14 )) col= 1,  state = 0;
     break;
  } 
  
 
  return timer + HELLTICK;    /* around 4 ms for 122.5 baud at two time slices per baud ( 245 baud ) */
}


/*******************************************************************/


void cat_band_change( unsigned long val ){    /* detect if we have a large qsy */
int i;

    if( bandswitch_enable == 0 || band_switch == JUMPERS ) return;
    
    for( i= 0; i < 4; ++i ){
        if( check_band(val) ) break;
        user_action(BAND,0);  /* switch to a different band and see if ok */ 
    }
}

int check_band( unsigned long val ){
int ok;
 
    ok= 0;
    if( band_switch == FOUR_BAND ){
       switch ( band ){
         case 0:  if( val < 9000000 ) ok= 1; break; 
         case 1:  if( val >= 9000000 && val < 12000000) ok= 1; break;
         case 2:  if( val >= 12000000 && val < 16000000) ok= 1; break;
         case 3:  if( val >= 16000000 ) ok= 1; break;
       }
    }
    if( band_switch == TWO_BAND ){
       if( band == 0 && val < 9000000 ) ok= 1;
       if( band == 2 && val >= 9000000 ) ok= 1;  
    }
    return ok;
}


void power_out(){   /* hardware mod - resistor divider is now about 10 to 1 instead of 2 to 1 */
                    /* 5 watts is about 22 peak rf volts, divided by 10 is 2.2 volts which is in range of the A/D converter */
                    /* this hardware mod has been removed.  At full power the voltage is > 3.3 volts so the A/D saturates */
                    /* this mod did not work well due to the very small cap coupling to the divider */
int val;
int pmap[11] = {0,217,310,372,434,496,536,589,620,657,691};
int i,bar;
static int peak_pwr;   // for power warn avoid false low during key up times

   led_on_timer = 600;
   if( user[DISPLAY] == 0 ) power_value = analogRead(POWEROUT);  // battery saver mode

   if( power_value > peak_pwr ) peak_pwr = power_value;
   else --peak_pwr;
   
   val= 0;
   if( power_value > pmap[2] ) val = FRED;   // 1 watt
   if( power_value > pmap[6] ) val = FYEL;   // 3 watts
   if( power_value > pmap[8] ) val = FGRN;   // 4 watts or better
   write_fleds( val, 0 ); 

   if( nokia == NORM_D || nokia == SPLIT_D ){

      lcd_goto(3,0);
      lcd_putch('T');
      lcd_goto( 3,7 );   // row 3 col 7
      if( PWR_WARN && transmitting ){    // check power out vs mode
        if( mode <= HELL && peak_pwr < 620 ){
          lcd_puts("LOW    ");
          return;
        }
        if( mode > HELL && peak_pwr >= 620 ){
          lcd_puts("HIGH   ");
          return;
        }
      }
      for( i = 1; i < 11; ++i ){      // else all ok and we display the bars
         if( power_value < pmap[i]  ) break;
         bar= ( i & 1 ) ?  0b01110000 : 0b01111100;
         lcd_write(bar);  lcd_write(bar); lcd_write(0);
      }
      for( ; i < 13; ++ i ){
         lcd_write(0);  lcd_write(0);  lcd_write(0);
      }
   }
}

// AM modulation. core timer function running at 4000 hz rate producing 2000 hz pwm
// have a delay of 10000 divided into on and off times
// target power from mod_up and mod_dn routines, actual from analog read of power out
// interesting idea so code has been left here.  The replacement routine below is easier 
// to adjust.
/* 
uint32_t psk_mod_core( uint32_t timer ){
static int duty;
static int on_off;
int error;

   if( transmitting == 0 ){
     LATFCLR = PSK_MOD;
     return timer + 100000;    // wait a couple ms
   }
     
   if( on_off ){    // start of on time
     error = 2 * (psk_mod_pwr - power_value ) - psk_pwr_offset;   // ?30?  what value is lost in the power out sensing diodes?
     duty += error;                                               //       adjust this offset for best IMD
     if( duty < psk_min_duty ) duty = psk_min_duty;               // adust min duty may help with IMD
     if( duty > 9500) duty = 9500;   // max 19/20
     on_off ^= 1;
     LATFSET = PSK_MOD;
     return timer + duty;
   }
   else{            // start of off time
     on_off ^= 1;
     LATFCLR = PSK_MOD;
     return timer + 10000 - duty;
   }
}

*/

// AM modulation. core timer function running at 4000 hz rate producing 2000 hz pwm
// have a delay of 10000 divided into on and off times
// target power from mod_up and mod_dn routines
// assumes modulation is linear with pwm duty cycle


uint32_t psk_mod_core( uint32_t timer ){
static int duty;
static int on_off;

   if( transmitting == 0 ){
     LATFCLR = PSK_MOD;
     return timer + 100000;    // wait a couple ms
   }
     
   if( on_off ){    // start of on time
     duty = psk_mod_pwr + psk_min_duty;    //  adjust min duty for best IMD
     if( band == 3 ) duty = ( psk_mod_pwr >> 1 ) + ( psk_mod_pwr >> 2 ) + psk_min_duty + 1500;   
     on_off ^= 1;                                                       // more drive offset, less drive for 17 meters
     LATFSET = PSK_MOD;
     return timer + duty;
   }
   else{            // start of off time
     on_off ^= 1;
     LATFCLR = PSK_MOD;
     return timer + 10000 - duty;
   }
}



/*  core timer function for fft processing */
/*  calculate the value to return as period in us * 40 */
/*  freq 6400 is period 156.25 us */
/*  for psk31 and rtty the freq is 4000 */
uint32_t dsp_core( uint32_t timer ){
static int counter;
static long w0,w1,w2;
static int dcnt;
long sample;

   if( transmitting == 0 && tdown == 0 && timeout_ok == 0){
      sample = analogRead(CODEREAD_PIN);
      
      /* butterworth iir highpass filter to remove dc component 
       w0 = a0*sample_in + a1*w1 + a2*w2
       sample_out = w0 + b2*w2 + b1*w1
       w1 --> w2,  w0 --> w1
       constants are 1.148988, 1.7323776, -0.757547, -2.0, 1.0  in q12 format
       */
    //ch1 = sample;    // debug - input to filter 
       w0 = 2*4706L * sample + 7060L * w1 - 3103L * w2;    // gain of 2
       sample = w0 + 4096L * w2 - 8192L * w1;
       w0 >>= 12;
       sample >>= 12;
       w2 = w1;  w1 = w0;       
       // sample -= 512;// or just skip the filter but what is the fun in that?

       if( mode == MFSK && fun_selected[0] == NARROW && ( user[CODEREAD] || serial_decode )){   // only decode when in narrow bandwidth mode
          sample = remix(sample);
          dcnt++;
          dcnt &= 3;
          if( dcnt == 0 ){                  // change rate to 1000 hz
             samples[s_in++] = sample;
             s_in &= 7;
             rty_in = s_in;  
          }
          fast_plot = 1;       // with the slow sample rate we need to return to the fast plotting of dft results
          goalpost = 27;      // resampled to 1000 hz and sideband swapped - what was at 878 hz is now at 422 hz 
       }
       else{                             // store all the samples
          samples[s_in++] = sample;
          s_in &= 7;
          fast_plot = 0;
          if( mode == MFSK ) goalpost = 14;
       }
       
       if( ( mode == RTTY || mode == PSK31 ) && ( user[CODEREAD] || serial_decode ) ){   // run the rtty decoder in a less time sensitive code stream
           rty_in = s_in;                      // use the same buffer as the fft samples
       }       
   }
   else if( transmitting && mode == PSK31 )  psk_fcore();
  // else if( transmitting && mode == WSPR ) LATFINV = PSK_MOD; // 50 percent low power for wspr
   

   ++counter;
   switch( counter & 0x1f ){
      case 0:  rit_value = analogRead( RIT_PIN ); break;
      case 8:  power_value = analogRead( POWEROUT ); break;
      case 16: battery_value = analogRead( BATTERYCHK ); break;
     // case 24: smeter_value = analogRead( SIGNAL ); break;
   }

   jt_time = 4;      // get or send 4 * 6400 characters per second on serial line
   
   /* software scope - timebase will be a little off when running at 4000 samples per second */
   if( scope_active == 1 || scope_active == 2 ) scope();
   
   if( mode == RTTY || mode == PSK31 || mode == MFSK ) return timer + 10000;  // sample rate is 4000 for 62.5 hz per dft bucket - hopefully above highpass filter will be ok
   else return timer + 6250;                 // sample rate is 6400 for 100 hz per dft bucket
}

//  filter and mix signal to 300 hz.  when we resample to 1000 hz rate --> gives 15.625 hz dft buckets for the mfsk decoder
long remix(long sample){
static long vfo;
const long pvfo = 8364;    // 1300/4000 * 2pi in q12.  vfo at 1300 to mix 1000hz to 300 hz

 
    // first - bandpass filter  - same as the rtty bandpass filter
    sample = rtty_bandpass(sample);

    // 2nd - mix to 300 hz - same as the 2nd psk modem ( this will also swap sidebands )
    vfo = vfo + pvfo + ( mfsk_afc >> 5 );
    if( vfo >= 2*pi ) vfo -= 2*pi;
    
    sample = sample * tsin(vfo);  // mix with local osc at 1300 hz 
    sample >>= 14;     

    // 3rd lowpass filter at the new audio IF
    sample = mfsk_lowpass(sample);
 
   return sample; 
}

// 430 hz cutoff
long mfsk_lowpass(long val ){
const long ck[] =     
  { -13, -415, -620, -439, 94, 699, 973, 629, -279, -1305, -1767, -1082, 896, 3726, 6497, 8207 };   // q15 constants
static long w[32];     // delay line
static int in;         // circular index
int i,j,k;

   w[in] = val;    
   j = in;             // forward index
   k = in - 1;         // reverse index
   if( k < 0 ) k = 31;
   ++in;
   in &= 31;
   val = 0;            // sum
   
   for( i = 0; i < 16; ++i ){
     val += ( ck[i] * ( w[j++] + w[k--] ) );     // constants are symmetrical
     j &= 31;
     if( k < 0 ) k = 31;    
   }
   
   val >>= 15;
   return val;
}



// psk sending - not a core function but called from core function dsp_core at 4000 times per second
void psk_fcore(){        // fake core function
static int counter;      // each psk bit will taks 128 interrupts to complete
static int state;        // the job we are working on
static int zeros;        // zero counter - need at least two between characters
static unsigned int reg;          // our copy of 1's and zero's
static unsigned int last_bit;     // flags for when we are AM modulating the tx ( if zero then needs mod )
static unsigned int next_bit;
                  

   // if( psk_dn_count ) return;    // in process of turning off
   ++counter;
   if( counter == 64 ){          // the software phase reversal
      last_bit = reg & 0x8000;  // look behind, when zero bring power up 65 to 127
      reg <<= 1;     
      reg &= 0xffff;
      next_bit = reg & 0x8000;  // look ahead, when zero drop power down 1 to 63
   }

   if( psk_dn_count ) last_bit = next_bit = 0x8000;  // sending postable of 1's
   
   if( counter == ( psk_mod_delay + 64 ) && last_bit == 0 ) LATGINV = PSEL; // the delayed hardware phase reversal 
   
   psk_mod_up( last_bit, counter );   // pulse width mod the FET bias 
   psk_mod_dn( next_bit, counter );
   
   if( counter == 128 ){
      counter = 0;
      
      switch( state ){
       case 0:          // looking for a character to send
         if( pflag ){
            if( pchar == 18 ){    // control R found in character stream, return to receive
              psk_dn_count = 1;      // start the postamble of steady carrier
              pflag = 0;
              return;
            }
            pchar *= 2;  // two chars int the table per character
            reg = varicode[pchar++] << 8;
            reg |= varicode[pchar];
            reg &= 0xffff;           // make anything larger than 16 bit int all zero
            pflag = 0;               // flag we are ready for another char
            state = 1;
            next_bit = reg & 0x8000;
         }
         else state = 2, zeros = 0;  // else idle
       break;
      
       case 1:          // sending some bits until empty of 1's
         if( reg == 0 ) state = 2, zeros = 0;
       break;
      
       case 2:          // inserting two zero's in the bit stream
         if( ++zeros == 2 ) state = 0;
       break;         
      }     
   }  
}

void psk_mod_up( int dat, int count ){   // active counts 65 - 127
                                         // power up after a phase reversal
static int done;
int tval;

  if( count < 65 ) return;  
  
  if( count == 65 ) done = ( dat ) ? 1 : 0;

  tval = psk_sin_cos(count - 64, 0);  
  if( tval == 4096 ) done = 1;
  if( done ) tval = 4096;       // stick at full power when we get there in the table
   
  tval <<= 1;           // scale 0 to 4096 to 0 to 8192 which will become the pwm duty cycle count out of 10000 counts
  psk_mod_pwr = tval;    
}


void psk_mod_dn( int dat, int count ){   // active counts 1 - 63
                                         // power down as phase reversal coming up
static int done;
int tval;

  if( count > 63 || count == 0 ) return;
  if( count == 1 ) done = (dat) ? 1 : 0;

  tval = psk_sin_cos( count, 16 );     // cosine starts at 16 offset in the table
  if( tval == 0 ) done = 1;
  if( done ) tval = (dat) ? 4096 : 0;
 
  tval <<= 1;
  psk_mod_pwr = tval;
  
}


// look up in the sin_cos table with interpolation 
int psk_sin_cos( int index, int offset ){
  
int i, rem, val;

   i = index >> 2;
   rem = index - ( 4 * i );
   switch( rem ){
     case 0:  val = 4 * sin_cos[i + offset ];  break;   // 4 parts of just one value in table
     case 1:  val = 3 * sin_cos[i + offset ] + sin_cos[i + offset + 1]; break;
     case 2:  val = 2 * sin_cos[i + offset ] + 2 * sin_cos[i + offset + 1]; break;
     case 3:  val = sin_cos[i + offset ] + 3 * sin_cos[i + offset + 1]; break;
   }
   val >>= 2;   // divide by 4
   return val;
}


void setup() 
{

    pinMode (TX_OUT,                OUTPUT);
    digitalWrite(TX_OUT,            LOW);       // turn off TX


  // these pins are for the AD9834 control
    pinMode(SCLK_BIT,               OUTPUT);    // clock
    pinMode(FSYNC_BIT,              OUTPUT);    // fsync
    pinMode(SDATA_BIT,              OUTPUT);    // data
    pinMode(RESET_BIT,              OUTPUT);    // reset
    pinMode(FREQ_REGISTER_BIT,      OUTPUT);    // freq register select
    pinMode(PSEL_PIN,               OUTPUT);    // seems to have been left out

    //---------------  Encoder ------------------------------------
    pinMode (encoder0PinA,          INPUT);     // using optical for now
    pinMode (encoder0PinB,          INPUT);     // using optical for now 

    //--------------------------------------------------------------
    pinMode (TX_Dit,                INPUT);     // Dit Key line 
    pinMode (TX_Dah,                INPUT);     // Dah Key line
    pinMode (Band_End_Flash_led,    OUTPUT);
    
    //-------------------------------------------------------------
    pinMode (Multi_function_Green,  OUTPUT);    // Band width
    pinMode (Multi_function_Yellow, OUTPUT);    // Step size
    pinMode (Multi_function_Red,    OUTPUT);    // Other
    pinMode (Multi_Function_Button, INPUT);     // Choose from Band width, Step size, Other

    //--------------------------------------------------------------
    pinMode (Select_Green,          OUTPUT);    //  BW wide, 100 hz step, other1
    pinMode (Select_Yellow,         OUTPUT);    //  BW medium, 1 khz step, other2
    pinMode (Select_Red,            OUTPUT);    //  BW narrow, 10 khz step, other3
    pinMode (Select_Button,         INPUT);     //  Selection form the above

    pinMode (Medium_A8,             OUTPUT);    // Hardware control of I.F. filter Bandwidth
    pinMode (Narrow_A9,             OUTPUT);    // Hardware control of I.F. filter Bandwidth
    
    pinMode (Side_Tone,             OUTPUT);    // sidetone enable

    //---------------------------------------------------------------
    pinMode (Band_Select,           INPUT);     //  band select will be changed to output as needed
    pinMode (Band_Select2,          OUTPUT);    //  band select
    pinMode (PSK_MOD_PIN,           INPUT);     //  pin 4 in non active state

    //--------------------------------------------------------------

   digitalWrite(Side_Tone, LOW);     
   digitalWrite(SCLK_BIT, HIGH);     
   digitalWrite(FSYNC_BIT, HIGH);  
   digitalWrite(SDATA_BIT, HIGH);
//   digitalWrite(PSK_MOD_PIN,HIGH);
   
   AD9834_reset();                        
   AD9834_init();
   AD9834_reset();           //??         // low to high
   Band_Set_40_20M();        //  test for band switch board or jumper on for 40 meters
   digitalWrite ( FREQ_REGISTER_BIT, LOW);  /* receive mode on power up */ 
   digitalWrite ( PSEL_PIN, LOW);  /* pin was left unitialized */ 
   
   straightkey= readpaddle();
   
   en_dir= 0;
   en_lval= read_encoder();

   LCD.InitLCD(contrast);

   set_tuning_rate( fun_selected[1]);  // needs to be before menu or encoder doesn't work

   top_menu(0);

/* implement the defaults */
   set_band_width( fun_selected[0]);
   update_frequency(DISPLAY_UPDATE);   
   
}  // end setup


/*****************   MENU's *******************************/
struct MENU {
  const int no_sel;                 // number of selections
  const char title[15];             // top line - 14 char max in title
  const char choice[8][9];          // selections to display - max 8 selections - max text length is 8
};


struct MENU display_menu = {
   2,
   "Display",
   { "None", "Nokia" }
}; 

struct MENU mode_menu = {
   8,
   "Select Mode",
   { "CW", "Hell", "PSK31", "RTTY", "MFSK16", "WSPR", "JT65", "Mem Tune" }          
};

struct MENU time_menu = {
   4,
   "Set Seconds",
   { "0 Even", "30", "60 Odd", "90" }
};

struct MENU wspr_duty_menu = {
   5,
   "WSPR TxPercent",
   { "0", "5", "10", "15", "20" }
};

struct MENU crh_tx_menu = {
   3,
   "TX Method",
   { "Key Jack", "Terminal", "Perl GUI" }        // hardware interface to computer or running a terminal program
};

struct MENU cat_menu = {
   3,
   "CAT Emulation",
   {"None", "TenTec", "Elecraft" }
};

struct MENU serial_decode_menu = {   
   2,                                // if using CAT control alot one may want to set this to no
   "Serial Decode",                  // as extra text on the serial line may confuse HRD or whatever program is used for CAT
   {"No", "Yes" }                    // if using rtty terminal mode, this is forced to yes and CAT forced to no
};

struct MENU license_menu = {        // Tx lockout by license class.  General coverage receive
   5,
   "Band Limits",
   { "Extra" , "Advanced" , "General", "Novice", "Europe" }
};

struct MENU band_switch_menu = {
   3,
   "Band Switching",
   { "Jumpers", "Two Band", "FourBand" }
};
   

struct MENU rtty_on_leds_menu = {
   2,
   "RTTY on LED's",
   { "No" , "Yes" }
};

struct MENU cw_tone_menu = {
   5,
   "CW Pitch Freq",
   { "600", "700", "800", "900", "1000" }
};

// menu's for tweaking the psk modulator
struct MENU psk_min_duty_menu = {
   5,
   "PSK Min Duty",
   { "200","400","600","800","1000" }
};
struct MENU psk_mod_delay_menu = {
   5,
   "PSK Mod Delay",
   { "0", "2", "4", "6", "8" }
};
struct MENU sideband_mode_menu = {
   2,
   "Sideband Mode",
   { "Normal", "USB only" } 
};
             
struct MENU soft_scope_menu = {
   6,
   "Scope Timebase",
   { "12.5 ms", "25 ms", "50 ms", "100 ms", "200 ms", "400 ms" }
};
 
   
void top_menu( int warm_boot ){
  
int i;

   if( nokia ) detachCoreTimerService( dsp_core );
   if( mode == HELL ) detachCoreTimerService( feld_hell_core );
   if( mode == WSPR ) detachCoreTimerService( wspr_core );
   if( mode == JT65 ) detachCoreTimerService( jt65_core );
   if( mode == PSK31 ) detachCoreTimerService( psk_mod_core );
   if( mode == MFSK ) detachCoreTimerService( mfsk_core );

   Serial.end();
   if( transmitting ) rtty_down();             // stop tx
   pinMode (PSK_MOD_PIN,           INPUT);     //  pin 4 in non active state

   if( mem_tune ) mode = MEM_TUNE, mem_tune = 0;
   if( mode <= MFSK ) save_restore(SAVE); 
   
   user[CODEREAD]= 0;    // why this - prevent screen writes during the menu?
   top_active = 1;     // changes what encoder routine does
 
   // open up the serial port for the serial menu's
   if( SERIAL_MENUS ) Serial.begin(1200);          // whatever baud you want.  I use 1200 as it is the ARGO baud rate

   // cold start should default to no Display if ever want to use radio in the field without a display
   // select action changes user[DISPLAY] when button is pressed - unwanted side effect but we will use that to advantage
   user[DISPLAY] ^= warm_boot;     // restore previous and determine if 1st startup
   nokia = user[DISPLAY] = top_menu2( user[DISPLAY], &display_menu );
   if( nokia == 0 ) mode = CW, sideband_mode = NORMAL;
  
   
  // if we have a display then show the other menu's
   if( user[DISPLAY] || SERIAL_MENUS ){

    if( SOFTSCOPE ){
       timeb = top_menu2( timeb, &soft_scope_menu );
       timebase= 1;    i = timeb;
       while( i-- ) timebase *= 2; 
    }
     
     crh_tx_method = top_menu2( crh_tx_method, &crh_tx_menu );  // what comes up in the menu's depends upon what one picks
                                                                // as some settings conflct with the hardware
                                                                // for example the terminal send modes and CAT_EMU 
     // mode menu  -  if using the Perl GUI the mode is picked with that application
     if( crh_tx_method != CRH_TX_PERL ) mode = top_menu2(mode, &mode_menu);   
  
     // set the suggested sideband mode based upon the operating mode, then let user override that if desired
     sideband_mode = ( mode >= RTTY ) ? USB_ONLY : NORMAL;
     if( mode < WSPR ) sideband_mode = top_menu2(sideband_mode, &sideband_mode_menu);
     
     if( mode == HELL ){
        attachCoreTimerService( feld_hell_core );
        goalpost = 10;
        mode_offset = 1000;
     }  
     
     // Even if no display allow the terminal mode to use all the dsp functions
     // Can use spot function to tune in the signal and observe decoded text on the terminal program
     // tuning will be blind - only thing left is long press of the function button to announce the freq
     if( crh_tx_method == CRH_TX_TERM ) user[DISPLAY] = nokia = 1;
     if( user[DISPLAY] ) attachCoreTimerService( dsp_core );
   //  goalpost = 9;   

     if( mode == RTTY ){
        rtty_on_leds = top_menu2( rtty_on_leds, &rtty_on_leds_menu );
        goalpost = 16;   /* move tuning markers for rtty */
        mode_offset = 1000;
     } 
     if( mode == PSK31 ){
       psk_min_du = top_menu2( psk_min_du, &psk_min_duty_menu );  
       psk_min_duty = 200 * psk_min_du + 200;                     
       psk_mod_delay = 2 * (top_menu2( psk_mod_delay/2, &psk_mod_delay_menu ));
       
       goalpost = 16; 
       mode_offset = 1000;
     }  
     if( mode == CW ){
       cw_offset_tone = top_menu2( cw_offset_tone, &cw_tone_menu );   // returns a number 0 to 4
       mode_offset = 600 + 100 * cw_offset_tone;
       goalpost = 6 + cw_offset_tone;
     }
     if( mode == MFSK ){
       mode_offset = 878;
       goalpost = 14;
       attachCoreTimerService( mfsk_core );       
     }
       

     // cat emu menu
     if( crh_tx_method == CRH_TX_PERL ) cat_emu = ARGO_EMU;      // if using the perl gui then need to force TenTec emulation
     else if( crh_tx_method == CRH_TX_TERM || mode == JT65) cat_emu = NO_EMU;   // dumb terminal program on serial port, so no CAT emulation
     else  cat_emu = top_menu2( cat_emu, &cat_menu );   
                    
     // band limits menu
     band_limits = top_menu2( band_limits, &license_menu );

     // band switch module installed ?
     band_switch = top_menu2( band_switch, &band_switch_menu );
  
     // serial decode on or off menu
     //    serial decode when on will send the decoded text to the computer for a hyperterm session
     //    so you can see the decoded text on a larger screen
     //    force on if using a dumb terminal program
     //    this may interfer with Cat emulation but am allowing the choice
     if( crh_tx_method == CRH_TX_TERM ) serial_decode = 1;
     else if( crh_tx_method == CRH_TX_PERL || mode == JT65 ) serial_decode = 0;  // perl gui and JT uses the serial port
     else serial_decode = top_menu2( serial_decode, &serial_decode_menu );          
     
     if( mode == WSPR ){                          // sync up the seconds.  Press button when at chosen time in 2 minute interval
        // randomSeed( 20 ); 
        wspr_duty = top_menu2( wspr_duty, &wspr_duty_menu );
        sec = 30 * top_menu2( 2, &time_menu );    // for even minutes use values less than 60
        msec = 0;                                 // the 20 second menu timeout may interfer with setting the seconds counter
        oldtime = millis();                       //    so timeout changed to 35 seconds in top_menu2()
        
        // set up the splits to receive usb on 7 and 10 meters
        for( i= 0; i < 4; ++i ) save_split[i] = 1;
        split = 1;
        user[SPLIT] = 1;
        user[LOCK] = 1;
        save_tx_vfo[0] =  7040100L + WSPR_TX_OFFSET;
        save_tx_vfo[1] = 10140200L + WSPR_TX_OFFSET;
        save_tx_vfo[2] = 14097100L + WSPR_TX_OFFSET;
        save_tx_vfo[3] = 18106100L + WSPR_TX_OFFSET;
        save_rx_vfo[0] = 7038600L; 
        save_rx_vfo[1] = 10138700L;       //     dds freq is about 2 mhz for 40 meters and about 1.1 mhz for 30 meters
        save_rx_vfo[2] = 14095600L;
        save_rx_vfo[3] = 18104600L;
        tx_vfo = save_tx_vfo[band];
        rx_vfo = save_rx_vfo[band];
        goalpost = 15;     // centered on 1500 hz
        mode_offset = 0;   // using split for the offset
        attachCoreTimerService( wspr_core );
     }
     
     if( mode == JT65 ){      // set up split, ignore tuning info from host program HFWST
        for( i= 0; i < 4; ++i ) save_split[i] = 1;
        split = 1;
        user[SPLIT] = 1;
        user[LOCK] = 1; 
        save_tx_vfo[3] = 18103270L;   
        save_rx_vfo[3] = 18102000L;            
        save_tx_vfo[2] = 14077270L; 
        save_rx_vfo[2] = 14076000L;            // these are the common starting vfo readings.  JT65 tunes split in lock step
        save_tx_vfo[1] = 10139270L;            // so you can unlock the vfo and tune around when the band is busy and
        save_rx_vfo[1] = 10138000L;            // the signals spread out.
        save_tx_vfo[0] = 7077270L;     
        save_rx_vfo[0] = 7076000L;     
        goalpost = 13;
        mode_offset = 0;
        tx_vfo = save_tx_vfo[band];
        rx_vfo = save_rx_vfo[band];
        fun_selected[0] = WIDE;  // BW wide
        jt_fcalc0 = (long)( (save_rx_vfo[2] - bfo )* (268.435456e6 / Reference ));  // report 20 meters
        stage_str("1,W6CQZ_FW_1000;\r\n");  // Sends a 1 time signon message at firmware startup      
        attachCoreTimerService( jt65_core );
     }
     
     if( mode == MEM_TUNE ) user[LOCK] = 1,  mem_tune = 2; // 2 forces inititalization of memory tuning 
                                                         
   }  // end of if we have a display menu's
   
   
   
 /*end of menus */
   if( SERIAL_MENUS ) Serial.end();
   LCD.clrScr();
   LCD.print("Radio Active",0,0);
   top_active= 0;  
   if( serial_decode && cat_emu == NO_EMU ) Serial.begin(1200); // use whatever baud you wish for the dumb term 
   if( cat_emu == K3_EMU ) Serial.begin(38400);
   if( cat_emu == ARGO_EMU ) Serial.begin(1200);         // a TenTec ARGO V is 1200 baud
   if( mode == JT65 ) Serial.begin( 115200 );
   if( mode <= MFSK )  save_restore(RESTORE);      

   set_band_width( fun_selected[0]);
   
   if( sideband_mode == USB_ONLY ) sideband = USB;
   else sideband = ( band < 2 ) ? LSB : USB;
   sliding_offset = 0;    // RIT normal again
   
   if( mode == PSK31 ){
     digitalWrite(FSYNC_BIT, LOW);  //
     clock_data_to_ad9834(0xC000); // phase zero reg 0
     clock_data_to_ad9834(0xE800); // phase pi reg 1, 180 degree shift for psk31   
     digitalWrite(FSYNC_BIT, HIGH);
     attachCoreTimerService( psk_mod_core );
   }
   if( mode == JT65 || mode == RTTY || mode == PSK31 || mode == MFSK ){ 
     pinMode(PSK_MOD_PIN, OUTPUT);
     LATFCLR = PSK_MOD;
   } 

}

int top_menu2(int def_val, struct MENU *m){     // return the menu selection values 

int old_val;
int counter = 3500;

  old_val= def_val;
  LCD.clrScr(); 
  LCD.setFont( SmallFont );
  show_menu(def_val,m);

  while( read_buttons() );  /* wait for release of the buttons */
  delay(50);
  
  while( 1 ){
     delay( 10 );
     def_val = def_val + encoder();     // turn the tuning knob to highlight a selection
     if( def_val < 0 ) def_val = 0;
     if( def_val >= m->no_sel ) def_val = m->no_sel -1;
     if( def_val != old_val){
       old_val= def_val;
       show_menu(def_val,m);            // show the new highlighted value 
       counter = 3500;
     }
     if( --counter == 0 ) break;     /* timeout in 35 seconds if operator is asleep */
     if( read_buttons() ) break;    /* push select or function to make a choice */     
  }
  
   return def_val; 
}


// now have more than 5 selections, so need to roll the choices if out of bounds
void show_menu( int sel, struct MENU *m ){  // display menu on nokia display
int i;
static int base;

   while( sel > base + 4 ) ++base;    // move the menu window around only when needed
   while( sel < base ) --base;        // so the selected choice is in range
   if( m->no_sel <= 5 ) base = 0;     // most of the menu's will not need a base
   
   LCD.print(m->title,0,0);
   for( i= 0; i < m->no_sel; ++i ){
      if( i < base ) continue;
      if( i > base + 4 ) break;
      if( i == sel ) LCD.invertText( 1 );
      else LCD.invertText( 0 );
      LCD.clrRow( i - base + 1 );
      LCD.print(m->choice[i], 16, 8 * (i - base + 1) );
   }
   LCD.invertText(0);
 
 // show some hint on the screen if there are more choices than what is displayed
   if( base != 0 ) LCD.print("--",RIGHT,8);
   if( (m->no_sel - base)  > 5 ) LCD.print("++",RIGHT,40);

   if( SERIAL_MENUS ){               // display current selection on the terminal screen
      Serial.print("\r\n");            // still use the encoder and select/function buttons to make a choice
      Serial.print(m->title); 
      Serial.print("\r\n   ");
      Serial.print(m->choice[sel]);     
      Serial.print("\r\n");
   }
}

void save_restore( int ba ){    // save cw,hell,rtty setup 
static long s_tx_vfo[4];        // could probably do this per mode with double subscript array
static long s_rx_vfo[4];        // but we will see how this works for now
static int s_split[4];
static int s_lock;
static int s_band;

int i;

   if( ba == SAVE ) {    // saving
      s_band = band;
      s_lock = user[LOCK];
      save_rx_vfo[band] = rx_vfo;     // capture where we are on the current band
      save_tx_vfo[band] = tx_vfo;     // normally not saved unless band is changed
      for( i = 0; i < 4; ++i ){
        s_tx_vfo[i] = save_tx_vfo[i];
        s_rx_vfo[i] = save_rx_vfo[i];
        s_split[i] = save_split[i];
      }
   }
   else{              // restoring
      for( i = 0; i < 3; ++i ){      // restore band we were on
         if( band == s_band ) break; // this corrupts save_tx_vfo[] and save_rx_vfo[]
         user_action(BAND,1);        // but sets relays for desired band and sets proper sideband
      }
      user[LOCK] = s_lock;
      for( i= 0; i < 4; ++i ){
         save_tx_vfo[i]  =  s_tx_vfo[i];  // fix up the save arrays
         save_rx_vfo[i] = s_rx_vfo[i];
         save_split[i] = s_split[i];
      }
     split = save_split[band];
     rx_vfo = save_rx_vfo[band];
     tx_vfo = save_tx_vfo[band];     
   }
}

//  this menu will keep the loop timing intact without any delays using a state machine
//  external events will change the select_macro variable causing different things to happen here
void macro_select(){      // called every 8 ms when active
static int save_nokia;    
static int choice= 0;
int en;
char c;
int i;

   
   switch( select_macro ){
      case 1:    /* just starting */
         save_nokia = nokia;
         nokia = MACRO_D;
         select_macro = 2;   
       //  choice = 0;       // return to choice 0 when re-enter the menu, comment this out to keep last choice 
         LCD.clrScr();
         LCD.setFont(SmallFont);
         show_macro_menu(choice);
      break;
      case 2:   /* checking the encoder for changes */
         en = encoder();
         if( en ){
            choice += en;
            if( choice < 0 ) choice = 0;
            if( choice > 19 ) choice = 19;
            show_macro_menu(choice);
         }
      break;
      case 3:   /* a selection was made, so put it in the buffer */
         if( (mode == MFSK || mode == RTTY || mode == PSK31)  && transmitting == 0 ){
            if( mode == RTTY ) rtty_up();
            else if( mode == PSK31 ) psk31_up();
            else if( mode == MFSK ) mfsk_flag = MFSK_GO;
            if( serial_decode) stage_str("\r\n");
         }
         i = 0;
         while( c= macro[choice][i++] ){      // index the macro
            if( serial_decode ){
              stage( c );
              if( c == '\r' ) stage( '\n' );
            }
            if( mode != PSK31 && mode != MFSK ) c= toupper(c);
            load_tx_queue( c | 0x80 );   
         }
         select_macro = 2;      // back to looking for another selection
      break;
      case 4:   /* function = exit was tapped */
         nokia = save_nokia;
         select_macro = 0;         // turn off this routine
         LCD.clrScr();
         tuning_display();
      break;
   }
  
}


void show_macro_menu(int choice ){
int i;
int k;
char c;
char buf[16];
static int base;

   while( choice < base ) --base;
   while( choice > (base + 4 )) ++base;

   for( i = 0; i < 5; ++i ){
      if( choice == base + i ) LCD.invertText( 1 );
      else LCD.invertText( 0 );
      strncpy( buf, macro[base + i], 14 );           // get as much of the macro as will fit on the screen
      buf[14] = 0;
      LCD.print(buf, 0, 8 * i );
      LCD.clrRow(i,6*strlen(buf));
   }
   LCD.invertText(0);
   LCD.print("Func->Exit",RIGHT,40);
}

/* *********************************************************************************** */

/* rit with a deadband through the complete range */
#define DEADBAND 3

void rit_read(){
static int ritvalue = 512;
int newval;
int snapval;

    snapval = ( mode == PSK31 || mode == MFSK ) ? 5 : 25 ;    // allow finer RIT tuning with psk31
    
    /* avoid reading RIT pot during transmit.  Voltage sag will affect reading */
    if( transmitting || tdown ) return;
    if( mode == WSPR || mode == JT65 ){
       rit_offset = 0;
       return; 
    }

    if( user[DISPLAY] == 0 ) rit_value = analogRead( RIT_PIN );  // battery save mode     
    newval = (rit_value + (7 * ritvalue))/8;     //Lowpass filter

    if( mode == CW && sliding_offset_enable && cw_offset_tone != 4 ){
       if( slide_off( newval ) ) return;    // rit at extreme position
    }

    /* dead band */
    if( ( newval < ritvalue + DEADBAND ) && ( newval > ritvalue - DEADBAND )) return;
    
    ritvalue = newval;
    rit_offset = ritvalue - 512;
    
    /* snap to zero */
    if( rit_offset > -snapval && rit_offset < snapval ) rit_offset = 0;
    if( mode == PSK31 || mode == MFSK ) rit_offset >>= 3;   // finer control for psk mode
    
    update_frequency(DISPLAY_UPDATE);
         
}

// sliding offset in CW mode.  Signal tunes at 1000 when active
int slide_off(int val ){
static int delta;

   
   switch( sliding_offset ){
      case 0:      // normal mode and looking for max value
         if( val > 1000 ){
            delta = 100 *( 4 - cw_offset_tone );
            mode_offset = 1000;
            goalpost = 10;
            if( sideband == USB ) delta = -delta;
            rx_vfo += delta;
            tx_vfo += delta;   
            sliding_offset = 1;
            rit_offset = 0;
            update_frequency(DISPLAY_UPDATE);
         }
      break;
      case 1:      // at max, looking to make rit active again
         if( val < 1000 ) sliding_offset = 2;
      break;
      case 2:      // rit active at the new offset, looking for max negative value
         if( val < 25 ){  // change back to the menu selected offset
            mode_offset = 600 + 100 * cw_offset_tone;
            goalpost = 6 + cw_offset_tone;
            rx_vfo -= delta;
            tx_vfo -= delta;
            sliding_offset = 3;
            rit_offset = 0;
            update_frequency(DISPLAY_UPDATE);            
         } 
      break;
      case 3:      // at max negative, looking to make rit active again
         if( val > 25 ) sliding_offset = 0;       
      break;
   }  
  
   return (sliding_offset & 1);    // what rit is doing alternates with each state of sliding_offset     
}
//--------------------------- Encoder Routine ----------------------------  

int read_encoder(){   /* return in LSBits */
int val;

   val = ( PORTD >> 8 ) & 2;  /* encoder A to bit 1 */
   val |= ( PORTD & 4 );      /* encoder B to bit 2 */
   return (val >> 1);   
}


int encoder(){        /* elmer 160 algorithm for gray code encoder */
int temp,i;
long update;
long mod;

    if( user[LOCK] && contrast_adjust == 0 && wpm_adjust == 0 && top_active == 0 && mem_tune == 0 ) return 0;   /* frequency locked */

    /*  read encoder */
    temp= read_encoder();
    if( temp != en_lval ){                    /* changed */
       i= (( en_lval << 1 ) ^ temp ) & 2;     /* get direction */
       en_lval= temp;
       if( i == en_dir ){                     /* same direction as last time */
           update = ( en_dir ) ? tuning_rate : -tuning_rate;

           /* alternate encoder function - top menu or macro's.  In Fax mode unlock to tune around */
           if( top_active || select_macro || ( mem_tune && user[LOCK] ) ){
             if( update > 0 ) return 1;
             else return -1; 
           }
           
           /* alternate encoder function - code speed adjust */
           if( wpm_adjust ){
             if( update > 0 ) ++wpm;
             else --wpm;
             
             if( wpm < 10 ) wpm = 10;   /* limits of the adjustment */
             if( wpm > 30 ) wpm = 30;
             wpm_display();
             led_on_timer = 600;     
             return 0;                    /* skip updating the frequency */
           }

           /* alternate encoder function - contrast adjust */
           if( contrast_adjust ){
             if( update > 0 ) ++contrast;
             else --contrast;
             
             if( contrast < 50 ) contrast = 50;   /* limits of the adjustment */
             if( contrast > 76 ) contrast = 76;
             contrast_display();     
             return 0;                    /* skip updating the frequency */
           }

           
           /* round freq to the tuning rate */
           mod = listen_vfo % tuning_rate;
           if( mod && update < 0) update = -mod;
           else if( mod && update > 0 ) update = tuning_rate - mod;
           
           if( mode == JT65 ){    // forcing split and lock step tuning of tx and rx when in JT mode
              rx_vfo += update;
              tx_vfo += update;
           }
           else switch( split ){
              case 0: tx_vfo = rx_vfo = rx_vfo + update;  break;    /* normal */
              case 1: rx_vfo += update; break;                      /* tx freq fixed, changing rx freq */
              case 2: tx_vfo += update; break;                      /* rx freq fixed, changing tx freq */
           }
                      
          update_frequency(DISPLAY_UPDATE);
       }    
       else en_dir= i;                        /* else save the new direction */
    }
    return 0;
}

void memory_tune(){     // cycle through the wefax memory channels
int i;
int new_band;
int old_mode;
static int counts;      // slow down the encoder 

   counts += encoder();
   if( counts > -2 && counts < 2 && mem_tune == 1 ) return;    // mem_tune is 2 to force initial setup
   if( counts < 0 ) channel = channel - 1;
   else channel = channel + 1;
   counts = 0;
   
   if( mem_tune == 2 ){
      --channel;     // back to where we were
      mem_tune= 1;   // initialization over
   }
   if( channel >= NOMEM ) channel = 0;
   if( channel < 0 ) channel = NOMEM - 1;
   old_mode = mode;

   new_band = memory[channel].band;
   if( band_switch == TWO_BAND ) new_band &= 2;   // 0 or 2 for the two band module   
   for( i = 0; i < 3; ++i ){          // using for loop in case band in memory channel is not reachable
      if( band == new_band ) break;   // if jumper is band switch, then this will do no harm
      user_action( BAND, 1 );         // change to next band ( also restores previous vfo values which we don't want )
   }
   sideband = memory[channel].sideband;
   rx_vfo = tx_vfo = memory[channel].freq + memory[channel].offset;

   mode = memory[channel].mode;
   if( mode == JT65 || mode == WSPR ) mode = WEFAX;    // split modes not allowed in the memory
   mode_offset = ( sideband == USB ) ? -memory[channel].offset : memory[channel].offset;
   
   if( old_mode != mode ){
      if( old_mode == PSK31 ) detachCoreTimerService( psk_mod_core );
      if( old_mode == MFSK ) detachCoreTimerService( mfsk_core );
      if( old_mode == HELL ) detachCoreTimerService( feld_hell_core );
      if( mode == HELL ) attachCoreTimerService( feld_hell_core );
      if( mode == PSK31 ) attachCoreTimerService( psk_mod_core );
      if( mode == MFSK ) attachCoreTimerService( mfsk_core );
   }
   fun_selected[0] = ( mode > MFSK ) ? WIDE : MEDIUM ;   // set wide or medium bandwidth
   
   // set up the tuning goalpost for any strange offsets in the memory.  Anything out of bounds is set to 10
   goalpost = mode_offset / 100;
   if( goalpost < 0 ) goalpost = -goalpost; 
   if( mode == RTTY || mode == PSK31 ) goalpost = 1.6 * goalpost;    // rtty dsp sample time is slower making 16 == 1000 center
   if( mode == WEFAX && goalpost == 19 ) goalpost = 23;  
   if( goalpost < 6 || goalpost > 26 ) goalpost = 10;
      
   update_frequency(DISPLAY_UPDATE);
   set_band_width(fun_selected[0]);
   split = user[SPLIT] = 0;         // no splits, the offset in the memory turns into a mode_offset
   
   write_sleds(SGRN); 
   mem_tune = 3;           // flag we set the Green LED on.   Turned off in loop()
   led_on_timer = 600;    // timer for the user help text display
   user_help(3);        // show mode / sideband
}


int mfsk_fec( int arg ){     // encode 1 bit into two
static int x,y;
int fec;
const int poly1 = 0b1101101;
const int poly2 = 0b1001111;
//const int poly1 = 0b1011011;
//const int poly2 = 0b1111001;

   if( arg == -1 ){    //  init command is -1
      x= 0, y= 0;
      return 0;
   } 
   
   // shift in the new bit
   x <<= 1;    y <<= 1;
   x |= arg;   y |= arg;
   x &= 0x7f;  y &= 0x7f;

   // generate the fec coded bits
   fec = mfsk_fec2( x, poly1 );  
   fec <<= 1;
   fec |= mfsk_fec2( y, poly2 ); 

   return fec;
}

int mfsk_fec2( int w, int poly ){
int t , i;

   // for each bit set in poly, half add the corresponding bit in the delay line  
   t= 0; 
   for( i = 0; i < 7; ++i ){
     if( poly & 1 ) t ^= (w & 1);
     poly >>= 1;   w >>= 1;
   }  
   return t;
}


int mfsk_interleave( int in4 ){ 
static unsigned int x[10];         // 10 cascaded 4x4 bit arrays each stored as 16 bits inline
int i;                             // ABCD EFGH IJKL MNOP
                                   // new bits are ABCD
                                   // taking bits out on the diagonal  AFKP
                                   // and they go into the top of the next 4x4 array

   if( in4 == -1 ){
     for( i = 0; i < 10; ++i ) x[i] = 0;
     return 0;
   }
   
   in4 <<= 12;                     // shift bits to the top position
   for( i = 0; i < 10; ++i ){
     x[i] >>= 4;
     x[i] |= in4;
     in4 = 0;
     if( x[i] & 0x8000 ) in4 |= 0x8000; 
     if( x[i] & 0x0400 ) in4 |= 0x4000; 
     if( x[i] & 0x0020 ) in4 |= 0x2000; 
     if( x[i] & 0x0001 ) in4 |= 0x1000;
   }
  
   in4 >>= 12;                    // return output bits to the bottom position
   return (in4 & 0xf);            // mask just in case to 4 bits
}


int mfsk_dinterleave( int in4 ){   // broke this out of interleave function so that we can test with a software loopback
                                   // except for the diagonal used the functions are identical
static unsigned int x[10];         // 10 cascaded 4x4 bit arrays each stored as 16 bits inline
int i;                             // ABCD EFGH IJKL MNOP
                                   // new bits are ABCD
                                   // taking bits out on the oposite diagonal MJGD
                                   // and they go into the top of the next 4x4 array

   if( in4 == -1 ){
     for( i = 0; i < 10; ++i ) x[i] = 0;
     return 0;
   }
   
   in4 <<= 12;                     // shift bits to the top position
   for( i = 0; i < 10; ++i ){
     x[i] >>= 4;
     x[i] |= in4;
     in4 = 0;
     if( x[i] & 0x0008 ) in4 |= 0x8000; 
     if( x[i] & 0x0040 ) in4 |= 0x4000; 
     if( x[i] & 0x0200 ) in4 |= 0x2000; 
     if( x[i] & 0x1000 ) in4 |= 0x1000;     
   }
  
   in4 >>= 12;                    // return output bits to the bottom position
   return (in4 & 0xf);            // mask just in case to 4 bits
}




void update_frequency(int disp){
unsigned long freq0;
unsigned long rit;   /* need to reverse for 20 meters */
int i;
int mode_off;


    rit = rit_offset;
    mode_off = mode_offset;
    listen_vfo = ( split == 2 ) ? tx_vfo : rx_vfo;
    if( sideband == USB && band == 0 ){           // 40 meters USB 
       freq0 = bfo - listen_vfo;                    // 40 meters will tune backwards
    }     
    else if( sideband == USB ){
       freq0 = listen_vfo - bfo;  
       rit = -rit;
    }
    else{                            // Lower sideband
       freq0 = listen_vfo + bfo;
       mode_off = - mode_offset;
    }

    /* refuse to tune to certain frequencies - stay put until spot is tuned over or away */
    if( listen_vfo < 400000 || listen_vfo > 30000000 ) return;
    /* check nozones */
    for(i = 0; i < NUMNOZONE; ++i ){
        if( listen_vfo >= (nozone[i] - 30000) && listen_vfo <= (nozone[i] + 30000) ) return;
    }
    
    if( split != 2 ) freq0 += rit;           /* put in RIT offset on rx_vfo only */
    
    program_freq0( freq0 );    
    program_freq1( tx_vfo + mode_off );   /* always tranmitting on dds freq1, swap option swaps which vfo we listen and tune with */

    if( mode == PSK31 ){   // the AD9834 keeps forgetting the phase information when tuning around.  Not sure why?
     digitalWrite(FSYNC_BIT, LOW); 
     clock_data_to_ad9834(0xC000); // phase zero reg 0
     clock_data_to_ad9834(0xE800); // phase pi reg 1, 180 degree shift for psk31
     digitalWrite(FSYNC_BIT, HIGH);     
    }
    if( disp ) tuning_display();
    led_on_timer = 600;  /* delay for freq display timeout - 4.8 sec */
    nokia_s_inhibit = 0;    
    
}


//------------------ Initial Band Select ------------------------------------
void Band_Set_40_20M(){
int bsm;

    bsm = digitalRead(Band_Select); 

    // if low, then disable the band switching
    //  select 40 or 20 meters, 0 for 40, and 1 for 20 meters or the bandswitch module is installed
    if ( bsm == 1 ){   /* always power up on 20 meters so this works with or without a band switch module */
       band = 2;
       bandswitch_enable = 1;   /* enabled */
       pinMode (Band_Select,OUTPUT);   /* change mode of the band switch pin and write it low */
       digitalWrite(Band_Select,LOW); 
       digitalWrite(Band_Select2,LOW);  // for 4 band module 
       user[BAND] = 1;                 /* for LED display */
       sideband = USB;    
    }    
    else{
       band = 0;
       bandswitch_enable = 0;  /* stuck on 40 meters */
       user[BAND] = 0;
       sideband = LSB;
    }
   
    tx_vfo = save_tx_vfo[band];
    rx_vfo = save_rx_vfo[band];
    update_frequency(DISPLAY_UPDATE);
}


#ifdef NOWAY
/* debug function - display the peak value over time on the screen */
/* position 2 is an event counter */
void peak_value( int pos, long val ){
  static int count;
  static long pval[2], nval[2];
  static long rave[2];
  static long counts;
  char buf[35];
  
     if( pos == 2 ) counts += val;
     else if( pos < 2 ){ 
       if( val > pval[pos] ) pval[pos] = val;   // peak value
       if( val < nval[pos] ) nval[pos] = val;
       if( val > rave[pos] ) ++rave[pos];       // median ??
       if( val < rave[pos] ) --rave[pos];
     }
     if( ++count >= 1000 ) {    // 20000 for fast sampling
        count = 0;
        ltoa(pval[0],buf,10);
        lcd_goto(0,0);
        lcd_puts(buf); lcd_puts("  ");
        if( counts != 0 ){
          ltoa(counts,buf,10);
          lcd_puts(buf); lcd_puts("  ");           
        }

        ltoa(nval[0],buf,10);
        lcd_goto(1,0);
        lcd_puts(buf); lcd_puts(" ");

        ltoa(rave[0],buf,10);
        lcd_puts(buf); lcd_puts(" ");
        
        ltoa(pval[1],buf,10);
        lcd_goto(2,0);
        lcd_puts(buf); lcd_puts("  ");
        
        ltoa(nval[1],buf,10);
        lcd_goto(3,0);
        lcd_puts(buf); lcd_puts(" ");

        ltoa(rave[1],buf,10);
        lcd_puts(buf); lcd_puts(" ");
        
        pval[0] = pval[1] = -999999999;
        nval[0] = nval[1] =  999999999;
       // rave[0] = rave[1] = 0;
        counts = 0;
        
        nokia_s_inhibit = 1;   /* stop the s meter from overwiting the debug data */
     } 
}
#endif

//-----------------------------------------------------------------------------
// ****************  Dont bother the code below  ******************************
// \/  \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
//-----------------------------------------------------------------------------


void program_freq0(long frequency)
{
unsigned long fcalc;
int flow,fhigh;

  //  AD9834_reset_high();  /* this causes RIT noise */
    fcalc = frequency*(268.435456e6 / Reference );    // 2^28 =
    flow = fcalc&0x3fff;              //  49.99975mhz  
    fhigh = (fcalc>>14)&0x3fff;
    digitalWrite(FSYNC_BIT, LOW);  //
    clock_data_to_ad9834(flow|AD9834_FREQ0_REGISTER_SELECT_BIT);
    clock_data_to_ad9834(fhigh|AD9834_FREQ0_REGISTER_SELECT_BIT);
    digitalWrite(FSYNC_BIT, HIGH);
  //  AD9834_reset_low();
}    // end   program_freq0

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||  
void program_freq1(long frequency)
{
unsigned long fcalc;
int flow,fhigh;

  //  AD9834_reset_high(); 
    fcalc = frequency*(268.435456e6 / Reference );    // 2^28 =
    flow = fcalc&0x3fff;              //  use for 49.99975mhz   
    fhigh = (fcalc>>14)&0x3fff;
    digitalWrite(FSYNC_BIT, LOW);  
    clock_data_to_ad9834(flow|AD9834_FREQ1_REGISTER_SELECT_BIT);
    clock_data_to_ad9834(fhigh|AD9834_FREQ1_REGISTER_SELECT_BIT);
    digitalWrite(FSYNC_BIT, HIGH);  
  //  AD9834_reset_low();
}  

//------------------------------------------------------------------------------
void clock_data_to_ad9834(unsigned int data_word)
{
    char bcount;
    unsigned int iData;
    iData=data_word;
    digitalWrite(SCLK_BIT, HIGH);  //portb.SCLK_BIT = 1;  
    // make sure clock high - only chnage data when high
    for(bcount=0;bcount<16;bcount++)
    {
        if((iData & 0x8000)) digitalWrite(SDATA_BIT, HIGH);  //portb.SDATA_BIT = 1; 
        // test and set data bits
        else  digitalWrite(SDATA_BIT, LOW);  
        digitalWrite(SCLK_BIT, LOW);  
        digitalWrite(SCLK_BIT, HIGH);     
        // set clock high - only change data when high
        iData = iData<<1; // shift the word 1 bit to the left
    }  // end for
}  // end  clock_data_to_ad9834

//-----------------------------------------------------------------------------
void AD9834_init()      // set up registers
{
    AD9834_reset_high(); 
    digitalWrite(FSYNC_BIT, LOW);
    clock_data_to_ad9834(0x2300);  // Reset goes high to 0 the registers and enable the output to mid scale.
    clock_data_to_ad9834((FREQ0_INIT_VALUE&0x3fff)|AD9834_FREQ0_REGISTER_SELECT_BIT);
    clock_data_to_ad9834(((FREQ0_INIT_VALUE>>14)&0x3fff)|AD9834_FREQ0_REGISTER_SELECT_BIT);
    clock_data_to_ad9834(0x2200); // reset goes low to enable the output.
    AD9834_reset_low();
    digitalWrite(FSYNC_BIT, HIGH);  
}  //  end   init_AD9834()

//----------------------------------------------------------------------------   
void AD9834_reset()
{
    digitalWrite(RESET_BIT, HIGH);  // hardware connection
    for (int i=0; i <= 2048; i++);  // small delay

    digitalWrite(RESET_BIT, LOW);   // hardware connection
}

//-----------------------------------------------------------------------------
void AD9834_reset_low()
{
    digitalWrite(RESET_BIT, LOW);
}

//..............................................................................     
void AD9834_reset_high()
{  
    digitalWrite(RESET_BIT, HIGH);
}
//^^^^^^^^^^^^^^^^^^^^^^^^^  DON'T BOTHER CODE ABOVE  ^^^^^^^^^^^^^^^^^^^^^^^^^ 
//=============================================================================


#ifdef NOWAY
// this effort did not seem to help any.
// it was an attempt to recover characters lost due to signal distortion and noise
// saving the code in case wish to re-visit in the future
int sc( int val, int n ){    //error score - sum of squares
int s;

  --n;
  s= 0;
  if( val < 32 ) s= 300;   // too short to decode
  if( val > 351 ) s = 300; // too long to decode
  val-= n * 16;            // remove extra rounding
  val &= 31;               // remainder mod 32
  val -= 16;               // error from the rounding value
  s += val * val;          // square the error
  return s;
}

int ss(int a, int b, int c, int d, int e ){ // find lowest error score
  
    if( e < d && e < c && e < b && e < a ) return 4;
    if( d < e && d < c && d < b && d < a ) return 3;
    if( c < e && c < d && c < b && c < a ) return 2;
    if( b < e && b < d && b < c && b < a ) return 1;
    return 0;    
}

// a routine between psk_decode and psk_decode2 to remove short zero's
// perhaps does more harm than good ?
void psk_decode4( int count ){
static int a,b,c,d;
int tx;     // triple cross
int dx1;     // double cross
int dx2;     // double cross
int b1;     // borrow b, fix c
int b2;     // borrow d, fix c
int ce;

   psk_decode2( d );
   d= c; c= b; b= a;
   a = count;
   
   if( d == 0 || c == 0 || b == 0 ) return;
   if( c > 32 ) return;
   if( a < 32 && b < 32 && c < 32 ) return;   

if( led_on_timer == 0 ){
   write_sleds(SYEL);
   led_on_timer = 10;
}
   tx = sc(a+b,2) + sc(c+d,2);
   
   dx1 = sc(a+b+c,3) + sc(d,1);
   dx2 = sc(a,1) + sc(b+c+d,3); 

   ce = c & 31;   
   ce = 48 - ce;
   b1 = sc(a,1) + sc(b-ce,1) + sc(c + ce,1) + sc(d,1);
   b2 = sc(a,1) + sc(b,1) + sc(c + ce,1) + sc(d-ce,1);
   
   if( c > 28 ){
      b1 -= 100;
      b2 -= 100;
   }
   if( b < 32 ) tx -= 100;
   if( c < 22 ){
     dx1 -= 100;
     dx2 -= 100;
   }   
      
ch2= ss(tx,dx1,dx2,b1,b2) + 1;
  
   switch( ss(tx,dx1,dx2,b1,b2) ){
      case 0:
        c = a + b - 16;
        d = c + d - 16;
        a = b = 0;
      break;
      case 1:
        c = a + b + c - 32;
        a = b = 0;
      break;
      case 2:
        d = b + c + d - 32;
        c = a;
        a = b = 0;
      break;
      case 3:
        c += ce;
        b -= ce;
      break;
      case 4:
        c += ce;
        d -= ce;
      break;     
   }   
}


// generate the mfsk convolution table
void table_gen(){
  
int i,j,k;
unsigned int c;
int b;
int d;

   stage_str("\r\nconst unsigned int fec_table[] = {");

   d = 0;
   for(i = 0; i < 256; ++i ){
     
       c = 0;
       mfsk_fec( -1 );
       k= i;
       for( j = 0; j < 8; ++j ){
           c <<= 2;
           b = ( k & 0x80 ) ? 1 : 0 ;
           c |= mfsk_fec(b); 
           k <<= 1; 
       }


       if( d == 0 ) {
          stage_str("\r\n   ");
       }
       ++d;
       if( d > 4 ) d = 0;
      
       stage_str("0x");
       for( j = 0; j < 4; ++j ){
          b = c & 0xf000;
          b >>= 12;
          if( b < 10 ) stage( b + '0' );
          else stage( b - 10 + 'A' );
          c <<= 4;
       }
       if( i < 255 ) stage_str(",  ");
       while( un_stage());
       
   }  
   stage_str("\r\n   };");
}
#endif

