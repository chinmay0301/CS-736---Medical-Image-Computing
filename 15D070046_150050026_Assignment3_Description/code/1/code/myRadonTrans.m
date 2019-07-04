function radon_transform = myRadonTrans(img, deltaT, deltaTheta, deltaS)
	t = -90:deltaT:90;
	theta = 0:deltaTheta:180-deltaTheta;
	radon_transform = zeros(length(t), length(theta)); 

	for i = 1:length(t)
		for j= 1:length(theta)
			radon_transform(i,j) = myIntegration(img, t(i), theta(j), deltaS);
		end
	end
	
end