%--------------------------------------------------------------------------
%------- Seguimiento de cambios de vegetación mediante mapas satelitales --
%------- Por: Jairo David Campaña Rosero   jairo.campana@udea.edu.co ------
%-------      CC 1010060870 -----------------------------------------------
%-------      Santiago Escobar Casas       santiago.escobar8@udea.edu.co --
%-------      CC 1214746431 -----------------------------------------------
%-------      Estudiantes de ingenieria de sistemas UdeA ------------------
%------- Curso: Procesamiento digital de Imágenes -------------------------
%------- Noviembre 2020 ---------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%--1. Inicializo el sistema -----------------------------------------------
%--------------------------------------------------------------------------

clear all   % Inicializa todas las variables
close all   % Cierra todas las ventanas, archivos y procesos abiertos
clc         % Limpia la ventana de comandos
%Se carga la carpeta en la que estan las imagenes como un datastore
datastore = datastore('../00I_Landsat_8/');

%Podemos ir leyendo las y mostrando las imagenes una a una.
%En este ejemplo nos quedaremos con una escogida previamente.
ds_size = size(datastore.Files);
len = ds_size(1);
% for i =1:len 
%     a = read(datastore);
%     imshow(a);
%     pause();
% end

a = imread('../Test_Images/Image_1.jpg');
figure(1);imshow(a); %Imagen con la que se va a trabajar

%--------------------------------------------------------------------------
%-- 2. Preprocesado de la imagen ------------------------------------------
%--------------------------------------------------------------------------

%---- Rotacion con un valor hallado experimentalmente----------------------

b = imrotate(a,12, 'crop');
figure(2);imshow(b); %Imagen rotada


%---- Recorte con valores hallados experimentalmente ----------------------
%- En futuros avances se pretende realizar el recorte sistematicamente ----
%- para solo trabajar sobre el area de interes, por lo que el recorte no --
%- sera utilizado en este ejemplo -----------------------------------------

% %matriz con los valores para realizar el recorte
% auxR = 1.0e+03*[3.0305    3.4215    2.8550    2.8670]; 
% b = imcrop(b,auxR); %Recorte de la imagen
% figure(3);imshow(b); %Imagen recortada


%--------------------------------------------------------------------------
%-- 3. Segmentado de la capa vegetal --------------------------------------
%--------------------------------------------------------------------------

%---- Segmentado usando valores hallados con la app "Color Thresholder" ---
%Internamente createMask convierte la imagen a espacio de color lab y
%realiza threshold con valores hallados experimentalmente
[BW,maskedRGBImage] = createMask(b);
figure(4);imshow(BW); %mascara binaria
figure(5);imshow(maskedRGBImage);%imagen original con la mascara aplicada

%---- Segmentado usando k-means -------------------------------------------
%- El codigo y las imagenes se encuentran en los respectivos archivos de
%- k-means ../K-means/K-means_3 y ../K-means/K-means_4


%---- Segmentado usando la funcion multithresh. Por el momento se ha ------
%---- abandonado, debido a que la funcion createMask y la segmentacion por-
%---- k-means han proporcionado mejores resultados ------------------------
% figure(7);
% for i= 1:8
%     thresh = multithresh(b,i);
%     c = rgb2gray(b);
%     seg_I = imquantize(c,thresh);
%     RGB = label2rgb(seg_I); 	
%     subplot(2,4,i);imshow(RGB);
%     title(strcat('RGB Segmented Image: ',num2str(i)));
% end

%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------
%% 

%--- Herramienta de recorte manual para hallar valores experimentalmente --
% [J,rect] = imcrop(b);
% auxR = rect;
% c = imcrop(b,auxR);
% figure();imshow(c);
% subplot(1,2,1)
% imshow(a)
% title('Original Image') 
% subplot(1,2,2)
% imshow(c)
% title('Cropped Image')

%---- Ciclo para hallar valor que se debe rotar la imagen------------------
% for angle = 0:20
%     b = imrotate(a,angle,'crop');
%     imshow(b);
%     title(['Angle: ' int2str(angle)]);
%     pause(0.1);
% end