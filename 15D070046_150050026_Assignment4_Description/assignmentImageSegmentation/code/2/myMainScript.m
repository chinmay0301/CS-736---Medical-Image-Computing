%% Script to run the EM algorithm for Q2
clear; close all;
% initalize the label image and parameters. 
[X, Y, mean_init, std_init] = init();

%% Motivation - 
% Since we are dealing with a clustering problem, a good initialization to 
% the labels can be achieved using K-means clustering on the noisy image.
% Based on the initially assigned label, the initial means and standard
% deviations are computed. 
mu = mean_init; sigma = std_init;
X_inp = X;

figure;
imshow(Y,[]);
colorbar;
title('Original Noisy Image');

figure;
imshow(X,[]);
colorbar;
title('Initialized Image using K means');

% initial estimate of parameters -: 
disp('initialized means'); disp(mu); 
disp('initialized sigmas'); disp(sigma);

% EM Loop 
for i = 1:50
    [mem,X_map,post_before, post_after] = Estep(X_inp,Y,mu,sigma,0.8);
    [mu,sigma] = Mstep(mem,Y);
    prob_arr(i) = post_after;
    X_inp = X_map;
    fprintf('iteration %f. | log posterior before ICM beta = 0.8 %f. \n',i,post_before);
    fprintf('log posterior after ICM beta = 0.8 %f. \n',post_after);
end

% The optimal estimates for class means are -: 
disp('optimal class mean estimates for beta = 0.8'); disp(mu); 
[~, label_img] = max(mem);
label_img = squeeze(label_img); label_img(X==0) = 0;
  
figure;
subplot(2,2,1)
imshow(squeeze(mem(1,:,:)),[]);
colorbar;
title('Membership for class 1');
subplot(2,2,2)
imshow(squeeze(mem(2,:,:)),[]);
colorbar;
title('Membership for class 2');
subplot(2,2,3)
imshow(squeeze(mem(3,:,:)),[]);
colorbar;
title('Membership for class 3');
subplot(2,2,4)
imshow(label_img,[]);
colorbar;
title('Label Image');
suptitle('beta = 0.8');

figure;
plot(prob_arr);
xlabel('iteration number'); ylabel('log Posterior'); title('log Posterior Probability vs Iterations beta = 0.8');

mu = mean_init; sigma = std_init;
X_inp = X;


for i = 1:50
    [mem,X_map,post_before, post_after] = Estep(X_inp,Y,mu,sigma,0);
    [mu,sigma] = Mstep(mem,Y);
    prob_arr(i) = post_after;
    X_inp = X_map;
    fprintf('iteration %f. | log posterior before ICM beta = 0 %f. \n',i,post_before);
    fprintf('log posterior after ICM beta = 0  %f. \n',post_after);
end

[~, label_img] = max(mem);
label_img = squeeze(label_img); label_img(X==0) = 0;


figure;
subplot(2,2,1)
imshow(squeeze(mem(1,:,:)),[]);
colorbar;
title('Membership for class 1');
subplot(2,2,2)
imshow(squeeze(mem(2,:,:)),[]);
colorbar;
title('Membership for class 2');
subplot(2,2,3)
imshow(squeeze(mem(3,:,:)),[]);
colorbar;
title('Membership for class 3');
subplot(2,2,4)
imshow(label_img,[]);
colorbar;
title('Label Image');
suptitle('beta = 0');

figure;
plot(prob_arr);
xlabel('iteration number'); ylabel('log Posterior'); title('log Posterior Probability vs Iterations beta = 0');



