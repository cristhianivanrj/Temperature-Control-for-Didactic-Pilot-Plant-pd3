function F=Funcion_Objetivo_PID(x)

Kpm=x(1); %Constante Proporcional
Kim=x(2); %Constante Integral
Kdm=x(3); %Constante Derivativa

%%%%%%% Guarda las constantes para ser usadas en simulink %%%%%%%%
save Kpm; 
save Kim;
save Kdm;
%%%%Restricciones según Criterios de Diseño %%%%%%
%Mp<= 4 %
%
%

% correr simulink e obtener Valores simulados

sprintf('Kp=%3.3f, Ki=%3.3f, Kd=%3.3f',x(1),x(2),x(3)) 
%Simular = sim('Stank_01',[0 1000]);

%%%%%% Conocer los parametros de simulación del modelo%%%%%

load('Kpm.mat');
load('Kdm.mat');
load('Kim.mat');


simOut = sim('Opt_Tanque02','SimulationMode','normal','AbsTol','auto',...
            'StopTime', '200', ... 
            'ZeroCross','off', ...
            'SaveTime','on','TimeSaveName','tout', ...
            'SaveState','off','StateSaveName','xout',...
            'SaveOutput','on','OutputSaveName','yout',...
            'SignalLogging','on','SignalLoggingName','logsout', 'ReturnWorkspaceOutputs', 'on');

        
%%%%%%%%%%%%%%%%%%%%%%%%%%5
TransResp = simOut.get('TransResp');
Tiempo = TransResp.time;
Amplitud = TransResp.signals.values;
figure(1)
grid
plot(Tiempo,Amplitud,'color',rand(1,3))
grid
hold on
yfinal=38; % SetPoint Dato importante
Parametros = stepinfo(Amplitud,Tiempo);
Vest=(double(Parametros.SettlingMax) + double(Parametros.SettlingMin))/2;
error= double(yfinal-Vest);
Parametros = stepinfo(Amplitud,Tiempo,yfinal);
Tss=double(Parametros.SettlingTime);    %Tiempo de Estabilización
Tr=double(Parametros.RiseTime);         %Tiempo de Levantamiento
Tp=double(Parametros.PeakTime);         %Tiempo de Sobre impulso
Mp=double(Parametros.Overshoot);        %Sobre Impulso [%]
Peak=double(Parametros.Peak);           %Pico Maximo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Asiganción de pesos Función Objetivo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W_Tss=30;
W_Tr=30;
W_Tp=10;
W_err=100;
W_Peak=10;

%Peaks=W_Peak*(Peak+Mp)
Peaks=W_Peak*(Mp+Peak);
Tiempos=(W_Tss*Tss+W_Tr*Tr+W_Tp*Tp);
Errores=W_err*abs(error)

F=Tiempos + Errores + Peaks
 