%% Ítem 5- Trabajo Práctico


% Descripción:
% Este script resuelve el ítem 5 del trabajo práctico.

% Inicialmente, cargaremos la tabla con el siguiente script. 
% ----------------------------------------
% 1. Leer los datos de la primera hoja (valores)
data = readtable('Curvas_Medidas_Motor_2025_v.xls', 'Sheet', 1);
% 2. Asignar columnas según los títulos de la segunda hoja
tiempo = data{:,1};                % Tiempo [s]
velocidad = data{:,2};             % Velocidad angular [rad/s]
corriente_armadura = data{:,3};    % Corriente de armadura [A]
tension = data{:,4};               % Tensión aplicada [V]
torque_carga = data{:,5};          % Torque de carga T_L [Nm]
% 3. Parámetros gráficos
lw = 1.5;             % grosor de línea
fs = 12;              % tamaño de fuente
% 4. Crear los subplots
figure('Name', 'Variables del sistema motor', 'NumberTitle', 'off');
subplot(4,1,1);
plot(tiempo, velocidad, 'b', 'LineWidth', lw);
xlabel('Tiempo [s]', 'FontSize', fs);
ylabel('\omega [rad/s]', 'FontSize', fs);
title('Velocidad angular', 'FontSize', fs+1);
grid on;
legend('\omega(t)', 'Location', 'best');
subplot(4,1,2);
plot(tiempo, corriente_armadura, 'r', 'LineWidth', lw);
xlabel('Tiempo [s]', 'FontSize', fs);
ylabel('i_a [A]', 'FontSize', fs);
title('Corriente de armadura', 'FontSize', fs+1);
grid on;
legend('i_a(t)', 'Location', 'best');
subplot(4,1,3);
plot(tiempo, tension, 'k', 'LineWidth', lw);
xlabel('Tiempo [s]', 'FontSize', fs);
ylabel('V_a [V]', 'FontSize', fs);
title('Tensión aplicada', 'FontSize', fs+1);
grid on;
legend('V_a(t)', 'Location', 'best');
subplot(4,1,4);
plot(tiempo, torque_carga, 'g', 'LineWidth', lw);
xlabel('Tiempo [s]', 'FontSize', fs);
ylabel('T_L [Nm]', 'FontSize', fs);
title('Torque de carga', 'FontSize', fs+1);
grid on;
legend('T_L(t)', 'Location', 'best');


%El siguiente script fue utilizado para obtener Wr/Va y comparar como
%quedaba sin el coeficiente lineal de s en numerador.

% Además, combinandolo con una selección manual de puntos del ploteo
% anterior, me encargué de anotar manualmente los valores de la muestra
% Y(t),t necesarios
% para calcular la Ia/Va, dado que era más facil intervenir directamente
% sobre el código de esta manera. 

%% Chen vs Datos Reales (100 ms a 700 ms)
clear; clc; close all;
%% 1) Cargo y recorto datos
data = readtable('Curvas_Medidas_Motor_2025_v.xls','Sheet',1);
t     = data{:,1};      % Tiempo [s]
omega = data{:,2};      % Velocidad angular [rad/s]
Va    = data{:,4};      % Tensión aplicada [V]
mask    = (t>=0.100) & (t<=0.700);
t_rec   = t(mask);
omega_r = omega(mask);
Va_r    = Va(mask);
%% 2) Puntos de Chen (en segundos y rad/s)
% Utilizando los valores proporcionados
t1 = 0.100;    y1 = 4.94691; % Velocidad en t1
t2 = 0.200;    y2 = 6.72475; % Velocidad en t2
t3 = 0.300;    y3 = 7.32749; % Velocidad en t3
%% 3) Cálculo manual del método de Chen
StepAmp = 2;   % Amplitud del escalón [V]
Knorm   = 7.6231/2    % ganancia normalizada
k1 = (y1/StepAmp)/Knorm - 1;
k2 = (y2/StepAmp)/Knorm - 1;
k3 = (y3/StepAmp)/Knorm - 1;
b  = 4*k1^3*k3 - 3*k1^2*k2^2 - 4*k2^3 + k3^2 + 6*k1*k2*k3;
a1 = (k1*k2 + k3 - sqrt(b)) / (2*(k1^2 + k2));
a2 = (k1*k2 + k3 + sqrt(b)) / (2*(k1^2 + k2));
beta = (k1 + a2)/(a1 - a2);
T1 = -t1/log(a1);
T2 = -t1/log(a2);
T3 = beta*(T1 - T2) + T1;
%% 4) Función de transferencia de Chen
s     = tf('s');
Gchen = Knorm*(T3*s + 1)/((T1*s + 1)*(T2*s + 1));
%% 5) Simulo respuesta al escalón en t1
t0    = t_rec - t1;                  % eje de tiempo para step()
y_chen = StepAmp * step(Gchen, t0);  % escala a 12 V
%% 6) Gráficos
figure('Position',[100 100 600 500]);
% 6.1) Entrada de tensión
subplot(2,1,1);
plot(t_rec, Va_r, 'b', 'LineWidth',1.5);
xlabel('Tiempo [s]'); ylabel('V_a [V]');
title('Escalón de Tensión (100 ms–700 ms)');
grid on;
% 6.2) Velocidad real vs modelo de Chen
subplot(2,1,2);
plot(t_rec, omega_r, 'k',  'LineWidth',1.5, 'DisplayName','\omega real');
hold on;
plot(t_rec, y_chen,  'r--','LineWidth',1.5, 'DisplayName','\omega Chen');
xlabel('Tiempo [s]'); ylabel('\omega [rad/s]');
title('Comparación: Velocidad real vs Chen');
legend('Location','best');
grid on;
Gchen
Gchen2= 3.812/(0.004782*s^2+0.1426*s+1);
step(2*Gchen2,2*Gchen)

%% Los funciones finales del informe vienen dadas tras varias iteraciones de selección 
 % manual de puntos y comparación con los datos obtenidos. 

 