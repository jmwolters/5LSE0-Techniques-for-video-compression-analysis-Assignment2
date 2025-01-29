close all
clear all

lena = imread("Wolters/lena.pgm");
lena = im2double(lena);

peppers = imread("Wolters/peppers.pgm");
peppers = im2double(peppers);

% lena_brightness = blockproc(lena_dct, [8 8], @(blockstruct) idct2(blockstruct.data + bright_val));
% lena_contrast = blockproc(lena_dct, [8 8], @(blockstruct) idct2(blockstruct.data .* contrast_val));

lena_fft = fftshift(fft2(lena));
peppers_fft = fftshift(fft2(peppers));

% 2a
% Plot the amplitude\
% figure(1)
% subplot(2,2,1);
% imshow(log(1+abs(lena_fft)),[]);
% subplot(2,2,2);
% imshow(angle(lena_fft));
% 
% subplot(2,2,3)
% imshow(log(1+abs(peppers_fft)),[]);
% subplot(2,2,4)
% imshow(angle(peppers_fft));

% 2b
le_abs_pe_ang = abs(lena_fft).*exp(1j.*angle(peppers_fft));
pe_abs_le_ang = abs(peppers_fft).*exp(1j.*angle(lena_fft));

% figure(2)
% subplot(1,2,1)
% imshow(abs(ifft2(le_abs_pe_ang)))
% subplot(1,2,2)
% imshow(abs(ifft2(pe_abs_le_ang)))

% 2c
% TODO: Improve DC centering and contrast normalization.
% figure(3)
lena_random = zeros(8,8,1000);
lena_random_centered = zeros(8,8,1000);
lena_random_vector = zeros(64,1,1000);
lena_pca = zeros(8,8,1000);
rng(15)
for i = 1:1000
    x = randi(512-7);
    y = randi(512-7);

    lena_random(1:8,1:8,i) = lena(x:x+7,y:y+7);

    lena_random_centered(1:8,1:8,i) = (lena_random(1:8,1:8,i) - mean2(lena_random(1:8,1:8,i)));
    lena_min = min(min(lena));
    lena_max = max(max(lena));
    lena_random_centered(1:8,1:8,i) = ((lena_random_centered(1:8,1:8,i)-lena_min)/(lena_max-lena_min)).*255;
    lena_random_vector(1:64,1,i) = reshape(lena_random_centered(1:8,1:8,i),64,1);

    % if (i < 11)
    %     subplot(5,4,i*2-1)
    %     imshow(lena_random(1:8,1:8,i))
    %     subplot(5,4,i*2)
    %     imshow(lena_random_centered(1:8,1:8,i))     
    % end
end
lena_random_matrix(1:64,1:1000) = lena_random_vector(1:64,1,1:1000);
[coeff, score, latent] = pca(lena_random_matrix','NumComponents',64);

% figure(4)
% for j = 1:64
%     lena_pca(1:8,1:8,j) = reshape(coeff(1:64,j),8,8);
%     subplot(8,8,j)
%     imshow(lena_pca(1:8,1:8,j),[])
% end

% 2e
Lambda = diag(latent)+ eye(64)*1e-5;

white_mat = coeff*1/sqrtm(Lambda)*coeff';

lena_white = zeros(512,512);
for x_patch = 1:8:512-7
    for y_patch = 1:8:512-7
        lena_patch = lena(x_patch:x_patch+7,y_patch:y_patch+7);
        patch_mean = mean2(lena_patch);
        lena_patch = lena_patch - patch_mean;
        lena_patch_vector = reshape(lena_patch,64,1);
        lena_vector_white = white_mat*lena_patch_vector;
        lena_white(x_patch:x_patch+7,y_patch:y_patch+7) = reshape(lena_vector_white,8,8);
    end
end
figure(1)
imagesc(lena_white)
colorbar;