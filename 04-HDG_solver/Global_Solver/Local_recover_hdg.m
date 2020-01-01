function num_sol=Local_recover_hdg(A_loc,b_loc,uhat_vector)

    [N_dof,~,N_ele] = size(A_loc);

    num_sol = zeros(N_dof,N_ele);

    for ii = 1:N_ele
        num_sol(:,ii) = A_loc(:,:,ii) * uhat_vector(ii:ii+1) + b_loc(:,ii);
    end
    
end