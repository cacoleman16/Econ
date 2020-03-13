
%% This file creates the Historical Decomp for Homework 3, ECO 761
%%%       Outline    %%%
% 1) Reads in the data and intaializes values
% 2) Calculates the VAR and IRF
% 3) Gives weights for each of structural shocks at a given time horizon
% 4) Plots the Histroical Decompostion for each varaible
% like figure 4.2 Kilan Lutz 


%% Section 1) Read in and intialize the data
clear;
close all;


%This defines variables that are global, meaning the all files interacting
% with this script will use them.
global h t;

h=15;           % Maximum impulse response horizon
p=4;            % Lag order

%I read the data in as a table, but we want it in matrix form
y = readtable('/Users/chase/Downloads/bpdata.xlsx','ReadRowNames',true);

% The order is y ,t, g. We want the order to be t,g,y T
% This selects each row ":" from speficifed columns.
%Notation is written as X(row, column).
y = y(:, {'t', 'g', 'y'});
% We need the data as an array, this function does the conversion.
y = table2array(y);

% The number of rows is the number of time horizons and the number of
% columns is the number of parameters. So this says: Take the [row,column]
% length of y.
[t,q]=size(y); 

% This plots GDP, I do this to decide when I want do the bargraphs 
figure 
plot(y(:,3))


%% Section 2) Calculate the VAR and IRF
% It does the VAR estiamtion a la OLS
[A,SIGMA,Uhat,V,X] = var_ols(y,p);
% y       Data matrix
% B0inv   Structural multiplier matrix
% A       Companion matrix
% p       Lag order
% Uhat    Residual matrix

% I'll do two specfications, one following original, one with chol, here I
% just pick when to use by setting cholesy to true or false

cholesky = true; 
if cholesky == true
    Uhat = Uhat(1:3,:);
    B0inv = chol(SIGMA)';
    B0inv = B0inv(1:3,1:3);
    What=inv(B0inv)*Uhat;
else 
    Uhat = Uhat(1:3,:);
    B0inv = (SIGMA)';
    B0inv = B0inv(1:3,1:3);
    What=inv(B0inv)*Uhat;
end 

% Note to self, i need to get the dmiensions for these shocks correcoty
% then i must figure out which shock i want to graph .
% Compute structural multipliers for a horizon of t-p

IRF=IRF_cholesky(A,B0inv,p,q,t-p-1);

%% Section 3) Weight the Estimated Structral Shocks 

% So here we are weighting  the effect for a given shock on GDP, meaning
% each structural shock will be in respect to the 3rd varaible GDP. So we
% think of the index like this: shock as a result of GDP on tax in position
% 3, shock as a result of GDP on gov 6, and for GDP in spot 9. If we did
% this for tax, then we would make the first index in IRF(w,1:i) where w =
% {1,5,7} and {3,6,9} for shocks in goverment 
yhat1=zeros(t-p,1); yhat2=zeros(t-p,1); yhat3=zeros(t-p,1); 
for i=1:t-p
    yhat1(i,:)=dot(IRF(3,1:i),What(1,i:-1:1));
    yhat2(i,:)=dot(IRF(6,1:i),What(2,i:-1:1));
    yhat3(i,:)=dot(IRF(9,1:i),What(3,i:-1:1));  
end;

%% Section 4) Plot the histrorical decomposition


% Here I make the time variable for the x-axis, because there are 4 lags,
% I start at 1951, four quarters after the start of the data.
time = datetime(1951,01,01):calquarters(1):datetime(2015,07,01); 



subplot(q ,1,1)
plot(time,detrend(y(5:263,3)),'k-','linewidth',3);
title(' Detrended GDP real per capita ','fontsize',18)
ylabel('dollars?','fontsize',18)
grid on


% Histroical Decompostion of Spending, Yhat1
subplot(q,1,2)
plot(time,yhat1,'k-','linewidth',3);
title('Cumulative Effect of Spending Shock on GDP', 'fontsize',18)
ylabel('Percent','fontsize',18)
grid on

% Histroical Decompostion of Tax, Yhat2
subplot(q,1,3)
plot(time, yhat2,'k-','linewidth',3);
title('Cumulative Effect of Tax Shock on GDP','fontsize',18)
ylabel('Percent','fontsize',18)
grid on




