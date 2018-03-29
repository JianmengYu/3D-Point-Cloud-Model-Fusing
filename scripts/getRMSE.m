reload;
error = zeros(50,3);
for i=1:50
    [planes,points] = getCleanPlane(i);
    try
        pc = getPC(i);
        XYZ = squeeze(pc.Location);
    catch Error
        continue
    end
    
    if numel(planes) == 0
        continue
    end 
    
    error(i,1) = size(points(points>0),1);
    error(i,2) = size(planes,1);
    
    numPoints = numel(points);
    localError = zeros(numPoints,1);
    
    for j = 1:numPoints
        planeID = points(j);
        if planeID > 0
         localError(j) = abs(XYZ(j,:) * planes(planeID,1:3)' + planes(planeID,4));
        end 
    end
    
    if max(points) == 1
        error(i,3) = sqrt(mean(localError(points==1).^2));
    end
    
    if max(points) == 2
        localError1 = sqrt(mean(localError(points==1).^2));
        localError2 = sqrt(mean(localError(points==2).^2));
        error(i,3) = (localError1 + localError2)/2;
    end
    
    if max(points) == 3
        localError1 = sqrt(mean(localError(points==1).^2));
        localError2 = sqrt(mean(localError(points==2).^2));
        localError3 = sqrt(mean(localError(points==3).^2));
        error(i,3) = (localError1 + localError2 + localError3)/3;
    end
    i
   
end

hold on;
bar(error(:,3))
xlim([0 51]);
set(gca,'xTick',1:50);
xlabel('Frame Number');
ylabel('(Average) Root Mean Square Error');
hold off;