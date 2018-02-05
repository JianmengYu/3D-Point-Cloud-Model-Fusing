%ROLL THE TAPE
reload;
for i=1:50
    fprintf('Checking Frame %i\n', i);
    showPlane(pcl_train,i);
    pause();
end