function A = volume_integral_gradu_gradu(N_u,N_GQ)
% compute (grad_u_i,grad_u_j) on reference element with Gauss quadrature N_GQ
% {grad_u_i} grad_u-variable basis

%% Get Quadrature points and weights
[r,w] = my_quadrature(N_GQ);

%% Get Vandermonde matrix for the basis

temp_grad = my_gradvandermonde_u(r,N_u);


%% Numerical quadrature

A = temp_grad' * (w.*temp_grad);


end