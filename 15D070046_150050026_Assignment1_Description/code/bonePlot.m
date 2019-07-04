data = load('../data/bone3D.mat');
pointSets = data.shapesTotal;

[data_preshaped, N , dim, num_points] = preprocess(pointSets);
h1 = figure;
for i = 1:N
    scatter3(pointSets(1,:,i), pointSets(2,:,i), pointSets(3,:,i),5, rand(1,3)); 
    hold on;
    title('Initial pointsets - Bones')
end
hold off;
save('../results/Initial_Pointsets_Bones.mat','h1');
[z_mean, data_aligned] = mean_calc(data_preshaped, N, dim, num_points);
h2 = figure;
for i = 1:N
    scatter3(data_aligned(1,:,i), data_aligned(2,:,i), data_aligned(3,:,i), 5, rand(1,3));     
    hold on;
    title('Aligned point sets and mean shape - Bones');
end
p1 = patch('vertices', z_mean','faces', data.TriangleIndex, 'facecolor','c','faceAlpha', 0.25, 'edgeAlpha', 0.05);
legend(p1,'Mean');
hold off;
save('../results/AlignedPointsetsAndMeanBones.mat','h2');
[D_sorted, V_sorted]  = mode_variation(z_mean, data_aligned, N, dim, num_points);
h3 = figure;
hold on;
title('Plot of variances - Bones');
plot(diag(D_sorted));
hold off;
save('../results/PlotVarianceBones.mat','h3');
z_mode1 = V_sorted(:,1)*sqrt(D_sorted(1,1));
z_mode2 = V_sorted(:,2)*sqrt(D_sorted(2,2));
z_mode3 = V_sorted(:,3)*sqrt(D_sorted(3,3));

z_mode1 = V_sorted(:,1)*sqrt(D_sorted(1,1));
z_mode2 = V_sorted(:,2)*sqrt(D_sorted(2,2));
z_mode3 = V_sorted(:,3)*sqrt(D_sorted(3,3));

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

p_1 = figure;
patch('vertices', z_mean','faces', data.TriangleIndex, 'facecolor', 'c', 'FaceAlpha', 0.25, 'EdgeAlpha', 0.05);
title('mean');
view([1 1 1])
save('../results/ModesOfVariationBones_mean.mat','p_1');

p_2 = figure;
patch('vertices', z1_1','faces', data.TriangleIndex, 'facecolor', 'c', 'FaceAlpha', 0.25, 'EdgeAlpha', 0.05);
title('+2 std. dev. for principal mode 1');
view([1 1 1])
save('../results/ModesOfVariationBones_2sd_p1.mat','p_2');

p_3 = figure;
patch('vertices', z1_2','faces', data.TriangleIndex, 'facecolor', 'c', 'FaceAlpha', 0.25, 'EdgeAlpha', 0.05);
title('-2 std. dev. for principal mode 1');
view([1 1 1])
save('../results/ModesOfVariationBones_neg_2sd_p1.mat','p_3');

p_4 = figure;
patch('vertices', z2_1','faces', data.TriangleIndex, 'facecolor', 'y', 'FaceAlpha', 0.25, 'EdgeAlpha', 0.05);
title('2 std. dev. for principal mode 2');
view([1 1 1])
save('../results/ModesOfVariationBones_2sd_p2.mat','p_4');

p_5 = figure;
patch('vertices', z2_2','faces', data.TriangleIndex, 'facecolor', 'y', 'FaceAlpha', 0.25, 'EdgeAlpha', 0.05);
title('-2 std. dev. principal mode 2');
view([1 1 1])
save('../results/ModesOfVariationBones_neg_2sd_p2.mat','p_5');

%legend([pm,p2,p3],'Mean','+2 std. dev','-2 std. dev');
%hold off;
%save('../results/ModesOfVariationBones.mat','h4');