%% input parameters 
tic;
inp.scale = 4;               % decimation factor 
inp.sigma = 10;              % standard deviation of Gaussian noise
inp.k = 2;                   % size of LR block -: (2k+1)x(2k+1)
inp.K = 100;                 % K nearest neighbors patches
inp.maxIter = 15;            % Number of back projection iterations
inp.lambda = 0.001;          % Regularization Parameter for sparse regression
inp.gamma = 44;
inp.epsilon = 2;             % Norm threshold including a vector in database construction
inp.init_resize = 0.4;       % initial Resizing factor for database construction, controls size of original HR image
inp.path = 'Images/Test/d.png'; % Which image to be used 
%% Constructing Dataset
clc
close all
addpath('helper')
[HR_data, LR_data] = dataset_construction(inp);

%% Generating Low resolution noisy input
img = imread(inp.path); 
img = imresize(img, inp.init_resize);
img = double(rgb2gray(img));

L_inp = imresize(img, 1/inp.scale);
L_inp = L_inp + inp.sigma*randn(size(L_inp)); 

%% Super Resolution and back projection
[im_denoised, im_superRes] = SRSW(L_inp,HR_data,LR_data, inp);
    if inp.sigma==0
        output_super_srsw = ibp(uint8(im_superRes), uint8(L_inp), inp.maxIter);
    end
    output_super_srsw = ibp(uint8(im_superRes), uint8(im_denoised), inp.maxIter);
    output_super_bicubic = imresize(L_inp,inp.scale*size(L_inp),'bicubic');
    
    disp('PSNR and SSIM for Bicubic');
    PSNR_bicubic = cal_psnr(output_super_bicubic, img)
    SSIM_bicubic = cal_ssim(output_super_bicubic, img, 0, 0)
    
    disp('PSNR and SSIM for SRSW');
    PSNR_srsw = cal_psnr(output_super_srsw, img)
    SSIM_srsw = cal_ssim(output_super_srsw, img, 0, 0)

%% Displaying Outputs
    figure, imshow(uint8(L_inp)), title('Low Res Input');
    figure, imshow(uint8(img)), title('Original High Res Image');
    figure, imshow(uint8(output_super_bicubic)), title('SR Bicubic')
    figure, imshow(uint8(output_super_srsw)), title('SR SW')
toc;