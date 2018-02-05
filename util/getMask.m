function [ mask ] = getMask(frameNum)
%Input: frameNum: (int)     The number of frame.
%   return the mask.
    offset =       [ 0.15, 0.20, 0.25, 0.04];
    center =       [-0.71,-0.3,  0.81, 0.05];

    IMG = getImage(frameNum);
    XYZ = getDepth(frameNum);
       
    %BG removal: clears boundary
    %Not very useful, table and box have similar color
    %BG = double(rgb2gray(getImage(pcl_train,1)));
    %mask = abs(double(rgb2gray(IMG))-BG) > 20;
    
    %XYZ boundary
    mask = (XYZ(:,:,1) > center(1)-offset(1));
    mask(XYZ(:,:,1) > center(1)+offset(1)) = 0;
    mask(XYZ(:,:,2) < center(2)-offset(2)) = 0;
    mask(XYZ(:,:,2) > center(2)+offset(2)) = 0;
    mask(XYZ(:,:,3) < center(3)-offset(3)) = 0;
    mask(XYZ(:,:,3) > center(3)+offset(3)) = 0;
    %Erode to remove noise
    SE1 = strel('square',3);
    SE2 = strel('square',4);
    mask1 = imerode(imdilate(mask,SE1),SE2);
    
    %Hand HSV
    mask2 = removeSkin(IMG);
    %Disk because finger?
    SE3 = strel('disk',3);
    SE4 = strel('disk',7);
    mask2 = imdilate(imerode(mask2,SE3),SE4);
    
    %Background Blue
    mask3 = removeBlue(IMG);
    SE5 = strel('square',10);
    mask3 = imerode(imdilate(mask3,SE5),SE5);
    
    %CONBAIN!
    maskf = bitand(mask1,~mask2);
    maskf = bitand(maskf,~mask3);
    %Remove points with wrong XYZ
    mask = bitand(maskf,mask);
    %mask = mask2;
    %mask = mask3;
end

