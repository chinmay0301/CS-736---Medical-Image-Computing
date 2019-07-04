
data = load('../data/ellipses2D.mat');
pointSets = data.pointSets;

[data_preshaped, N , dim, num_points] = preprocess(pointSets);
h1 = figure;
hold on;
title('Initial pointsets - Ellipses')
for i = 1:N
    scatter(pointSets(1,:,i), pointSets(2,:,i), 5, rand(1,3)); 
end
hold off;
save('../results/Initial_Pointsets_Ellipses.mat','h1');
[z_mean, data_aligned] = mean_calc(data_preshaped, N, dim, num_points);
h2 = figure;
hold on;
title('Aligned point sets and mean shape - Ellipses');
for i = 1:N
    scatter(data_aligned(1,:,i), data_aligned(2,:,i), 5, rand(1,3));     
end
p1 = plot(z_mean(1,:),z_mean(2,:), 'LineWidth', 3);
legend(p1,'Mean');
hold off;
save('../results/AlignedPointsetsAndMeanEllipses.mat','h2');
[D_sorted, V_sorted]  = mode_variation(z_mean, data_aligned, N, dim, num_points);
h3 = figure;
hold on;
title('Plot of variances - Ellipses');
plot(diag(D_sorted));
hold off;
save('../results/PlotVarianceEllipses.mat','h3');
z_mode1 = V_sorted(:,1)*sqrt(D_sorted(1,1));
z_mode2 = V_sorted(:,2)*sqrt(D_sorted(2,2));
z_mode3 = V_sorted(:,3)*sqrt(D_sorted(3,3));

h4 = figure;
z1_1 = z_mean(:) + 2*z_mode1;  % vary the coefficient of z to see the range of a mode of variation
z1_1 = z1_1/norm(z1_1,2);
z1_1 = reshape(z1_1,[dim,num_points]);

z1_2 = z_mean(:) - 2*z_mode1;  % vary the coefficient of z to see the range of a mode of variation
z1_2 = z1_2/norm(z1_2,2);
z1_2 = reshape(z1_2,[dim,num_points]);

z2_1 = z_mean(:) + 2*z_mode2;  % vary the coefficient of z to see the range of a mode of variation
z2_1 = z2_1/norm(z2_1,2);
z2_1 = reshape(z2_1,[dim,num_points]);

z2_2 = z_mean(:) - 2*z_mode2;  % vary the coefficient of z to see the range of a mode of variation
z2_2 = z2_2/norm(z2_2,2);
z2_2 = reshape(z2_2,[dim,num_points]);

hold on;
title('Aligned point sets, mean shape and modes of variation- Ellipses');
for i = 1:N
    scatter(data_aligned(1,:,i), data_aligned(2,:,i), 5, rand(1,3));     
end
pm = plot(z_mean(1,:),z_mean(2,:),'LineWidth', 3);
p2 = plot(z1_1(1,:),z1_1(2,:),'LineWidth', 3);
p3 = plot(z1_2(1,:),z1_2(2,:),'LineWidth', 3);
legend([pm,p2,p3],'Mean','+2 std. dev','-2 std. dev');

hold off;
save('../results/ModesOfVariationEllipses.mat','h4');

