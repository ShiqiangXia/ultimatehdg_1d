function refine_vec = Adaptivity(refine_number,num_sol_0,N_GQ)

[~,N_ele] = size(num_sol_0);
refine_vec = zeros(1,N_ele,numeric_t);
%refine_vec(1) = numeric_t('1');
refine_vec(6) = numeric_t('1');

%refine_vec(12:14) = numeric_t('1');

end