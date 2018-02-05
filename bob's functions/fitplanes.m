pc = getPC(pcl_train,40);
XYZ = squeeze(pc.Location);

figure(1)
clf
hold on
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'k.');

[NPts, W] = size(XYZ);
patchid = zeros(NPts,1);
planelist = zeros(20,4);
remaining = XYZ;

for i = 1 : 4   

  % select a random small surface patch
  [oldlist,plane] = select_patch(remaining);

  % grow patch
  stillgrowing = 1;
  print('fitting plane')
  while stillgrowing

    % find neighbouring points that lie in plane
    stillgrowing = 0;
    [newlist,remaining] = getallpoints(plane,oldlist,remaining,NPts);
    [NewL,W] = size(newlist);
    [OldL,W] = size(oldlist);
if i == 1
 plot3(newlist(:,1),newlist(:,2),newlist(:,3),'r.');
 save1=newlist;
elseif i==2 
 plot3(newlist(:,1),newlist(:,2),newlist(:,3),'b.');
 save2=newlist;
elseif i == 3
 plot3(newlist(:,1),newlist(:,2),newlist(:,3),'g.');
 save3=newlist;
elseif i == 4
 plot3(newlist(:,1),newlist(:,2),newlist(:,3),'c.');
 save4=newlist;
else
 plot3(newlist(:,1),newlist(:,2),newlist(:,3),'m.');
 save5=newlist;
end
pause(1)
    
    if NewL > OldL + 50
      % refit plane
      [newplane,fit] = fitplane(newlist);
[newplane',fit,NewL]
      planelist(i,:) = newplane';
      if fit > 0.04*NewL       % bad fit - stop growing
        break
      end
      stillgrowing = 1;
      oldlist = newlist;
      plane = newplane;
    end
  end

waiting=1
	 pause(1)

['**************** Segmentation Completed']

end