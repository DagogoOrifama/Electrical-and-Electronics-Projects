% MatLab Simulation program for a Boost Converter
% Written by Dagogo Orifama, dagoris2010@gmail.com
% Electronics and Electrical Engineering, University of Leeds

% Initializing the given parameters
Vi = 15; % input voltage
fs = 5000; % switching frequency
CO = 333.3 * 1e-6; % Output capacitor
L = 18.75 * 1e-3; % Inductor
rL = 0.2; % resistance of the inductor
RL = 15; % Load resistance
tp = 1 / fs; % switching period
dt = 4 * 1e-6; % Sampling time step
k = 0.5; % Switching duty ratio
IL = 0; % Initial load current
V0 = 0; % Initial output voltage
x = [IL; V0]; % X-component of the state space model
B = [1 / L; 0]; % B-component of the state space model
U = Vi; % U-component of the state space model

VCSAVE = []; % Empty array to store voltage
ILSAVE = []; % Empty array to store current
sim_time = []; % Empty array to store simulation time

for t = 0:dt:500 * tp % switching period interval
    tDiff = mod(t, tp); % compare t and tp and compute the difference
    
    if tDiff < (k * tp) % Condition for switch to be on
        S = 1; % Switch ON
    else
        S = 0; % Switch OFF
    end
    
    A = [-rL / L, -(1 - S) / L; (1 - S) / CO, -(1 / (CO * RL))]; % A component of the state space equation

    % Start of fourth order Runge-Kutta Method
    k1 = dt * (A * x + B * U); % First order term
    k2 = dt * (A * (x + 0.5 * k1) + (B * U)); % Second order term
    k3 = dt * (A * (x + 0.5 * k2) + (B * U)); % Third order term
    k4 = dt * (A * (x + k3) + (B * U)); % Fourth order term
    x = x + ((k1 + 2 * k2 + 2 * k3 + k4) / 6); % Formula for finding x
    
    IL = x(1); % Current component of the x result
    V0 = x(2); % Voltage component of the x result
    
    VCSAVE = [VCSAVE, V0]; % saves the array of Capacitor voltages
    ILSAVE = [ILSAVE, IL]; % saves the array of Inductor currents
    sim_time = [sim_time, t]; % saves array of simulation time
end

figure(1) % Specify figure
plot(sim_time, VCSAVE) % Plot voltage versus simulation time
title('Capacitor voltage versus Simulation time'); % set graph title
ylabel('Capacitor Voltage(V)'); % set y-axis label
xlabel('Simulation Time(s)'); % set x-axis title
grid on
grid minor

figure(2)
plot(sim_time, ILSAVE) % Plot Inductor current versus simulation time
title('Inductor Current versus Simulation Time'); % set graph title
ylabel('Inductor Current(A)'); % set y-axis label
xlabel('Simulation Time(s)'); % set x-axis title
grid on
grid minor