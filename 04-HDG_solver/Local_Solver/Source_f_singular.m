function my_f = Source_f_singular(exact_func,xL,xR,N_GQ,N_u)
% compute the singular integral (f, basis_u) on interval (xL, xR) with GQ order
% N_GQ;
%We assume the singular point is the xL=0 and change variables can fix this
%singularity.

if isequal(exact_func,@singular_func102)
    % singular function is -10/9 * x^(-1/3)
    my_alpha = numeric_t('1/3'); % alpha is between 0 and 0.5
    inv_alpha = numeric_t('1')/my_alpha;
    my_constant = numeric_t('-10/9');
    
    h = abs(xR - xL);
    mid = (xR+xL)/numeric_t('2');

    new_xL = xL;
    new_xR = xR^(my_alpha);
    new_h = abs(new_xR - new_xL);
    new_mid = (new_xR+new_xL)/numeric_t('2');
    
    [r,w] = my_quadrature(N_GQ);
    
    f_values = my_constant * (Ref_phy_map(r,new_h,new_mid)).^(inv_alpha - 2);
    
    new_r = (Ref_phy_map(r,new_h,new_mid).^(inv_alpha) - mid) /(h/numeric_t('2'));
    temp_basis = my_vandermonde_u(new_r,N_u);
    
    my_f  = inv_alpha * temp_basis'*(w.*f_values) * new_h/numeric_t('2');
    
end


end