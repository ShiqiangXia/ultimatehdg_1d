function out = Subinterval_Integral(given_func_pts,gq_pts_ref,hs,w,N_basis,flag)

[~,N_interval] = size(given_func_pts);
out = zeros(N_basis,1,numeric_t);

for ii = 1:N_interval
    scale_factor = hs(ii)/numeric_t('2');
    temp_f = given_func_pts(:,ii);
    
    if flag == 0
        temp_basis_mtrix = my_vandermonde_u(gq_pts_ref(:,ii),N_basis);
    else
        temp_basis_mtrix = my_vandermonde_q(gq_pts_ref(:,ii),N_basis);
    end
    
    out = out + scale_factor * ( temp_basis_mtrix' * (w.*temp_f) );
    
end

end