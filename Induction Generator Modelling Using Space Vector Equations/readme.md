# Induction Generator Modelling Using Space Vector Equations

## Project Overview

This project focuses on modeling an induction generator driven by a wind turbine using space vector equations. The objective is to understand and simulate the dynamic behavior of an induction generator, examining various parameters such as stator and rotor currents, flux linkages, speed, electric torque, power factor, output power, and efficiency. The modeling and simulation were conducted using MATLAB software.

## Key Objectives

1. Apply phasor representation to three-phase variables.
2. Use Clarke Transformation for voltage and current conversion between ABC and d-q planes.
3. Develop state space equations for dynamic changes in induction generators.
4. Simulate induction machine operation driven by a wind turbine.
5. Evaluate electric torque, power factor, output power, and efficiency through simulations.

## Methodology

- **Equivalent Circuit Model**: Used to represent the induction generator in a stationary reference frame.
- **State Space Representation**: Developed to express the d-q current values in terms of flux linkages and inductances.
- **Runge-Kutta Method**: Employed for numerical integration in the simulation.
- **Clarke Transformation**: Applied for converting three-phase variables to d-q axis and vice versa.

## Simulation Details

- **Software**: MATLAB
- **Hardware**: HP 64-bit computer, 500GB HDD, 4GB RAM, 1.90GHz CPU
- **Parameters**: Inertia, friction, rated power, poles, voltage, frequency, resistances, and inductances.

## Results

The simulation was performed under different mechanical torque values to observe the response of the induction generator. Key findings include:

- **Synchronous Mode**: Rotor speed and electrical torque behavior under synchronous conditions.
- **Super-synchronous Mode**: Impact of increased mechanical torque on rotor speed, stator current, and electrical torque.
- **Efficiency and Power Factor**: Computed for different operating conditions, showing efficiency improvements with higher torque values.
- **Smoothened Rotor Speed**: Achieved by adding rotor resistance, demonstrating improved transient response.

## Conclusion

The project successfully modeled and simulated a wind turbine-driven induction generator, analyzing various performance parameters. The results demonstrated how mechanical input power affects the rotor speed and output power, with additional rotor resistance leading to smoother operation.

## References

1. L. Zhang, ELEC5564: Power Generation by Renewable Source Laboratory Notes, University of Leeds, 2017.
2. H. S, Grid Integration of wind energy conversion systems, 2nd edition, Wiley, 2006.

## Appendix

The MATLAB code used for the simulation is provided in the appendix of the report. The code includes initialization of parameters, application of Clarke's Transformation, and implementation of the Runge-Kutta 4th order method for solving the state space equations. The code also includes plotting of the simulation results for analysis.

## Author
**Dagogo Gowin Orifama**  
**dagoris2010@gmail.com**
