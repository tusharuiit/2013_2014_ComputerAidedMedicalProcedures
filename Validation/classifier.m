% Using matlab generate one vector of 100 random Gaussian values with mean=0 and std=1 and
% a second vector of random Gaussian values with mean=0.3 and std=1. Assume the samples of
% the first vector belong to the class positive and the second vector class negative. Apply a
% threshold of 0.15 and classify the samples and then compute the accuracy, sensitivity, and
% specificity of the classifier.

rand1 = 0 + 1.*randn(100,1);
rand2 = 0.3 + 1.*randn(100,1);


positive = rand1; negative = rand2;
TP = length(find(positive>0.15));
FP = length(find(positive<0.15));

TN = length(find(negative<0.15));
FN = length(find(negative>0.15));



% accuracy, sensitivity, and specificity
Accuracy = (TN + TP)/(TN+FN+TP+FP)
Sensitivity = TP/(TP+FN)
Specificity = TN/(TN+FP)