%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function cost_function
% implement intensity based registration

function [similarity_value] = cost_function(transform_params, img_fixed, img_moving, similarity_measure)

global img_registertest

% construct current transformation
angle = transform_params(1);
dx    = transform_params(2);
dy    = transform_params(3);

% apply current transformation to img_moving
%   store result in "img_registertest"
img_registertest = image_rotate(img_fixed, angle, [0 0]);
img_registertest = image_translate(img_registertest, [dx dy]);


% calculate similarity measure
switch upper(similarity_measure)
    case 'SSD'
        % calculate SSD
        [row columns] = size(img_fixed);
        similarity_value = sum(sum((img_fixed-img_registertest).^2))/(row*columns);
        
    case 'SAD'
        % calculate SAD
        [row columns] = size(img_fixed);
        similarity_value = sum(sum(abs(img_fixed-img_registertest)))/(row*columns);
        
    case 'NCC'
        %%% TODO:
        % calculate NCC
        img_fixedV = double(img_fixed(:));
        img_registertestV = double(img_registertest(:));
        
        mean_x = mean(img_fixedV);
        mean_y = mean(img_registertestV);
        std_x = std(img_fixedV);
        std_y = std(img_registertestV);
        similarity_value = -sum((img_fixedV-mean_x).*(img_registertestV - mean_y))/(size(img_fixed,1)*std_x*std_y);
        
        
    case 'MI'
        %%% TODO:
        % calculate MI, use the function joint_histogram
        [rowsF colsF] = size(img_fixed);
        [rowsR colsR] = size(img_registertest);
        
%         px = imhist(img_fixed);
%         py = imhist(img_registertest);
        
        pxy = joint_histogram(img_fixed, img_registertest);
        px = sum(pxy,1);
        py = sum(pxy,2);
        pxy = double(pxy);
        
        similarity_value = 0;
        
        for i=1:256
            for j=1:256
                if pxy(i,j)~=0 && px(i)~=0 && py(j)~=0
                    similarity_value = similarity_value + pxy(i,j)*log(pxy(i,j)/(px(i)*py(j))); 
                end
            end
        end
        similarity_value = -similarity_value;
end