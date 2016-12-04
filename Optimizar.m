close all, clear all, clc
tic;
FitnessFunction = @Funcion_Objetivo_PID; % Function handle to the fitness function
numberOfVariables = 3; % Number of decision variables
lb = [-10;-10;-10]; % Lower bound
ub = [10;10;10]; % Upper bound
A = []; % No linear inequality constraints
b = []; % No linear inequality constraints
Aeq = []; % No linear equality constraints
beq = []; % No linear equality constraints
[x,Fval,exitFlag,Output,population,scores] = ga(FitnessFunction,numberOfVariables,A,b,Aeq,beq,lb,ub)
figure(2)
hold on
plot(x,Fval,'+');
tiempo=toc;

%Kp=x(1); %Constante Proporcional
%Ki=x(2); %Constante Integral
%Kd=x(3); %Constante Derivativa


