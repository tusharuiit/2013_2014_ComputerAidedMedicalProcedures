function showSeeds(A,seeds,labels)
h = figure; imagesc(A); colormap gray;
hold on
[seedsy,seedsx] = ind2sub(size(A),seeds(:));
plot(seedsx(labels==1),seedsy(labels==1),'rx');
plot(seedsx(labels==2),seedsy(labels==2),'gx');
title('Seeds. Red:Foreground, Green: Background')
end