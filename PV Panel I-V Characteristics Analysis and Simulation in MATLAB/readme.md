# Power Generation by Renewable Sources

## Project Overview

This project focuses on measuring the current-voltage (I-V) characteristics of a practical photovoltaic (PV) panel and simulating the PV panel under different weather conditions using MATLAB. The primary goal is to understand the performance of PV panels in varying environmental conditions and to model their behavior using numerical methods.

## Objectives

1. Measure the I-V and P-V characteristics of a PV panel under various weather conditions.
2. Simulate the PV panel using MATLAB to predict its performance under different temperatures and solar irradiance levels.
3. Analyze the effect of temperature and irradiance on the maximum power point (MPP) of the PV panel.
4. Utilize the Newton-Raphson method to solve the PV equation for accurate modeling.

## Experimental Setup

### Measurement of I-V Characteristics

The I-V characteristics were measured for a PV panel at different temperature ranges (23°C - 28°C and 31°C - 36°C). The results were plotted to show the relationship between current, voltage, and power output under these conditions.

### Results

- **Figure 1.1**: I-V characteristics at different weather conditions.
- **Figure 1.2**: P-V characteristics at different weather conditions.
- **Table 1.1**: Maximum power points and corresponding voltages and currents for various weather conditions.

### Analysis

- **Effect of Solar Irradiance**: As the light level (G) increases, the maximum power output of the PV cell also increases.
- **Effect of Temperature**: Higher temperatures result in a decrease in the maximum power output due to increased internal carrier recombination rates and reduced band gap.

## MATLAB Simulation

### PV Module Modeling

The PV panel was modeled in MATLAB using the Newton-Raphson method, which is an iterative root-finding algorithm. The simulation considered various weather conditions to predict the panel's performance.

### Key Parameters and Equations

- **Photocurrent (Isc)**: Light-generated current in the cell.
- **Diode Current (ID)**: Current due to diffusion of charge carriers.
- **Shunt Resistance (Rp)**: Represents losses due to defects in the PV cell.
- **Series Resistance (Rs)**: Represents ohmic losses due to metal contacts.
- **Load Resistance (RL)**: Resistance connected to the output terminal of the PV cell.


## Author
**Dagogo Gowin Orifama**  
**dagoris2010@gmail.com**
