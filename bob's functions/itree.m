% interpretation tree - match model and data features until Limit are 
% successfully paired or can never get Limit
% numM - number of model featurses
% mlevel - last matched model feature
% Limit - early termination threshold
% pairs(:,2) - paired model-data features
% numpairs - number of paired features
% numD - number of data featurses
function success=itree(numM,mlevel,Limit,pairs,numpairs,numD)

  % check for termination conditions
  if numpairs >= Limit		% enough pairs to verify
    [Rot,trans] = estimatepose(numpairs,pairs);
    success = verifymatch(Rot,trans,numpairs,pairs);
    if success
      matchedpairs=pairs(1:numpairs,:)
      Rot
      trans
      plotsolution(Rot,trans);
      pause(1)
    end
    success=1;    % can set to 0 to force backtracking for other solutions
    return
  end
  if numpairs + numM - mlevel < Limit	% never enough pairs
    success=0;
    return
  end

  % normal case - see if we can extend pair list
  mlevel = mlevel+1;
  for d = 1 : numD	% try all data lines
%trypair=[mlevel,d]
    if unarytest(mlevel,d)
      % do all binary tests
      passed=1;

      for p = 1 : numpairs
        if ~binarytest(mlevel,d,pairs(p,1),pairs(p,2))
          passed=0;
          break
        end
      end
%if mlevel==5 & d==7
%passed=0;
%end
      % passed all tests, so add to matched pairs and recurse
      if passed
	pairs(numpairs+1,1)=mlevel;
	pairs(numpairs+1,2)=d;
	success = itree(numM,mlevel,Limit,pairs,numpairs+1,numD);
	if success
	  return
	end
      end
    end
  end

  % wildcard case - go to next model line
  success = itree(numM,mlevel,Limit,pairs,numpairs,numD);
