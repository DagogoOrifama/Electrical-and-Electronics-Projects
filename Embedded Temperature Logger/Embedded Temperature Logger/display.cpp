#include "mbed.h"
#include "N5110.h"
#include "getData.h"
#include "display.h"


//    VCC,SCE,RST,D/C,MOSI,SCLK,LED
N5110 lcd(p7,p8,p9,p10,p11,p13,p21);  // LPC1768 - pwr from GPIO
InterruptIn brightSet(p17); // Brightness Interrupt subroutine
DigitalIn plotview(p16, PullUp); // Initialising button A as input to display plot view when button is pressed
DigitalIn defaultview(p17, PullUp); // Initialising button B as input to display default view when button is pressed
DigitalIn mylogstatus(p18);   // Initialising switch on Pin 18 as input, this is used to log data to file when ON 

//Global variable
int brightVal=0;
int firstTime = 1;
int plot = 0;
int plot_array[84];


void togglePlot() {
        while(1) {
            if(!plotview) // checks if botton A is pressed
            {
                plot = 1;
            }
            if(!defaultview)  // checks if botton B is pressed
            {
                plot = 0;
            }
        }
}
void plotArray(){
    for (int i=0; i<83; i++)
    {
        plot_array[i] = plot_array[i+1];
    }
    plot_array[83] = (int)getTemperature();
}
void display1() {
    if (plot == 0) // show normal view
    {
    if (firstTime == 1)  // if the LCD is displaying for the first time
    {
    lcd.init();   //  initialise display
    lcd.clear();  // clear LCD
    lcd.setContrast(0.5);  // Sets LCD contrast
    brightSet.rise(&brightness);  // calls on the brightness function to set the brightness of LCD
    //if LCD is ON for the first time display a welcome message
    lcd.printString("TEMP LOGGER", 0, 0);
    lcd.printString("DAGOGO ORIFAMA", 0, 2);
    lcd.printString("SID:201177661", 0, 3);
    lcd.printString("A>>Plot view", 0, 4);
    lcd.printString("B>>Sets bright", 0, 5);
    lcd.refresh();
    wait(5.0);
    firstTime = 0;
    }  
    lcd.clear();
    char tempbuffer [14];
    char timebuffer [15];
    int length1 = sprintf(tempbuffer, "T=%2.2f C", getTemperature()); // Print formatted temperature to tempbuffer
    int length2 = getTime(timebuffer);       //get the corresponding time 
//  lcd.printString("SID:201177661", 0, 0);
    lcd.printString("TEMP LOGGER", 0, 0);     //Display "TEMP LOGGER" on LCD
    if(length1<=14){
         lcd.printString(tempbuffer,0,2);      //Display formatted temperature in tempbuffer on LCD
    }
    
    if(length2<=14){
         lcd.printString(timebuffer,0,3);      //Display the corresponding time on LCD
    }
    
      
    float newTemp= getTemperature();     //get temperature in real time to determine weather status              
     if (newTemp>28.00){                 //checks if newTemp is greater than maximum temperature setting of 28 degree celsius
        lcd.printString("HOT WEATHER",0,4);  // if newTemp is greater than 28 display "HOT WEATHER" on LCD
        }
    if (newTemp>24.00 & newTemp<28.00){  //checks if newTemp is within the range of 24 to 28 degree celsius
         lcd.printString("WARM WEATHER",0,4); // if newTemp is within the range of 24 to 28 degree celsius, display "WARM WEATHER" on LCD
        }
    if (newTemp<24.00){                  //checks if temperature is lower than normal temperature setting of 24 degree celsius
         lcd.printString("COLD WEATHER",0,4);  // if newTemp is lower than 24 degree celsius, display "COLD WEATHER" on LCD
        }    
    
    if(mylogstatus)  // Checks if the switch on P18 is ON, if true
    { lcd.printString("LOGGING ON",0,5); // display "LOGGING ON" on LCD
    }
    else //if false  
    { lcd.printString("LOGGING OFF",0,5); // display "LOGGING OFF" on LCD
    }
    
    lcd.refresh();    
    }
    else  // plot graph
    {
        int y;
        lcd.clear();
        for (int x=0; x<=83; x++) {  //Plot temperature
            if (plot_array[x]>=47) {
                y = 0;
            } else {
                y = 47 - plot_array [x];
            }
            lcd.setPixel(x, y);
        }
        for (int x = 0; x <=83; x ++)  
        {
            lcd.setPixel(x, 47); // set time axis
        }
        for (int y = 0; y <=47; y ++)
        {
            lcd.setPixel(0, y);    // plots the Temperature axis
        }
        lcd.printString("T",0,0);  //print Temperature axis label
        lcd.refresh();             //show changes
        lcd.printString("t",78,5); //print time axis label
        lcd.refresh();
    }
}
void brightness(){
    brightVal=brightVal+1;            //Sets brightness Variable
    if(brightVal==1){                 //brightness level 1
    lcd.setBrightness(0.2);           //sets lcd brightness level to 20%
    wait(1.0);                        //delay for 1 second
    }
    if(brightVal==2){                //brightness level 2
    lcd.setBrightness(0.5);          //sets lcd brightness level to 50%
    wait(1.0);                       //delay for 1 second
    }
    if(brightVal==3){                //brightness level 3
    lcd.setBrightness(1.0);          //sets lcd brightness level to 100%
    brightVal=0;                     // reset brightness counter
    wait(1.0);                       //delay for 1 second
    }
}