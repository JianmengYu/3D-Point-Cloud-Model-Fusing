IMG = getMaskedImage(pcl_train,18);
BW = edge(rgb2gray(IMG),'Sobel',0.2);
SE = strel('square',2);
BW = imerode(imdilate(BW,SE),SE);
imshow(cat(1,rgb2gray(IMG),BW*255));