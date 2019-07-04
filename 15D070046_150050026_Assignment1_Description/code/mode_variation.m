function [D_sorted, V_sorted] = mode_variation(z_mean, data_aligned,N, dim, num_points)

X = reshape(data_aligned, [dim*num_points, N ])- repmat(z_mean(:), [1,N]);

Cov = X*X'/(N-1);
[V,D] = eig(Cov);
[d,ind] = sort(diag(D),'descend');
D_sorted = D(ind,ind);
V_sorted = V(:,ind);

end

