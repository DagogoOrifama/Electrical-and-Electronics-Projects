% MatLab Simulation program for a PV+Boost Converter
% Written by Dagogo Orifama, dagoris2010@gmail.com
% Electronics and Electrical Engineering, University of Leeds

Cin = 200e-6; % input voltage
Fs = 5000; % switching frequency
Cout = 300e-6; % output capacitance
L = 0.0187; % inductance
rL = 0.2; % inductor resistance
RL = 15; % load resistance
k = 0.55; % duty ratio

Ts = 1 / Fs; % switching period
dt = 4e-6; % time step or increment
I_L = 0; % inductor current
Vout = 0; % initial output voltage
Vin = 0;
x = [Vin; I_L; Vout]; % x component of state space matrix
B = [1 / Cin; 0; 0]; % B component of state space matrix

% Acquiring PV information
Ai = 1.72; % Ideality factor of the diode
q = 1.6 * 1e-19; % Electron charge
kBoltz = 1.380658 * 1e-23; % Boltzmann constant
Eg = 1.1; % Energy gap
Ior = 19.9693 * 1e-6; % Reverse saturation current at Tr
Iscr = 3.3; % Short circuit current at Tr
ki = 1.7 * 1e-3; % temperature coefficient of circuit current
ns = 40; % number of series cell
np = 2; % number of parallel cell
Rs = 5 * 1e-5; % series resistance
Rp = 5 * 1e5; % parallel resistance
Tr = 301.18; % Reference temperature
acc = 0.001; % Error limit for obtaining Ipv using Newton termination condition

G = 1;
Ta = 25;

% Compute the remaining PV parameters needed for the simulation
Tc = Ta + 0.2 * G + 273.18; % Evaluating the cell temperature
Isc = (Iscr + ki * (Tc - Tr)) * G; % Evaluating short-circuit current
Is = Ior * (Tc / Tr)^3 * exp(q * Eg * (1 / Tr - 1 / Tc) / (kBoltz * Ai)); % Evaluating the diode leakage current

Pin_array = [];
Pout_array = [];
Vin_sim = [];
VCSAVE = []; % array to hold the capacitor voltage
ILSAVE = []; % array to hold the inductor voltage
sim_time = []; % array to hold the sampling time

V = 0; % set V to zero

% Iterate through sampling time of 0 to 500Tp
for t = 0:dt:500 * Ts
    error = 50;
    I = Isc; % set I to Isc, since this current, Isc is one of the extreme operating points of the PV
    % condition to check that the PV current does not go beyond zero
    while error > acc
        fI = I - np * Isc + np * Is * (exp(q * (V / ns + I * Rs / np) / (Ai * kBoltz * Tc)) - 1) + (V * np / ns + I * Rs) / Rp; % re-evaluate the function using the new I value
        dfI = 1 + Rs / Rp + ((q * Is * Rs) / (Ai * kBoltz * Tc)) * exp(q * (V / ns + I * Rs / np) / (Ai * kBoltz * Tc)); % re-evaluate the function derivative using the new I value
        
        In = I - (fI / dfI); % obtain a new I value
        error = abs((In - I) / I); % re-compute the error
        I = In;
    end
    Ipv = In;
    U = Ipv;
    tDiff = mod(t, Ts); % get the instantaneous time by comparing t with Tp
    
    s = 0; % variable to hold either the ON or OFF state conditions of the circuit
    if tDiff < (k * Ts)
        s = 1; % set switch to ON state
    else
        s = 0; % set switch to OFF state
    end
    
    A = [0, -1 / Cin, 0; 1 / L, -rL / L, -(1 - s) / L; 0, (1 - s) / Cout, -(1 / (Cout * RL))]; % A component of state-space equation
    
    % Start of fourth order Runge-Kutta Method
    k1 = dt * (A * x + B * U); % First order term
    k2 = dt * (A * (x + 0.5 * k1) + (B * U)); % Second order term
    k3 = dt * (A * (x + 0.5 * k2) + (B * U)); % Third order term
    k4 = dt * (A * (x + k3) + (B * U)); % Fourth order term
    x = x + ((k1 + 2 * k2 + 2 * k3 + k4) / 6); % Formula for finding x
    
    Vin = x(1);
    I_L = x(2); % extract the inductor current
    Vout = x(3); % extract the capacitor voltage
    V = Vin;
    Pin = Vin * I_L;
    Pout = (Vout^2) / RL;
    
    Vin_sim = [Vin_sim, Vin];
    VCSAVE = [VCSAVE, Vout]; % store the capacitor voltage for each time step
    ILSAVE = [ILSAVE, I_L]; % store inductor current for each time step
    sim_time = [sim_time, t]; % store simulation time
    Pout_array = [Pout_array, Pout];
    Pin_array = [Pin_array, Pin];
end

Poutave = (max([Pout_array(end-50:end)]) + min([Pout_array(end-50:end)])) / 2;
Pinave = (max([Pin_array(end-50:end)]) + min([Pin_array(end-50:end)])) / 2;

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