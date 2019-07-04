function integral = myIntegration(img, t, theta, deltaS)
	[M,N] = size(img);

	s_max = floor(sqrt((M/2)^2 + (N/2)^2))+1;
	s_range = -s_max:deltaS:s_max;

	x = t*cosd(theta)-s_range*sind(theta)+ floor(N/2);
	y = t*sind(theta)+s_range*cosd(theta)+ floor(M/2);

	vals = interp2(img, x, y);
	nan_index = isnan(vals);
	vals(nan_index) = 0;

	integral = sum(vals)*deltaS;
end