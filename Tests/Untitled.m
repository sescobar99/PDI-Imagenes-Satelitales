% clear all, clc
% datastore = datastore('.\' );
% for i =1:10
% a = read(datastore);
% imshow(a);
% pause();
% end
% figure(1);imshow(a);
a = imread('../Test_Images/Image_1.jpg');
b = imrotate(a,12, 'crop');
% figure(2);imshow(b);
[BW,maskedRGBImage] = createMask(b);
figure(3);imshow(maskedRGBImage);
% figure(4);imshow(BW);
% auxR = 1.0e+03*[3.0305    3.4215    2.8550    2.8670];
% b = imcrop(b,auxR);
% figure(2);imshow(b);
% thresh = multithresh(b,7);
% c = rgb2gray(b);
% figure(3);imshow(c);
% seg_I = imquantize(c,thresh);
% RGB = label2rgb(seg_I); 	 
% figure(4);imshow(RGB);
% axis off
% title('RGB Segmented Image')

 


% [J,rect] = imcrop(b);
% auxR = 1.0e+03*[3.0305    3.4215    2.8550    2.8670];
% c = imcrop(b,auxR);
% figure(5);imshow(c);
% subplot(1,2,1)
% imshow(a)
% title('Original Image') 
% subplot(1,2,2)
% imshow(c)
% title('Cropped Image')


% for angle = 11:13
%     b = imrotate(a,angle,'crop');
%     imshow(b);
%     title(['Angle: ' int2str(angle)]);
%     pause();
% end