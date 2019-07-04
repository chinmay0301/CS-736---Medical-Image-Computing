function R_filt = myFilter(R,type,L)
% filter to implement ram-lak, shepp logan and cosine filtering
% for the radon transform

% Assuming that fft of the radon transform for every value of theta is
% calculated for a frequency grid with 2000 points. 
gridLen = 1000; 
filter = [0:gridLen/2]./(gridLen/2);
w = 2*pi*[0:gridLen/2]/gridLen;   

if(strcmp(type,'shepp-logan') == 1)
    filter = filter.* (sin(w/(2*L))./(w/(2*L)));
    filter(1) = 0;
elseif(strcmp(type,'cos') == 1)
    filter = filter.* cos(w/(2*L));
end

filter(w>pi*L) = 0;
temp = fliplr(filter);
filter = [filter(1:end-1)';temp(2:end)'];
R_fft = fft(R, gridLen);
R_filt = real(ifft(R_fft.*repmat(filter,1,size(R,2))));
R_filt(size(R,1) + 1:end,:) = [];
end

