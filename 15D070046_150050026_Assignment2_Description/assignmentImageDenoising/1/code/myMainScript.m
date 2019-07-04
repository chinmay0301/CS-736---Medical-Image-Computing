%% Assignment 2 - Q1

%%%%%%%%% RRMSE between noisy and noiseless image -:
load('../data/assignmentImageDenoisingPhantom.mat');
y = imageNoisy; x_true = imageNoiseless;
disp('RRMSE between noisy and noiseless image');
disp(norm(abs(x_true) - abs(y),'fro')/norm(abs(x_true),'fro'));

%%%%%%%% Optimal values of parameters -:
%%%%%%%% Quadratic - alpha_opt = 0.21
[err,loss_quad,x_quad] = gradDescent(0.21,0,1,'quad');
disp('optimum Quadratic error');
disp(err);
%%%%%%%% Error for Quad at 1.2 and 0.8 times alpha_opt
[err,~,x] = gradDescent(0.21*0.8,0,1,'quad');
disp('error for 0.8 alpha');
disp(err);
[err,~,x] = gradDescent(1.2*0.21,0,1,'quad');
disp('error for 1.2 alpha');
disp(err);

%%%%%%%% Huber - alpha_opt = 0.81 and gamma_opt = 0.025
[err,loss_huber,x_huber] = gradDescent(0.81,0.025,1,'huber');
disp('optimum Huber error');
disp(err);
%%%%%%%% Error for Huber at 1.2 and 0.8 times alpha_opt
[err,~,x] = gradDescent(0.81*0.8,0.025,1,'huber');
disp('error for 0.8 alpha');
disp(err);
[err,~,x] = gradDescent(1.2*0.81,0.025,1,'huber');
disp('error for 1.2 alpha');
disp(err);
%%%%%%%% Error for Huber at 1.2 and 0.8 times gamma_opt
[err,~,x] = gradDescent(0.81,0.8*0.025,1,'huber');
disp('error for 0.8 gamma');
disp(err);
[err,~,x] = gradDescent(0.81,1.2*0.025,1,'huber');
disp('error for 1.2 gamma');
disp(err);

%%%%%%%% Adaptive - alpha_opt = 0.98 and gamma_opt = 0.011
[err,loss_adaptive,x_adaptive] = gradDescent(0.98,0.011,1,'adaptive');
disp('optimum Adaptive error');
disp(err);
%%%%%%%% Error for Adaptive at 1.2 and 0.8 times alpha_opt
[err,~,x] = gradDescent(0.98*0.8,0.011,1,'adaptive');
disp('error for 0.8 alpha');
disp(err);
[err,~,x] = gradDescent(1*0.98,0.011,1,'adaptive');
disp('error for alpha, since 1.2 alpha > 1');
disp(err);
%%%%%%%% Error for Adaptive at 1.2 and 0.8 times gamma_opt
[err,~,x] = gradDescent(0.98,0.8*0.011,1,'adaptive');
disp('error for 0.8 gamma');
disp(err);
[err,~,x] = gradDescent(0.98,1.2*0.011,1,'adaptive');
disp('error for 1.2 gamma');
disp(err);

%%%%%%% Image results 
figure;
subplot(2,3,1);
imshow(x_true,[0,1]);
title('Original Noiseless Image');

subplot(2,3,2);
imshow(abs(y),[]);
title('Noisy Image');

subplot(2,3,3);
imshow(abs(x_quad),[]);
title('Denoised image - quadratic');

subplot(2,3,4);
imshow(abs(x_huber),[]);
title('Denoised image - huber');

subplot(2,3,5);
imshow(abs(x_adaptive),[]);
title('Denoised image - adaptive');
suptitle('Image results for shepp logan phatom - Q1')

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
