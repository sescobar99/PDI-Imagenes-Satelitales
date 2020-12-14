function [BW,maskedRGBImage,RGB, maskedKImage,maskedFinalImage,greenPN, n, b,k3c1,k3c2,k3c3] = createMaskV2(RGB)
% Funcion que realiza el procesado de la imagen. Recibe una imagen en RGB y
% la convierte a Lab para obtener la mascara con unos valores predefinidos,
% adicionalmente utiliza los canales a* y b* para aplicar K-means(k=3).
%Retorna: 
%La mascara de threshold en BW. 
%Imagen con la mascara de threashold aplicada en maskedRGBImage.
%Imagen original ingresada en RGB.
%La imagen con la mascar verde de kmeans aplicada en maskedkImage.
%La imagen con la mascara OR aplicada en maskedFinalImage.
%El conteo de pixeles de maskedFinalImage en greenPN
%Arrays n y b para debug del metodo de seleccionar mascara de kmeans verde
%k3c1, k3c2, k3c3. Imagenes con las mascaras aplicadas del proceso de
%kmenas
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
[i, n, b] = greenest(k3c1,k3c2,k3c3);
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
