%% CT Chest image
load('../../data/CT_Chest.mat');
imageCT = mat2gray(imageAC);
for i = 0:180
    theta = [i:1:i+150];
    R = radon(imageCT,theta);
    backPro = iradon(R,theta,'linear','Ram-Lak',1,512);
    rrmse(i+1) = norm(imageCT - backPro,'fro')/norm(imageCT,'fro');
end
figure;
plot(rrmse);
xlabel('theta'); ylabel('error');
title('rrmse error vs theta for CT Chest image');

[val, ind] = min(rrmse);
disp(strcat(' minimum error occurs for CT Chest image occurs at theta = ',' ',num2str(ind-1),' degrees and minimum RRMSE is ',' ',num2str(val)));
theta_opt = [ind-1:1:ind+149];
R = radon(imageCT,theta_opt);
backPro_opt = iradon(R,theta_opt,'linear','Ram-Lak',1,512);
figure;
subplot(1,2,1)
imshow(imageCT,[]);
title('Original Image');
subplot(1,2,2)
imshow(backPro_opt,[]);
title('Best Reconstruction with min RRMSE')
suptitle('CT Chest Image Reconstruction');

%% Phantom Image

load('../../data/myPhantom.mat');
imageCT = mat2gray(imageAC);
for i = 0:180
    theta = [i:1:i+150];
    R = radon(imageCT,theta);
    backPro = iradon(R,theta,'linear','Ram-Lak',1,256);
    rrmse(i+1) = norm(imageCT - backPro,'fro')/norm(imageCT,'fro');
end
figure;
plot(rrmse);
xlabel('theta'); ylabel('error');
title('rrmse error vs theta for Phantom image');

[val, ind] = min(rrmse);
disp(strcat(' minimum error for phantom image occurs at theta = ',' ',num2str(ind-1),' degrees and minimum RRMSE is ',' ', num2str(val)));
theta_opt = [ind-1:1:ind+149];
R = radon(imageCT,theta_opt);
backPro_opt = iradon(R,theta_opt,'linear','Ram-Lak',1,256);
figure;
subplot(1,2,1)
imshow(imageCT,[]);
title('Original Image');
subplot(1,2,2)
imshow(backPro_opt,[]);
title('Best Reconstruction with min RRMSE')
suptitle('Phantom Image Reconstruction');