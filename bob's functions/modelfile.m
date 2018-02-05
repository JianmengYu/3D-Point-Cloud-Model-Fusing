global model planenorm facelines

% triangular face
planenorm(1,:) = [0,0,-1];       % tri face 1 surf normal
facelines(1) = 3;                % # of boundary lines
model(1,1,:) = [0,0,0,66,0,0];   % Edge 1
model(1,2,:) = [0,0,0,0,66,0];   % edge 2
model(1,3,:) = [0,66,0,66,0,0];  % edge 3

planenorm(2,:) = [0, -1, 0];     % rect face 2 surf normal
facelines(2) = 4;
model(2,1,:) = [0,0,0,0,0,47];
model(2,2,:) = [0,0,0,66,0,0];
model(2,3,:) = [66,0,0,66,0,47];
model(2,4,:) = [0,0,47,66,0,47];

planenorm(3,:) = [-1, 0, 0];     % rect face 3 surf normal
facelines(3) = 4;
model(3,1,:) = [0,0,0,0,0,47];
model(3,2,:) = [0,0,0,0,66,0];
model(3,3,:) = [0,66,0,0,66,47];
model(3,4,:) = [0,0,47,0,66,47];
