%% Ítem 4 - Trabajo Práctico


% Descripción:
% Este script resuelve el ítem 4 del trabajo práctico.
clear all; clc; close all;
% Parámetros del motor
Laa = 366e-6;      % H
Ra  = 55.6;        % Ohm
Ki  = 6.49e-3;     % Nm/A
Km  = 6.53e-3;     % V/(rad/s)
J   = 5e-9;        % kg*m^2
B   = 0;           % Nm/(rad/s)
% Matrices del sistema
A = [-Ra/Laa, -Km/Laa, 0;
     Ki/J ,  -B/J  , 0;
     0    ,   1    , 0];
Bmat = [1/Laa,   0;
        0   , -1/J;
        0   ,   0];
% Tiempo de simulación
T = 5;         % 
tp = 1e-7;        % paso de integración
N = round(T / tp);
t = linspace(0, T, N);
% Entradas: voltaje y torque de carga
va = 12 * ones(1, N);           % Escalón de 12V
Tl = 1.3e-3 * ones(1, N);       % Torque constante 0.2 mNm
u = [va; Tl];
% Inicialización de estados
x = [0; 0; 0];                  % [i_a; omega_r; theta]
ia = zeros(1, N);
w  = zeros(1, N);
theta = zeros(1, N);
% Simulación por Euler
for i = 1:N-1
   xp = A * x + Bmat * u(:, i);  % dx/dt
   x = x + xp * tp;
   ia(i+1)    = x(1);
   w(i+1)     = x(2);
   theta(i+1) = x(3);
end
% Graficar resultados
figure;
subplot(3,1,1); plot(t, ia, 'r'); grid on;
title('Corriente en el motor'); ylabel('i_a (A)');
subplot(3,1,2); plot(t, w, 'b'); grid on;
title('Velocidad angular'); ylabel('\omega_r (rad/s)');
subplot(3,1,3); plot(t, theta, 'g'); grid on;
title('Posición angular'); xlabel('Tiempo (s)'); ylabel('\theta (rad)');
 