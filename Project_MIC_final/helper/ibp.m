function [X] = ibp(X, Y_den, maxIter)
    X = double(X); Y_den = double(Y_den);
    [r_l, c_l] = size(Y_den);
    [r_h, c_h] = size(X);
    p = fspecial('gaussian', 5, 1);
    p = p.^2;
    p = p./sum(p(:));

    for i = 1:maxIter,
        Y_s = imresize(X, [r_l, c_l]);
        diff = imresize(Y_den - Y_s, [r_h, c_h]);
        X = X + conv2(diff, p, 'same');
    end
end
