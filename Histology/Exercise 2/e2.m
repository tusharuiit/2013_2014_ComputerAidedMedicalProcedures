
% This exercise shows the difference between polyaffine warps and linear
% interpolations of transformations. 
% To keep things simple we do not do a 2D interpolation (bilinear) but a 1D
% interpolation. Thus, only two transformations, which are located at
% different x-coordinates are used for the interpolation. 
%
% a) For a linear interpolation the weights of each interpolant must be
% computed. Open denseField.m and fill out the function weightsLinear to
% produce two weights for the two transformations.
%
% b) For the polyaffine warp the transformation matrices T{1}.A and T{2}.A
% must be made 'small' by using the matrix logarithm as described in the
% lecture. Compute and store these small matrices in T{1}.M and
% T{2}.m, respectively. Do this in the function denseField before 
% the start of the loop, which warps the points.
% Then, the interpolation is performed by iteratively updating the point
% with the small matrix. In denseField.m edit the function 
% infinitesimallyTransformPoint. Here, compute a direction vector from
% T{i}.M and T{i}.c, and store it in vectors(i). The interpolation is then
% done in the following lines.
%
% The final result should look like e2.fig.
function e2

close all;
clear all;

% set up two rigid transformations consisting
% cell consisting of A, c, where A is the rigid transformation and 
% c is the center of the transformation patch
angle = 0.63;

T = cell(1,2);
T{1}.A = [[cos(angle) -sin(angle); sin(angle) cos(angle)], [0; 0]; 0 0 1];
T{1}.c = [-2;0];
T{2}.A = [[cos(-angle) -sin(-angle); sin(-angle) cos(-angle)], [0; 0]; 0 0 1];
T{2}.c = [2;0];

% create points that should be warped
points_x = -5:0.5:5;
points_y = -5:0.5:5;

% compute displacement vectors using two Ts and the points
% using (forbiddden!) linear interpolation of the entries of the Ts
[dxl, dyl] = denseField( points_x, points_y, T, 'linear', 8 );
% using the polyaffine framework for the interpolation
[dx, dy] = denseField( points_x, points_y, T, 'polyaffine', 8 );

% plot the deformation fields
subplot(1,2,1)
plotDeformationField(points_x,points_y,dxl,dyl);axis image; title('linear');
subplot(1,2,2)
plotDeformationField(points_x,points_y,dx,dy);axis image; title('polyaffine');
end

function plotDeformationField(p_x,p_y,dx,dy)
hold on;
for yi = 1:numel(p_y)
    Tx = p_x + dx(:,yi)';
    Ty = p_y(yi) + dy(:,yi)';
    plot(Tx, Ty);
end
for xi = 1:numel(p_x)
    Tx = p_x(xi) + dx(xi,:);
    Ty = p_y + dy(xi,:);
    plot(Tx, Ty);
end
hold off;
end
