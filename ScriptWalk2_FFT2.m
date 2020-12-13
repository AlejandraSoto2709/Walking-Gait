clear all, close all, clc 
load('Centros1')
%% Variables de c/trayectoria
xCadera=xCentros(1,:);
yCadera=yCentros(1,:);
xRodilla=xCentros(2,:);
yRodilla=yCentros(2,:);
xTobillo=xCentros(3,:);
yTobillo=yCentros(3,:);
%-Tiempo
tCadera=140:0.0001:620; 
tRodilla=140:0.0001:640;
tTobillo=140:0.0001:600;
%% Interpolacion y gráficas
%-CADERA
figure(1)
plot(xCadera,yCadera,'*r') 
hold on
grid on 
%-Método de interpolación que evita oscilaciones en los picos 
xm=[];
for i=1:length(xCentros(1,:))-1
   xm(i)=xCentros(1,i+1)-xCentros(1,i);
end
xm=mean(xm);
p=1/(1+((xm)^3/6)); %P="smoothing parameter"
pp_Cadera=csaps(xCentros(1,:),yCentros(1,:),p);
yy_Cadera=ppval(pp_Cadera,tCadera);
plot(tCadera,yy_Cadera,'k')

%-RODILLA
figure(2)
plot(xRodilla,yRodilla,'*y')
hold on 
grid on 
%-Método de interpolación que evita oscilaciones en los picos 
xm=[];
for i=1:length(xCentros(2,:))-1
   xm(i)=xCentros(2,i+1)-xCentros(2,i);
end
xm=mean(xm);
p=1/(1+((xm)^3/6)); %P="smoothing parameter"
pp_Rodilla=csaps(xCentros(2,:),yCentros(2,:),p);
yy_Rodilla=ppval(pp_Rodilla,tRodilla);
plot(tRodilla,yy_Rodilla,'k')

%-Tobillo 
figure(3)
plot(xTobillo,yTobillo,'*g')
hold on 
grid on 
%--Funcion que evita valores repetidos en X y regresión en los mismos
[XcentrosT,ind_unicos]=unique(xCentros(3,:));
Repetidos=setdiff(1:length(xCentros(3,:)),ind_unicos);
YcentrosT=yCentros(3,:);
for i=1:length(Repetidos)
    YcentrosT(Repetidos(i))=[];
end

%-Método de interpolación que evita oscilaciones en los picos 
xm=[];
for i=1:length(XcentrosT)-1
   xm(i)=XcentrosT(i+1)-XcentrosT(i);
end
xm=mean(xm);
p=1/(1+((xm)^3/6)); %P="smoothing parameter"
pp_Tobillo=csaps(XcentrosT,YcentrosT,p);
yy_Tobillo=ppval(pp_Tobillo,tTobillo);
plot(tTobillo,yy_Tobillo,'k')

%% Variables para Fourier
%-Frecuencia de Muestreo
Fs = 50;             
L= 500;
%-Periodo de Muestreo
T = 1/Fs;              
%% Calculo de la FFT
Y_Cadera=fft(yy_Cadera);
%-Señal de potencia abs = magnitud del num imaginario
P2Cadera = abs(Y_Cadera/L);
%-Mitad de la señal válida
P1Cadera = P2Cadera(1:L/2+1);             
P1Cadera(2:end-1) = 2*P1Cadera(2:end-1);
f = Fs*(0:(L/2))/L;

Y_Rodilla=fft(yy_Rodilla);
P2Rodilla = abs(Y_Rodilla/L);
P1Rodilla = P2Rodilla(1:L/2+1);
P1Rodilla(2:end-1) = 2*P1Cadera(2:end-1);

Y_Tobillo=fft(yy_Tobillo);
P2Tobillo = abs(Y_Tobillo/L);
P1Tobillo = P2Tobillo(1:L/2+1);
P1Tobillo(2:end-1) = 2*P1Cadera(2:end-1);
%% Filtrado (quitar frecuencias)
%-Umbral en magnitud de P2, lo menor se elimina
umbral = 0.8;        
Y2Cadera = Y_Cadera;
Y2CAdera(P2Cadera<umbral)=0+0i;

Y2Rodilla = Y_Rodilla;
Y2Rodilla(P2Rodilla<umbral)=0+0i;

Y2Tobillo = Y_Tobillo;
Y2Tobillo(P2Tobillo<umbral)=0+0i;

%% Recuperar la señal por la transformada inversa
y2Cadera=ifft(Y2Cadera);
y2Rodilla=ifft(Y2Rodilla);
y2Tobillo=ifft(Y2Tobillo);
%% Funciones orignales y filtradas
figure(1)
plot(tCadera,y2Cadera,'-.b')
title('Cadera/Rojo')
legend('Puntos','Original','Filtrada')
hold off
figure(2)
plot(tRodilla,y2Rodilla,'-.b')
title('Rodilla/Amarillo')
legend('Puntos','Original','Filtrada')
hold off
figure(3)
plot(tTobillo,y2Tobillo,'-.b')
title('Tobillo/Rosa')
legend('Puntos','Original','Filtrada')
hold off
%% Guardar en archivo .mat
save('SeñalesFourier1','Y_Cadera','Y_Rodilla','Y_Tobillo')