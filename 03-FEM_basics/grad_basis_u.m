function P = grad_basis_u(r,N)
% derivative of the normalized basis function for u variable on reference element
% r: points
% N: basis number (1,2,....Nu)

%% If use Legendre Polynomial (normalized)
[P] = GradJacobiP(r,0,0,N-1); % basis_N = Legendre poly degree N-1

end