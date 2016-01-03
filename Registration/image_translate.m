%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B = image_translate(A, t)
%   A image, t translation vector
%   uses best-neighbor

function B = image_translate(A,t)

    B = A*0;
    
    d1 = size(B,1);
    d2 = size(B,2);
    % backward warping
    for xb=1:d1
        for yb=1:d2
            
			% calculate the correct indices for accessing matrix A
            %%%TODO Revise
            xa = round(xb - t(1));
            ya = round(yb - t(2));
            
            if ( xa>0 && ya>0 && xa<=d1 && ya<=d2 )
                B(xb,yb) = A( xa , ya );
			end
            
        end
    end
