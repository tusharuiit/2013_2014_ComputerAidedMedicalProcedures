
% E1a) conversion from rgb to od. 
% convert an rgb-value to optical density (od) space.
% a value of 255 should map to a value close to 0, a value of 0 should map
% to 1.
% Note: keep in mind that log(0) maps to -infinity, which should be
% avoided!
function D = rgb2od(I)
%    D = double(I)/255 % this is a placeholder, which is wrong!
    D = -log((double(I)+1)/255)/log(255);
end