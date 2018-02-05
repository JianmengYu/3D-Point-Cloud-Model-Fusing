function [ XYZ ] = getDepth(frameNum)
%Input: frameNum: (int)     The number of frame.
%   return the xyz locs.
    global pcl_train;

    img = pcl_train{frameNum}.Location(:,:);
    XYZ = flip(rot90(reshape(img, [512, 424, 3])));
    
end

