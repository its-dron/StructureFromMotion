generateData;

% correctE = R2*makeSkewSymmetric(T2);
correctE = makeSkewSymmetric(T2)*R2';
testE = computeE(x1, x2);

nonZero = correctE > 0;

correctE(nonZero) ./ testE(nonZero)