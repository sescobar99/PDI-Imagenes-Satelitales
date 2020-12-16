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
datastore = datastore('../Data/SATELLITE_1/landsat');
% datastore = datastore('../00I_Landsat_4_5_Visible');

folderName = 'SATELLITE_1'; %nombre de la carpeta en la que se van a guardar los datos
csv = []; %Se va a generar un resumen del resultado como csv

%--------------------------------------------------------------------------
%--2. Recorrer el dataset procesando cada imagen --------------------------
%--------------------------------------------------------------------------
%Podemos ir leyendo y aplicandole el proceso a las imagenes una a una.
ds_size = size(datastore.Files);
len = ds_size(1);

batch = 1; %modo batch
for i =1:len
    [a, info] = read(datastore); %Lectura de la imagen y obtencion de metadatos
    
    %Se obtiene el nuombre del archivo para guardar las imagenes y generar el csv
    fileName = split(info.Filename, filesep);
    
    imgPath = fileName(end-3:end);
    imgPath = strcat('.',filesep,imgPath(1),filesep,imgPath(2),filesep,imgPath(3),filesep,imgPath(4));
    
    fileName = fileName(end);
    str = split(fileName, '_');
    
    %obtener version del sensor
    ls_v = char(str(1));
    ls_v = ls_v(end);
    %Se obtiene la fecha y se convierte a formato AAAA-MM-DD (deprecated)
    %     date = char(str(4));
    %     date = insertAfter(date,4,'-');
    %     date = insertAfter(date,7,'-');
    
    %----------------------------------------------------------------------
    %--3. Preprocesamiento de la imagen -----------------------------------
    %----------------------------------------------------------------------
    %Se procesa la imagen y se retorna el numero de pixeles con vegetacion,
    %la imagen con la mascara de threshold, la image del ROI(en modo
    %interactivo es toda la imagen), y la imagen con la mascara del kmeans
    [vegetationIndex, maskedRGBImage,RGB,maskedKImage] = rotateCropAndProcess(a, batch,ls_v);
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %En la funcion rotateCropAndProcess se continua con el apartado 4
    
    %----------------------------------------------------------------------
    %--5. Persistencia de los datos ---------------------------------------
    %----------------------------------------------------------------------
    %Se forma string que sera guardado en csv
    record = [cellstr(imgPath), vegetationIndex];
    csv = [csv; record];
    
    fileName = char(fileName);
    %Se guardan las dos imagenes con las mascaras (kmeans, threshold)
    %FILENAME = ['../Data/SATELLITE_1/kmeans/' char(fileName)];
    FILENAME = strcat('..', filesep, 'Data', filesep, folderName, filesep, 'kmeans', filesep, fileName);
    imwrite(maskedKImage,FILENAME);
                
    %FILENAME = ['../Data/SATELLITE_1/thresholding/' char(fileName)];
    FILENAME = strcat('..', filesep, 'Data', filesep, folderName, filesep, 'thresholding', filesep, fileName);          
    imwrite(maskedRGBImage,FILENAME);
    
    %Imprimir el numero actual de la iteracion
    disp(i)
end

%Guardar csv
%writecell(csv,'../Data/SATELLITE_1/data.txt');
writecell(csv,strcat('..', filesep, 'Data', filesep, folderName, filesep, 'data.csv'));
          


%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA PRINCIPAL ------------------
%--------------------------------------------------------------------------
%% 

function [vegetationIndex, maskedRGBImage,RGB,maskedKImage] = rotateCropAndProcess(a, batchMode, landsat)
%Esta funcion rota*, corta*, y llama a create mask para que procese la imagen
%*si modo batch = 1
%Retorna: El numero de pixeles de vegetacion(OR entre mascara verde de 
%K-means y mascara de threshold) en vegetationIndex. La imagen con la 
%mascara del treshlod aplicaeda en maskedRGBIMage. La ROI en RGB. La imagen
%con la mascara verde de k-means aplicada en maskedKImage

%--------------------------------------------------------------------------
%--3. Preprocesamiento de la imagen ---------------------------------------
%--------------------------------------------------------------------------
b = a;

%Seleecion de modo batch. En el modo batch se rotan las imagenes y se
%recorta el area de interes ya que son valores hallados experimentalmente
%para landsat 4,5 y 8
if(batchMode == 1)
    if(landsat == 8)
        degree = 12;
        auxC = 1.0e+03*[2.8, 4, 5.9-2.8, 7.1-4];
    else
        degree = 8;
        auxC= 1e3 * [2.7 3.6 6-2.7 6.5-3.6];
    end
    b = imrotate(a,degree, 'crop'); %rotacion
    b = imcrop(b,auxC); %recorte
end

%--------------------------------------------------------------------------
%--4. Procesamiento de la imagen ------------------------------------------
%--------------------------------------------------------------------------
[~,maskedRGBImage,RGB,maskedKImage, ~,vegetationIndex, ~, ~, ~, ~, ~] = createMaskV2(b);
% [BW,maskedRGBImage,RGB,maskedKImage, maskedFinalImage,vegetationIndex, n, b, k3c1, k3c2, k3c3] = createMaskV2(b);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
end

function NewCharArray = insertAfter( CharArray, Position, WhatToInsert)
  NewCharArray = char( strcat( cellstr(CharArray(:,1:Position)), cellstr(WhatToInsert), cellstr(CharArray(:, Position+1:end)) ) );
end

