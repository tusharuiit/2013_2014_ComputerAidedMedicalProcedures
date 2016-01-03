%% Computer Aided Medical Procedures II - Summer 2012
%% Filtering
%% Exercise 4
%% Frangi filter

clear all; close all; clc; 

%% Read the image
I = imread('vessel.png'); 
I = double(I(:,:,1));

%% Set the Parameters
sigmas = [1:1:5];
beta  = 1;
c     = 100;

%% Create matrices to store all vesselness images
AllScale =zeros([size(I) length(sigmas)]);

%% Display the original image
figure(1); subplot(1,2,1); imagesc(I); axis image; colormap gray;axis off; title('Original');

% Frangi filter for all the scales sigma
for i = 1:length(sigmas)
    
    % 1. Calculate the 2D hessian for the scale sigmas(i)
    %% ToDo: Fill Hessian2D
    [Dxx,Dxy,Dyy] = Hessian2D(I, sigmas(i));
    
    % Correct for scale
    Dxx = (sigmas(i)^2)*Dxx;
    Dxy = (sigmas(i)^2)*Dxy;
    Dyy = (sigmas(i)^2)*Dyy;
    % Calculate eigenvalues and vectors and sort the eigenvalues
    [Lambda1,Lambda2]=eig2image(Dxx,Dxy,Dyy);

    % 2. Compute the similarity measures that make sense in 2D
    % and the corresponding vesselness measure
    Rb  = abs(Lambda1)./(abs(Lambda2));
    S   = sqrt(Lambda1.^2 + Lambda2.^2);
    
    [row col] = size(Lambda2);
    
    Vesselness = zeros(size(Lambda2));
    
    for j=1:row
        for k= 1:col
            if Lambda2(j,k) > 0
                Vesselness(j,k) = 0;
            else
                Vesselness(j,k) = exp(-(Rb(j,k)^2)/(2*beta^2))*(1-exp(-(S(j,k)^2)/(2*c^2)));
            end
        end
    end
    
    % 3. Set the Vesselness to 0 if Lambda2 is positive
    % and Store the results in the matrix AllScale
    AllScale(:,:,i) = Vesselness;
    
    figure(1); subplot(1,2,2); imagesc(Vesselness); axis image; colormap gray;axis off; title(sigmas(i));
    pause(0.1)
end

% 4. Which scale returns the highest vesselness value?
% Deduce the filtered image If
 [If I] = max(AllScale, [], 3);
 
% Display
figure(1); subplot(1,2,2); imagesc(If); axis image; ...
    colormap gray;axis off; title('Frangi filter');