function [ ] = show3D( frameNum, filter )
%SHOW3D load frame (frameNum) of pcl_train
%   if filter is true, only show selected points
%   Detailed explanation goes here
    global pcl_train;

    try
        close(100);
    end
    figure(100);

    if nargin < 2
        filter = true;
    end
    
    pc = getPC(pcl_train, frameNum, filter);
    
    showPointCloud(pc);

end

