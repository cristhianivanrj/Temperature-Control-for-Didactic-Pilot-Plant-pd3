%Sistema Intercambiador de calor
function [sys,x0,str,ts] = Tanque02(t,x,u,flag)
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
sizes.NumInputs      = 12;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = [30];
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


Tin_q=u(1);         %Temperatura de entrada del fluido caliente[°C]
Fin_q=u(2);         %Flujo de entrada agua caliente  [0.0000439 m^3/seg]
Fin_fria=u(3);      % Flujo de entrada agua fria [0.0000439 m^3/seg]
Tref=u(4);          %Temperatura de Referencia (SetPoint)
Alpha_Isol=u(5);    %Coef de transferecnia de Calor insolamiento [80 W/m^2K]
V= u(6);            %Volumen 0.0261 [m^3]
den=u(7);           %Densidad Especifica del agua [1000 Kg/m^3] 
Cp= u(8);           %Calor especifico do líquido  [4.176 kJ/kg.K]
Cpared= u(9);       %Capacidad de Calor del acero inox [16.3 (W/(m•K))] 
Tin_f=u(10);        %Temperatura de entrada del fluido frio [°C]
Fout1=u(11);         %Flujo de Salida Tanque de Mixtura  [0.0000439 m^3/seg]
Tamb=u(12);         %Temperatura Ambiente 23 [°C]       
T=x(1);             %Temperatura interna del Tanque [°C]

Fin_f= Fin_fria*(0.00507888889*10)/100;
For01=(V*den*Cp+Cpared);
Fout=Fin_q+Fin_f;
sys(1)=((Fin_q*Cp*den*(Tin_q-Tref))/For01)+((Fin_f*den*Cp*(Tin_f-Tref))/For01)- ((Fout*den*Cp*(T-Tref))/For01)-((Alpha_Isol*(T-Tamb))/For01);%

% end mdlDerivatives
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
sys(1) = x(1); % Salida Temperatura

%
% end mdlOutputs
