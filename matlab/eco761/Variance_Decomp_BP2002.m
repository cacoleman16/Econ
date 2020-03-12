
%% This file creates the var decomposition  for Homework 3, ECO 761
%%%%% Outline %%%%% 
% 1) First the program reads in the data, initalizing some values then
% resizes the excel file for the variables of interest. 
% 2) This section generetates the data structures from the VAR and 
% their impsle response functions.
% 3)Plots the Variance Decompostion in three subplots
% like figure 4.1 Kilan Lutz,





%% Section 1: Read in the data and intialize the set up
clear;


%This defines variables that are global, meaning the all files interacting
% with this script will use them.
global h t;

h=20;           % Maximum impulse response horizon
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

%% Section 2: Generates the VAR and IRF
% This fuction is from Lutz Kilian, 1997
% It does the VAR estiamtion a la OLS
[A,SIGMA,Uhat,V,X] = olsvarc2(y,p); 


% Creates the Impusle Response Functions
horizon=0:h;
[IRF]=IRF_cholesky(A,SIGMA(1:q,1:q),p,h,q);

% Quantifyings the effect of other variables on Tax
% IRF(4,:)=cumsum(IRF(4,:));
% IRF(7,:)=cumsum(IRF(7,:));
% % Quantifyings the effect of other variables on Gov
% IRF(2,:)=cumsum(IRF(2,:));
% IRF(8,:)=cumsum(IRF(8,:));
% Quantifyings the effect of other variables on GDP
IRF(3,:)=cumsum(IRF(3,:));
IRF(6,:)=cumsum(IRF(6,:));


%% Section 3: Plots the Variance Decomposition 
%Subplot lets you put multiple plots in one image. Since we need two plots,
%the syntax is subplot(rows, column, plot of reference)

% The syntax is plot(x,y, options). The options include things like making
% a line at zzero, picking the color of the plot to be red, font size,
% etc. Matlab keeps good documentation on the graphic functions online.
subplot(2,1,1)
plot(horizon, IRF(3,:),'r-',horizon,zeros(size(horizon)),'linewidth',3);
title('Spending Shock','fontsize',18)
ylabel('Percent','fontsize',18)
xlabel('Months','fontsize',18)
axis([0 h -5 5])

subplot(2,1,2)
plot(horizon,IRF(6,:),'r-',horizon,zeros(size(horizon)),'linewidth',3);
title('Tax Shock','fontsize',18)
ylabel('Percent','fontsize',18)
xlabel('Months','fontsize',18)
axis([0 h -5 5])






