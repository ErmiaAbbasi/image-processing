img1 = imread('portrait-of-a-cat.jpg');
size(img1)
img2 = rgb2gray(img1);
img2 = im2double(img2);
tiledlayout(1,2);
nexttile
imshow(img1)
title('original image')
nexttile
imshow(img2)
title('grayscale image')
figure;
imhist(img2)
title('histogram')
img_contrast = std2(img2);
disp(['Contrast (Standard Deviation): ', num2str(img_contrast)]);
F = fft2(img2);
F_shift = fftshift(F);
figure;
tiledlayout(1,2);
nexttile;
imshow(img2);
nexttile;
imshow(log(1+abs(F_shift)),[]);
[M, N] = size(img2);
centerX = N / 2;
centerY = M / 2;
cutoff = 60;
[X, Y] = meshgrid (1:N, 1:M);
D = sqrt((X - centerX).^2 + (Y - centerY).^2);
H_low = double(D <= cutoff);
H_high = double(D > cutoff);
figure; imshow(H_low);
figure; imshow(H_high);
G_low_shift = F_shift .* H_low;
G_high_shift = F_shift .* H_high;
img_low = real(ifft2(ifftshift(G_low_shift)));
img_high = real(ifft2(ifftshift(G_high_shift)));
figure; imshow(img_low);
figure; imshow(img_high);