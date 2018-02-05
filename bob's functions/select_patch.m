% find a candidate planar patch
function [fitlist,plane] = select_patch(points)

  [L,D] = size(points);
  tmpnew = zeros(L,3);
  tmprest = zeros(L,3);

  % pick a random point until a successful plane is found
  success = 0;
  while ~success
    idx = floor(L*rand)
    pnt = points(idx,:);
  
    % find points in the neighborhood of the given point
    DISTTOL = 5.0;
    fitcount = 0;
    restcount = 0;
    for i = 1 : L
      dist = norm(points(i,:) - pnt);
      if dist < DISTTOL
        fitcount = fitcount + 1;
        tmpnew(fitcount,:) = points(i,:);
      else
        restcount = restcount + 1;
        tmprest(restcount,:) = points(i,:);
      end
    end
    oldlist = tmprest(1:restcount,:);

    if fitcount > 10
      % fit a plane
      [plane,resid] = fitplane(tmpnew(1:fitcount,:))

      if resid < 0.1
        fitlist = tmpnew(1:fitcount,:);
        return
      end
    end
  end  
