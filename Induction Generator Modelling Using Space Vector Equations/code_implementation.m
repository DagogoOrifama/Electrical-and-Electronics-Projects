clear;
clc

% Prompt and receive the total simulation time
sim_time = input('please enter total simulation time: ');

% Declaration of machine constants and parameters
Tm = -1; % Maximum torque of machine in Nm
J = 0.025284; % Inertia of machine kg-m^2/s
B = 0.005; % Machine friction in Nms
HP = 5; % Machine rated power in Horse power (HP)
Pm = HP * 746.15; % Machine rated power in watts (3730.75W)
P = 4; % Number of poles, thus, 2 pole pairs
Vm = 230; % Supply voltage in volts, 230
f = 50; % Supply frequency in Hz
Rs = 0.5673; % Stator resistance in ohms
Rr = 0.7091; % Rotor resistance in ohms 0.7091
Lss = 0.00301; % Stator leakage inductance in H
Lrr = Lss; % Rotor leakage inductance in H
Lm = 0.075239; % Mutual inductance in H
Ls = Lss + Lm; % Stator self inductance in H
Lr = Lrr + Lm; % Rotor self inductance in H
a = 1 / ((Ls * Lr) - (Lm^2));
Tp = 1 / f; % Sampling period
ws = 2 * pi * f; % Synchronous speed
dt = 0.0002; % Time step
rem = mod(Tp, dt); % Get the remainder
simulation_period = round((Tp - rem) / dt); % Simulation period
sample_time = ((simulation_period * sim_time) + 1); % Sampling time
sim_time_array = (0:dt:(Tp * sim_time)); % Array of total simulation time

% Initialize variables and arrays
lqs = zeros(1, sample_time); % Array of q-component of stator flux linkage
lds = zeros(1, sample_time); % Array of d-component of stator flux linkage
lqr = zeros(1, sample_time); % Array of q-component of rotor flux linkage
ldr = zeros(1, sample_time); % Array of d-component of rotor flux linkage
rotor_speed = zeros(1, sample_time); % Array 
Va = zeros(1, sample_time); % Array of stator voltage phase 1
Vb = zeros(1, sample_time); % Array of stator voltage phase 2
Vc = zeros(1, sample_time); % Array of stator voltage phase 3
Ia = zeros(1, sample_time); % Array of stator current phase 1
Ib = zeros(1, sample_time); % Array of stator current phase 2
Ic = zeros(1, sample_time); % Array of stator current phase 3
Tem = zeros(1, sample_time); % Electrical torque array
Va(1) = Vm * sqrt(2) * cos(0) / sqrt(3);
Vb(1) = Vm * sqrt(2) * cos(-2 * pi / 3) / sqrt(3);
Vc(1) = Vm * sqrt(2) * cos(2 * pi / 3) / sqrt(3);

Vm = Vm * sqrt(2) / sqrt(3);
Te = 0;
iqs = 0;
ids = 0;
iqr = 0;
idr = 0;
temp_var1 = 0;
rotor_fre = 0;

