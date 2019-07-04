%% Assignment 2 

load('../data/assignmentImageDenoisingBrainNoisy.mat');
y = imageNoisy;

%%% Code for 2(a)
disp('Select 5 patches in the image of same size, which are completely dark, and are spatially far away and then average the standard deviations of these patches for the real and imaginary parts separately over the 5 patches');
std_real = (std2(real(y(1:20,1:20))) + std2(real(y(236:256,1:20))) + std2(real(y(1:20,236:256))) + std2(real(y(200:220,1:20))) + std2(real(y(200:220,236:256))))/5;
std_imag = (std2(imag(y(1:20,1:20))) + std2(imag(y(236:256,1:20))) + std2(imag(y(1:20,236:256))) + std2(imag(y(200:220,1:20))) + std2(imag(y(200:220,236:256))))/5;
disp('std dev for imaginary part -:');
disp(std_imag);
%%%%%%%% Optimal values of parameters -:
%%%%%%%% Quadratic - alpha_opt = 0.48
[loss_quad,x_quad] = gradDescent(0.48,0,1,'quad');

%%%%%%%% Huber - alpha_opt = 0.60 and gamma_opt = 0.06
[loss_huber,x_huber] = gradDescent(0.60,0.06,1,'huber');

%%%%%%%% Adaptive - alpha_opt = 0.50 and gamma_opt = 0.08
[loss_adaptive,x_adaptive] = gradDescent(0.50,0.08,1,'adaptive');

%%%%%%% Image results 

subplot(2,2,1);
imshow(abs(y),[]);
title('Noisy Image');

subplot(2,2,2);
imshow(abs(x_quad),[]);
title('Denoised image - quadratic');

subplot(2,2,3);
imshow(abs(x_huber),[]);
title('Denoised image - huber');

subplot(2,2,4);
imshow(abs(x_adaptive),[]);
title('Denoised image - adaptive');
suptitle('Image results for brain image - Q2')

%%%%%% Error with iteration plots 
figure;
subplot(1,3,1)
plot(loss_quad);
xlabel('Iterations'); ylabel('Objective Value');
title('Objective - Quadratic');

subplot(1,3,2)
plot(loss_huber);
xlabel('Iterations'); ylabel('Objective Value');
title('Objective - Huber');

subplot(1,3,3)
plot(loss_adaptive);
xlabel('Iterations'); ylabel('Objective Value');
title('Objective - Adaptive');
suptitle('Objective value with iteration for different potentials - Q1')
