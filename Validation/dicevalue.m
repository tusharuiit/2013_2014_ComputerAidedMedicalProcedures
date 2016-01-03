clear all ; close all; clc;

Image1 = imread('1.tif'); Image1 = rgb2gray(double(Image1));
Image2 = imread('2.tif'); Image2 = rgb2gray(double(Image2));
Image3 = imread('3.tif'); Image3 = rgb2gray(double(Image3));

I1seg = RegionGrowing(Image1,0.1);
% size(I1seg)
I2seg = RegionGrowing(Image2,0.1);
I3seg = RegionGrowing(Image3,0.1);

[row,col] = size(Image1);
count = 0;
for i = 1:row
    for j = 1:col
        if(Image1(i,j)==1 && I1seg(i,j)==1)
            count = count+1;
        end
    end
end         
Dvalue1 = 2*count/(length(find(Image1)) + length(find(I1seg)))

[row,col] = size(Image2);
count = 0;
for i = 1:row
    for j = 1:col
        if(Image2(i,j)==1 && I2seg(i,j)==1)
            count = count+1;
        end
    end
end         
Dvalue2 = 2*count/(length(find(Image2)) + length(find(I2seg)))

[row,col] = size(Image3);
count = 0;
for i = 1:row
    for j = 1:col
        if(Image3(i,j)==1 && I3seg(i,j)==1)
            count = count+1;
        end
    end
end         
Dvalue3 = 2*count/(length(find(Image3)) + length(find(I3seg)))
