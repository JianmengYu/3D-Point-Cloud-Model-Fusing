function [ ] = showPlane( pcl_train, frameNum )
%SHOWPLANE plot the plane, dont use
%   Detailed explanation goes here
    try
        pc = getPC(pcl_train,frameNum);
    catch Error
        disp('Sorry no points in this frame.')
        return
    end
    getCleanPlane(pc,1);
end

