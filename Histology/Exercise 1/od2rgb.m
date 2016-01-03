% E1a) build the inverse function of rgb2od
function I = od2rgb(D)
%   I = uint8(D*255); % this is a placeholder, which is wrong!
  I = uint8((255*exp(-log(255)*D)-1)*(255/254));
end