function [ ] = show3D( pcl_train, frameNum, filter )
%SHOW3D load frame (frameNum) of pcl_train
%   if filter is true, only show selected points
%   Detailed explanation goes here

    try
        close(100);
    end
    figure(100);

    if nargin < 3
        filter = true;
    end
    
    pc = getPC(pcl_train, frameNum, filter);
    
    showPointCloud(pc);

end

