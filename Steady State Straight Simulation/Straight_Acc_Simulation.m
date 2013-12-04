function [speed_kmh, acceleration, gear, t, E] = Straight_Acc_Simulation(pi...
    , Total_Mass, Torque, RPM, gear_ratios, Final_ratio, Tire_radious...
    , drag_coef, Area, air_t, atm_p, V_initial, straight_length, rolling_coef...
    , g)
%STRAIGHT_ACC_SIMULATION Summary of this function goes here

% Performance Simulator v0.1
% Date: 27-11-2013
% Author: César Álvarez Porras (www.cesar-ap.com)

% Script: Calculates time spent in an acceleration sector given the
% entry speed, sector length and vehicle data.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                         Variables Declaration                       %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Physics constants
% pi = 3.14159;
% g=9.81;
% 
% % Vehicle Parameters
% Total_Mass = 1200; % Kg
% Torque = [300, 330, 370, 400, 450, 470, 520, 580, 620, 660, 680, 670, 640, 620, 600, 590, 570];
% RPM =    [2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000];
% gear_ratios = [3.1, 2.3, 1.9, 1.7, 1.5, 1.4];
% Final_ratio = 2.8;
% Tire_radious = 0.355;% m
% 
% % Aerodynamic
% drag_coef = 0.335;% at 20 FRH and 40 RRH
% Area = 1.475;% m^2
% 
% % Scenario
% air_t = 23;% C degrees
% atm_p = 1000;% mbar
% rolling_coef = 0.696;
%
% V_initial = 32;% Km/h
% straight_length = 300;% m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                              Execution                              %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
distance = linspace(1,straight_length,straight_length); % generate array of distances
power = Calculate_Power(Torque,RPM,'no'); % Calculates the power

speed = zeros(1,straight_length); % array to keep speed (m/s) on every point
speed_kmh = zeros(1,straight_length); % array to keep speed (kmh) on every point
acceleration = zeros(1,straight_length); % array to keep aceleration on every point
gear = zeros(1,straight_length); % array to keep gear on every point
torque = zeros(1,straight_length); % array to keep torque on every point
W = zeros(1,straight_length); % array to keep rev at the wheel on every point
E = zeros(1,straight_length); % array to keep rev at the engine on every point
t = zeros(1,straight_length); % array to keep t spent on every point
Fr = zeros(1,straight_length); % array to keep Fr on every point
Fd = zeros(1,straight_length); % array to keep Fd on every point
Fw = zeros(1,straight_length); % array to keep Fw on every point
Ff = zeros(1,straight_length); % array to keep Ff on every point

speed(1) = V_initial*0.27; % load initial speed  (m/s)
speed_kmh(1) = V_initial; % load initial speed  (Km/h)


for i=1:(straight_length-1)
    % Calculates the next sample speed based on current smaple speed and 
    % current distance position
    W(i) = speed(i) / Tire_radious * 60 / (2*pi); % rpm at the wheel
    [gear(i), torque(i), E(i)] = Optimum_Gear(W(i), gear_ratios, Final_ratio, Torque, RPM);
    % Calculate the Engine Force
    Fw(i) = Engine_Force(torque(i), gear(i), Final_ratio, gear_ratios, Tire_radious);
    % Calculate the Rolling Resistance
    Fr(i) = Rolling_Resistance(speed(i),rolling_coef, Total_Mass, g);
    % Calculate the Aero Downforce Resistance
    Fd(i) = Aero_Resistance(drag_coef, Area, air_t, atm_p, speed(i));
    % calcualtes the combined Forces
    Ff(i) = Fw(i)-Fr(i)-Fd(i);

    % Calculates the instant Acceleration
    acceleration(i) = Ff(i) / Total_Mass;
    % Calcualtes the distance covered
    space = distance(i+1)-distance(i);
    % Calculates the time spent on this sample
    t(i) = space / speed(i);
    % Calculates the instant Speed    
    speed(i+1) = acceleration(i) * t(i) + speed(i); % Next sample speed is current speed and current acceleration
    speed_kmh(i+1) = speed(i+1) / 0.27; % speed expressed in Km/h
end


for i=straight_length % Fill last sample of data
    W(i) = speed(i) / Tire_radious * 60 / (2*pi); % rpm at the wheel
    [gear(i), torque(i), E(i)] = Optimum_Gear(W(i), gear_ratios, Final_ratio, Torque, RPM);
    % Calculate the Engine Force
    Fw(i) = Engine_Force(torque(i), gear(i), Final_ratio, gear_ratios, Tire_radious);
    % Calculate the Rolling Resistance
    Fr(i) = Rolling_Resistance(speed(i),rolling_coef, Total_Mass, g);
    % Calculate the Aero Downforce Resistance
    Fd(i) = Aero_Resistance(drag_coef, Area, air_t, atm_p, speed(i));
    % calcualtes the combined Forces
    Ff(i) = Fw(i)-Fr(i)-Fd(i);
    % Calculates the instant Acceleration
    acceleration(i) = Ff(i) / Total_Mass;  
    % Calcualtes the distance covered    
    space = distance(i)-distance(i-1);    
    % Calculates the time spent on this sample    
    t(i) = space / speed(i);
end

V_final = speed_kmh(end);

sector_time = 0;
for i=1:length(t)
    sector_time = sector_time + t(i);
end

fprintf('The time needed to cover a %d m length straight from %d Km/h to %d Km/h is %d seconds\n',straight_length, V_initial, V_final, sector_time);
    
% % Plotting Values
% set(figure,'Name','Outputs','NumberTitle','off');
% subplot(4,1,1);
% plot(speed_kmh);
% ylabel('Speed [Km/h]');
% grid on;
% subplot(4,1,2);
% plot(gear);
% ylabel('Gear');
% grid on;
% subplot(4,1,3);
% plot(torque);
% ylabel('Torque [Nm]');
% grid on;
% subplot(4,1,4);
% plot(E);
% xlabel('Distance [m]');
% ylabel('RPM');
% grid on;

end