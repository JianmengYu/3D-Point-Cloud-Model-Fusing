%ROLL THE TAPE
for i=1:50
    a = cat(2,getImage(i),getMaskedImage(i));
    imshow(a);
    pause(0.1);
end
clear i;
clear a;