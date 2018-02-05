function [ ] = showPlane( frameNum )
%SHOWPLANE plot the plane, dont use
%   Detailed explanation goes here
    try
        pc = getPC(frameNum);
    catch Error
        disp('Sorry no points in this frame.')
        return
    end
    getCleanPlane(frameNum,1);
end