for tm_s = 1:sim_time % For loop to evaluate the simulation period
    % Temporary storage of data
    rTm = round(((tm_s - 1) * simulation_period) + 1);
    lqsinit = lqs(rTm);
    ldsinit = lds(rTm);
    lqrinit = lqr(rTm);
    ldrinit = ldr(rTm);
    asinit = rotor_speed(rTm);
    teinit = Tem(rTm);
    Lqs = zeros(1, simulation_period);
    Lds = zeros(1, simulation_period);
    Lqr = zeros(1, simulation_period);
    Ldr = zeros(1, simulation_period);
    As = zeros(1, simulation_period);
    tte = zeros(1, simulation_period);
    va = zeros(1, simulation_period);
    vb = zeros(1, simulation_period);
    vc = zeros(1, simulation_period); % Phase voltages
    i1 = zeros(1, simulation_period);
    i2 = zeros(1, simulation_period);
    i3 = zeros(1, simulation_period); % Phase current
    Te = (3 / 2) * (P / 2) * Lm * ((iqs * idr) - (ids * iqr)); % Torque computation

    % Pick the mechanical torque based on the value of the simulation time inputted
    if (tm_s <= 100)
        Tm = -1;
        scale = 1;        
    elseif (tm_s > 100 && tm_s <= 200)
        Tm = -20;
        scale = 1;
    elseif (tm_s > 200)
        Tm = -30;
        scale = 1;
    end

    for i = 1:simulation_period
        var_y = 0; % It is 1 for doubly fed machine
        Tst = i * dt; % Present simulation time

        if (abs(temp_var1 - 1500) <= 5)
            rotor_fre = 0; % Utilized for doubly fed
        else
            rotor_fre = 50 - (temp_var1 / 30); % Utilized for doubly fed  
        end

        wr = 2 * pi * rotor_fre; % Evaluate the rotor frequency for doubly fed machine
        temp_var2 = ((tm_s - 1) * Tst);

        % Transformation of the d-q vector component 
        vqs = scale * ((2 / 3) * (Vm * cos(ws * Tst))) - ((1 / 3) * (Vm * cos((ws * Tst) - (2 * pi / 3)))) - ((1 / 3) * (Vm * cos((ws * Tst) + (2 * pi / 3))));
        vds = scale * -((sqrt(3) / 3) * (Vm * cos((ws * Tst) - (2 * pi / 3)))) + ((sqrt(3) / 3) * (Vm * cos((ws * Tst) + (2 * pi / 3))));
        vqr = scale * ((2 / 3) * (Vm * cos(wr * Tst))) - ((1 / 3) * (Vm * cos((wr * Tst) - (2 * pi / 3)))) - ((1 / 3) * (Vm * cos((wr * Tst) + (2 * pi / 3))));
        vdr = scale * -((sqrt(3) / 3) * (Vm * cos((wr * Tst) - (2 * pi / 3)))) + ((sqrt(3) / 3) * (Vm * cos((wr * Tst) + (2 * pi / 3))));

        % Runge-Kutta RK4 starts
        for j = 1:4
            if j == 1
                if i == 1
                    AS = asinit; % Initial rotor speed  
                    LQS = lqsinit; % Determination of stator q flux 
                    LDS = ldsinit; % Determination of stator d flux 
                    LQR = lqrinit; % Determination of rotor q flux 
                    LDR = ldrinit; % Determination of rotor d flux           
                end
                if j > 1
                    AS = (As(i - 1));
                    LQS = (Lqs(i - 1));
                    LDS = (Lds(i - 1));
                    LQR = (Lqr(i - 1));  
                    LDR = (Ldr(i - 1));           
                end

                % First update of RK4
                rk1wr = (1 / J) * 2 * (Te - Tm - (B * AS * 2));
                rk1qs = (-(a * Rs * Lr) * LQS) + (a * Rs * Lm * LQR) + vqs;
                rk1ds = (-(a * Rs * Lr) * LDS) + (a * Rs * Lm * LDR) + vds;            
                rk1qr = (a * Rr * Lm * LQS) + (-(a * Rr * Ls) * LQR) + (AS * 2 * LDR) + (var_y * vdr);
                rk1dr = (a * Rr * Lm * LDS) - (AS * 2 * LQR) - ((a * Rr * Ls) * LDR) + (var_y * vqr);

                % Second update of RK4
            elseif j == 2
                if i == 1
                    AS = asinit + (rk1wr * (dt / 2));
                    LQS = lqsinit + (rk1qs * (dt / 2));
                    LDS = ldsinit + (rk1ds * (dt / 2));
                    LQR = lqrinit + (rk1qr * (dt / 2));
                    LDR = ldrinit + (rk1dr * (dt / 2));            
                end
                if i > 1
                    AS = As(i - 1) + (rk1wr * (dt / 2));
                    LQS = Lqs(i - 1) + (rk1qs * (dt / 2));
                    LDS = Lds(i - 1) + (rk1ds * (dt / 2));
                    LQR = Lqr(i - 1) + (rk1qr * (dt / 2));
                    LDR = Ldr(i - 1) + (rk1dr * (dt / 2));            
                end
                rk2wr = (1 / J) * 2 * (Te - Tm - (B * AS * 2));
                rk2qs = (-(a * Rs * Lr) * LQS) + (a * Rs * Lm * LQR) + vqs;
                rk2ds = (-(a * Rs * Lr) * LDS) + (a * Rs * Lm * LDR) + vds;
                rk2qr = (a * Rr * Lm * LQS) + (-(a * Rr * Ls) * LQR) + (AS * 2 * LDR) + (var_y * vdr);
                rk2dr = (a * Rr * Lm * LDS) - (AS * 2 * LQR) - ((a * Rr * Ls) * LDR) + (var_y * vqr);

                % Third update of RK4
            elseif j == 3
                if i == 1
                    AS = asinit + (rk2wr * (dt / 2));
                    LQS = lqsinit + (rk1qs * (dt / 2));
                    LDS = ldsinit + (rk1ds * (dt / 2));
                    LQR = lqrinit + (rk1qr * (dt / 2));
                    LDR = ldrinit + (rk1dr * (dt / 2));      
                end
                if i > 1
                    AS = As(i - 1) + (rk2wr * (dt / 2));
                    LQS = Lqs(i - 1) + (rk2qs * (dt / 2));
                    LDS = Lds(i - 1) + (rk2ds * (dt / 2));
                    LQR = Lqr(i - 1) + (rk2qr * (dt / 2));
                    LDR = Ldr(i - 1) + (rk2dr * (dt / 2));        
                end
                rk3wr = (1 / J) * 2 * (Te - Tm - (B * AS * 2));
                rk3qs = (-(a * Rs * Lr) * LQS) + (a * Rs * Lm * LQR) + vqs;
                rk3ds = (-(a * Rs * Lr) * LDS) + (a * Rs * Lm * LDR) + vds;
                rk3qr = (a * Rr * Lm * LQS) + (-(a * Rr * Ls) * LQR) + (AS * 2 * LDR) + (var_y * vdr);
                rk3dr = (a * Rr * Lm * LDS) - (AS * 2 * LQR) - ((a * Rr * Ls) * LDR) + (var_y * vqr);

                % Fourth update of RK4
            elseif j == 4
                if i == 1
                    AS = asinit + (rk3wr * dt);
                    LQS = lqsinit + (rk3qs * dt);
                    LDS = ldsinit + (rk3ds * dt);
                    LQR = lqrinit + (rk3qr * dt);
                    LDR = ldrinit + (rk3dr * dt);            
                end
                if i > 1
                    AS = As(i - 1) + (rk3wr * dt);
                    LQS = Lqs(i - 1) + (rk3qs * dt);
                    LDS = Lds(i - 1) + (rk3ds * dt);
                    LQR = Lqr(i - 1) + (rk3qr * dt);
                    LDR = Ldr(i - 1) + (rk3dr * dt);       
                end
                rk4wr = (1 / J) * 2 * (Te - Tm - (B * AS));
                rk4qs = (-(a * Rs * Lr) * LQS) + (a * Rs * Lm * LQR) + vqs;
                rk4ds = (-(a * Rs * Lr) * LDS) + (a * Rs * Lm * LDR) + vds;
                rk4qr = (a * Rr * Lm * LQS) + (-(a * Rr * Ls) * LQR) + (AS * 2 * LDR) + (var_y * vdr);
                rk4dr = (a * Rr * Lm * LDS) - (AS * 2 * LQR) - ((a * Rr * Ls) * LDR) + (var_y * vqr);
            end % End of if condition        
        end % End of for loop j

        % Runge-Kutta 4-summation 
        if i == 1
            As(i) = asinit + ((dt / 6) * (rk1wr + (2 * rk2wr) + (2 * rk3wr) + rk4wr));
            Lqs(i) = lqsinit + ((dt / 6) * (rk1qs + (2 * rk2qs) + (2 * rk3qs) + rk4qs));
            Lds(i) = ldsinit + ((dt / 6) * (rk1ds + (2 * rk2ds) + (2 * rk3ds) + rk4ds));
            Lqr(i) = lqrinit + ((dt / 6) * (rk1qr + (2 * rk2qr) + (2 * rk3qr) + rk4qr));
            Ldr(i) = ldrinit + ((dt / 6) * (rk1dr + (2 * rk2dr) + (2 * rk3dr) + rk4dr));     
        end
        if i > 1
            As(i) = As(i - 1) + ((dt / 6) * (rk1wr + (2 * rk2wr) + (2 * rk3wr) + rk4wr));
            Lqs(i) = Lqs(i - 1) + ((dt / 6) * (rk1qs + (2 * rk2qs) + (2 * rk3qs) + rk4qs));
            Lds(i) = Lds(i - 1) + ((dt / 6) * (rk1ds + (2 * rk2ds) + (2 * rk3ds) + rk4ds));
            Lqr(i) = Lqr(i - 1) + ((dt / 6) * (rk1qr + (2 * rk2qr) + (2 * rk3qr) + rk4qr));
            Ldr(i) = Ldr(i - 1) + ((dt / 6) * (rk1dr + (2 * rk2dr) + (2 * rk3dr) + rk4dr));     
        end      

        % Evaluate rotor and stator d-q current values
        iqs = a * ((Lr * Lqs(i)) - (Lm * Lqr(i)));
        iqr = a * ((Ls * Lqr(i)) - (Lm * Lqs(i)));
        ids = a * ((Lr * Lds(i)) - (Lm * Ldr(i)));
        idr = a * ((Ls * Ldr(i)) - (Lm * Lds(i)));

        Te = (3 / 2) * (P / 2) * Lm * ((iqs * idr) - (ids * iqr)); % Evaluate the electrical torque
        tte(i) = Te; % Update the electrical torque matrix

        % Applying Inverse Clarke's Transformation
        va(i) = vqs;
        vb(i) = (-0.5 * vqs) + ((-sqrt(3) / 2) * vds);
        vc(i) = (-0.5 * vqs) + ((sqrt(3) / 2) * vds);  
        i1(i) = ids;
        i2(i) = (-0.5 * ids) + ((sqrt(3) / 2) * iqs);
        i3(i) = (0.5 * ids) + ((-sqrt(3) / 2) * iqs);
        temp_var1 = As(i);         
    end % End of simulation period

    for k = 1:simulation_period % For loop to update matrices
        rotor_speed(1 + ((tm_s - 1) * simulation_period) + k) = As(k); % Update rotor speed matrix
        lqs(1 + ((tm_s - 1) * simulation_period) + k) = Lqs(k); % Update stator q flux matrix
        lds(1 + ((tm_s - 1) * simulation_period) + k) = Lds(k); % Update stator d flux matrix
        lqr(1 + ((tm_s - 1) * simulation_period) + k) = Lqr(k); % Update rotor q flux matrix
        ldr(1 + ((tm_s - 1) * simulation_period) + k) = Ldr(k); % Update rotor d flux matrix
        Tem(1 + ((tm_s - 1) * simulation_period) + k) = tte(k); % Update electric torque matrix
        Ia(1 + ((tm_s - 1) * simulation_period) + k) = i1(k); % Update phase 1 current matrix
        Ib(1 + ((tm_s - 1) * simulation_period) + k) = i2(k); % Update phase 2 current matrix
        Ic(1 + ((tm_s - 1) * simulation_period) + k) = i3(k); % Update phase 3 current matrix
        Va(1 + ((tm_s - 1) * simulation_period) + k) = va(k); % Update phase 1 voltage matrix
        Vb(1 + ((tm_s - 1) * simulation_period) + k) = vb(k); % Update phase 2 voltage matrix
        Vc(1 + ((tm_s - 1) * simulation_period) + k) = vc(k); % Update phase 3 voltage matrix
    end % End of k for loop  
