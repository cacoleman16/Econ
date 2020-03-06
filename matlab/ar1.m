
%% This file simulates an AR1 process then graphes the spectrum 
clear all; close all; clc;

T     = 300;            %Number of Observations
y     = ones(T,1);      %Initialize Simulation Vector
y(1)  = 0;              %Set the first obs. to 0   
rho1  = 0.8;            %Set the value of the coefficient on y(t-1                     
eps = randn(300,1);


for t=2:T                    %Starts at two because y(1) = 0
    y(t) = rho1*y(t-1)+ eps(t);    %The AR(1) model
end

%Plot the series
figure
plot(y);
title('AR(1)');
xlabel('t')
ylabel('y(t)')

v = ones(100,1); %Initialize the frequency vector
omega = linspace(0, pi, 100)'; % 100 frequicnies between 0 and pi
s = ones(100,1); %Initialize the Spectrum vector
for p = 1:length(s) %loop through the omegas
s(p) = 1 / ((2*pi) * (1 - 2*(0.8)*cos(omega(p))+(0.8)^2)); %The Spectrum
end



figure
plot(omega, s);
title('AR(1) Spectrum');
xlabel('omega')
ylabel('s(omega)')
