% verifies that the estimated translation and rotation do work
% 1) rotated model normals close to data normals
% 2) transformed model vertices lie inside the data plane
function success = verifymatch(Rot,trans,numpairs,pairs)

  global planenorm planelist model facelines

  % check normals
  success = 0;
  for i = 1 : numpairs
    d = planelist(pairs(i,2),1:3);
    m= planenorm(pairs(i,1),:);
%cn=[i,acos(d*Rot*m')]
    if acos(d*Rot*m') > 0.2
      ['Verification : reject - normals mis-aligned']
      return    % reject as too misaligned
    end
  end

  % check points
  m = zeros(3,1);
  for i = 1 : numpairs                    % over faces
    for k = 1 : facelines(i)              % over segments
      for j = 1 : 2                       % over endpoints
        m(1) = model(pairs(i,1),k,3*j-2); % get a point
        m(2) = model(pairs(i,1),k,3*j-1); % get a point
        m(3) = model(pairs(i,1),k,3*j);   % get a point
        tm = Rot*m + trans;               % transformed
        te = [tm' 1];                     % extended
%cp=te * planelist(pairs(i,2),:)'
        if abs(te * planelist(pairs(i,2),:)') > 1.5
          ['Verification : reject - vertices mis-aligned']
          return   % reject as too far away
        end
      end
    end
  end

  % special case of vector triple product if 3+ planes
  d1 = planelist(pairs(1,2),1:3);
  d2 = planelist(pairs(2,2),1:3);
  d3 = planelist(pairs(3,2),1:3);
  m1 = planenorm(pairs(1,1),:);
  m2 = planenorm(pairs(2,1),:);
  m3 = planenorm(pairs(3,1),:);
  if (d1*cross(d2',d3'))*(m1*cross(m2',m3')) < 0
    return
  end
  
  success = 1;
  
  
