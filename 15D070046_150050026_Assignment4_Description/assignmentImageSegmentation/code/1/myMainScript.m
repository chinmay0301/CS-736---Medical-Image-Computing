clear;
tic;

load('../../data/assignmentSegmentBrain.mat/assignmentSegmentBrain.mat')
img = imageData.*imageMask;

[row, col] = find(imageMask);
rect = [min(col), min(row), max(col) - min(col), max(row) - min(row)];
img = imcrop(img, rect);
imageMask = imcrop(imageMask, rect);

K = 3;

[m,n] = size(img);

%% Membership initialization
% <html> The initalization method used is kmeans. 
% This is a good initalization as it is widely used for
% image segmentation.The value of class means is
% the value of means over the segments thus obtained by kmeans 
% initalization. </html>
[labels, initial_means] = kmeans(img(:),4);
labels = reshape(labels, [m,n]);

% interchanging labels to make label corresponding to (1,1) 4
l1 = labels(1,1);
l2 = (labels == 4);
labels(labels == l1) = 4;
labels(l2) = l1;

u = zeros(m,n,K);
means = zeros(1,K);
for k = 1:K
    u(:,:,k) = (labels == (k));
    means(k) = mean(img(labels == k));
end

figure;
subplot(131), imshow(u(:,:,1)); title('class 1');
subplot(132), imshow(u(:,:,2)); title('class 2');
subplot(133), imshow(u(:,:,3)); title('class 3');
suptitle('Initial membership');

fprintf('Initial class means - %f, %f and %f\n', means(1), means(2), means(3));

q = 2;
fprintf('q = %d\n',q);
neighbour_mask = fspecial('gaussian', 12, 5); 
fprintf('neighborhood mask is 12*12 gaussian with sigma = 5\n');
figure;
imshow(neighbour_mask, [])
suptitle('Neighbourhood mask');

bias = 0.5*ones(m,n);
d = zeros(m,n,K);
obj_fn_vals = [];

for iter = 1:40
	convoluted_bias = conv2(bias, neighbour_mask, 'same');
	squared_convoluted_bias = conv2(bias.^2, neighbour_mask, 'same');

	% Solving for optimal membership
	for k = 1:K
		d(:,:,k) = img.^2 - 2*means(k).*img.*convoluted_bias + (means(k).^2).*squared_convoluted_bias;
	end
	u_unnormalized = (1./d).^(1/(q-1));
	normalize_factor = nansum(u_unnormalized,3);
	for k = 1:K
		u_temp = u_unnormalized(:,:,k)./normalize_factor;
		u_temp(isnan(u_temp)) = 1.0;
		u(:,:,k) = u_temp.*imageMask;
	end
	
	% Solving for optimal class means
	for k = 1:K
		means(k) = sum(sum((u(:,:,k).^q).*img.*convoluted_bias))/(sum(sum((u(:,:,k).^q).*squared_convoluted_bias)));
    end
 
	% Solving for optimal bias
	sum_bias_num = zeros(m,n);
	sum_bias_denom = zeros(m,n);
	for k = 1:K
		sum_bias_num = sum_bias_num + ((u(:,:,k).^q).*means(k));
		sum_bias_denom = sum_bias_denom + ((u(:,:,k).^q).*(means(k)^2));
	end
	bias_num = conv2(img.*sum_bias_num, neighbour_mask, 'same');
	bias_denom = conv2(sum_bias_denom, neighbour_mask, 'same');
	bias = bias_num./bias_denom;
    bias(isnan(bias)) = 0.0;

	% Computing objective function value
	val = sum(sum(sum((u.^q).*d)));
	obj_fn_vals = [obj_fn_vals val];

end

fprintf('Optimal class means - %f, %f and %f\n', means(1), means(2), means(3));

figure;
plot(obj_fn_vals)
xlabel('iteration');
ylabel('Objective function value')
suptitle('Objective function value vs iterations');

bias_removed_img = zeros(m,n);
for k = 1:K
    bias_removed_img = bias_removed_img + u(:,:,k)*means(k);
end
residual_img = img-(bias_removed_img.*bias);

[~,new_labels] = max(u,[],3);
for k = 1:K
	u(:,:,k) = (new_labels == k).*imageMask;
end
figure;
subplot(131), imshow(u(:,:,1)); title('class 1');
subplot(132), imshow(u(:,:,2)); title('class 2');
subplot(133), imshow(u(:,:,3)); title('class 3');
suptitle('Optimal membership');

figure;
subplot(221);imshow(img, []); title('Original Corrupted Image');
subplot(222);imshow(bias, []); title('Optimal Bias field');
subplot(223);imshow(bias_removed_img, []); title('Bias Removed Image');
subplot(224);imshow(residual_img, []); title('Residual Image');
suptitle('FCM segmentation');


toc;

