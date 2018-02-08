function [ pc ] = fuseModel( )
%COM Summary of this function goes here
%   Detailed explanation goes here

    global estimated_size model;
    
    %Optionally remove points outside ze box
    removeOutside = true;
    %plot = true; %you know you want to plot.
    
    XYZs = [];
    RGBs = [];
    
    %Rotation and shifting needed to apply.
    %r =  rotx(90);
    r = rotx(270) * rotz(180);
    norm = - (estimated_size / 2);
    
    for i = 1:50
        try
            pc = getPC(i);
        catch Error
            continue
        end
        [planes,points] = getCleanPlane(i);
        
        [XYZ, C, points] = getRotatedPoints( i );
        IMG = squeeze(pc.Color);
        
        %Compute Normalization and Rotate for Next main plane.
        rotate = model(i,1);
        if rotate ~= 0
            
            if rotate > 10
                rot1 = fix(rotate/10);
                rotate = fix(mod(rotate,10));
                if rot1 == 1
                    r = r * rotx(90);
                elseif rotate == 3
                    r = r * rotx(270);
                end
            end
            
            if rotate == 1
                r = r * rotx(90);
            elseif rotate == 3
                r = r * rotx(270);
            elseif rotate == 2
                r = r * roty(90);
            elseif rotate == 4
                r = r * roty(270);
            end
                            
        end
        
        local_rotate = model(i,2);
        
        if local_rotate >= 1
            if local_rotate == 1
                r2 = r * rotz(270);
            elseif local_rotate == 2
                r2 = r * rotz(0);
            elseif local_rotate == 3
                r2 = r * rotz(90);
            else
                r2 = r * rotz(180);
            end
        else
            r2 = r;
        end
        
        %Normalize the points so the model center at (0,0).
        if size(planes,1) <= 1
            
            
            continue
        end
                
        for j=1:numel(points)
            XYZ(j,:) = r2 * XYZ(j,:)';
            
            thisnorm = norm .* sign((r2*[1;1;1])');
            XYZ(j,:) = XYZ(j,:) + thisnorm;
        end
        
        mask = points > 0;
        if removeOutside
            mask = bitand(mask, XYZ(:,1) < estimated_size(1)/2+0.001);
            mask = bitand(mask, XYZ(:,1) >-estimated_size(1)/2-0.001);
            mask = bitand(mask, XYZ(:,2) < estimated_size(2)/2+0.001);
            mask = bitand(mask, XYZ(:,2) >-estimated_size(2)/2-0.001);
            mask = bitand(mask, XYZ(:,3) < estimated_size(3)/2+0.001);
            mask = bitand(mask, XYZ(:,3) >-estimated_size(3)/2-0.001);
        end
        
        XYZs = cat(1,XYZs,XYZ(mask,:));
        RGBs = cat(1,RGBs,IMG(mask,:));
        %pc = pointCloud(XYZ(mask,:), 'Color', IMG(mask,:));
        pc = pointCloud(XYZs, 'Color', RGBs);
        clf;
        showPointCloud(pc)
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        
        i
                
        pause();
    end

end

