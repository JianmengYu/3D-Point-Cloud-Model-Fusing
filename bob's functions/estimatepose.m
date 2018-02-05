% estimates the transformation that maps a given set of
% model planes to a set of data planes
function [Rot,trans] = estimatepose(numpairs,pairs)

  global planenorm planelist model

  % estimate rotation
  M = zeros(3,numpairs);
  D = zeros(3,numpairs);
  for i = 1 : numpairs
    n = planenorm(pairs(i,1),:);
    M(:,i) = n';
    d = planelist(pairs(i,2),1:3);
    D(:,i) = d';
  end
  [U,DG,V] = svd(D*M');
  Rot = U*V';

  % estimate translation
  L = zeros(3,3);
  N = zeros(3,1);
  for i = 1 : numpairs
    d = planelist(pairs(i,2),1:3);
    dt = d';
    n = planelist(pairs(i,2),1:3);
    b = -n'*planelist(pairs(i,2),4);
    a = zeros(3,1);
    a(1) = model(pairs(i,1),1,1);
    a(2) = model(pairs(i,1),1,2);
    a(3) = model(pairs(i,1),1,3);
    ra = Rot*a;
    L = L + dt*d;
    N = N + (dt*d)*(ra-b);
  end
  trans = -inv(L)*N;


% matchedpairs =
% 
%      1     4
%      2     3
%      3     1
% 
% 
% Rot =
% 
%    -0.7712    0.6323    0.0732
%     0.4028    0.5739   -0.7131
%    -0.4929   -0.5204   -0.6973
% 
% 
% trans =
% 
%   358.9451
%  -198.3927
%  -162.1491
