function alpha = NQP(y,U,W,inp)
    w_t = inp.lambda*(1+W');
    [m, K] = size(U);
    % initializing alpha > 0
    alpha = mean(y) + max(randn(K,1),0);

    if inp.sigma == 0
        err_thresh = m;
    else
        err_thresh = m*inp.sigma^2;
    end
    res = y-U*alpha;
    err_now = norm(res,2)^2; 
    t=0;

    while (err_now >= err_thresh && t<300)
        alpha = alpha.*(U'*y)./(U'*U*alpha + w_t);
        res = y - U*alpha;
        err_now = norm(res,2)^2;
        t=t+1;
    end
end