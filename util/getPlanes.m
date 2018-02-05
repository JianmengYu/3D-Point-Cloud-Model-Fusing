function [ planes, pts ] = getPlanes( xyz, plot )
%GETPLANES return a list of candidate planes
%   Input: xyz: a list of coordinate with N x 3 shape.
%          Plot: Optional, show the colored planes.
%---Set parameter-----------------------------------------------
    PLANENUM  = 5;     %Max number of planes needed.
    
    PATDISTOL = 0.01;  %Patch-Distance Tolerance.
    PATMINPNT = 10;    %Minimum points for a patch to form.
    PATMAXRES = 0.0005; %Patch Plane Fitting Error Tolerance. 
    PATTRIES  = 500;    %Limit attempts to find patches. 
    
    PLANEGROWLIM = 5;   %Limit of times to grow a plane.
    PLANEREFITLIM = 50;  %Number of newpoints needed to refit.
    PLANEDISTOL = 0.006; %Plane-Distance Tolerance.
    PLANEPDISTOL = 2;  %Tolerance between point on same plane.
    PLANEMAXRES = 0.005;%Max Average Fitting Error Tolerance 
%---End setting-------------------------------------------------

    if nargin < 2
        plot = false;
    end
    
    [NPts, W] = size(xyz);
    assert(W==3, 'Nx3 shape pls');
    
    planes = zeros(PLANENUM,4);
    remaining = xyz;
    
    if plot
        figure(1)
        clf
        hold on
        %plot3(remaining(:,1),remaining(:,2),remaining(:,3),'k.');
    end
    
    indexs = 1:NPts;
    pts = zeros(NPts,1);
    
    for i = 1:PLANENUM
        %---Init---
        fitlist = [];
        newlist = [];
        fitindex = [];
        breaknextfor = false;
        %---Patch selection-------------------------------------
        L = size(remaining,1);
        idxs = randperm(L);
        for j = 1:L
            pnt = remaining(idxs(j),:);
            dists = sqrt(sum((remaining-ones(size(remaining))*diag(pnt)).^2,2));
            mask = dists < PATDISTOL;
            if sum(mask) > PATMINPNT
                fitlist = remaining(mask,:);
                %Too lazy to optimize this.
                [plane,resid] = fitplane(fitlist);
                if resid < PATMAXRES
                    remaining = remaining(~mask,:); %Bob forgot this.
                    planes(i,:) = plane;
                    fitindex = indexs(mask);
                    indexs = indexs(~mask);
                    break
                end
            end
            %Skipped when patch is found.
            %When no more patch could be found, skip the next for
            %loop to printout result.
            if j == L || j == PATTRIES
                breaknextfor = true;
                %disp('no more patches could be found!')
            end
        end
        %---Grow Patch to Plane-----------------------------------
        for j = 1:PLANEGROWLIM
            if breaknextfor
                break
            end
            distoplane = abs(remaining * planes(i,1:3)' + planes(i,4));
            mask = distoplane < PLANEDISTOL;
            %Is this really necessary? It's very slow.
            %for k = 1:size(mask,1)
            %    if ~mask(k)
            %        continue
            %    end
            %    for l = 1:size(fitlist,1)
            %        if norm(remaining(k,:)-fitlist(l,:)) < PLANEPDISTOL
            %            break;
            %        end
            %        if l == size(fitlist,1)
            %            mask(k) = false;
            %        end
            %    end
            %end
            newlist = cat(1,fitlist,remaining(mask,:));
            
            if sum(mask) > PLANEREFITLIM
                [newplane,fit] = fitplane(newlist);
                if fit > PLANEMAXRES * size(newlist,1)
                    break %Bad fit?
                end
                planes(i,:) = newplane;
                fitlist = newlist;
                remaining = remaining(~mask,:);
                fitindex = cat(2,fitindex,indexs(mask));
                indexs = indexs(~mask);
                continue
            end
            break %Weird control loop in bob's code.
        end
        %---End Grow Plane------------------------------------------
        pts(fitindex) = i;
        try
        if plot
            if i == 1
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'r.');
            elseif i==2 
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'b.');
            elseif i == 3
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'g.');
            elseif i == 4
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'c.');
            else
                plot3(newlist(:,1),newlist(:,2),newlist(:,3),'m.');
            end
        end
        end
    end
end

