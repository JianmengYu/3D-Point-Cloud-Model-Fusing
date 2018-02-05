pc = getPC(pcl_train,30);
XYZ = squeeze(pc.Location);
ABCD = fitplane(XYZ);
A = ABCD(1);
B = ABCD(2);
C = ABCD(3);
D = ABCD(4);

%[x y] = meshgrid(-1:0.01:0);
%z = -1/C*(A*x + B*y + D); % Solve for z vertices data
%xyz = reshape(cat(3,x,y,z),[10201,3]);
%XYZ = cat(1,XYZ,xyz);
%showPointCloud(pc);
%scatter3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'filled')