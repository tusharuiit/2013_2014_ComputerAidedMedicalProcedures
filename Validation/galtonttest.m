close all; clear all;
data = csvread ('galton.csv',1,0);


% testing less than , i.e. , alternative hypothesis (no equal to sign) 
% 0.05 is Alpha - the Significance level 
% 'left' - Test the alternative hypothesis that the population mean1 is less than population mean1
% source - mathworks ttest
childheight = data(:,1) ; 
parentheight = data(:,2) ; 
[hval,pval] = ttest(childheight,parentheight ,0.05,'left')