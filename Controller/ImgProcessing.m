classdef ImgProcessing
    methods(Static)        
        function processData(dataLoaderL)
            %Metodo para procesar las imagenes, recibe un dataset, lo
            %recorre y obtiene cada imagen para procesarla.
            %folderName es el nombre de la carpeta en la que se va a guardar
            %la informacion e.g. 'SATELLITE_1'
            
            %Se carga la carpeta en la que estan las imagenes
            datastore = dataLoaderL;
            path = datastore.images.Data.imagePath;
            

            %Podemos ir leyendo y aplicandole el proceso a las imagenes una a una.
            len = datastore.size;
                        
            %Creacion de csv para exportar datos
            csv = [];
            folderName = split(path, '\');
            folderName = folderName(3);
            for i =1:len
                
                node = datastore.getElement(i);%Lectura de la imagen
                imgPath = node.Data.imagePath;
                a = imread(imgPath); %Guardar imagen en a
                imgName = split(imgPath, '\');
                imgName = imgName(end);
                
                %Obtener nombre del archivo y guardarlo en fileName
                fileName = imgName;
                fileName = cellstr(fileName); %Convertir string a cell para facilitar al guardar csv
                str = split(fileName, '_');
                
                %Se obtiene la fecha y se convierte a formato AAAA-MM-DD
                date = char(str(4));
                date = ImgProcessing.insertAfter(date,4,'-');
                date = ImgProcessing.insertAfter(date,7,'-');
                
                %-- Preprocesamiento de la imagen -------------------------                
                %Se procesa la imagen y se retorna el numero de pixeles con vegetacion,
                %la imagen con la mascara de threshold, la image del ROI(en modo
                %interactivo es toda la imagen), y la imagen con la mascara del kmeans
                [vegetationIndex, maskedRGBImage,RGB,maskedKImage] = ImgProcessing.rotateCropAndProcess(a, 0, 0); %version interactiva solo recibe imagen
                %----------------------------------------------------------------------                
                %En la funcion rotateCropAndProcess se continua con el apartado 4

                %----------------------------------------------------------------------
                %--5. Persistencia de los datos ---------------------------------------
                %----------------------------------------------------------------------
                %Se forma string que sera guardado en csv
                record = [date, fileName, vegetationIndex];
                csv = [csv; record];


                fileName = char(fileName);
                %Se guardan las dos imagenes con las mascaras (kmeans, threshold)
                FILENAME = ['..' filesep 'Data' filesep folderName filesep 'kmeans' filesep fileName];
                imwrite(maskedKImage,FILENAME);

                FILENAME = ['..' filesep 'Data' filesep folderName filesep 'thresholding' filesep fileName];          
                imwrite(maskedRGBImage,FILENAME);

                %Imprimir el numero actual de la iteracion
                disp(i)
                
            end
            %guardar csv
            writecell(csv,['..' filesep 'Data' filesep folderName filesep 'data.txt']);
            
            %--------------------------------------------------------------
            %----------------- FIN DEL PROGRAMA PRINCIPAL -----------------
            %--------------------------------------------------------------           
            
        end
        
        function [vegetationIndex, maskedRGBImage,RGB,maskedKImage] = rotateCropAndProcess(a, batchMode, landsat)
            %Esta funcion rota*, corta* y llama a create mask para que
            %procese la imagen
            %*si modo batch = 1
            %Retorna: El numero de pixeles de vegetacion(OR entre mascara
            %verde de K-means y mascara de threshold) en vegetationIndex,
            %la imagen con la mascara del treshlod aplicaeda en
            %maskedRGBIMage. La ROI en RGB. La imagen con la mascara verde
            %de k-mena aplicada en maskedKImage
            
            
            b = a;
            
            %--------------------------------------------------------------
            %--3. Preprocesamiento de la imagen ---------------------------
            %--------------------------------------------------------------
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

            %--------------------------------------------------------------
            %--4. Procesamiento de la imagen ------------------------------
            %--------------------------------------------------------------
            [~,maskedRGBImage,RGB,maskedKImage, ~,vegetationIndex, ~, ~, ~, ~, ~] = ImgProcessing.createMaskV2(b);
            % [BW,maskedRGBImage,RGB,maskedKImage, maskedFinalImage,vegetationIndex, n, b, k3c1, k3c2, k3c3] = createMaskV2(b);
            %--------------------------------------------------------------
            %--------------------------------------------------------------
            %--------------------------------------------------------------
        end
        
        function [BW,maskedRGBImage,RGB, maskedKImage,maskedFinalImage,greenPN, n, b,k3c1,k3c2,k3c3] = createMaskV2(RGB)
            %--------------------------------------------------------------------------
            %--4. Procesamiento de la imagen ------------------------------------------
            %--------------------------------------------------------------------------
            %Funcion que realiza el procesado de la imagen. Recibe una imagen en RGB y
            % la convierte a Lab para obtener la mascara con unos valores predefinidos,
            % adicionalmente utiliza los canales a* y b* para aplicar K-means(k=3).
            %   Retorna: 
            %   La mascara de threshold en BW. 
            %   Imagen con la mascara de threashold aplicada en maskedRGBImage.
            %   Imagen original ingresada en RGB.
            %   La imagen con la mascar verde de kmeans aplicada en maskedkImage.
            %   La imagen con la mascara OR aplicada en maskedFinalImage.
            %   El conteo de pixeles de maskedFinalImage en greenPN
            %   Arrays n y b para debug del metodo de seleccionar mascara de kmeans verde
            %   k3c1, k3c2, k3c3. Imagenes con las mascaras aplicadas de kmeans
            %------------------------------------------------------
        

            % Convert RGB image to chosen color space
            I = rgb2lab(RGB);

            % Define thresholds for channel 1 based on histogram settings
            channel1Min = 46.585;
            channel1Max = 67.300;

            % Define thresholds for channel 2 based on histogram settings
            channel2Min = -49.958;
            channel2Max = -9.489;

            % Define thresholds for channel 3 based on histogram settings
            channel3Min = -22.600;
            channel3Max = 56.834;

            % Create mask based on chosen histogram thresholds
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            BW = sliderBW;

            % Initialize output masked image based on input image.
            maskedRGBImage = RGB;

            % Set background pixels where BW is false to zero.
            maskedRGBImage(repmat(~BW,[1 1 3])) = 0;


            %Take only a* and b* channel
            ab = I(:,:,2:3);
            ab = im2single(ab);
            %Funcion para aplicar segmentacion mediante kmeans
            % Repeat the clustering 3 times to avoid local minima
            k3 = imsegkmeans(ab,3,'NumAttempts',3);

            %Apply different k3 labels as mask
            mask1 = k3==1;
            k3c1 = RGB .* uint8(mask1);
            mask2 = k3==2;
            k3c2 = RGB .* uint8(mask2);
            mask3 = k3==3;
            k3c3 = RGB .* uint8(mask3);

            %Choose the greenest k-label
            [i, n, b] = ImgProcessing.greenest(k3c1,k3c2,k3c3);
            switch i
                case 1
                    maskedKImage = k3c1;
                    mask = mask1;
                case 2
                    maskedKImage = k3c2;
                    mask = mask2;
                case 3
                    maskedKImage = k3c3;
                    mask = mask3;
            end

            finalMask = or(mask,BW);
            maskedFinalImage = RGB;
            maskedFinalImage(repmat(~finalMask,[1 1 3])) = 0;
            greenPN= sum(finalMask,'all');
        end
        
        function NewCharArray = insertAfter( CharArray, Position, WhatToInsert)
            %funcion auxiliar para menejo de strings
          NewCharArray = char( strcat( cellstr(CharArray(:,1:Position)), cellstr(WhatToInsert), cellstr(CharArray(:, Position+1:end)) ) );
        end
        
        function [i, n, b] = greenest(k3c1,k3c2,k3c3)
            %Returns the greenest among 3 RGB  images.
            %  [i, n, b] = greenest(k3c1,k3c2,k3c3) Compares 3 RGB images returns the
            %  index of the greenest one in i, uses lab color space and predefined
            %  thresholds values for comparison. Sums the number of pixels of the mask
            %  Second threshold is to not take into acconunt the green clouds. Returns
            %  sum of green pixels and green clouds in n and b (3x1 arrays) for debug
            %  purposes
                        
            %Threshold para vegetacion
            channel1Min = 46.585;
            channel1Max = 67.300;
            channel2Min = -49.958;
            channel2Max = -9.489;
            channel3Min = -22.600;
            channel3Max = 56.834;

            %Threshold para nubes
            badChannel1Min = 64.857;
            badChannel1Max = 85.027;
            badChannel2Min = -37.999;
            badChannel2Max = -13.807;
            badChannel3Min = -8.828;
            badChannel3Max = 1.678;

            %Aplicar ventana deslizante(nubes y vegetacion) y obtener suma 
            I = rgb2lab(k3c1);
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            n1 = sum(sliderBW,'all');
            sliderBad = (I(:,:,1) >= badChannel1Min ) & (I(:,:,1) <= badChannel1Max) & ...
                (I(:,:,2) >= badChannel2Min ) & (I(:,:,2) <= badChannel2Max) & ...
                (I(:,:,3) >= badChannel3Min ) & (I(:,:,3) <= badChannel3Max);
            b1 = sum(sliderBad,'all');

            I = rgb2lab(k3c2);
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            n2 = sum(sliderBW,'all');
            sliderBad = (I(:,:,1) >= badChannel1Min ) & (I(:,:,1) <= badChannel1Max) & ...
                (I(:,:,2) >= badChannel2Min ) & (I(:,:,2) <= badChannel2Max) & ...
                (I(:,:,3) >= badChannel3Min ) & (I(:,:,3) <= badChannel3Max);
            b2 = sum(sliderBad,'all');

            I = rgb2lab(k3c3);
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            n3 = sum(sliderBW,'all');
            sliderBad = (I(:,:,1) >= badChannel1Min ) & (I(:,:,1) <= badChannel1Max) & ...
                (I(:,:,2) >= badChannel2Min ) & (I(:,:,2) <= badChannel2Max) & ...
                (I(:,:,3) >= badChannel3Min ) & (I(:,:,3) <= badChannel3Max);
            b3 = sum(sliderBad,'all');

            %Array de indice de vegetacion
            n = [n1, n2, n3];

            %Array de indice de nubes verdosas
            b = [b1, b2, b3];

            [~, i] = max(n);
            [maxB,iB] = max(b);
            %Control de caso en el que hay mas nubes que vegetacion
            if i == iB && maxB ~= 0
                n(i) = -n(i);
                [~, i] = max(n);
            end
        end
        
    end
end

