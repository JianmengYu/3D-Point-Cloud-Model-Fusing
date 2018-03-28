%ROLL THE TAPE
%previmage = [];
for i=1:50
    a = getImage(i);
    mask = getMask(i);
    depth = reshape(getDepth(i),[217088,3]);
    depth(isnan(depth))=0;
    location = zeros(424,512,2);
    
    [A,B] = getCleanPlane(i);
    
    if numel(A) == 0
        %imshow(a);
        pause(0.1);
        continue
    end
    
    %curi = i;
    count = 1;
    for j=1:424
        for k=1:512
            location(j,k,:)=[j,k];
            if mask(j,k)
                point = a(j,k,:);
                if ~(point(1)<=0 && point(2)<=0 && point(3)<=0);
                if B(count)==1
                    a(j,k,:) = [255 0 0];
                elseif B(count)==2
                    a(j,k,:) = [0 0 255];
                elseif B(count)==3
                    a(j,k,:) = [0 255 0];
                elseif B(count)==-1
                    a(j,k,:) = [255 255 0];
                end
                count = count + 1;
                end
            end
        end
    end
    %[curi-1 curi]
    %a2 = cat(2, previmage, a);
    %previmage = a;
    
    C = getCorner(i);
    location = reshape(location,[217088,2]);
    
    if numel(C) > 0
   
    D = zeros(4,2);
    for n=1:4
        dist = sqrt(sum((depth-ones(size(depth))*diag(C(n,:))).^2,2));
        [~,MIN] = min(dist);
        D(n,:) = location(MIN,:);
    end
    
    for n=2:4
        D(n,:) = (D(n,:) - D(1,:))/2;
    end
    plotmask = zeros(424,512);
    
    %plot normal
    
    if max(B) >= 1
        index = floor(D(1,:)+D(2,:)+D(4,:));
        plotmask(index(1),index(2)) = 1;
        for n=1:100
            index2 = floor(index - n* 0.01 * D(3,:));
            plotmask(index2(1),index2(2)) = 1;
        end
    end
    
    if max(B) >= 2
        index = floor(D(1,:)+D(2,:)+D(3,:));
        plotmask(index(1),index(2)) = 1;
        for n=1:100
            index2 = floor(index - n* 0.01 * D(4,:));
            plotmask(index2(1),index2(2)) = 1;
        end
    end
    
    if max(B) >= 3
        index = floor(D(1,:)+D(3,:)+D(4,:));
        plotmask(index(1),index(2)) = 1;
        for n=1:100
            index2 = floor(index - n* 0.01 * D(2,:));
            plotmask(index2(1),index2(2)) = 1;
        end
    end
    
    SE = strel('disk',3);
    plotmask = imdilate(plotmask,SE);
    temp = a(:,:,1);
    temp(plotmask == 1) = 255;
    a(:,:,1) = temp;
    temp = a(:,:,2);
    temp(plotmask == 1) = 255;
    a(:,:,2) = temp;
    temp = a(:,:,3);
    temp(plotmask == 1) = 0;
    a(:,:,3) = temp;
    
    end
    
    
    imshow(a);
    pause();
end
reload;