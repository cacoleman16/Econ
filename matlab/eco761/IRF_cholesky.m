% Modified from Lutz Kilan, University of Michigan April 1997
% Generates the Impulse Response Functions to do the Variance Decompoistion
%

function [IRF]=IRF_cholesky(A,SIGMA,p,h,q)

J=[eye(q,q) zeros(q,q*(p-1))];
IRF=reshape(J*A^0*J'*chol(SIGMA)',q^2,1);

for i=1:h
	IRF=([IRF reshape(J*A^i*J'*chol(SIGMA)',q^2,1)]);
end;
