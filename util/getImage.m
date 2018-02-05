function [ IMG ] = getImage(pcl_train, frameNum, plot)
%Input: pcl_train:(cell)    The pcl_train, dude.
%       frameNum: (int)     The number of frame.
%       plot:     (boolean) Use of Imshow or not.
%   return the image as RGB array.

    if nargin < 3
        plot = false;
    end
    
    img = pcl_train{frameNum}.Color(:,:);
    IMG = flip(rot90(reshape(img, [512, 424, 3])));
    
    if plot
        imshow(IMG);
    end
    
end

