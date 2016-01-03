% script implementing a conventional gradient descent
% for the convex relaxation of the Chan-Vese model
%
% written by
% Maximilian Baust
% May 15th 2013
% Chair for Computer Aided Medical Procedures & Augmented Reality
% Technische Universität München

addpath('./Filtering');

close all;
clear;
clc;

% define parameters
lambda = 0; %Default 0.01
steps = 200; %Default: 100
tau = 0.05; %Default: 0.1

% load image
I = double(rgb2gray(imread('AAA.png'))+1)/256;

% initialize u
u = I;

% initialize mean values
mu_1 = 0.8;
mu_2 = 0.2;

% main iteration
for i = 1:steps
    
    % update mean values
%      mu_1 = sum(u(:).*I(:))/(sum(u(:))+10*eps);
%      mu_2 = sum((1-u(:)).*I(:))/(sum(1-u(:))+10*eps);
    
    % compute gradient of the energy
    % 
    % compute the gradient of the energy defined on slide 34, equation (21)
	% and store it in the variable grad_E.
    norma = norm(grad(u));
    if norma == 0
        norma = norma + 10*eps;
    end
    
    tmp = grad(u)/norma;
    
    grad_E = (I - mu_1).^2 - (I - mu_2).^2 - lambda*div(tmp(1), tmp(2));
    
    % HINT: Use the functions div and grad for computing the gradient of
    %       the regularizer!
    
    % gradient descent step for u   
    u = u - tau*grad_E;
    
    % project u in order to ensure that 0 <= u <= 1
    %
    % re-project the function u as described on slide 41, equation (32).
    % 
    % HINT: This can be done in a single line of code!
    u = min(max(u,0),1);
    
    % visualize
    subplot(1,3,1)
    imagesc(I);
    axis equal tight off;
    colormap gray;
    hold on
    contour(u,[0.5 0.5],'y','LineWidth',2);
    hold off
    title('image with segmenting contour')
    
    subplot(1,3,2)
    imagesc(u);
    axis equal tight off;
    title(['embedding function u, step ' num2str(i)]);
    
    subplot(1,3,3)
    imagesc(grad_E);
    axis equal tight off;
    title('Graaaadient')
    drawnow 
    
end % end of main iteration