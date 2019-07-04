
%% Part a 
f = phantom(256);
theta = linspace(0,177,60);
R = radon(f,theta);
backPro = iradon(R,theta,'linear','none',1,256);
figure;
subplot(3,3,1)
imshow(f,[]);
colorbar;
title('Phantom');
subplot(3,3,2)
imshow(R,[]);
colorbar;
title('Radon transform at given angles');
subplot(3,3,3)
imshow(backPro,[]);
colorbar;
title('Unfiltered Back Projection');

%% Showing plots are different filters at w_max and w_max/2 
% Ram Lak Filter
R_filt_rlk = myFilter(R,'ram-lak',1); % L = w_max
backPro_rlk_1 = iradon(R_filt_rlk,theta,'linear','none',1,256)/2;
R_filt_rlk = myFilter(R,'ram-lak',0.5); % L = w_max/2
backPro_rlk_2 = iradon(R_filt_rlk,theta,'linear','none',1,256)/2;

% Shepp Logan Filter 
R_filt_shepp = myFilter(R,'shepp-logan',1); % L = w_max
backPro_shepp_1 = iradon(R_filt_shepp,theta,'linear','none',1,256)/2;
R_filt_shepp = myFilter(R,'shepp-logan',0.5); %  L = w_max/2
backPro_shepp_2 = iradon(R_filt_shepp,theta,'linear','none',1,256)/2;

% Cosine Filter
R_filt_cos = myFilter(R,'cos',1); % L = w_max
backPro_cos_1 = iradon(R_filt_cos,theta,'linear','none',1,256)/2;
R_filt_cos = myFilter(R,'cos',0.5); %  L = w_max/2
backPro_cos_2 = iradon(R_filt_cos,theta,'linear','none',1,256)/2;

subplot(3,3,4)
imshow(backPro_rlk_1,[]);
title('L = w_{max} Ramlak Filter');
colorbar;

subplot(3,3,5)
imshow(backPro_shepp_1,[]);
title('L = w_{max} Shepp Logan Filter');
colorbar;

subplot(3,3,6)
imshow(backPro_cos_1,[]);
title('L = w_{max} Cosine Filter');
colorbar;

subplot(3,3,7)
imshow(backPro_rlk_2,[]);
title('L = w_{max}/2 Ramlak Filter');
colorbar;

subplot(3,3,8)
imshow(backPro_shepp_2,[]);
title('L = w_{max}/2 Shepp Logan Filter');
colorbar;

subplot(3,3,9)
imshow(backPro_cos_2,[]);
title('L = w_{max}/2 Cosine Filter');
colorbar;
suptitle('Q2 - part a . Maximize the fig for better view');


%% Part b
S0 = f;
S1 = conv2 (f, fspecial ('gaussian', 11, 1), 'same');
S5 = conv2 (f, fspecial ('gaussian', 51, 5), 'same');

figure;
subplot(1,3,1)
imshow(S0,[]);
title('S0');

subplot(1,3,2)
imshow(S1,[]);
title('S1');

subplot(1,3,3)
imshow(S5,[]);
title('S5');
suptitle('Q2 Part b');

% radon transforms
Rd_S0 = radon(S0,theta);
Rd_S1 = radon(S1,theta);
Rd_S5 = radon(S5,theta);

% Backprojections
R0 = iradon(Rd_S0,theta,'linear','Ram-Lak',1,256);
R1 = iradon(Rd_S1,theta,'linear','Ram-Lak',1,256);
R5 = iradon(Rd_S5,theta,'linear','Ram-Lak',1,256);

rrmse_S0 = norm(S0 - R0,'fro')/norm(S0,'fro');
rrmse_S1 = norm(S1 - R1,'fro')/norm(S1,'fro');
rrmse_S5 = norm(S5 - R5,'fro')/norm(S5,'fro');

disp(strcat('RRMSE for S0: ', num2str(rrmse_S0)));
disp(strcat('RRMSE for S1: ', num2str(rrmse_S1)));
disp(strcat('RRMSE for S5: ', num2str(rrmse_S5)));
disp(' The RRMSE is least for S5 since it is the most blurred image. Blurring results in attenuating high frequency components in the image.  The reconstruction error stems from the fact that the ram-lak filter clips of frequencies higher than a certain threshold. Since the most blurred image will have the most attenuated high frequency components, the reconstruction error will be the least for it after filtered backprojection using Ram Lak filter'); 

%% Part c
L_arr = [1e-3:1e-3:1];

for i=1:1000
    R0 = iradon(Rd_S0,theta,'linear','Ram-Lak',L_arr(i),256);
    R1 = iradon(Rd_S1,theta,'linear','Ram-Lak',L_arr(i),256);
    R5 = iradon(Rd_S5,theta,'linear','Ram-Lak',L_arr(i),256);

    err_S0(i) = norm(S0 - R0,'fro')/norm(S0,'fro');
    err_S1(i) = norm(S1 - R1,'fro')/norm(S1,'fro');
    err_S5(i) = norm(S5 - R5,'fro')/norm(S5,'fro');
end

figure;
plot(err_S0);
hold on;
plot(err_S1);
hold on;
plot(err_S5);
legend('S0','S1','S5');
title('RRMSE plots for S1 S2 and S5 across different values of L - Q2 Part c');
