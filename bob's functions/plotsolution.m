function plotsolution(Rot,trans)

global model planelist planenorm facelines

p1 = zeros(3,1);
p2 = zeros(3,1);
for i = 1 : 3
  for j = 1 : facelines(i)
    p1(1) = model(i,j,1);
    p1(2) = model(i,j,2);
    p1(3) = model(i,j,3);
    p2(1) = model(i,j,4);
    p2(2) = model(i,j,5);
    p2(3) = model(i,j,6);
    tp1 = Rot*p1 + trans;
    tp2 = Rot*p2 + trans;
    plot3([tp1(1),tp2(1)],[tp1(2),tp2(2)],[tp1(3),tp2(3)],'k-')
  end
end




