function [ P M ] = getSquareSurface( frameNum, plot )
%DONOTUSE
    if nargin < 2
        plot = false;
    end
    
    P=[];
    M=[];
    [planes points] = getCleanPlane(frameNum);
    try
        pc = getPC(frameNum);
    catch Error
        return
    end
    XYZ = squeeze(pc.Location);
    
    NP = size(planes,1);
    
    for i=1:size(planes,1)
        if i = 1
            plane1 = planes(1,:);
        end
    end
        
        for j=1:size(points,1)
            if points(j) == i
                                
            end
        end
    

end

