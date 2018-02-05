function [ IMG ] = getMaskedDepth(frameNum, plot)
%Input: frameNum: (int)     The number of frame.
%       plot:     (boolean) Use of Imshow or not.
%   return the masked image as RGB array.
    if nargin < 2
        plot = false;
    end
        
    IMG = getImage(frameNum);
    mask = getMask(frameNum);
    
    for i=1:3
        temp = IMG(:,:,i);
        temp(mask == 0) = 0;
        IMG(:,:,i) = temp;
    end
    
    if plot
        imshow(IMG);
    end
    
end

