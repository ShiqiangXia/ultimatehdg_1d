function [DVr] = GradVandermonde1D(N,r)

% function [DVr] = GradVandermonde1D(N,r)
% Purpose : Initialize the gradient of the modal basis (i) at (r) at order N
%           compute all Legendre polynomials derivative (deg<= N) at given points r

% return Matrix (dimension will be r * N+1) 
% every row : same point different polynomials

DVr = zeros(length(r),(N+1),numeric_t);

% Initialize matrix
for i=0:N
   [DVr(:,i+1)] = GradJacobiP(r(:),0,0,i);
end
return