function [ data_preshaped, N, dim, num_points ] = preprocess(dataset)

dim = size(dataset,1);
num_points = size(dataset,2);
N = size(dataset,3);
z_cent = sum(dataset,2)/size(dataset,2);
z_cent = repmat(z_cent,[1,size(dataset,2),1]);
data_preshaped = dataset - z_cent;
temp = reshape(data_preshaped,[dim*num_points,N]);
%vec_temp = vecnorm(temp);
for i = 1:N
    temp(:,i) = temp(:,i)/norm(temp(:,i),2);
end
data_preshaped =reshape(temp, [ dim, num_points, N ]);
end

