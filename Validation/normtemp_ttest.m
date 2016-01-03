close all; clear all;

data = csvread ('normtemp.csv',1,0);

maleindex = find(data(:,2)==1);
ladiesindex = find (data(:,2)==2);

% temp is for temperature
% hr is for heart rate

maletemp = data(maleindex,1) ;
malehr =  data(maleindex,3);
ladiestemp = data(ladiesindex,1) ;
ladieshr = data(ladiesindex,3);


[htemp,ptemp] = ttest(maletemp,ladiestemp)
[hhr,phr] = ttest(malehr,ladieshr)

[hall2,pall2] = ttest2([maletemp malehr],[ladiestemp ladieshr])
[hall1,pall1] = ttest([maletemp malehr],[ladiestemp ladieshr])
