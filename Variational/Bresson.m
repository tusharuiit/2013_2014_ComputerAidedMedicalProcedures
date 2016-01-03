% script implementing the splitting method of Bresson et al.
% for the convex relaxation of the Chan-Vese model
% as described in the following article
%
% X. Bresson, S. Esedoglu, P. Vandergheynst, J.P. Thiran and S. Osher
% Fast Global Minimization of the Active Contour/Snake Model
% Journal of Mathematical Imaging and Vision (JMIV), 28(2), 151-167, 2007
%
% written by
% Maximilian Baust
% May 15th 2013
% Chair for Computer Aided Medical Procedures & Augmented Reality
% Technische Universität München

% cleaning work
close all;
clear;
clc;

% define parameters
lambda = 1000; %Default 0.01
theta = 1.0; 
steps = 200; %Default 100
steps_fp = 5;
tau = 0.0005; %Default 0.1

% load image
I = double(rgb2gray(imread('AAA.png'))+1)/256;

% initialize u and v
u = I;
v = zeros(size(I));

% initialize mean values
mu_1 = 0.8;
mu_2 = 0.2;

% main iteration
for i = 1:steps
    
    % update constants
    mu_1 = sum(u(:).*I(:))/(sum(u(:))+10*eps);
    mu_2 = sum((1-u(:)).*I(:))/(sum(1-u(:))+10*eps);
    
    % compute L2-gradient of data term
    grad_E = (I-mu_1).^2-(I-mu_2).^2;
    
    % solve for u
    p1 = zeros(size(u));
    p2 = zeros(size(u));
    
    for j = 1:steps_fp
        [d1 d2] = grad(div(p1,p2)-v/theta);
        N = 1+tau*sqrt(d1.^2+d2.^2);
        p1 = (p1 + tau*d1)./N;
        p2 = (p2 + tau*d2)./N;
    end % end of inner iteration
    
    u = v - theta*div(p1,p2);
    
    % solve for v
    v = min(max(u-theta*grad_E,0),1);
    
    % visualize
    subplot(1,2,1)
    imagesc(I);
    axis equal tight off;
    colormap gray;
    hold on
    contour(u,[0.5 0.5],'y','LineWidth',2);
    hold off
    title('image with segmenting contour')
    
    subplot(1,2,2)
    imagesc(u);
    axis equal tight off;
    title(['embedding function u, step ' num2str(i)]);
    
    drawnow
    
end % end of main iteration