#include "mbed.h"
#include "getData.h"
#include "display.h"
#include "rtc.h"
 
Ticker file, display, plotdata; // timer that control temperature acquisition, display of data to screen and graph plotting
BusOut mywriteleds(LED1, LED2, LED3, LED4); // Initialising LED1, LED2, LED3, LED4 as output
LocalFileSystem local("local"); // create local filesystem
DigitalIn mylogswitch(p18);      // sets Switch connected to P18 as input
void writeDataToFile();          // Function to write data to file

int main() {
    // void rtcTime(1511954097); //current unix time stamp
    file.attach(&writeDataToFile, 60.0); // Log data (time, data and temperature) to file every 60 seconds
    display.attach(&display1, 0.5);      // Display new temperature reading from sensor every 0.5seconds
    plotdata.attach(&plotArray,1.0);     // send new data every 1seconds to be plotted on the graph
    togglePlot();                        // toggle between default view and plot view
}
void writeDataToFile(){
    if(mylogswitch) { // if switch is ON, log data to file

float temperature = getTemperature(); 
 char timeBuffer [15];
 getTime(timeBuffer);
 mywriteleds = 15; // turn on LEDs for feedback
 FILE *fp = fopen("/local/Log.csv", "a"); // open 'log.csv' for appending
 // if the file doesn't exist it is created, if it exists, data is appended to the end
 fprintf(fp,"=\"%s\", %.2f\r\n",timeBuffer,temperature); // print string to file
 fclose(fp); // close file
 mywriteleds = 0; // turn off LEDs to signify file access has finished
}
}