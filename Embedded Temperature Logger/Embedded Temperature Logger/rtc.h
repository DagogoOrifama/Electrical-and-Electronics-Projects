#include "mbed.h"

void serialISR(); // ISR that is called when serial data is received
void setTime(); // function to set the UNIX time
void rtcTime(); // RTC time function