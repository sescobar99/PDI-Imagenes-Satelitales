%--------------------------------------------------------------------------
%------- Seguimiento de cambios de vegetación mediante mapas satelitales --
%------- Por: Jairo David Campaña Rosero   jairo.campana@udea.edu.co ------
%-------      CC 1010060870 -----------------------------------------------
%-------      Santiago Escobar Casas       santiago.escobar8@udea.edu.co --
%-------      CC 1214746431 -----------------------------------------------
%-------      Estudiantes de ingenieria de sistemas UdeA ------------------
%------- Curso: Procesamiento digital de Imágenes -------------------------
%------- Diciembre 2020 ---------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%--1. Inicializo el sistema -----------------------------------------------
%--------------------------------------------------------------------------

%clear all   % Inicializa todas las variables
clear variables
close all   % Cierra todas las ventanas, archivos y procesos abiertos
clc         % Limpia la ventana de comandos
%Se carga la carpeta en la que estan las imagenes como un datastore
datastore = datastore('../00I_Landsat_8/');
% datastore = datastore('../00I_Landsat_4_5_Visible/');

%Podemos ir leyendo y aplicandole el proceso a las imagenes una a una.
% ds_size = size(datastore.Files);
% len = ds_size(1);
len = dataLoaderL.size;
csv = [];

for i =1:5 %len
    node = getElement(i)
    imgPath = node.Data.imagePath;
    a = imread(imgPath);
%     [a, info] = read(datastore);
%     figure(1);imshow(a);
    


    [vegetationIndex, maskedRGBImage,RGB,maskedKImage] = rotateAndCrop(a);
    
    fileName = split(info.Filename, filesep);
    fileName = fileName(end);    
    str = split(fileName, '_');
    date = char(str(4));
    date = insertAfter(date,4,'-');
    date = insertAfter(date,7,'-');
    record = [date fileName vegetationIndex];
    csv = [csv; record];
    
    FILENAME = ['../SATELLITE_1/kmeans/' char(fileName)];
    imwrite(maskedKImage,FILENAME);
    
    FILENAME = ['../SATELLITE_1/landsat/' char(fileName)];
    imwrite(maskedRGBImage,FILENAME);
end
writecell(csv);


%--------------------------------------------------------------------------
%-- 2. Preprocesado de la imagen ------------------------------------------
%--------------------------------------------------------------------------

%---- Rotacion con un valor hallado experimentalmente----------------------

%%b = imrotate(a,12, 'crop');

%figure(2);imshow(b); %Imagen rotada


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
%%[BW,maskedRGBImage] = createMask(b);
%figure(4);imshow(BW); %mascara binaria
%%figure(5);imshow(maskedRGBImage);%imagen original con la mascara aplicada

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

function [vegetationIndex, maskedRGBImage,RGB,maskedKImage] = rotateAndCrop(a)
b = imrotate(a,12, 'crop');

%Opcion 1: Recortar solo el area de interes y pasarla asi
%Opcion 2: Recortar borde negro, pasarla asi y luego volver a recortar ROI
auxR = 1.0e+03*[2.8, 4, 5.9-2.8, 7.1-4];

% b = imresize(b,0.3);
% auxR = 1.0e+03*[0.18, 0.18, 2.02-0.18, 2.02-0.18]; % 30% quitar borde negro

b = imcrop(b,auxR);


[~,maskedRGBImage,RGB,maskedKImage, ~,vegetationIndex, ~, ~, ~, ~, ~] = createMaskV2(b);
% [BW,maskedRGBImage,RGB,maskedKImage, maskedFinalImage,vegetationIndex, n, b, k3c1, k3c2, k3c3] = createMaskV2(b);

end

function NewCharArray = insertAfter( CharArray, Position, WhatToInsert)
  NewCharArray = char( strcat( cellstr(CharArray(:,1:Position)), cellstr(WhatToInsert), cellstr(CharArray(:, Position+1:end)) ) );
end

