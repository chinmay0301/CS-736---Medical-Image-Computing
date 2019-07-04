function mask =gaussMask(stdIn,k)
    varIn = stdIn*stdIn;
    T = 0.1;
    [x y] = meshgrid(-k:k, -k:k);

    mask = (1/(2*pi*varIn))*exp(-0.5*(x.^2 + y.^2)/varIn);
    weight = sum(sum(mask));

    mask = mask./weight;
end