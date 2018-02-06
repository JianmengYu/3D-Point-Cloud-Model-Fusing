function [ planesout, pointsout ] = getCleanPlane( frameNum, plot )
%Input: plot: boolean, optional, self explanatory.
%   return a list of planes, and a list of plane allocation.
%   set detailed parameters at getPlanes function, dont do it here.
%---Set parameter-----------------------------------------------
    MINPNT = 400; %Minimum point needed in plane for it to count.
    MAXANG = 15;    %Maximum angle in merge plane phase.
    REJANG = 65;   %Minimum angel needed between axis.
    ROUND = 5;     %Number of times to run getPlane.m
    OUT = 10;       %Maximum number of planes needed.
    PLANEDISTOL = 0.01; %Plane-Distance Tolerance.
    
%---End setting-------------------------------------------------
    try
        pc = getPC(frameNum);
    catch Error
        planesout = [];
        pointsout = [];
        return
    end

    if nargin < 2
        plot = false;
    end
        
    XYZ = squeeze(pc.Location);
    
    planes = [];
    points = [];
    
    planesout = [];
    
    %--Get the planes
    for i = 1:ROUND
        [tempplane, temppoint] = getPlanes(XYZ);
        planes = cat(1,planes,tempplane);
    
        points = cat(1,points,histc(temppoint,1:5));
    end
    
    %Get most possible plane.
    for i = 1:OUT
        if numel(points) == 0
            break
        end
        %Sort the remaining
        [ points, indexs ] = sort(points,'descend'); 
        if points(1) < MINPNT %Stop if no more good planes
            break
        end
        %Get a list of similar planes
        planes = planes(indexs,:);
        mask = logical(zeros(size(points)));
        mask2 = logical(zeros(size(points)));
        u = planes(1,1:3);
        for j= 1:size(points)
            if points(j) < MINPNT
                continue
            end
            v = planes(j,1:3);
            angle = atan2d(norm(cross(u,v)),dot(u,v));
            if angle < MAXANG
                mask(j) = true;
            end
            if angle < REJANG
                mask2(j) = true;
            end
        end
        %'Average' the candidate planes.
        if sum(mask)==1
            planesout = cat(1,planesout,planes(mask,:));
        else
            planesout = cat(1,planesout,mean(planes(mask,:)));
        end
        
        %Remove planes have similar angles
        points = points(~mask2);
        planes = planes(~mask2,:);
    end
    
    %prepare output
    %Mark all the points 
    NPts = size(XYZ,1);
    planenum = size(planesout,1);
    pointsout = zeros(NPts,1);
    index = 1:NPts;
    count = 1;
    newplaneouts = [];
    for i = 1:planenum
        %Get distant of everypoint to the plane checking.
        distoplane = abs(XYZ * planesout(i,1:3)' + planesout(i,4));
        mask = distoplane < PLANEDISTOL; %points in range
        %Check size of plane.
        mask2 = bitand(mask, pointsout == 0);
        if sum(mask2) < MINPNT
            continue
        end
        
        newplaneouts = cat(1,newplaneouts,planesout(i,:));
        
        mask2 = pointsout > 0; %Currently Marked points
        mask2 = bitand(mask, mask2); %Intersect Point
        mask = bitand(mask, ~mask2); %Remove the intersection points.
        
        pointsout(index(mask)) = count;
        pointsout(index(mask2)) = -1;
        
        %index = index(~mask);
        %XYZ = XYZ(~mask,:);
        count = count + 1;
    end
    
    %Re-mark cross points
    for i = 1:size(pointsout,1)
        if pointsout(i) == -1
            distoplane = abs(XYZ(i,:) * newplaneouts(:,1:3)' + newplaneouts(:,4)');
            [~, pointsout(i)] = min(distoplane);
        end
    end
    
    %plot stuff
    if plot
        figure(1)
        clf
        hold on
        for i = 1:planenum
            mask = pointsout == i;
            newlist = XYZ(mask,:);
            if i == 1
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'r.');
            elseif i==2 
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'b.');
            elseif i == 3
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'g.');
            end
        end
        
        mask3 = pointsout == -1;
        mask4 = pointsout == 0;
        intersect = XYZ(mask3,:);
        XYZ = XYZ(mask4,:);
    	plot3(intersect(:,1),intersect(:,2),intersect(:,3),'y.');
    	plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'k.');
    end
    planesout = newplaneouts;
end

