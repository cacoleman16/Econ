%% This simulates a data generating process then plots the autocovariance function for it.


clear all; close all; clc;

 %Simulate the process
Nlags=100;             % number of logs in autocov func
T     = 1000;          %Set how many observations you need
y     = ones(T,1);    %Create a vector of dim Tx1 to store the simulations
y(1:2,:) = 0;                 %Set the first two obs. to 0  
y(3)  = 1;                   %Set the third obs. to 1
rho1  = 0.9;                 %Set the value of rho1 
rho2  = 0.2;                 %Set the value of rho2        
sigma = .1;                  %Set the value of the s.d. of the error term
mu_e  = 0;                   %Set the value of the mean of the error term
eps  = normrnd(mu_e, sigma, T, 1);
eps(1:2,:)= 0;


for t=3:1000    %Start the loop running from obs. 4 to 1000 
    y(t) = rho1*y(t-1) + rho2*y(t-2) + eps(t)+ 1.3 * eps(t-1);%The AR(3) model
end
figure 
[Acf,lags]=xcov(y,Nlags, 'biased'); 
plot(lags,Acf, 'k-' )
xlabel('Lags');
title('Autocovaraince from Simultation');
grid



