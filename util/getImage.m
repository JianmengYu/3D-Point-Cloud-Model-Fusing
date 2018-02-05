function [ IMG ] = getImage(frameNum, plot)
%Input: frameNum: (int)     The number of frame.
%       plot:     (boolean) Use of Imshow or not.
%   return the image as RGB array.
    global pcl_train;

    if nargin < 2
        plot = false;
    end
    
    img = pcl_train{frameNum}.Color(:,:);
    IMG = flip(rot90(reshape(img, [512, 424, 3])));
    
    if plot
        imshow(IMG);
    end
    
end

