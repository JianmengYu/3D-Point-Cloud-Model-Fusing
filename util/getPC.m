function [ pc ] = getPC( pcl_train, frameNum, filter )
%GETPC Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 3
        filter = true;
    end    

    IMG = getImage(pcl_train, frameNum);
    XYZ = getDepth(pcl_train, frameNum);
    mask = getMask(pcl_train, frameNum);
    
    points={};
    rgbs={};
    
    count = 1;
    for i=1:424
        for j=1:512
            if (~filter) || (mask(i,j)~=0)
                point = IMG(i,j,:);
                if ~(point(1)<=0 && point(2)<=0 && point(3)<=0)
                    points{count}=XYZ(i,j,:);
                    rgbs{count}=point;
                    count = count + 1;
                end
            end
        end
    end
    
    pc = pointCloud(cell2mat(points), 'Color', cell2mat(rgbs));
    
end

