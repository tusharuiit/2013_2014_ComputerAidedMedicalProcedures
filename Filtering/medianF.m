function I = medianF(I)
[tx ty] = size(I);

for i=3:(tx-2)
    for j=3:(ty-2)
        M = I((i-2):(i+2) , (j-2):(j+2));
        M = M(:);
        I(i,j) = median(M);
    end
end

end