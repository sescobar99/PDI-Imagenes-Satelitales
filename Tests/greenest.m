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