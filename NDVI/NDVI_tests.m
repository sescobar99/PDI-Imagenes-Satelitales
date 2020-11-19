%hcube = hypercube("LC08_L1TP_009054_20171218_20171224_01_T1_MTL.txt");

% 
% File_Path = 'C:\Users\Santiago\Downloads\LC08_L1TP_009054_20171218_20171224_01_T1\'; %%keep the \
% File_Name = 'LC08_L1TP_009054_20171218_20171224_01_T1_B';
% Band_Number = '3';
% Full_File_Name = strcat(File_Path, File_Name, Band_Number, '.TIF');
Full_File_Name = 'LC08_L1TP_009054_20171218_20171224_01_T1_B3.tif';
[G, ~] = readgeoraster(;
% [G, ~] = readgeoraster(Full_File_Name);
% clearvars Band_Number Full_File_Name
% Band_Number = '4';
% Full_File_Name = strcat(File_Path, File_Name, Band_Number, '.TIF');
% [R, ~] = geotiffread(Full_File_Name);
% clearvars Band_Number Full_File_Name
% Band_Number = '5';
% Full_File_Name = strcat(File_Path, File_Name, Band_Number, '.TIF');
% [NIR, ~] = geotiffread(Full_File_Name);
% clearvars File_Path File_Name Band_Number Full_File_Name
% G_heq = histeq(G);
% R_heq = histeq(R);
% NIR_heq = histeq(NIR);
% NIR = double(NIR_heq);
% R = double(R_heq);
% G = double(G_heq);
% NDVI = (NIR -R) ./ (NIR + R);
% figure(), imshow(NDVI, []), title('NDVI');
% colormap(jet);
% colorbar;
% impixelinfo