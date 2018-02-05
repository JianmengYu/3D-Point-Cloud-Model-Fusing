function [ IMG ] = getMaskedImage(pcl_train, frameNum, plot)
%Input: pcl_train:(cell)    The pcl_train, dude.
%       frameNum: (int)     The number of frame.
%       plot:     (boolean) Use of Imshow or not.
%   return the masked image as RGB array.

    if nargin < 3
        plot = false;
    end
        
    IMG = getImage(pcl_train, frameNum);
    mask = getMask(pcl_train, frameNum);
    
    for i=1:3
        temp = IMG(:,:,i);
        temp(mask == 0) = 0;
        IMG(:,:,i) = temp;
    end
    
    if plot
        imshow(IMG);
    end
    
end

