% close all;
% Create two vectors of 100 random Gaussian values with mean =0 and std=0.5.
% Depict the bland-altman plot and the boxplot of the error.

rand1 = 0 + 0.5.*randn(100,1);
rand2 = 0 + 0.5.*randn(100,1);

%Horizontal lines are drawn at the mean difference, and at the limits of agreement, 
%which are defined as the mean difference plus and minus 1.96 times the standard deviation of the differences

figure(); plot((rand1+rand2)/2,rand1-rand2,'b+'); title('bland-altman plot');
hold on; plot((rand1+rand2)/2,zeros(100,1),'b-'); 
hold on; plot((rand1+rand2)/2,ones(100,1)*1.96*0.5,'r-'); 
hold on; plot((rand1+rand2)/2,ones(100,1)*(-1.96*0.5),'r-');


figure(); boxplot([rand1 rand2],{'rand1' 'rand2'}); title('box plot');