end % End of total simulation time

for i = 1:length(rotor_speed) % For loop to convert rotor speed to rpm
    rotor_speed(i) = (rotor_speed(i)) * (30 / pi); % Convert rotor speed to rpm  
end % End of loop

% Plots of results
figure(1)
plot(sim_time_array, Ia, sim_time_array, Ib, sim_time_array, Ic);
xlabel('Simulation Time (sec)');
ylabel('Phase Current (A)');
legend('Phase 1 Current (A)', 'Phase 2 Current (A)', 'Phase 3 Current (A)');
title('Phase Currents Against Time')
grid on

figure(2)
plot(sim_time_array, rotor_speed, 'linewidth', 2);
xlabel('Simulation Time (sec)');
ylabel('Rotor Speed (rev/min)');
legend('Rotor speed (rev/min)');
title('Rotor Speed Against Time');
grid on

figure(3)
plot(sim_time_array, lqs, sim_time_array, lds, sim_time_array, lqr, sim_time_array, ldr);
xlabel('Simulation Time (sec)');
ylabel('Flux-linkages (A/S)');
legend('stator-q flux linkage', 'stator-d flux linkage', 'rotor-q flux linkage', 'rotor-d flux linkage');
title('Flux Linkages Against Time')
grid on

figure(4)
plot(sim_time_array, Tem, 'linewidth', 2);
xlabel('Simulation Time (sec)');
ylabel('Electrical torque (Nm)');
legend('Electrical Torque');
title('Electrical Torque Against Time')
grid on

figure(5)
plot(sim_time_array, Va, sim_time_array, Vb, sim_time_array, Vc)
xlabel('Simulation Time (sec)');
ylabel('Phase Voltage (V)'); 
legend('Phase 1 Voltage (V)', 'Phase 2 Voltage (V)', 'Phase 3 Voltage (V)');
title('Phase Voltages against Time')
grid on

figure(6)
plot(sim_time_array, Va, sim_time_array, Ia, 'linewidth', 2)
xlabel('Simulation Time (sec)');
ylabel('Phase 1 voltage and current');
title('Phase 1 Voltage and Current Against Time')