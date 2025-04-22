%% Ítem 2 y 3 - Trabajo Práctico


% Descripción:
% Este script resuelve el ítem 2 del trabajo práctico.

% ---------------------------------------------------
% 1. Leer los datos desde el archivo Excel
data = readtable('Curvas_Medidas_RLC_2025.xls');
% 2. Asignar columnas a variables
tiempo = data{:,1};         % tiempo en segundos
corriente_L = data{:,2};    % corriente en amperios
tension_C = data{:,3};      % tensión en el capacitor en voltios
% 3. Definir rango de interés (10 ms a 15 ms)
t_inicial = 10e-3;
t_final = 15e-3;
rango_valido = (tiempo >= t_inicial) & (tiempo <= t_final);
% 4. Recortar los vectores según la máscara
tiempo_recortado = tiempo(rango_valido);
corriente_L_recortada = corriente_L(rango_valido);
tension_C_recortada = tension_C(rango_valido);
% 5. Graficar los datos recortados
figure;
plot(tiempo_recortado, tension_C_recortada, 'b', 'DisplayName', 'Tensión en el capacitor');
hold on;
plot(tiempo_recortado, corriente_L_recortada, 'r', 'DisplayName', 'Corriente en la bobina');
xlabel('Tiempo [s]');
ylabel('Magnitudes');
title('Datos entre 10 ms y 15 ms');
legend;
grid on;
% ---------------------------------------------------
% 6. MÉTODO DE CHEN - Con puntos seleccionados manualmente
% Ingresá los tiempos (en segundos) y los valores medidos de salida
t1 = 0.00025;    y1 = 4.82483;
t2 = 0.0005;    y2 = 7.73008;
t3 = 0.00075;    y3 = 9.45898;
% Amplitud del escalón aplicado (por ejemplo, 12 V)
StepAmplitude = 12;
% Normalización a escalón unitario
K = 1;  % ganancia asumida 1
k1 = (y1 / StepAmplitude) / K - 1;
k2 = (y2 / StepAmplitude) / K - 1;
k3 = (y3 / StepAmplitude) / K - 1;
% Cálculo del método de Chen
b = 4*(k1^3)*k3 - 3*(k1^2)*(k2^2) - 4*(k2^3) + k3^2 + 6*k1*k2*k3;
a1 = (k1*k2 + k3 - sqrt(b)) / (2*(k1^2 + k2));
a2 = (k1*k2 + k3 + sqrt(b)) / (2*(k1^2 + k2));
beta = (k1 + a2) / (a1 - a2);
T1 = real(-t1 / log(a1));
T2 = real(-t1 / log(a2));
T3 = real(beta * (T1 - T2) + T1);
% Crear modelo de Chen como función de transferencia
s = tf('s');
G_chen = K * (T3*s + 1) / ((T1*s + 1)*(T2*s + 1));
% ---------------------------------------------------
% 7. Comparar datos reales vs modelo de Chen
% Crear vector de tiempo para simular
t_sim = linspace(tiempo_recortado(1), tiempo_recortado(end), length(tiempo_recortado));
% Simular respuesta al escalón de amplitud 12V
y_modelo = StepAmplitude * step(G_chen, t_sim);
% Graficar comparación
figure;
plot(tiempo_recortado, tension_C_recortada, 'b', 'DisplayName', 'Datos reales');
hold on;
plot(t_sim, y_modelo, 'k--', 'LineWidth', 2, 'DisplayName', 'Modelo de Chen');
xlabel('Tiempo [s]');
ylabel('Tensión en el capacitor [V]');
title('Comparación: Datos reales vs. modelo de Chen');
legend;
grid on;
simplify(G_chen)
%OBTENER LOS VALORES R,  L y C
%sabiendo que R=220 Ohms y que el numerador es igual a 1 (el cero extra puede haber aparecido %producto de la selección de puntos
[num, den] = tfdata(G_chen, "vector");
R = 220;
a2 = den(1);  % coeficiente de s^2
a1 = den(2);  % coeficiente de s^1
% Se asume que la función de transferencia teórica es:
% G(s) = 1 / (L*C*s^2 + R*C*s + 1)
%% Así se identifican:
%   L * C = den(1)
%   R * C = den(2)
% Calcular C a partir de R * C = den(2)
C = den(2) / R
% Calcular L a partir de L * C = den(1)
L = den(1) / C


% ---------------------------------------------------


%Ahora Item 3: 



% 8.Simular la corriente teórica (modelo con salida I(s)/Vin(s))

% Función de transferencia de corriente asociada a la tensión en el capacitor:
% I(s)/Vin(s) = s*C / (L*C*s^2 + R*C*s + 1)
numerador_corriente = [C 0];  % s*C
denominador_corriente = [L*C R*C 1];  % LC*s^2 + RC*s + 1

G_corriente_ideal = tf(numerador_corriente, denominador_corriente);

% Simular respuesta en corriente al escalón de 12V
corriente_ideal = StepAmplitude * step(G_corriente_ideal, t_sim);

% Graficar comparación entre corriente real y corriente estimada (modelo Chen)
figure;
plot(tiempo_recortado, corriente_L_recortada, 'r', 'DisplayName', 'Corriente real (medida)');
hold on;
plot(t_sim, corriente_ideal, 'g--', 'LineWidth', 2, 'DisplayName', 'Corriente simulada (Chen)');
xlabel('Tiempo [s]');
ylabel('Corriente [A]');
title('Comparación: Corriente real vs. modelo Chen (corriente teórica)');
legend;
grid on;
