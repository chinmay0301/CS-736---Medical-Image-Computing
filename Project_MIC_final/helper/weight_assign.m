function [W, ix] = weight_assign(y,U,inp)
    d = zeros(1,size(U,2));
    mu = mean(y)./mean(U);
    parfor i=1:size(U,2)
        v = y-mu(i)*U(:,i);
        d(1,i) = norm(v,2)^2 + abs(mean(v)) + abs(var(v) - inp.sigma^2);    
    end
    [W, ix]= sort(d);
    W = W(1:inp.K);
    ix = ix(1:inp.K);
    if inp.sigma>0
        idx = find(W>(inp.gamma*length(y)*inp.sigma^2));       
        W(idx)=exp(W(idx));
    end
end
