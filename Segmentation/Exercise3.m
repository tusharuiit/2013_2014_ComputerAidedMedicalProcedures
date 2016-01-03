%% Exercise 3
%% Edge-Based segmentation methods
%% Gradient based / Basic, Canny

%% Clear and close everything
clear all; close all; clc;

%% ----------------------------------------------------------------------%%
%% ---------------------------------------------------------------------%%
%% Load the image
load('Image.mat')
Image = mat2gray(double(Image));
[s1 s2] = size(Image);

%% Filter the image with a Gaussian filter
gauss = fspecial('gaussian', [3 3], 1.5);
Image = imfilter(Image, gauss, 'symmetric');
fig = figure; imagesc(Image,[0 1]); axis image; colormap gray;axis off; ...
    axis xy

%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% A. Basic Edge detection

%% 1. Compute the Magnitude of the gradient
[gx gy] = grad(Image);
M = sqrt(gx.^2 + gy.^2);

figure(fig+1); imagesc(M); axis image; colormap jet;axis off; ...
    title('Gradient Magnitude'); axis xy

%% Threshold the gradient
EdgeBasic = (M>0.1);
figure(fig+2); imagesc(EdgeBasic); axis image; colormap gray; axis off; ...
    title('Edge - Basic thresholding'); axis xy

disp('1 - pause')
pause
close(fig+2)


%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% B. CANNY

%% STEP1: Non Maxima suppression step
Mn = M; %% Initialize the image with supressed non maxima edges

%% a. Compute the gradient direction
% gx = conv2(Image, [-1 0 1]);
% gx = gx(:, 2:end-1);
% 
% gy = conv2(Image, [-1 0 1]');
% gy = gy(2:end-1,:);

alpha = atan(gy./gx);

figure(fig+2); imagesc(alpha); axis image; colormap jet; axis off; ...
    title('Gradient Direction'); axis xy; colorbar

indices = alpha < 0;
alpha = (indices * pi) + alpha;

a = [0 45 90 135 180]; %% The 4 basic gradient directions (0=180)
a = a.*pi/180;

for i = 2:s1-1
    for j = 2:s2-1
        %% Compute the nearest basic direction to the local gradient
        %% direction
        %nearest = b
        [~, b] = min(abs(alpha(i,j)-a));
%         nearest = ;
        
        
        %% Just say that 0 and 180 should have the same index
        if b==5
            b=0;
            %alpha_b(i,j) = 1;
%         else
%             alpha_b(i,j) = nearest;
        end
        
        %% Get the two neigbors in opposite directions
        % (4 possibilities)
        if b== 0
            nd = Mn(i+1,j);
            ng = Mn(i-1,j);
        elseif b == 1
            nd = Mn(i+1,j+1);
            ng = Mn(i-1,j-1);
        elseif b == 2
            nd = Mn(i,j+1);
            ng = Mn(i,j-1);
        elseif b == 3
            nd = Mn(i-1,j+1);
            ng = Mn(i+1,j-1);
        end
        %% And check if the gradient magnitude is is smaller than the
        %% gradient magnitude of one of its neighbours in the chosen
        %% direction. In this case, set it to zero in Mn.
        if Mn(i,j) < nd || Mn(i,j) < ng
            Mn(i,j)=0;
        end
    end
end

%% Display
figure(fig+3); imagesc(Mn); axis image; colormap jet; axis off; ...
    title('Magnitude after Non maxima suppresion'); axis xy

%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% STEP2: Hysteresis

% Create the strong pixel map
Th = 0.1;               %% high treshold
StrongPixel = zeros(s1,s2);

for i=1:s1
    for j=1:s2
        if Mn(i,j) <= Th
            StrongPixel(i,j)= 0;
        else
            StrongPixel(i,j)= 1;
        end
    end
end
%StrongPixel = find(M > 0.3);        %% Strong pixel map

% Create the weak pixel map
Tl = 0.03; %Default 0.3               %% low treshold
WeakPixel = zeros(s1,s2);


for i=1:s1
    for j=1:s2
        if Mn(i,j) <= Tl
            WeakPixel(i,j)= 0;
        else
            WeakPixel(i,j)= 1;
        end
    end
end

WeakPixel = WeakPixel - StrongPixel;

% Display
figure(fig+4); imagesc(StrongPixel); axis image; colormap gray; axis off; ...
    title('Strong Pixel'); axis xy
figure(fig+5); imagesc(WeakPixel); axis image; colormap gray; axis off; ...
    title('Weak Pixel'); axis xy

% Find the connected component (8-connectivity, use the function bwlabel)
Tmp = StrongPixel + WeakPixel;
C = bwlabel(Tmp,8);
figure(8)
imagesc(C); colormap jet

% Compute the final edge map "EdgeCanny"
EdgeCanny = zeros(size(M)); %% Initialize

% For every connected component, check if one of the pixels is a "strong
% pixel". In this case, set the whole component to be an edge
EdgeCanny = StrongPixel;
% 
% for i=1:s1
%     for j=1:s2
%         if C(i,j)~=0
%             if WeakPixel(i,j)~=0
%                 EdgeCanny(i,j) = 1;
%             end
%         end
%     end
% end

neigb=[-1 0; 1 0; 0 -1;0 1; 1 1; -1 -1; -1 1; 1 -1];

for k = 1:max(max(C))
    %k number of the connected component
    
    [r c] = find(C == k);
    [a b] = size(r);
    
    for i=1:a
        include = false;
        
        %Check the neighbourhood
        %Check whether correspond to a strong edge
        if StrongPixel(r(i),c(i)) ~=0
            include = true;
        else
            for j= 1:8
                if StrongPixel(r(i)+ neigb(j,1), c(i) + neigb(j,2)) ~= 0
                    include = true;
                end
            end
        end
        
        if include
            EdgeCanny(r(i),c(i)) = 1;
        end
        %If yes, we add the point
    end
end

% Display
figure(fig+6); imagesc(EdgeCanny); axis image; colormap gray; axis off; axis xy;...
    title('Final Canny output');


