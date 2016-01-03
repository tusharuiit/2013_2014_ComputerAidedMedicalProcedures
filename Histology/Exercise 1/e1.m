%Exercise1: color deconvolution
% a) compute mappings from rgb to optical density space and inversely.
%    for that fill out functions od2rgb.m and rgb2od.m
% b) compute the 'stain' matrix mapping from od space to stain
% concentration space.

function e1
% uncomment what you want to test
% e1a
e1b
end

function e1a
display(sprintf('rgb2od(255) = %d', rgb2od(255)));
display(sprintf('rgb2od(0) = %d', rgb2od(0)));
display(sprintf('od2rgb(0) = %d', od2rgb(0)));
display(sprintf('od2rgb(1) = %d', od2rgb(1)));
figure
plot(0:0.5:255,rgb2od(0:0.5:255)); %compare this to plote1a.fig
figure
plot(0:1/255:1, od2rgb(0:1/255:1));
end

function e1b
clear all;
I = imread('t1.tif');

% measured stain colors in RGB space
sH = rgb2od([133.87996, 124.53495, 195.26811]);
sE = rgb2od([232.39385,  98.17126, 192.10144]);

% E1b:
% creation of M matrix
% create a 3x3 matrix containing the normalized stain vectors
% in its 1st 2 columns and a vector orthogonal to them in the 3rd column.
% M = eye(3,3);
sH = sH/norm(sH);
sE = sE/norm(sE);
c = cross(sH, sE);
c = c/norm(c);
M = [sH; sE; c ];
M = M';

% rgb2od
Iod = rgb2od(I);

% compute stain concentrations
% Is = matrixMultImage(M,Iod);
Is = matrixMultImage(inv(M),Iod);


% select stain
S = eye(3,3);
S(1,1) = 1; S(2,2) = 0; S(3,3) = 0;
AH = matrixMultImage(S,Is);
S(1,1) = 0; S(2,2) = 1; S(3,3) = 0;
AE = matrixMultImage(S,Is);
S(1,1) = 0; S(2,2) = 0; S(3,3) = 1;
AR = matrixMultImage(S,Is);

% convert back
I2 = od2rgb(matrixMultImage(M,AH+AE));
IH = od2rgb(matrixMultImage(M,AH));
IE = od2rgb(matrixMultImage(M,AE));
IR = od2rgb(matrixMultImage(M,AR));
% I2 = od2rgb(matrixMultImage(inv(M),AH+AE));
% IH = od2rgb(matrixMultImage(inv(M),AH));
% IE = od2rgb(matrixMultImage(inv(M),AE));
% IR = od2rgb(matrixMultImage(inv(M),AR));

% compare this plot to plote1b.fig
figure
subplot(2,2,1);imagesc(I2);axis image;title('reconstructed');
subplot(2,2,2);imagesc(IH);axis image;title('H');
subplot(2,2,3);imagesc(IE);axis image;title('E');
subplot(2,2,4);imagesc(IR);axis image;title('residual');
end
