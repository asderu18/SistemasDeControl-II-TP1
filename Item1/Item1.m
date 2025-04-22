%% Ítem 1 - Trabajo Práctico

% Descripción:
% Este script resuelve el ítem 1 del trabajo práctico.


clc;
clear;

fprintf("========== ÍTEM 1 ==========\n");
fprintf("Resolviendo el ítem 1 del TP...\n\n");


%Codigo para obtener G(s). 


% Item 1
% Asigno valores a mis componentes:
R = 220
L = 500e-3
Cap = 2.2e-6
%Con estos valores de componentes planteo las matrices:
A = [-R/L  -1/L  ;  1/Cap   0]  % MATRIZ DE ESTADOS
B = [ 1/L  ;  0]     % MATRIZ DE ENTRADA
C = [ R 0]        % MATRIZ DE SALIDA
D = [0]      % MATRIZ DE TRANSMISIÓN DIRECTA
% Obtener simulaciones que permitan estudiar la dinámica del sistema, con
% una entrada de tensión escalón de 12V que cada 10 mseg cambia de signo
%Primero quiero obtener la función de transferencia utilizando las matrices
% A B C D
[num,den] = ss2tf(A,B,C,D) %State Space to Transfer Function
%Teniendo mi numerador y denominador puedo plantear mi función de
%transferencia:
G = tf(num,den)



%Código para aplicar integración por Euler y obtener el vector X*
 % Paso 1: Inicializar variables
% Entrada constante (escalón de 12 V)
vin = 12;
% Tiempo total de simulación y paso de integración
T = 0.05;         % 50 ms
tp = 1e-6;        % paso de integración
N = round(T / tp);
t = linspace(0, T, N);

I = zeros(1, N);
Vc = zeros(1, N);
u = vin * ones(1, N);  % Entrada constante de 12V durante toda la simulación

% Estado inicial y punto de operación
x = [0; 0];       % [corriente; tensión]
xop = [0; 0];

% Paso 2: Simulación con integración de Euler
for i = 1:N-1
   xp = A * (x - xop) + B * u(i);
   x = x + xp * tp;
   I(i+1) = x(1);
   Vc(i+1) = x(2);
end


% Graficar resultados
figure;
subplot(3,1,1); plot(t, u, 'k', 'LineWidth', 2); grid on;
title('Tensión de entrada (Vin)'); xlabel('Tiempo (s)');
subplot(3,1,2); plot(t, Vc, 'b', 'LineWidth', 2); grid on;
title('Tensión en el capacitor (Vc)'); xlabel('Tiempo (s)');
subplot(3,1,3); plot(t, I, 'r', 'LineWidth', 2); grid on;
title('Corriente en el circuito (I)'); xlabel('Tiempo (s)');

%Código para obtener las simulaciones requeridas por consigna + un retardo
% para observar bien el comienzo del transitorio: 

clear all; clc; close all;
% Asigno valores a los componentes
R = 220;
L = 500e-3;
Cap = 2.2e-6;
vin = 12;  % Tensión constante de entrada
% Matrices del sistema en espacio de estados
A = [-R/L  -1/L; 1/Cap   0];
B = [1/L; 0];
C = [R 0];
D = [0];
% Paso 1: obtener la función de transferencia (opcional)
[num, den] = ss2tf(A, B, C, D);
G = tf(num, den);
% Paso 2: Definir tiempo de simulación
T = 0.2;          % 200 ms
tp = 1e-6;        % paso de integración
N = round(T / tp);  % cantidad de muestras
t = linspace(0, T, N);
% Paso 3: Inicializar variables
I = zeros(1, N);
Vc = zeros(1, N);
Il = zeros(1, N);
Vcl = zeros(1, N);
u = vin * ones(1, N);  % Inicializa la entrada
% Estado inicial y punto de operación
x = [0; 0];       % [corriente; tensión]
xop = [0; 0];
% Parámetros de retardo
retardo = 10000;  % Número de pasos que se quiere retrasar la señal
u_delay = zeros(1, N);  % Inicializa el vector de la señal de entrada con retardo
% Paso 4: Simulación con entrada que cambia de signo cada 10 ms
cambio_entrada_cada = round(0.01 / tp);  % 10 ms en pasos
for i = 1:N-1
   % Cambiar la entrada cada 10 ms
   if mod(i, cambio_entrada_cada) == 0
       vin = -vin;  % Cambia de signo la entrada
   end
  
   % Asignar el valor de la entrada a u
   u(i) = vin;
 
   % Aplicar retardo a la entrada
   if i > retardo
       u_delay(i) = u(i - retardo);
   else
       u_delay(i) = 0;
   end
   % Modelo en espacio de estados (Euler explícito)
   xp = A * (x - xop) + B * u_delay(i);
   x = x + xp * tp;
  
   Il(i+1) = x(1);
   Vcl(i+1) = x(2);
end
% Paso 5: Graficar resultados
figure;
subplot(3,1,1); plot(t, u_delay, 'k', 'LineWidth', 2); grid on;
title('Tensión de entrada (Vin) con cambio de signo cada 10 ms'); xlabel('Tiempo (s)');
subplot(3,1,2); plot(t, Vcl, 'b', 'LineWidth', 2); grid on;
title('Tensión en el capacitor (Vc)'); xlabel('Tiempo (s)');
subplot(3,1,3); plot(t, Il, 'r', 'LineWidth', 2); grid on;
title('Corriente en el circuito (I)'); xlabel('Tiempo (s)');
%Ítem [1]: Código para ver la evolución de las variables de estado con 
% entrada de 12V:

clear all; clc; close all;
% Parámetros del circuito
R = 220;
L = 500e-3;
Cap = 2.2e-6;
% Matrices del sistema en espacio de estados
A = [-R/L  -1/L; 1/Cap   0];
B = [1/L; 0];
C = [R 0];
D = [0];
% Entrada constante (escalón de 12 V)
vin = 12;
% Tiempo total de simulación y paso de integración
T = 0.05;         % 50 ms
tp = 1e-6;        % paso de integración
N = round(T / tp);
t = linspace(0, T, N);
% Inicialización de variables
x = [0; 0];       % Estado inicial: [corriente; tensión en el capacitor]
Il = zeros(1, N); % Corriente
Vc = zeros(1, N); % Tensión en el capacitor
u = vin * ones(1, N);  % Entrada escalón
% Simulación usando Euler
for i = 1:N-1
   xp = A * x + B * u(i);
   x = x + xp * tp;
  
   Il(i+1) = x(1);
   Vc(i+1) = x(2);
end
% Graficar resultados
figure;
subplot(2,1,1); plot(t, Vc, 'b', 'LineWidth', 2); grid on;
title('Tensión en el capacitor (Vc)'); xlabel('Tiempo (s)'); ylabel('Voltaje (V)');
subplot(2,1,2); plot(t, Il, 'r', 'LineWidth', 2); grid on;
title('Corriente en el circuito (I)'); xlabel('Tiempo (s)'); ylabel('Corriente (A)');
