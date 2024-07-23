# Embedded Temperature Logger

## Overview
This project involves the design, construction, and programming of an embedded temperature logger. The primary goal is to create a system that accurately measures ambient temperature, displays it in real-time, logs data to an Excel file, and visualizes the temperature trends over time. This temperature logger is particularly useful in HVAC systems, where automated temperature monitoring is critical.

## Hardware Components
1. **Sensor Block**: Utilizes the TMP102 temperature sensor for accurate temperature measurement. The sensor communicates with the microcontroller using the I2C protocol.
2. **Power Block**: Includes a bank of 4 AA batteries, a CMOS battery for the real-time clock, and a USB port for alternative power supply.
3. **Controller Block**: Employs the NXP LPC1768 microcontroller, which is a high-performance ARM Cortex-M3 based processor.
4. **Display and Communication Block**: Features a Nokia N5110 LCD for displaying temperature data and status. Data logging is facilitated by storing readings in an Excel CSV file.

## Software Components
The software is written in C++ and compiled using the mbed online compiler. The program manages:
- Reading temperature data from the TMP102 sensor.
- Displaying the current temperature and time on the N5110 LCD.
- Logging temperature data to an Excel CSV file every 60 seconds.
- Switching between different display views and controlling the LCD brightness.

## Functionalities
- **Real-time Display**: Shows current temperature and time on the LCD.
- **Data Logging**: Logs temperature data into an Excel file every minute.
- **Temperature Plotting**: Provides a graphical representation of temperature changes over time.
- **Weather Status Indicator**: Displays messages indicating 'Hot', 'Warm', or 'Cold' weather based on the temperature readings.
- **User Controls**: Buttons to toggle between display views, control data logging, and adjust LCD brightness.

## Testing and Results
The system was tested for functionality, showing accurate temperature readings, real-time plotting, and successful data logging. The user interface on the LCD provides intuitive feedback on the system's status.

## Conclusion and Recommendations
The embedded temperature logger successfully meets its design objectives, providing accurate and real-time temperature monitoring and logging. Future improvements could include:
- Adding a menu for setting temperature thresholds.
- Allowing user adjustments for graph scale, LCD brightness, and logging intervals through a more flexible interface.

This project demonstrates a practical application of embedded systems in environmental monitoring and control, with potential for further enhancements and wider application.

## Author
**Dagogo Gowin Orifama**  
**dagoris2010@gmail.com** 
January 2018
