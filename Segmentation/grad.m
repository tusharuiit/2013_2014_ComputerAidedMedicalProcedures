function [dxu dyu] = grad(u)
% [dxu dyu] = grad(u) computes the gradient of the function u
% with forward differences assuming
% Neumann boundary conditions
%
% written by
% Maximilian Baust
% April 20th 2009
% Chair for Computer Aided Medical Procedures & Augmented Reality
% Technische Universität München

[m n] = size(u);

dxu = zeros(m,n);
dyu = zeros(m,n);

%approximate the derivative of u in x-direction with forward differences
tmp1 = [zeros(m,1) u];
tmp2 = [u zeros(m,1)];

t = tmp2-tmp1;
t = [t(:,2:end-1) zeros(m,1)];
%tmp1 = conv2(u, [-1 1]);
dxu = t; %tmp1(:,1:(n-1)) ;

%approximate the derivative of u in y-direction with forward differences
%tmp1 = conv2(u, [-1 1]');

tmp1 = [zeros(1,n); u];
tmp2 = [u; zeros(1,n)];

t = tmp2-tmp1;
t = [t(2:end-1,:) ; zeros(1,n)];

dyu = t; %tmp1(1:(m-1),:) ;



