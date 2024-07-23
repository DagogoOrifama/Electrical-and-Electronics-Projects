#include "mbed.h"
#include "getData.h"

BusOut mytempleds(LED3, LED4); // Function that declares LED 3 and LED4 as output
I2C tmp102(p28,p27);           // SDA, SCL

///hang in infinite loop flashing error code
void temperror(int code){
    while(1){
        mytempleds=0;  // OFF LED3 and LED4
        wait(0.25);    // wait
        mytempleds=code;   // ON LED3 and LED4 base on the value 'code'
        wait(0.25);    // wait
}
}
void initTMP102()
{
 tmp102.frequency(400000); // set bus speed to 400 kHz
 int ack; // used to store acknowledgement bit
 char data[2]; // array for data
 char reg = CONFIG_REG; // register address
 //////// Read current status of configuration register ///////

 ack = tmp102.write(TMP102_W_ADD,&reg,1); // send the slave write address and the configuration register address
 if (ack)
 temperror(1); // if we don't receive acknowledgement, flash error message
 ack = tmp102.read(TMP102_R_ADD,data,2); // read default 2 bytes from configuration register and store in buffer
 if (ack)
 temperror(2); // if we don't receive acknowledgement, flash error message
 ///////// Configure the register //////////
 // set conversion rate to 1 Hz
 data[1] |= (1 << 6); // set bit 6
 data[1] &= ~(1 << 7); // clear bit 7

 //////// Send the configured register to the slave ////////////

 char tx_data[3] = {reg,data[0],data[1]}; // create 3-byte packet for writing (p12 datasheet)
 ack = tmp102.write(TMP102_W_ADD,tx_data,3); // send the slave write address, config reg address and contents
 if (ack)
 temperror(3); // if we don't receive acknowledgement, flash error message

}

float getTemperature()
{
 int ack; // used to store acknowledgement bit
 char data[2]; // array for data
 char reg = TEMP_REG; // temperature register address
 ack = tmp102.write(TMP102_W_ADD,&reg,1); // send temperature register address
 if (ack)
 temperror(5); // if we don't receive acknowledgement, flash error message
 ack = tmp102.read(TMP102_R_ADD,data,2); // read 2 bytes from temperature register and store in array
 if (ack)
 temperror(6); // if we don't receive acknowledgement, flash error message
 int temperature = (data[0] << 4) | (data[1] >> 4);
 return temperature*0.0625;
}

int getTime(char *buffer) {
    time_t seconds = time(NULL); // get current time
 // format time into a string (time and date)
    int length = strftime(buffer, 15 , "%R %D", localtime(&seconds));
    return length;
}