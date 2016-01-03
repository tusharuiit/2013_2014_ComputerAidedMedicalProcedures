function [dx, dy] = denseField(points_x, points_y, T, method, N)
  
  % the number of iterations used during the fast polyaffine transformation
  if (nargin<5)
    N = 8;
  end
  
  % E2b) create the 'small versions' of T{1}.A and T{2}.A and save them in
  % T{1}.M and T{2}.M, respectively
%   T{1}.M = eye(3,3); %placeholder, replace this by correct formula
%   T{2}.M = eye(3,3); %placeholder, replace this by correct formula
%   
  T{1}.M = expm(logm(T{1}.A)/N);
  T{2}.M = expm(logm(T{2}.A)/N) ;
  
  dx = zeros( numel(points_x), numel(points_y) );
  dy = zeros( numel(points_x), numel(points_y) );
  
  % warp points
  for yi = 1:numel(points_y)
    for xi = 1:numel(points_x)
    
      x = points_x(xi);
      y = points_y(yi);
      
      if (strcmp(method,'polyaffine'))
        xt = transformPointPolyAffine([x y]', T, N);
      end
      if (strcmp(method,'linear'))
        xt = transformPointLinear([x y]', T);
      end
      
      dx(xi,yi) = xt(1) - x;
      dy(xi,yi) = xt(2) - y;

    end
  end
end

function pt = transformPointLinear(pt, T)
  [weight1, weight2] = weightsLinear(pt, T);
  A = weight1 * T{1}.A + weight2 * T{2}.A;
  pt_h = A * [pt;1];
  pt = pt_h(1:2,1);
end

function pt = transformPointPolyAffine(pt, T, N)
  for i=1:N
    pt = infinitesimallyTransformPoint(pt, T);
  end  
end

function pt = infinitesimallyTransformPoint(pt, T)
  vectors = zeros(2,numel(T));
  pt = [pt;1];
  for i=1:numel(T) % for all transformations
    c = T{i}.c;
    c = [c;0];
    M = T{i}.M;
    
    tmp = M*(pt - c)- (pt-c);
    vectors(:,i) = tmp(1:2);
    % E2b): compute direction vector from M, c, pt and store them in vectors(:,i)
  end
  pt = pt(1:2);
  [weight1, weight2] = weightsLinear(pt, T);
  pt = pt + weight1 * vectors(:,1) + weight2*vectors(:,2);
end

function [weight1, weight2] = weightsLinear(pt, T)

  % E2a) compute the weights for the transformations T{1} and T{2} depending on
  % point pt. For that you need the transformation centers, T{1}.c and
  % T{2}.c. 
  % Store the weight for T{1} in weight1 and for T{2} in weight2.
  % Note: Make sure that to handle the borders, i.e. if the point is 'left'
  % of T{1}.c weight1 should be 1 and weight2 should be 0. Analogously
  % treat the case where pt is 'right' of T{2}.
  
%   weight1=0; %placeholder, replace this by correct formula
%   weight2=0; %placeholder, replace this by correct formula
  
  if pt(1) < T{1}.c(1)
    weight1=1; 
    weight2=0;
  elseif pt(1) > T{2}.c(1)
      weight1 = 0;
      weight2 = 1;
  else
      weight1 = abs((T{2}.c(1) - pt(1)))/abs((T{2}.c(1) - T{1}.c(1)));
      weight2 = 1-weight1;
  end
end
