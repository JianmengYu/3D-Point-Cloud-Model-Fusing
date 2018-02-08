%Records the details of change to surface, for better merge.

%Random Patches is used to find planes, fix the seed for reproducible
%results. Random seed for RandPerm:

    global SEED estimated_size model;
    SEED = 420;

%Estimated size of the model
%   Use getRotatedPoints function with plot to find this.
%      %Dimension of the X Z Y edge of the box

    estimated_size = [0.17 0.09 0.17];
    %Use the below one for testing
    %estimated_size = [0.9 0.7 0.5];

%Red is main plane, blue is the second (clockwise second if third 
%plane exists) (It may show up as green). 

%Use playPlane2D to estimate this.
 
%below is a matrix showing:
%   first column: Change to red plane
%      0:  not changed
%      1:  changed to top,
%      2:  changed to  right,
%      3:  changed to  bottom,
%      4:  changed to  left,
%      12/14/32/34: Multiple Changes
%   second colum: direction of the "blue" plane.
%      0:  one or less plane is shown,
%      1:  on top,
%      2:  on right,
%      3:  on bottom,
%      4:  on left,

    model = [0 0; ... % 1
             0 0; ... %
             0 0; ... %
             0 1; ... %
             0 1; ... % 5
             0 1; ... % 
             1 0; ... % 
             0 0; ... % 
             1 3; ... % 
             0 0; ... % 10
             0 1; ... % 
             0 1; ... % 
            12 4; ... % 
             4 0; ... % 
             1 3; ... % 15
             0 2; ... % 
             0 1; ... % 
             0 2; ... % 
             2 4; ... % 
             0 2; ... % 20
             2 4; ... % 
             0 4; ... % 
             0 0; ... % 
             0 2; ... % 
             2 0; ... % 25
             0 2; ... % 
             2 4; ... % 
             0 4; ... % 
             0 0; ... % 
             0 2; ... % 30
             2 4; ... % 
             0 0; ... % 
             1 3; ... % 
             0 3; ... % 
             0 2; ... % 35
             0 1; ... % 
             1 0; ... % 
             0 0; ... % 
             0 1; ... % 
             1 3; ... % 40
             0 0; ... % 
             0 1; ... % 
             0 1; ... % 
             1 2; ... % 
             0 0; ... % 45
             2 4; ... % 
             0 4; ... % 
             0 0; ... % 
             0 1; ... % 
             0 0];    % 50
        