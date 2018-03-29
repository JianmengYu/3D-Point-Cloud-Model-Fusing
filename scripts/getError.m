numPlanes = zeros(50,1);
error = zeros(50,3);
for i=1:50
    [planes,~] = getCleanPlane(i);
    
    if numel(planes) == 0
        continue
    end
    
    numPlanes(i) = size(planes,1);
    
    if numPlanes(i) == 2
        plane1 = planes(1,1:3);
        plane2 = planes(2,1:3);
        error(i,1) = atan2d(norm(cross(plane1,plane2)),dot(plane1,plane2));
        error(i,1) = abs(90-error(i,1));
        error(i,2) = error(i,1);
        error(i,3) = error(i,1);
    end
    
    if numPlanes(i) == 3
        plane1 = planes(1,1:3);
        plane2 = planes(2,1:3);
        plane3 = planes(3,1:3);
        error(i,1) = atan2d(norm(cross(plane1,plane2)),dot(plane1,plane2));
        error(i,2) = atan2d(norm(cross(plane1,plane3)),dot(plane1,plane3));
        error(i,3) = atan2d(norm(cross(plane2,plane3)),dot(plane2,plane3));
        error(i,1) = abs(90-error(i,1));
        error(i,2) = abs(90-error(i,2));
        error(i,3) = abs(90-error(i,3));
        
    end
    i
end

meanerror = mean(error,2);
meanerror2 = meanerror;
meanerror3 = meanerror;
meanerror2(numPlanes==2) = 0;
meanerror3(numPlanes==3) = 0;
hold on;
bar(meanerror2,'r');
bar(meanerror3,'b');
xlim([0 51]);
set(gca,'xTick',1:50);
xlabel('Frame Number');
ylabel('(Average) Angular Error');
hold off;