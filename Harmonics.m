clear all, close all, clc 
load('SeñalesFourier1.mat')
%% Tiempo
tCadera=140:0.0001:640; 
tRodilla=140:0.0001:640;
tTobillo=140:0.0001:606;

%% Orden armónico
%-Cadera
PSC=abs(Y_Cadera);
Cadera_Series=2*abs(PSC./length(Y_Cadera));
figure(1)
stem(Cadera_Series(2:30),'filled','Color','r');
xlabel('Orden armónico')
ylabel('Amplitud')
title('Cadera/Rojo')
%-Rodilla
PSR=abs(Y_Rodilla);
Rodilla_Series=2*abs(PSR./length(Y_Rodilla));
figure(2)
stem(Rodilla_Series(2:30),'filled','Color','y');
xlabel('Orden armónico')
ylabel('Amplitud')
title('Rodilla/Amarillo')
%-Tobillo
PST=abs(Y_Tobillo);
Tobillo_Series=2*abs(PSR./length(Y_Tobillo));
figure(3)
stem(Tobillo_Series(2:30),'filled','Color','m');
xlabel('Orden armónico')
ylabel('Amplitud')
title('Tobillo/Rosa')