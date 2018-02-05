%ROLL THE TAPE
for i=1:50
    a = cat(2,getImage(pcl_train,i),getMaskedImage(pcl_train,i));
    imshow(a);
    pause(0.1);
end
clear i;
clear a;