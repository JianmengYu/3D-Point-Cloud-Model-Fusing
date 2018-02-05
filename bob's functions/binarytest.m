% angle between a pair of data faces lies within delta of angle between a
% pair of model faces
function success = binarytest(m1,d1,m2,d2)

  global model planelist planenorm
  binarydelta = 0.1;

  % get model and data direction vectors 
  success = 0;
  if m1 == m2
    return
  end
  if d1 == d2
    return
  end
  vecm1 = planenorm(m1);
  vecm2 = planenorm(m2);
  vecd1 = planelist(d1,1:3);
  vecd2 = planelist(d2,1:3);

  % get angles
  angd = acos(vecd1*vecd2');
  if angd > pi/2
    angd = pi - angd;
  end
  angm = acos(vecm1*vecm2');
  if angm > pi/2
    angm = pi - angm;
  end

  % do test
  if abs(angd - angm) <= binarydelta
    success = 1;
  end
