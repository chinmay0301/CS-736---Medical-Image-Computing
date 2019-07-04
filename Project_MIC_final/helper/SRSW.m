function [im_denoised, im_highRes] = SRSW(LR_inp, HR_data, LR_data, inp)

    %Mask = gaussMask(1, inp.scale*inp.k);
    [r,c] = size(LR_inp);

    inp_Matrix = im2col(LR_inp,[2*inp.k+1,2*inp.k+1],'sliding');   
    Weight_high = zeros(inp.scale*r-1,inp.scale*c-1);
    im_highRes = zeros(inp.scale*r-1,inp.scale*c-1);

    im_denoised = zeros(size(LR_inp));
    Weight_low = zeros(size(LR_inp));

    d = 0;
    waitb = waitbar(0,'Running code -: ');
    for i = inp.k+1:(c-inp.k)
        waitbar(i/(c-inp.k),waitb);
        for j = inp.k+1:r-inp.k   
                d = d + 1;
                y = inp_Matrix(:,d);
                y_norm = y/norm(y);
                U = y_norm'*LR_data;
                [U, idx] = sort(U,'descend');
                L1 = LR_data(:, idx(1:200));
                H1 = HR_data(:, idx(1:200));
                [W, Ind] = weight_assign(y, L1, inp);
                L1 = L1(:,Ind);
                H1 = H1(:,Ind);
                x = NQP(y, L1, W, inp);

                PL = L1*x;
                PL = reshape(PL,2*inp.k+1,2*inp.k+1);
                im_denoised(j-inp.k:j+inp.k,i-inp.k:i+inp.k)=im_denoised(j-inp.k:j+inp.k,i-inp.k:i+inp.k)+reshape(PL,2*inp.k+1,2*inp.k+1).*ones(2*inp.k+1,2*inp.k+1);
                Weight_low(j-inp.k:j+inp.k,i-inp.k:i+inp.k)=Weight_low(j-inp.k:j+inp.k,i-inp.k:i+inp.k)+ ones(2*inp.k+1,2*inp.k+1);

                PH = H1*x;
                PH = reshape(PH,inp.scale*inp.k*inp.k+1,inp.scale*inp.k*inp.k+1);     
                im_highRes(inp.scale*j-1-inp.scale*inp.k:inp.scale*j-1+inp.scale*inp.k,inp.scale*i-1-inp.scale*inp.k:inp.scale*i-1+inp.scale*inp.k)=im_highRes(inp.scale*j-1-inp.scale*inp.k:inp.scale*j-1+inp.scale*inp.k,inp.scale*i-1-inp.scale*inp.k:inp.scale*i-1+inp.scale*inp.k)+PH.*ones(size(PH));
                Weight_high(inp.scale*j-1-inp.scale*inp.k:inp.scale*j-1+inp.scale*inp.k,inp.scale*i-1-inp.scale*inp.k:inp.scale*i-1+inp.scale*inp.k)=Weight_high(inp.scale*j-1-inp.scale*inp.k:inp.scale*j-1+inp.scale*inp.k,inp.scale*i-1-inp.scale*inp.k:inp.scale*i-1+inp.scale*inp.k)+ ones(size(PH));
        end 
    end
    sum(sum(isnan(im_highRes)))
    close(waitb);
    im_denoised = im_denoised./Weight_low;
    im_highRes = im_highRes./Weight_high; 
    im_highRes = imresize(im_highRes(inp.k+1:end,inp.k+1:end),[inp.scale*r inp.scale*c]);
end
