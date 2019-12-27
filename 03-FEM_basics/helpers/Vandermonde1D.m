function [V1D] = Vandermonde1D(N,r)

% function [V1D] = Vandermonde1D(N,r)
% Purpose : Initialize the 1D Vandermonde Matrix, V_{ij} = phi_j(r_i);
%           compute all Legendre polynomials (deg<= N) at given points r
% N: polynomial degree  
% r: points

% return Matrix (dimension will be r * N+1) 
% every row : same point different polynomials


V1D = zeros(length(r),N+1,numeric_t);

for j=1:N+1 % for each column
    V1D(:,j) = JacobiP(r(:), 0, 0, j-1);
end
return