function P = basis_u(r,N)
% Normalized basis function for u variable on reference element
% r: points
% N: basis number (1,2,....Nu)

%% If use Legendre Polynomial (normalized)
[P] = JacobiP(r,0,0,N-1); % basis_N = Legendre poly degree N-1

end