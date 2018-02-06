picker = 19;
[planes points] = getCleanPlane(picker,1);
sa = size(planes,1);

pts = 0:0.01:1;
if sa == 2
   [A B C] = getPlaneIntersection(planes(1,:), planes(2,:));
   c1 = A(1) + B(1) * pts;
   c2 = A(2) + B(2) * pts;
   c3 = A(3) + B(3) * pts;
   plot3(c1,c2,c3);
end

if sa == 3
   [A B C] = getPlaneIntersection(planes(1,:), planes(2,:));
   c1 = A(1) + B(1) * pts;
   c2 = A(2) + B(2) * pts;
   c3 = A(3) + B(3) * pts;
   plot3(c1,c2,c3);
   
   [A B C] = getPlaneIntersection(planes(2,:), planes(3,:));
   c1 = A(1) + B(1) * pts;
   c2 = A(2) + B(2) * pts;
   c3 = A(3) + B(3) * pts;
   plot3(c1,c2,c3);
   
   [A B C] = getPlaneIntersection(planes(1,:), planes(3,:));
   c1 = A(1) + B(1) * pts;
   c2 = A(2) + B(2) * pts;
   c3 = A(3) + B(3) * pts;
   plot3(c1,c2,c3);
end