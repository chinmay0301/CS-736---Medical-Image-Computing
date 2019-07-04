function [z_mean, data_aligned] = mean_calc(data_preshaped, N, dim, num_points)


z_mean = sum(data_preshaped,3)/N;
z_mean = z_mean/norm(z_mean(:),2);
z_old = zeros(size(z_mean));
k = 0;
while (norm(z_old - z_mean) >= 1e-7)
    k = k + 1;
    z_old = z_mean;
    for i = 1:N
        data_preshaped(:,:,i) = align(z_mean, data_preshaped(:,:,i), dim, num_points);
    end
    z_mean = sum(data_preshaped,3)/N;
    z_mean = z_mean/norm(z_mean(:),2);
end
data_aligned = data_preshaped;
end