%Sistema para Simulação do tanque de aquecimento
function [sys,x0,str,ts] = Tanque01(t,x,u,flag)
switch flag,

 case 0
    [sys,x0,str,ts]=mdlInitializeSizes; % Initialization

 case 1
    sys = mdlDerivatives(t,x,u); % Calculate derivatives


 case 3
    sys = mdlOutputs(t,x,u); % Calculate outputs
 
  case { 2, 4, 9 },
    sys = [];
  otherwise
    error(['Unhandled flag = ',num2str(flag)]); % Error handling

end
% end csfunc

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes

sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 9;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = [26];
str = [];
ts  = [0 0];

% end mdlInitializeSizes
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

V= u(6);            %Volumen 0.0261 [m^3]
den=u(7);           %Densidad Especifica del agua [1000 Kg/m^3] 
Cp= u(8);           %Calor especifico do líquido  [4.176 kJ/kg.K]
Cpared= u(9);       %Capacidad de Calor del acero inox [16.3 (W/(m·K))] 
Ti=u(1);            %Temperatura inicial del Tanque [°C]        
T=x(1);             %Temperatura interna del Tanque [°C]
Qporc=u(3);         %Cantidad de Energía Suministrada 4 [KJ]
Alpha_Isol=u(5);    %Coef de transferecnia de Calor insolamiento [80 W/m^2K]
Tamb=26;            %Temperatura Ambiente 23 [°C]
Fi=u(2);            %Flujo de entrada   [0.0000439 m^3/seg]
Fo=Fi;
For01=(V*den*Cp+Cpared);
Tref=u(4);
deltaT=(2*Tref-(Ti+T))/2;
Qelect=Qporc*6/100;

sys(1)=((Fi*Cp*(Ti-T))/For01)+((Qelect*deltaT)/For01)-((Alpha_Isol*(T-Tamb))/For01);%-((Fo*den*Cp*(T-Tref))/For01)%Definitivo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% end mdlDerivatives
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
sys(1) = x(1);% Salida de Temperatura
%
% end mdlOutputs
