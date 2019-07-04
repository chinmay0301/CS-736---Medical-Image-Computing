function [mu,sigma] = Mstep(mem,Y)
    mu = zeros(3,1);
    sigma = zeros(3,1);
    for i = 1:3
        mu(i) = sum(vec(squeeze(mem(i,:,:)).*Y))/sum(vec(mem(i,:,:)));
        sigma(i) = sqrt(sum(vec(squeeze(mem(i,:,:)).*(Y - mu(i)).^2))/sum(vec(mem(i,:,:))));
    end
end
    