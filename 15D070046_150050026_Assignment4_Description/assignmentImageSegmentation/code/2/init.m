function [X, Y, mean_init, std_init] = init()
    load('../../data/assignmentSegmentBrainGmmEmMrf.mat/assignmentSegmentBrainGmmEmMrf.mat');
    %load('../../data/assignmentSegmentBrain.mat/assignmentSegmentBrain.mat');
    img = imageMask.*imageData;

    [L,Centers] = kmeans(img(:),4);
    img_init = reshape(L, [256,256]);
    if(img_init(1,1) == 0)
        img_init(img_init == img_init(1,1)) = 0;
    else
        l = img_init(1,1);
        a = img_init == 0;
        img_init(img_init == img_init(1,1)) = 0;
        img_init(a) = l;
    end
    t = sort(unique(img_init));
    img_init(img_init == t(2)) = 1;
    img_init(img_init == t(3)) = 2;
    img_init(img_init == t(4)) = 3;

    mean_init = zeros(3,1);
    std_init = zeros(3,1);

    for i = 1:3
        mean_init(i) = mean(imageData(img_init == i));
        std_init(i) = std(imageData(img_init == i));
    end
    X = img_init; Y = img;
end