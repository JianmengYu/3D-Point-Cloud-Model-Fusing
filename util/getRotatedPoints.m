function [ XYZ, C, points ] = getRotatedPoints( arg1, C )
%GETROTATEDPOINTS Project the coordinates onto xy,yz,xz planes.
%   arg1 : frameNum/ pc: if not frameNum, use the pc to extract corner.
%                     C: the extracted corner for rotation.
%   output: XYZ: points mapped to plane
%             C: swapped corners
%        points: new marked points (removing points outside the box)
    

    %---Setting Parameter---
    removeNegative = true;
    plot = true;
    %---Initialize---

    [planes, points] = getCleanPlane(arg1);
    if nargin < 2
        try
            arg1 = getPC(arg1);
        catch Error
            return
        end
        C = getCorner( arg1, planes, points );
    end
    XYZ = squeeze(arg1.Location);
    
    if size(C,1) == 0
        return
    end
    
    X = [1 0 0];
    Y = [0 1 0];
    Z = [0 0 1];
    Norm = C(1,:);
    C = bsxfun(@minus, C, Norm);
    XYZ = bsxfun(@minus, XYZ, Norm);
    
    %Calculate rotation matrix of first axis -- eliminate y;
    D = C(2,:);
    D(3) = 0;
    angle = atan2d(norm(cross(X,D)),dot(X,D));
    r = rotz(angle);
    D = r * C(2,:)';
    if abs(D(2)-0)>0.001
        r = rotz(360 - angle);
        D = r * C(2,:)';
    end
    
    %Calculate rotation matrix of first axis -- eliminate z;
    angle = atan2d(norm(cross(X,D)),dot(X,D));
    r2 = roty(angle);
    D = r2 * (r * C(2,:)');
    if abs(D(3)-0)>0.001
        r2 = roty(360 - angle);
        D = r2 * (r * C(2,:)');
    end
    
    %Calculate rotation matrix of second axis
    D = r2 * r * C(4,:)';
    angle = atan2d(norm(cross(Y,D)),dot(Y,D));
    r3 = rotx(angle);
    D = r3 * r2 * r * C(4,:)';
    if abs(D(3)-0)>0.001
        r3 = rotx(360 - angle);
        D = r3 * r2 * r * C(4,:)';
    end
    
    %Get final rotation matrix.
    r = r3 * r2 * r;
    
    %if mismatch, rotate more and swap axis.
    %Rotate to negative, (another rotation below rotate it back)
    D = r * C(3,:)';
    if D(3) > 0
        %if size(planes,1) == 3
        % THIS CASE IS MISSING, add it later.
        %end
        if size(planes,1) == 2
            r = roty(180) * r;
            D = C(2,:) - C(1,:);
            C(2,:) = C(2,:) - 2 * D;
            XYZ = bsxfun(@minus, XYZ, D);
        end
    end
    
    %Put red plane on xy plane, second plane on yz plane.
    %For better merging of planes.
    %i hate linear algebra.
     r = rotz(90) * rotx(180) * r;
    
    for i=1:numel(points)
        
        %Project all points on their plane.
        PN = points(i);
        if PN == 1
            PN = 3;
        elseif PN == 2
            PN = 4;
        elseif PN == 3
            PN = 2;
        else
            %Throw away the urchins
            XYZ(i,:) = [0 0 0];
            continue
        end
        point = projectPointOnLine(XYZ(i,:),[0 0 0],C(PN,:));
        XYZ(i,:) = XYZ(i,:) - point;
        
        % >>>ROTATE<<<   !orang DO NOT!
        %https://images7.memedroid.com/images/UPLOADED766/5933e855b50ca.jpeg
        XYZ(i,:) = r * XYZ(i,:)';
        
    end
    
    C = (r * C')';
    
    % Optionally remove all points with negative dim:
    if removeNegative
        %some error here
        mask = sum(XYZ < -0.0002,2) > 0;
        points(mask) = 0;
    end
    
    % Optionally remove outliers 
    % NO, leave the work to C
    
    if plot
    clf;
    hold on;
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    plot3(XYZ(points==1,1),XYZ(points==1,2),XYZ(points==1,3),'r.');
    plot3(XYZ(points==2,1),XYZ(points==2,2),XYZ(points==2,3),'b.');
    plot3(XYZ(points==3,1),XYZ(points==3,2),XYZ(points==3,3),'g.');
    %plot3(XYZ(points==-1,1),XYZ(points==-1,2),XYZ(points==0,3),'k.');
    scatter3(C(:,1),C(:,2),C(:,3),300,'filled');
    hold off;
    end

end

