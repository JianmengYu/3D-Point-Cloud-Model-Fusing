function [ XYZ ] = getDepth(pcl_train, frameNum)
%Input: pcl_train:(cell)    The pcl_train, dude.
%       frameNum: (int)     The number of frame.
%   return the xyz locs.

    img = pcl_train{frameNum}.Location(:,:);
    XYZ = flip(rot90(reshape(img, [512, 424, 3])));
    
end

