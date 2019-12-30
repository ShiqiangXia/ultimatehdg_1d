function A=volume_integral_q_q(N_q,N_GQ)

% compute (q_i,q_j) on reference element with Gauss quadrature N_GQ
% {q_i} q-variable basis

%% Get Quadrature points and weights
[r,w] = my_quadrature(N_GQ);

%% Get Vandermonde matrix for the basis
temp = my_vandermonde_q(r,N_q);

%% Numerical quadrature
A = temp' * (w.*temp);

end