hcube = hypercube('../00I_Landsat_8_NDVI/LC08_L1TP_009054_20171218_20171224_01_T1_MTL.txt');
ndviImg  = ndvi(hcube);
rgbImg = colorize(hcube,'Method','RGB','ContrastStretching',true);

fig = figure('Position',[0 0 1200 600]);
axes1 = axes('Parent',fig,'Position',[0 0.1 0.4 0.8]);
imshow(rgbImg,'Parent',axes1)
title('RGB Image of Data Cube')
axes2 = axes('Parent',fig,'Position',[0.45 0.1 0.4 0.8]);
imagesc(ndviImg,'Parent',axes2)
colorbar
title('NDVI Image')