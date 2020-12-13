close all, clear all, clc
%% Varibales del video
videoReader=VideoReader('walk.mp4');
videoHeight=videoReader.Height;
videoWidth=videoReader.Width; 
fps=get(videoReader,'FrameRate');
mov=struct('cdata',zeros(videoHeight,videoWidth,3),'colormap',[]);
    %cdata is color data, it indicates RGB values directly

%% Obtiene la información de c/frame del video
i=1;
while hasFrame(videoReader) 
    mov(i).cdata=readFrame(videoReader);
    i=i+1;
end

%% Muestra imagen y video
fg(1)=image(mov(1).cdata);
set(gcf,'position',[150 150 videoWidth videoHeight]);
set(gca,'units','pixels');
set(gca,'position',[0 0 videoWidth videoHeight]);
figure (2)
movie(mov,1,fps);
%% Colores RGB
 %[110,44,48]  Rojo
 %[162,149,4]  Amarillo
 %[194,99,138] Rosa
 MatrizRGB=[110,44,48;162,149,4;194,99,138];
 imshowDis=[30,50,63];
 xCentros=[];yCentros=[];
%% Recorre los tres renglones de la matriz RGB [se analiza c/color]
for j=1:3
    %j=1;
    cColor=MatrizRGB(j,:); % valor RGB marcas
    k=1;
   for i=1:length(mov)-22 %Identifica el color, en todo el video
        %-Calcula la distancia
        [nR nC x]=size(mov(k).cdata);
        im=double(mov(k).cdata);
        for r=1:nR 
            for c=1:nC
                color=im(r,c,1:3); % Valores RGB´pixel especifico
                distColor(r,c)=sqrt((cColor(1)-color(1))^2 +(cColor(2)-color(2))^2 + (cColor(3)-color(3))^2);
            end
        end
        %-Convierte el frame del video a imagen
        I=imshowDis(j);
        fg(3)=imshow(distColor<I); 
        [img,Map]=frame2im(getframe(gca));
        umb=graythresh(img);
        bw=im2bw(img,umb);
        [L,Ne]=bwlabel(bw);% CREO QUE ESTO SE PUEDE OMITIR
        set(gca,'position',[0 0 1 1],'units','normalized')
        %-Calcular propiedades de los objetos en la imagen
        propied=regionprops(L);
        %-Buscar el area mayor (la mancha)
        s1=find([propied.Area]==max([propied.Area])); %El valor en el struct
        %-Calcula centros
        centros=[propied(s1).Centroid];
        xCentros(j,k)=centros(1);
        yCentros(j,k)=centros(2);
        %-Grafica sobre el frame correspondiente su centro
        image(mov(k).cdata);
        hold on 
        plot(xCentros(j,k),yCentros(j,k),'*r')
        pause(0.2)
        hold off
        k=k+1;
    end
end

%% Graficas Trayectoria
figure(5)
%scatter(xCentros(1,:),yCentros(1,:),'r')
plot(xCentros(1,:),yCentros(1,:),'r')
xlabel('x')
ylabel('y')
title('Cadera/Rojo')
figure(6)
%scatter(xCentros(2,:),yCentros(2,:),'y')
plot(xCentros(2,:),yCentros(2,:),'y')
xlabel('x')
ylabel('y')
title('Rodilla/Amarillo')
figure(7)
%scatter(xCentros(3,:),yCentros(3,:),'m')
plot(xCentros(3,:),yCentros(3,:),'m')
xlabel('x')
ylabel('y')
title('Tobillo/Rosa')
 %%Guardar en archivo .mat
save('Centros1','xCentros','yCentros')