function psnr = cal_psnr(I,J)
    imdff = double(I) - double(J);
    imdff = imdff(:);
    rmse = sqrt(mean(imdff.^2));
    psnr = 20*log10(255/rmse);
end