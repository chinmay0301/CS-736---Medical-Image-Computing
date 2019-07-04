function [mem,X_map,post_before, post_after] = Estep(X,Y,mu,sigma,beta)
    %beta = 0.3;
    %mu = mean_init; sigma = std_init;
    for i = 1:3
        Prior_i = Prior(X,i,beta); Prior_i(X == 0) = 0;
        G_i = exp(-(1-beta)*(Y - mu(i)).^2/(2*sigma(i)*sigma(i)));G_i(X == 0) = 0;
        P(i,:,:) = Prior_i.*G_i;
    end
    [~, X_map] = max(P);
    X_map = squeeze(X_map); X_map(X==0) = 0;
    post_before = Posterior(X,Y,mu,sigma,beta);
    post_after = Posterior(X_map,Y,mu,sigma,beta);
     if(Posterior(X,Y,mu,sigma,beta) > Posterior(X_map,Y,mu,sigma,beta))
         X_map = X;
     end

    total = zeros(size(X));
    for i = 1:3
        ind = X_map == i;
        Prior_i = Prior(X_map,i,beta); Prior_i(X_map == 0) = 0;
        G_i = exp(-(Y - mu(i)).^2/(2*sigma(i)*sigma(i)));G_i(X_map == 0) = 0;
        P(i,:,:) = Prior_i.*G_i;
        total = total + squeeze(P(i,:,:));
    end

    mem(1,:,:) = squeeze(P(1,:,:))./total;
    mem(2,:,:) = squeeze(P(2,:,:))./total;
    mem(3,:,:) = squeeze(P(3,:,:))./total;
    mem(isnan(mem)) = 0;
end