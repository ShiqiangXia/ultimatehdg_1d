function A = volume_integral_divq_u(N_q,N_u,N_GQ)

% compute (grad_q_i,u_j) on reference element with Gauss quadrature N_GQ
% {grad_q_i} grad_q-variable basis
% {u_j} u-varaible basis

%% Get Quadrature points and weights
[r,w] = my_quadrature(N_GQ);

%% Get Vandermonde matrix for the basis

temp_grad_q = my_gradvandermonde_q(r,N_q);
temp_u = my_vandermonde_u(r,N_u);

%% Numerical quadrature

A = temp_grad_q' * (w.*temp_u);


end