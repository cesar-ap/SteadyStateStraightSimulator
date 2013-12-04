function [ output_args ] = Straight_Braking_Simulation( input_args )
%STRAIGHT_ACC_SIMULATION Summary of this function goes here

% Performance Simulator v0.1
% Date: 28-11-2013
% Author: César Álvarez Porras (www.cesar-ap.com)

% Script: Calculates time spent in an straight sector given the initial
% speed, final speed, sector length and vehicle data.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                         Variables Declaration                       %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Physics constants
pi = 3.14159;
g = 9.81;

% Vehicle Parameters
Total_Mass = 1200; % Kg
Torque = [300, 330, 370, 400, 450, 470, 520, 580, 620, 660, 680, 670, 640, 620, 600, 590, 570];
RPM =    [2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000];
gear_ratios = [3.1, 2.3, 1.9, 1.7, 1.5, 1.4];
Final_ratio = 2.8;
Tire_radious = 0.355;% m
Brakes_G_Force = 1; % G
rolling_coef = 0.396;

% Aerodynamic
drag_coef = 0.335;% at 20 FRH and 40 RRH
Area = 1.475;% m^2

% Scenario
air_t = 23;% C degrees
atm_p = 1000;% mbar
V_initial = 135;% Km/h
V_final = 200;% Km/h
straight_length = 800;% m

distance=linspace(1,straight_length,straight_length); % generate array of distances




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                              Execution                              %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf ('\n----------------------------------------------------------\n');
fprintf ('Analyzing Straight Sector of length %d m.\n', straight_length);

% Calculate the accelertion part of the sector
[speed_acc, acceleration, gear, t_acc, RPM] = Straight_Acc_Simulation(pi...
    , Total_Mass, Torque, RPM, gear_ratios, Final_ratio, Tire_radious...
    , drag_coef, Area, air_t, atm_p, V_initial, straight_length...
    , rolling_coef, g);

% Plotting Acceleration
set(figure,'Name','Acceleration','NumberTitle','off');
subplot(3,1,1);
plot(distance,speed_acc);
ylabel('Speed [Km/h]');
grid on;
subplot(3,1,2);
plot(distance,gear);
ylabel('Gear');
grid on;
subplot(3,1,3);
plot(distance,RPM);
xlabel('Distance [m]');
ylabel('RPM');
grid on;

% Calculate the braking part of the sector
[speed_brake, deceleration, F_brake, Fd_brake, t_brake] = Straight_Braking_Simulation(Total_Mass...
    , Brakes_G_Force, drag_coef, Area, air_t, atm_p, V_final, straight_length...
    , rolling_coef, g);

% Plotting Braking
set(figure,'Name','Braking','NumberTitle','off');
subplot(4,1,1);
plot(distance,speed_brake);
ylabel('Speed [Km/h]');
grid on;
subplot(4,1,2);
plot(distance,F_brake);
ylabel('Total Braking Force [N]');
grid on;
subplot(4,1,3);
plot(distance,Fd_brake);
ylabel('Aero Braking Force [N]');
grid on;
subplot(4,1,4);
plot(distance,deceleration);
xlabel('Distance [m]');
ylabel('Deceleration [m/s^2]');
grid on;


% Plotting acceleration and braking together
set(figure,'Name','Straight Sector','NumberTitle','off');
plot(distance,speed_acc,distance,speed_brake);
legend('Acceleration','Braking');
grid on;


speed = zeros(1,straight_length); % array to keep speed (kmh) on every point
t = zeros(1,straight_length); % array to keep speed (kmh) on every point
acc_time=0;
brake_time=0;

if length(speed_acc)~=length(speed_brake)
    % Warning message if the amount of samples of acceleration and braking
    % are not equal. Cancel execution.
    fprintf('!! Warning: Acceleration speed array and Braking Speed array have different lengths !!!')
else
    % We are going to find the maximum speed the vehicle can accelerate before
    % applying brakes to satisfy the speed at the final of the sector. 
    % Since the vehicle has more deceleration than acceleration, the slope
    % of the braking speed is bigger than the slope on the acceleration
    % speed. Therefore the braking speed will be bigger than the
    % acceleration speed as long as the maximum speed point has not been
    % reached.    
    for i=1:length(speed_acc)
        if speed_acc(i)<speed_brake(i)
            % If the braking speed is bigger than the acceleration speed we
            % use the acceleration speed since the car is still speeding
            % up.
            speed(i) = speed_acc(i);
            t(i) = t_acc(i);
            acc_time = acc_time + t_acc(i);
        else
            % If the acceleration speed is bigger than the braking speed,
            % then we use the braking speed assuming the car has already
            % started the braking phase.
            speed(i)=speed_brake(i);
            t(i) = t_brake (i);
            brake_time = brake_time + t_brake(i);
        end
    end
end

% Plotting acceleration and braking
set(figure,'Name','Straight Sector','NumberTitle','off');
plot(distance,speed);
xlabel('Distance [m]');
ylabel('Speed [Km/h]');
grid on;



sector_time=0;
for i=1:length(t)
    sector_time = sector_time + t(i);
    if i==1
        t(i)=t(i);
    elseif i>1
        t(i)=t(i-1)+t(1);
    end
end

fprintf ('The sector time is %d seconds (%d s accelerating and %d s under braking)\n', sector_time, acc_time, brake_time);
fprintf ('----------------------------------------------------------\n');

end