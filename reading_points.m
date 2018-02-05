%% Load the training data 
box = load('assignment_1_box.mat');
box = box.pcl_train;

%% Uncomment to load the test file
%box = load('assignment_1_test.mat');
%box = box.pcl_test;

% display the points as a point cloud and as an image
for frameNum = 1:length(box) % Reading the 50 point-clouds
    frameNum

    % extract a frame
    rgb = box{frameNum}.Color; % Extracting the colour data
    point = box{frameNum}.Location; % Extracting the xyz data
    pc = pointCloud(point, 'Color', rgb); % Creating a point-cloud variable

    % display the point cloud and corresponding image
    %figure(1)
    %imag2d(rgb) % Shows the 2D images
    figure(100)
    showPointCloud(pc)
    pause
end
      
