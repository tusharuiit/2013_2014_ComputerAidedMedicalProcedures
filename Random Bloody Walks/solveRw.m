function [probabilities, mask, colx, coly, values, W, Lu, Bt, M, diagonal, L] = solveRw(A,seeds,labels,beta)
seedsSort = sort(seeds);
%% Compute the edge weights with 4 neighbour connectivity
%Calculate the weights for each pair of neighbours
sizeA = size(A);
colx = [];
coly = [];
values = [];
numPixels = sizeA(1)*sizeA(2);

diagonal = zeros(numPixels,1);

for j=1:sizeA(2) %We go through the columns first
    for i=1:sizeA(1) %Then the rows
        %Current neighbour
        cValue = A(i,j); %current Value
        cIndex = sub2ind(sizeA, i,j); %currentIndex
        %Check the values for 
        
        %Neighbour 1 i j-1
        %Neighbour 2 i-1 j
        %Both have already been computed

        %Neighbour 3 i+1 j
        ni = i+1;
        nj = j;
        if (ni > 0 && nj > 0) && (ni <=sizeA(1) && nj <=sizeA(2))
            wij = abs(cValue - A(ni,nj));
            %Store the value on the matrix
            %Store it on [sub2ind(i,j) sub2ind(ni,nj)]
            cIndexNeighbour = sub2ind(sizeA, ni,nj); 
            colx = [colx,cIndex];
            coly = [coly, cIndexNeighbour];
            values = [values, wij];
            %Store it on [sub2ind(ni,nj) sub2ind(i,j)]
            colx = [colx, cIndexNeighbour];
            coly = [coly,cIndex];
            values = [values,wij];
        end
        
        %Neighbour 4 i j+1
        ni = i;
        nj = j+1;
        if (ni > 0 && nj > 0) && (ni <=sizeA(1) && nj <=sizeA(2))
            wij = abs(cValue - A(ni,nj));
            %Store the value on the matrix
            %Store it on [sub2ind(i,j) sub2ind(ni,nj)]
            cIndexNeighbour = sub2ind(sizeA, ni,nj); 
            colx = [colx,cIndex];
            coly = [coly, cIndexNeighbour];
            values = [values, wij];
            %Store it on [sub2ind(ni,nj) sub2ind(i,j)]
            colx = [colx, cIndexNeighbour];
            coly = [coly,cIndex];
            values = [values,wij];
        end
    end
end
 
minW = min(values);
maxW = max(values);
% values
%Normalize the weights
%Compute the exponential weights
values = (values - minW)./(maxW - minW + eps);
values = exp(-beta*values) + 1e-6;
% values
disp('End computations W')

%%Recompute L
tamValues = size(values,2);
%index to use in find
% tamValuesArray = 1:tamValues;

%number of pixels, values for the diagonal
%%Method one for computing the diagonal
% colxvalues = sortrows([colx', values']);
% for i=1:numPixels
%     tamValuesArray=1:size(colxvalues,1);
%     indx = find(colxvalues(tamValuesArray,1) == i);%numPixelsArray(i));
%     %Idea behind: they are sorted, so the indices can be diminished,
%     %improve the speed of the searches
%     diagonal(i) = sum(colxvalues(indx,2));
%     colxvalues=colxvalues(size(indx,1)+1:end, :);
%     
% end

W = sparse(colx, coly, values);

% keyboard

% whos W
%Method 2 for computing the diagonal

 diagonal = sum(W,2);
disp('End computations diagonal')

%Create a matrix
numPixelsArray = 1:numPixels;
L = sparse(numPixelsArray, numPixelsArray, diagonal');
L = L - W;

%% Assemble Lu and Bt by selecting rows and columns corresponding to unmarked nodes in the Graph-Laplacian
%%Lu should be sparse
sizeSeeds = size(seeds);
Lu = [];
Bt = [];
indexNoSeeds=[];
for s=1:sizeSeeds(1)
    if s==1
        if seedsSort(s)~=1
            Lu = [Lu; L(1:seedsSort(s)-1,:)]; 
            Bt= [Bt; L(1:seedsSort(s)-1,:)];
            indexNoSeeds= [indexNoSeeds, 1:seedsSort(s)-1];
        end
    else
        Lu = [Lu; L(seedsSort(s-1)+1:seedsSort(s)-1,:)];
        Bt= [Bt; L(seedsSort(s-1)+1:seedsSort(s)-1,:)];
        indexNoSeeds = [indexNoSeeds, seedsSort(s-1)+1:seedsSort(s)-1];
    end
end

%Last seed till the very end
Lu = [Lu; L(seedsSort(s)+1:end,:)];
Bt = [Bt; L(seedsSort(s)+1:end,:)];
indexNoSeeds = [indexNoSeeds, seedsSort(s)+1:numPixels];
%Go through the columns
Lu2 = [];
Bt2 = [];
for s=1:sizeSeeds(1)
    if s==1
        if seedsSort(s)~=1
            Lu2 = [Lu2,Lu(:,1:seedsSort(s)-1)];
        end
    else
        Lu2 = [Lu2, Lu(:,seedsSort(s-1)+1:seedsSort(s)-1)];
    end
    Bt2 = [Bt2,Bt(:,seedsSort(s))];
end
Lu2 = [Lu2, Lu(:,seedsSort(s)+1:end)];
Lu = Lu2;
Bt = Bt2;
Lu = sparse(Lu);
Bt = sparse(Bt);

% whos Lu
% whos Bt
disp('End Lu Bt')

%% Assemble M by creating a matrix, with one column per label
%%M should be sparse
M = zeros(sizeSeeds(1),2);
sorted = [seeds labels];
sorted = sortrows(sorted);
for s=1:sizeSeeds(1)
    M(s,sorted(s,2)) = 1;
end
M = sparse(M);
disp('End M')

%% Assemble the system of linear equations for solving the RandomWalks
%%problem
b = -Bt*M;
disp('End b')
%% Solve the linear system using backslash
probabilities = Lu\b;
mask = zeros(sizeA);
% mask2 = zeros(sizeA);
% mask3 = zeros(sizeA);
for s=1:sizeSeeds(1)
    [i,j] = ind2sub(sizeA, sorted(s,1)); %Position
    mask(i,j) = sorted(s,2); %Label
%     if sorted(s,2) ==1
%         mask2(i,j) = 1;
%     else
%         mask3(i,j) = 1;
%     end
end
disp('End mask1')

for pix=1:size(indexNoSeeds,2)
   if probabilities(pix,1) > probabilities(pix,2)
       labelPix = 1;
   else
       labelPix = 2;
   end
    [i,j] = ind2sub(sizeA, indexNoSeeds(pix));
    mask(i,j) = labelPix;
%     mask2(i,j) = b(pix,1);
%     mask3(i,j) = b(pix,2);
end
figure
imagesc(mask)

% figure
% imagesc(mask2)
% 
% figure
% imagesc(mask3)
end
