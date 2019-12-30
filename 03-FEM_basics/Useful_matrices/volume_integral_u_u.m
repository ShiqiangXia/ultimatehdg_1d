function A=volume_integral_u_u(N_u,N_GQ)

% compute (u_i,u_j) on reference element with Gauss quadrature N_GQ
% {u_i} u-variable basis

%% Get Quadrature points and weights
[r,w] = my_quadrature(N_GQ);

%% Get Vandermonde matrix for the basis
temp = my_vandermonde_u(r,N_u);

%% Numerical quadrature
A = temp' * (w.*temp);

end