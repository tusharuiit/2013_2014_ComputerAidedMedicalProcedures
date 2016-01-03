function Region = RegionGrowing(I,T)
%T Threshold

Visited = zeros(size(I));
Region = zeros(size(I));

% Location of the 8 neighbors
neigb=[-1 0; 1 0; 0 -1;0 1; 1 1; -1 -1; -1 1; 1 -1]; 
[s1, s2] = size(I);
t = tic;

% Select and add the seed point to tho the queue of pixel to visist "list"
figure; imagesc(I);axis image; axis xy; title('Select the seed point');...
    colormap gray;axis off
[y x] = ginput(1);
x = round(x); 
y = round(y);
Im = I(x,y);
list = [x, y];

% Grow until no more pixel can be added to the FIFO list
Im = I(x,y); % Initialize the mean Intensity inside the region
list = [x, y];

while(size(list,1)~=0)
    % Pick up and remove the first pixel from the list
    px = list(1,1);
    py = list(1,2);
    pixel = I(px,py);
    
    if size(list,1) > 1
        list = list(2:end,:);
    else
        list = [];
    end
    
    % Check if pixel is homogeneous
    % By comparing it to the mean Intensity inside the region
    homogen = abs(pixel-Im) <T; 
    
    if homogen~=0
        Region(px, py) = 1;
        %Mean intensity should only be updated if there is some change to
        %the region
        tmp = find(Region == 1);
        [tmp2 ~] = size(tmp);

        Im = (Im*(tmp2-1) + pixel)/tmp2; %Update the mean intensity in the region
    
        for k = 1:8
            %%TODO COMPARE THAT THEY ARE NOT IN THE VISITED LIST
            pxNeigh = px + neigb(k,1);
            pyNeigh = py + neigb(k,2);
            
            if Visited(pxNeigh, pyNeigh) == 0
                [b, ~] = size(list);
                
                inlist = 0;
                for l=1:b
                    if pxNeigh == list(l,1) && pyNeigh == list(l,2)
                        inlist = 1;
                    end  
                end
                if inlist== 0
                    list = [list; pxNeigh, pyNeigh ]; %Put pixels in the list
                end
            end
        end
    %else %Not homogeneous
    end
    
    Visited(px,py) = 1; %Whether it is homogeneous or not
    
    if toc(t)>1/23
        imagesc(I+Region,[0 1]); axis image; colormap gray; axis off; axis xy;
        drawnow;
        t = tic;
    end
    
end

%% Display
imagesc(I+Region,[0 1]); axis image; colormap gray; axis off; axis xy;
drawnow;

