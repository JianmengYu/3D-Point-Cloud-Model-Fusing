%ROLL THE TAPE
for i=1:50
    a = getImage(pcl_train,i);
    mask = getMask(pcl_train, i);
    
    try
        pc = getPC(pcl_train,i);
    catch Error
        
        imshow(a);
        pause(0.1);
        continue
    end
    [~,B] = getCleanPlane(pc);
    
    count = 1;
    for i=1:424
        for j=1:512
            if mask(i,j)
                point = a(i,j,:);
                if ~(point(1)<=0 && point(2)<=0 && point(3)<=0);
                if B(count)==1
                    a(i,j,:) = [255 0 0];
                elseif B(count)==2
                    a(i,j,:) = [0 0 255];
                elseif B(count)==3
                    a(i,j,:) = [0 255 0];
                elseif B(count)==4
                    a(i,j,:) = [255 255 0];
                end
                count = count + 1;
                end
            end
        end
    end
    imshow(a);
    pause(0.1);
end
reload;