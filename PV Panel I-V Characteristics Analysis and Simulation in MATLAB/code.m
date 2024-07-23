% MATLAB Simulation program for a PV Panel
% Written by Dagogo Orifama, 201177661
% Electronics and Electrical Engineering, University of Leeds

A =  1.72;              % Ideality factor
q = 1.6*10^-19;         % Electron charge
k  = 1.380658*10^-23;   % Boltzmann constant         
Eg = 1.1*1.6 *10^-19;   % Band gap
Ior = 19.9693*10^-6;    % Reverse saturation current at Tr               
Iscr = 3.3;             % Short-circuit current generated at the reference temperature, Tr
ki = 1.7*10^-3;         % Temperature coefficient of the short-circuit current
ns = 40;                % Number of series panel
np = 2;                 % Number of parallel panel
Rs = 5*10^-5;           % Series resistance
Rp = 5*10^5;            % Shunt resistance
Tr = 301.18;            % Reference temperature

% Prompt for values of Ta and G
disp('Input either (1) or (2) to vary the weather condition based on the value G or Ta respectively');
WC = input('Type your selection:'); % User input is stored here, value can either be 1 or 2

if(WC==1) 
    disp('Input the Values of G and Ta as a singular matrix: G1,G2,G3,Ta, Example: [0.3 0.5 1.0 25]');
    SM = input('Please input value: '); 
    G_range = [1, 3]; G_range(1) = SM(1); G_range(2) = SM(2); G_range(3) = SM(3); 
    Ta = SM(4); 
elseif(WC==2) 
    disp('Input the Values of G and Ta as a singular matrix: T1,T2,T3,G, Example: [25 40 60 1]');
    SM = input('Please input value: '); 
    T_range = [1, 3]; T_range(1) = SM(1); T_range(2) = SM(2); T_range(3) = SM(3); 
    G = SM(4); 
end

for G_val = 1:3 
    if(WC==1) 
        G = G_range(G_val); 
    elseif(WC==2) 
        Ta = T_range(G_val); G = SM(4); 
    end
    
    Tc = Ta + 0.2*G + 273.18;    % Evaluating the cell temperature
    Isc = (Iscr + ki*(Tc-Tr)) * G; % Evaluating short-circuit current
    Is = Ior * (Tc/Tr)^3 * exp(q*Eg*(1/Tr - 1/Tc) / (k*A)); % Evaluating the diode leakage current                 
    acc = 1e-3;
    I_array = []; V_array = []; P_array = [];
    I = Isc; V = 0;
    
    while I > 0
        fI = I - np*Isc + np*Is*(exp(q*(V/ns+I*Rs/np)/(A*k*Tc)) - 1) + (V*np/ns + I*Rs)/Rp; 
        dfI = 1 + Rs/Rp + q*Is*Rs/A*k*Tc*(exp(q*(V/ns+I*Rs/np)/A*k*Tc)); 
        I_val = I - fI/dfI; 
        error = abs(I_val-I);  
        
        while error > acc
            I = I_val; 
            fI = I - np*Isc + np*Is*(exp(q*(V/ns+I*Rs/np)/(A*k*Tc)) - 1) + (V*np/ns + I*Rs)/Rp; 
            dfI = 1 + Rs/Rp + q*Is*Rs/A*k*Tc*(exp(q*(V/ns+I*Rs/np)/A*k*Tc)); 
            I_val = I - fI/dfI; 
            error = abs(I_val-I);  
        end
        
        I_array = [I_array I_val]; V_array = [V_array V]; 
        P_val = I_val * V; 
        P_array = [P_array P_val]; 
        I = I_val; V = V + 0.1; 
        
        Pmp = max(P_array); 
        index = find(P_array == Pmp); 
        Vmp = V_array(index); 
        Imp = I_array(index);
    end
    
    disp(['I Values:', num2str(I_array)]);
    disp(['V Values:', num2str(V_array)]);
    disp(['P Values:', num2str(P_array)]);
    disp(['P Max:', num2str(Pmp)]); 
    disp(['V Max:', num2str(Vmp)]); 
    disp(['I Max:', num2str(Imp)]); 
    
    figure(1) 
    plot(V_array, I_array, 'linewidth', 1); 
    xlabel('voltage(V)'); ylabel('current(A)'); title('I-V characteristics curve');
    ylim([0, 8]);
    
    if(WC==1) 
        title('I-V characteristics curve at Ta = 25 degree celsius'); 
        legend(strcat('G1 = ', num2str(G_range(1)), 'kW/cm^2'), strcat('G2 = ', num2str(G_range(2)), 'kW/cm^2'), strcat('G3 = ', num2str(G_range(3)), 'kW/cm^2')); 
    elseif(WC==2) 
        title('I-V characteristics curve at G = 1.0kW/m2 '); 
        legend(strcat('Ta = ', num2str(T_range(1)), 'degree celsius'), strcat('Ta = ', num2str(T_range(2)), 'degree celsius'), strcat('Ta = ', num2str(T_range(3)), 'degree celsius')); 
    end
    
    hold on; grid on;
    pplot = plot(Vmp, Imp, 'd-');
    pplot.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold on;
    
    figure(2) 
    plot(V_array, P_array, 'linewidth', 1); 
    xlabel('voltage(V)'); ylabel('power(W)'); 
    ylim([0, 130]); 
    
    if(WC==1) 
        title('P-V characteristics curve at Ta = 25 degree celsius'); 
        legend(strcat('G1 = ', num2str(G_range(1)), 'kW/cm^2'), strcat('G2 = ', num2str(G_range(2)), 'kW/cm^2'), strcat('G3 = ', num2str(G_range(3)), 'kW/cm^2')); 
    elseif(WC==2) 
        title('P-V characteristics curve at G = 1.0kW/m2 '); 
        legend(strcat('Ta = ', num2str(T_range(1)), 'degree celsius'), strcat('Ta = ', num2str(T_range(2)), 'degree celsius'), strcat('Ta = ', num2str(T_range(3)), 'degree celsius')); 
    end
    hold on; grid on;
    pplot2 = plot(Vmp, Pmp, 'd-');
    pplot2.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold on;
end
