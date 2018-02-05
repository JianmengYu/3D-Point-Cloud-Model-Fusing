function [ planesout, pointsout ] = getCleanPlane( frameNum, plot )
%Input: plot: boolean, optional, self explanatory.
%   return a list of planes, and a list of plane allocation.
%   set detailed parameters at getPlanes function, dont do it here.
%---Set parameter-----------------------------------------------
    MINPNT = 300; %Minimum point needed in plane for it to count.
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
    
    %Sort the planes take average of planes similar to largest.
    for i = 1:OUT
        if numel(points) == 0
            break
        end
        [ points, indexs ] = sort(points,'descend'); 
        if points(1) < MINPNT
            break
        end
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
        
        if sum(mask)==1
            planesout = cat(1,planesout,planes(mask,:));
        else
            planesout = cat(1,planesout,mean(planes(mask,:)));
        end
        
        
        points = points(~mask2);
        planes = planes(~mask2,:);
    end
    
    %prepare output
    NPts = size(XYZ,1);
    planenum = size(planesout,1);
    pointsout = zeros(NPts,1);
    index = 1:NPts;
    
    if plot
        figure(1)
        clf
        hold on
    end
        
    count = 1;
    newplaneouts = [];
    
    %plot and final cleanup
    for i = 1:planenum
        distoplane = abs(XYZ * planesout(i,1:3)' + planesout(i,4));
        mask = distoplane < PLANEDISTOL;
        
        if sum(mask) < MINPNT
            continue
        end
        
        newplaneouts = cat(1,newplaneouts,planesout(i,:));       
        pointsout(index(mask)) = count;
        newlist = XYZ(mask,:);
        if plot
            if count == 1
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'r.');
            elseif count==2 
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'b.');
            elseif count == 3
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'g.');
            else
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'y.');
            end
        end
        index = index(~mask);
        XYZ = XYZ(~mask,:);
        count = count + 1;
    end   
    if plot
    	plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'k.');
    end
    planesout = newplaneouts;
end

