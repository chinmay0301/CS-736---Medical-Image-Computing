
function [HR_data, LR_data] = dataset_construction(inp)

	img_org = imread(inp.path); 
	img_org = imresize(img_org, inp.init_resize);
	img_org = double(rgb2gray(img_org));

	block_size = inp.scale*inp.k*inp.k + 1;
	hr_data = im2col(img_org, [block_size, block_size], 'sliding');

	D = decimate(inp.scale*inp.k*inp.k + 1, inp.scale);
	lr_data = D*hr_data;

	norm_den = sqrt(sum(lr_data.^2,1));
	idx = find(norm_den > inp.epsilon);
	norm_f = norm_den(:,idx);
	hr_data = hr_data(:,idx);
	lr_data = lr_data(:,idx);
	N = size(hr_data, 2);

	for i=1:N
	    HR_data(:,i) = hr_data(:,i)/norm_f(i);
	    LR_data(:,i) = lr_data(:,i)/norm_f(i);
	end
	
	count= 1;
	while count < N
		t = LR_data(:,count);
		temp = t'*LR_data;
		temp(count)= 0;
		idx = find(temp < 0.985);
		LR_data = LR_data(:, idx);
		HR_data = HR_data(:, idx);
		count = count +1;
		N = size(LR_data,2);
	end

	save('LR_data_inp.mat', 'LR_data');
	save('HR_data_inp.mat', 'HR_data');
end