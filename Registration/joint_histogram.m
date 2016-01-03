%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate joint histogram of 2 images

function [histo] = joint_histogram(img1, img2)

bins = 256;

histo = zeros(bins, bins);

%%% TODO:
% calculate the joint histogram of img1 and img2
%   and store it in histo

[rows cols] = size(img1);
% rows=size(img1,1);
% cols=size(img2,2);

for i=1:rows  
  for j=1:cols
    histo(img1(i,j)+1,img2(i,j)+1)= histo(img1(i,j)+1,img2(i,j)+1)+1;
  end
end
    histo = histo/sum(histo(:));

end



