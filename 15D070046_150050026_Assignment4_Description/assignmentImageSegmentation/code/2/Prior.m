function potential = Prior(X,l,beta)
    l = ones(size(X))*l;
    t = beta*(l ~= circshift(X,1,1)) + beta*(l ~= circshift(X,-1,1)) + beta*(l ~= circshift(X,1,2)) + beta*(l ~= circshift(X,-1,2));
    potential = exp(-t);
end

