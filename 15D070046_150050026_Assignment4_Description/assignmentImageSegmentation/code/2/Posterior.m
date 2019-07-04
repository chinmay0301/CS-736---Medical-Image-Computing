function posterior = Posterior(X,Y,mu,sigma,beta)
% gives log posterior as output
N = size(X,1); posterior = 0;
for i = 1:N
    for j = 1:N
        if(X(i,j)~=0)
            prior = 0;
            if(X(i+1,j)~=0)
                prior = prior -(beta*(X(i,j) ~= X(i+1,j)));
            end
            if(X(i,j+1)~=0)
                prior = prior -(beta*(X(i,j) ~= X(i,j+1)));
            end
            if(X(i,j-1)~=0)
                prior = prior -(beta*(X(i,j) ~= X(i,j-1)));
            end
            if(X(i-1,j)~=0)
                prior = prior -(beta*(X(i,j) ~= X(i-1,j)));
            end
            likelihood= -(Y(i,j) - mu(X(i,j))).^2/(2*sigma(X(i,j))*sigma(X(i,j)));
                %disp(likelihood);
            posterior = posterior + prior + likelihood;
        end
    end
end
end

