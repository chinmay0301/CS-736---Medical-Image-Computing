function [z] = align(z_ref, z_inp, dim, num_points)
% Alignment of pointsets 
% assuming that centroids of the pointsets are set to 0
% N - number of points in the pointset
% dim - dimension of a point in the pointset

%z_ref = z_ref(:); z_inp = z_inp(:);
%z_ref = z_ref/norm(z_ref,2); z_inp = z_inp/norm(z_inp,2); 

[U,S,V] = svd(z_inp*z_ref');

R = V*U';
if(det(R) + 1 <= 1e-4)
    D = eye(dim); D(dim,dim) = -1;
    R = V*D*U';
end
z = R*z_inp; z = reshape(z, [dim,num_points]);
end

