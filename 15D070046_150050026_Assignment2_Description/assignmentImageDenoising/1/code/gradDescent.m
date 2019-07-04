function [err,loss,x] = gradDescent(alpha,gamma,tau,mode)
% Loading images
load('../data/assignmentImageDenoisingPhantom.mat');
y = imageNoisy; x_true = imageNoiseless;


x = y;
x_old = x;
iters = 0;
while(tau>1e-8)
  iters = iters + 1;
  val_old = value_cal(x_old,y,mode,alpha,gamma);
  loss(iters) = val_old;
   x = x_old - tau*grad(x_old,y,mode,alpha,gamma);
   val = value_cal(x,y,mode,alpha,gamma);
   if(val > val_old)
      tau = tau*0.5;
   else
      tau = 1.1*tau;
      x_old = x;
      val_old = val;
   end
end

err = norm(abs(x)-abs(x_true),'fro')/norm(abs(x_true),'fro');
end