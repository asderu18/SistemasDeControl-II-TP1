Ra = 2.41356;
Laa = 0.00707;
Bm = 0;
J = 0.002133;
Km = 0.232629;
Ki = 0.2743;

% Armo las matrices del espacio de estados según las ecuaciones de estado
% y la ecuación de salida:
A = [-Ra/Laa, -Km/Laa, 0; 
    Ki/J, -Bm/J, 0; 
       0, 1, 0];
B = [1/Laa, 0; 
    0, -1/J;
    0, 0];
C = [0, 1, 0];
D = [0, 0];

% Calculo los autovalores de A para evaluar estabilidad (polos de FT), y
% tomamos su módulo para cálculos posteriores (omitiendo el 0):
polos = eig(A)
mod_polos = abs(real(polos));
mod_polos_sin_0 = mod_polos(mod_polos ~= 0);

% Definimos el polo más cercano y más lejano al origen
polo_cercano = min(mod_polos_sin_0)
polo_lejano = max(mod_polos_sin_0)

% Tiempo asociado al polo más rápido (mayor abs de parte real)
tR = -log(0.95)/polo_lejano

% Tiempo asociado al polo más lento (menor abs de parte real)
tL = -log(0.05)/polo_cercano

% Definimos el tiempo de simulación y de muestreo
t_sim = 1.5;
t_muestreo = 1e-5;
num_puntos = round(t_sim/t_muestreo) + 1;

% Inicializamos valores
t2 = linspace(0, t_sim, num_puntos);
u = zeros(1, num_puntos);
TL = zeros(1, num_puntos);
Ia = zeros(1, num_puntos);
Wr = zeros(1, num_puntos);
Tita = zeros(1, num_puntos);

% Definimos el vector de estados
x = [0 0 0]'; % Condiciones iniciales
x0 = [0 0 0]'; % Punto de operación

% Le damos valores a la salida y las variables de estado en cada punto
for i = 1:(t_sim/t_muestreo) - 1;
  if(t2(i) > 0.1)
    u(i) = 2;
  end

  if (t2(i) > 0.7)
    TL(i) = 0.12;
  end
  if (t2(i) > 1)
    TL(i) = 0;

    end
  % Ecuaciones de estado y de salida
  x_punto = A*(x - x0) + B*[u(i) TL(i)]';
  x = x + x_punto*t_muestreo; % Integración de Euler
  y = C*x;

  % Salidas y variables de estado
  Wr(i+1) = y;
  Ia(i+1) = x(1);
  Tita(i+1) = x(3);
end

%Finalmente grafico la entrada, salida y variables de estado
figure;
subplot(4,1,1);
plot(t2, Wr, "linewidth", 1.2);
title('Velocidad angular');
xlabel('Tiempo (s)');
ylabel('Vel. angular (rad/s)');
grid on

subplot(4,1,2);
plot(t2, Ia, "linewidth", 1.2);
title('Corriente en la armadura');
xlabel('Tiempo (s)');
ylabel('Corriente (A)');
grid on;

subplot(4,1,3);
plot(t2, u, "linewidth", 1.2);
title('Tensión de entrada');
xlabel('Tiempo (s)');
ylabel("Voltaje (V)");
grid on;

subplot(4,1,4);
plot(t2, TL, "linewidth", 1.2);
title('Torque de carga');
ylabel("Torque (N.m)");
xlabel('Tiempo (s)');
grid on;