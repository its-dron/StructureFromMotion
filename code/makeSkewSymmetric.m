function [ skew ] = makeSkewSymmetric( x )
%MAKESKEWSYMMETRIC Convert a 3x1 vector into a 3x3 skew symmetric matrix

skew=[0 -x(3) x(2) ; x(3) 0 -x(1) ; -x(2) x(1) 0 ];
end

