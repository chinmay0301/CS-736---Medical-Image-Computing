function [D] = decimate(k,s)
	d = zeros(k,k);
	for i = 1:s:k
	    for j = 1:s:k
	        d(i,j)=1;
	    end 
	end
	d1 = d(:)';
	D = diag(d1);
	D = D(any(D,2),:);
end