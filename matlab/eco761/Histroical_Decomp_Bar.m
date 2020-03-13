
%% This file creates the Bar Graphes for Homework 3, ECO 761
%%%       Outline    %%%
% 1) Reads in the data and intaializes values
% 2) Calculates the VAR and IRF
% 3) Gives weights for each of structural shocks at a given time horizon
% 4) Generate the bar graphes for the chosen time horizon (1979.1 - 1990.1)
% 5) Plot the bar grahpes 
% like figure 4.3 Kilan Lutz 


%% Section 1) Read in and intialize the data
clear;
close all;


%This defines variables that are global, meaning the all files interacting
% with this script will use them.
global h t;

h=15;           % Maximum impulse response horizon
p=4;            % Lag order
start_time = 113; % 1979.1
end_time = 160; % `1990.1

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

%% Section 2) Calculate the VAR and IRF
% It does the VAR estiamtion a la OLS
[A,SIGMA,Uhat,V,X] = olsvarc4(y,p);
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
  
% Compute structural multipliers for a horizon of t-p
IRF=irfvar_hw2(A,B0inv,p,q,t-p-1);

% Compute structural shocks What from reduced-form shocks Uhat 

%% Section 3)

% Just like the Histroprical Decompostion, see that file for a clear
% explinations of how I form the yhats.
yhat1=zeros(t-p,1); yhat2=zeros(t-p,1); yhat3=zeros(t-p,1); 
for i=1:t-p
    yhat1(i,:)=dot(IRF(3,1:i),What(1,i:-1:1));
    yhat2(i,:)=dot(IRF(6,1:i),What(2,i:-1:1));
    yhat3(i,:)=dot(IRF(9,1:i),What(3,i:-1:1));  
end;
    

%% Section 4)
% Real GDP expressed in exact percent deviations from mean
gdp = y(:,3); % Real gdp per captia in levels 
gdpMean=mean(gdp);
gdpExa=((gdp-mean(gdp))./mean(gdp))*100; 

% Focus on 1979.1-1990.1
ytrue=deseasonal_quarter(gdpExa); ytrue=ytrue(start_time:end_time,1);
yhat1=yhat1(start_time:end_time,1);
yhat2=yhat2(start_time:end_time,1);
yhat3=yhat3(start_time:end_time,1);

           
% Bar chart cumulative GDP per captia change: 1979.1 - 1990.1

Dtrue=gdpMean*(1+ytrue(end)/100)-gdpMean*(1+ytrue(1)/100);
D1=gdpMean*(1+yhat1(end)/100)-gdpMean*(1+yhat1(1)/100);
D2=gdpMean*(1+yhat2(end)/100)-gdpMean*(1+yhat2(1)/100);
D3=gdpMean*(1+yhat3(end)/100)-gdpMean*(1+yhat3(1)/100);
D = {D1,D2,D3};
for i = 1:3;
   D{i} = abs(D{i});
end
%% Section 5)
names = {'Spending Shocks', 'Tax Shocks', 'GDP shocks' ,'Total'} ;   
subplot(1,1,1)
bar([D{1} D{2} D{3} abs(Dtrue)])
ylabel('Log( Real per captia Dollars)','fontsize',16)
set(gca,'xticklabel',names)
% axis([0 6 0 100])
grid on
