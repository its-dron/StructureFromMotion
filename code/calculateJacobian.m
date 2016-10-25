syms a b c d e f g h i u v w x y z X Y Z fx fy dx dy px py

p = [px; py];
P = [X; Y; Z; 1];
K = [fx 0 dx; 0 fy dy; 0 0 1];
R = [a b c; d e f; g h i];
T = [x; y; z];

pt = K*[R,T]*P;
pt = pt(1:2) / pt(3);
error = norm(p-pt)^2;
