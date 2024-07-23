#include "mbed.h"
//Temperature addresses for ADD0 connected to ground
#define TMP102_ADD 0x48
#define TMP102_R_ADD 0x90
#define TMP102_W_ADD 0x91
//Register addresses
#define TEMP_REG 0X00
#define CONFIG_REG 0X01
#define THIGH_REG 0X03
#define TLOW_REG 0X02


void temperror(int code); // flashes the LED3 and LED4 if data is not read from the temperature sensor
void initTMP102();       // function that initialises the temperature
float getTemperature();  //subroutine that leads to the acquisition of the temperature from sensor
int getTime(char *buffer); // function that gets and format current time and date