function final_img = replaceBackground(foreground_img, background_img)
    img_gray = rgb2gray(foreground_img);
    img_double = im2double(img_gray);
    
    F = fft2(img_double);
    F_shift = fftshift(F);
    [M, N] = size(img_double);
    
    centerX = N / 2;
    centerY = M / 2;
    cutoff = 115;
    [X, Y] = meshgrid(1:N, 1:M);
    D = sqrt((X - centerX).^2 + (Y - centerY).^2);
    H_high = double(D > cutoff);
    
    G_high_shift = F_shift .* H_high;
    img_high = real(ifft2(ifftshift(G_high_shift)));
    
    img_blurred = imgaussfilt(img_high, 0.3);
    th = otsuthresh(imhist(img_blurred));
    binary_img = (img_blurred >= th);
    
    img4 = bwareaopen(binary_img, 40);
    [rows, cols] = size(img4);
    
    img_hor = img4;
    for i = 1:rows
        first_white = 0;
        last_white = 0;
        for j = 1:cols
            if img4(i, j) == 1
                if first_white == 0, first_white = j; end
                last_white = j;
            end
        end
        if first_white > 0 && last_white > first_white
            img_hor(i, first_white:last_white) = 1;
        end
    end
    
    img_ver = img4;
    for j = 1:cols
        first_white = 0;
        last_white = 0;
        for i = 1:rows
            if img4(i, j) == 1
                if first_white == 0, first_white = i; end
                last_white = i;
            end
        end
        if first_white > 0 && last_white > first_white
            img_ver(first_white:last_white, j) = 1;
        end
    end
    
    img_com = img_hor & img_ver;
    img_com = double(img_com);
    img_com_blurred = imgaussfilt(img_com, 15);
    th2 = otsuthresh(imhist(img_com_blurred));
    blurred_binary_img = (img_com_blurred >= th2);
    
    output = foreground_img;
    for c = 1:3
        channel = output(:, :, c);
        channel(~blurred_binary_img) = 0;
        output(:, :, c) = channel;
    end
    
    resized_bg = imresize(background_img, [rows, cols]);
    
    final_img = resized_bg;
    for r = 1:rows
        for c = 1:cols
            if blurred_binary_img(r, c) == 1
                final_img(r, c, :) = output(r, c, :);
            end
        end
    end
end

img1=imread("bdic-report-template-latex-main\images\phil-robson-R0T-2U-O5fc-unsplash.jpg");
bg_img = imread("SS CA2\Images\image03.jpg");

result = replaceBackground(img1,bg_img);

figure;
imshow(result);