function my_f = Source_f(exact_func,xL,xR,N_GQ,N_u)
% compute the integral (f, basis_u) on interval (xL, xR) with GQ order
% N_GQ;
[r,w] = my_quadrature(N_GQ);

h = abs(xR - xL);
mid = abs(xR+xL)/numeric_t('2');

f_values = exact_func(Ref_phy_map(r,h,mid),2); % f = - Laplace u

temp_basis = my_vandermonde_u(r,N_u);

my_f  = temp_basis'*(w.*f_values);

end