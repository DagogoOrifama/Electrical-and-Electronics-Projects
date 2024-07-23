#include "mbed.h"
#include "rtc.h"

Serial serial(USBTX,USBRX);
int setTimeFlag = 0; // flag for ISR
char rxString[16]; // buffer to store received string
void rtcTime()
{
 serial.attach(&serialISR); // attach serial ISR
 char buffer[30]; // buffer used to store time string

 set_time(1512223589); // initialise time to 2nd December, 2017
 while(1) {
 time_t seconds = time(NULL); // get current time
 // format time into a string (time and date)
 strftime(buffer, 30 , "%X %D", localtime(&seconds));
 // print over serial
 serial.printf("Time = %s\n",buffer);
 wait(1.0); // delay for a second

 if (setTimeFlag) { // if updated time has been sent
 setTimeFlag = 0; // clear flag
 setTime(); // update time
 }
 }
}
void setTime() {
 // print time for debugging
 serial.printf("set_time - %s",rxString);
 // atoi() converts a string to an integer
 int time = atoi(rxString);
 // update the time
 set_time(time);
}
void serialISR() {
 // when a serial interrupt occurs, read rx string into buffer
 serial.gets(rxString,16);
 // set flag
 setTimeFlag = 1;
}