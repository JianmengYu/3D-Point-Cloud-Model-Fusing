function [ C ] = getCorner( arg1, planes, points )
%GETCORNER Summary of this function goes here
%   INPUT: arg1 (frameNum / pc): if frameNum: getPC and other arguments
                                %if pc: need other argyments
%           planes, points: from getCleanPlane.       
%   OUTPUT: C: if one plane: []
              %if two plane: 2x3 matrix of 2 corner points
              %if  3  plane: 4x3 matrix of 4 corner points

    %---Setting Parameter---
    cutoff      = 4;%  For winsor the connect line
    cutoffshift = 2;%  Shift % for 3 plane case.
    cutoff2     = 3;%  Cutoff % for 3/4th point 
    plot = false;
    %---Initialize---
    %Problematic frames: 7 34 42
    C = zeros(3,3);
    if nargin < 2
        [planes points] = getCleanPlane(arg1);
        try
            arg1 = getPC(arg1);
        catch Error
            return
        end
    end
    XYZ = squeeze(arg1.Location);
    
    %--- Ignore if only 1 plane---
    NPS = size(planes,1);
    if NPS <= 1
        C = [];
        plot3(XYZ(points==1,1),XYZ(points==1,2),XYZ(points==1,3),'b.');
        return
    end
    
    if plot
    clf;
    hold on;
    plot3(XYZ(points==1,1),XYZ(points==1,2),XYZ(points==1,3),'b.');
    plot3(XYZ(points==2,1),XYZ(points==2,2),XYZ(points==2,3),'g.');
    plot3(XYZ(points==3,1),XYZ(points==3,2),XYZ(points==3,3),'r.');
    end
    
    mask = bitor(points == 1,points==2);
    XYZ2 = XYZ(mask,:);
    
    %Project all points on the connect line.
    [P,V,~] = getPlaneIntersection(planes(1,:),planes(2,:));
    tps = zeros(size(XYZ2,1),1);
    for i = 1:size(XYZ2,1)
        [point, tp] = projectPointOnLine(XYZ2(i,:),P,V);
        XYZ2(i,:) = point;
        tps(i) = tp;
    end
    
    %Winsor the line
    lower = cutoff;
    upper = 100 - lower;
    lim = prctile(tps,[lower,upper]);
    
    %If third plane, shift the winsor direction.
    if NPS == 3
        [NP,~] = getPlaneLineIntersection(planes(3,:),P,V);
        [~, tp3] = projectPointOnLine(NP,P,V);
        if abs(lim(1)-tp3) < abs(lim(2)-tp3)
            lower = cutoff - cutoffshift;
            upper = 100 - lower;
            lim = prctile(tps,[lower,upper]);
        else
            lower = cutoff + cutoffshift;
            upper = 100 - lower;
            lim = prctile(tps,[lower,upper]);
        end
    end
    
    %Remove outlier in the line
    mask = bitand(tps>lim(1),tps<lim(2));
    XYZ2=XYZ2(mask,:);
    tps2=tps(mask);
    [~, MAX] = max(tps2);
    [~, MIN] = min(tps2);
    C(1,:) = XYZ2(MAX,:);
    C(2,:) = XYZ2(MIN,:);
    
    %In 3-plane's case, points could be shifted.
    if NPS == 3
        [NP,~] = getPlaneLineIntersection(planes(3,:),P,V);
        dists = sqrt(sum((C(1:2,:)-ones(size(C(1:2,:)))*diag(NP)).^2,2));
        [~, MAX] = max(dists);
        C2 = zeros(4,3);
        C2(1,:) = NP;
        C2(2,:) = C(MAX,:);
    %Also get a third point in plane.
        mask = points > 1;
        XYZ3 = XYZ(mask,:);
        tps = zeros(size(XYZ3,1),1);
        for i = 1:size(XYZ3,1)
            [point, tp] = projectPointOnLine(XYZ3(i,:),NP,planes(1,1:3));
            XYZ3(i,:) = point;
            tps(i) = tp;
        end
        lim = prctile(tps,[cutoff2,100-cutoff2]);
        mask = bitand(tps>lim(1),tps<lim(2));
        XYZ3=XYZ3(mask,:);
        tps=tps(mask);
        if mean(tps) < 0
            [~, MIN] = min(tps);
            C2(3,:) = XYZ3(MIN,:);
            XYZ3 = XYZ3(tps < 0,:);
        else
            [~, MAX] = max(tps);
            C2(3,:) = XYZ3(MAX,:);
            XYZ3 = XYZ3(tps > 0,:);
        end
        
    %And fourth point
        mask = bitor(points==1,points==3);
        XYZ = XYZ(mask,:);
        tps = zeros(size(XYZ,1),1);
        crossV = cross(V,planes(1,1:3));
        for i = 1:size(XYZ,1)
            [point, tp] = projectPointOnLine(XYZ(i,:),NP,crossV);
            XYZ(i,:) = point;
            tps(i) = tp;
        end
        lim = prctile(tps,[cutoff2,100-cutoff2]);
        mask = bitand(tps>lim(1),tps<lim(2));
        XYZ=XYZ(mask,:);
        tps=tps(mask);
        if mean(tps) < 0
            [~, MIN] = min(tps);
            C2(4,:) = XYZ(MIN,:);
            XYZ = XYZ(tps < 0,:);
        else
            [~, MAX] = max(tps);
            C2(4,:) = XYZ(MAX,:);
            XYZ = XYZ(tps > 0,:);
        end
        
        %Put C back
        C = C2;
        if plot
            plot3(XYZ3(:,1),XYZ3(:,2),XYZ3(:,3),'b.');
            plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'g.');
        end
    end
    
    %Add optional line on 2 plane
    if NPS == 2
        NP = C(1,:);
        mask = points == 2;
        XYZ3 = XYZ(mask,:);
        tps = zeros(size(XYZ3,1),1);
        v = planes(1,1:3);
        for i = 1:size(XYZ3,1)
            [point, tp] = projectPointOnLine(XYZ3(i,:),NP,v);
            XYZ3(i,:) = point;
            tps(i) = tp;
        end
        lim = prctile(tps,[cutoff2,100-cutoff2]);
        if mean(tps) < 0
            mask = bitand(tps>lim(1),tps<0);
            XYZ3=XYZ3(mask,:);
            tps=tps(mask);
            [~, MIN] = min(tps);
            C(3,:) = XYZ3(MIN,:);
        else
            mask = bitand(tps<lim(2),tps>0);
            XYZ3=XYZ3(mask,:);
            tps=tps(mask);
            [~, MAX] = max(tps);
            C(3,:) = XYZ3(MAX,:);
        end
        
        mask = points == 1;
        XYZ = XYZ(mask,:);
        tps = zeros(size(XYZ,1),1);
        crossV = cross(V,planes(1,1:3));
        for i = 1:size(XYZ,1)
            [point, tp] = projectPointOnLine(XYZ(i,:),NP,crossV);
            XYZ(i,:) = point;
            tps(i) = tp;
        end
        lim = prctile(tps,[cutoff2,100-cutoff2]);
        if mean(tps) < 0
            mask = bitand(tps>lim(1),tps<0);
            XYZ=XYZ(mask,:);
            tps=tps(mask);
            [~, MIN] = min(tps);
            C(4,:) = XYZ(MIN,:);
        else
            mask = bitand(tps<lim(2),tps>0);
            XYZ=XYZ(mask,:);
            tps=tps(mask);
            [~, MAX] = max(tps);
            C(4,:) = XYZ(MAX,:);
        end
        
        if plot
            plot3(XYZ3(:,1),XYZ3(:,2),XYZ3(:,3),'b.');
            plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'g.');
        end
            
    end
    
    
    if plot
    plot3(XYZ2(:,1),XYZ2(:,2),XYZ2(:,3),'r.');
    scatter3(C(:,1),C(:,2),C(:,3),100,'filled');
    hold off;
    end
    
end

