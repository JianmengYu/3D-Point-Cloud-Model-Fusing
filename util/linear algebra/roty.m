function R = roty(beta)
%ROTY  rotate around Y by BETA
%
%	R = ROTY(BETA)
%
% See also: ROTX, ROTZ, ROT, POS.

% $ID$
% Copyright (C) 2005, by Brad Kratochvil

R = [cosd(beta) 0 sind(beta); ...
             0 1         0; ...
    -sind(beta) 0 cosd(beta)];
  
  
% this just cleans up little floating point errors around 0 
% so that things look nicer in the display
if exist('roundn'),
  R = roundn(R, -15);
end

end