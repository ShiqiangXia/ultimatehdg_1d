function num_sol=Local_recover_hdg(A_loc,b_loc,uhat_vector)

% return matrix of dimension (N_q+N_u+N_hat) x N_ele
% N_hat = 2

    [N_dof,~,N_ele] = size(A_loc);

    num_sol = zeros(N_dof+2,N_ele);

    for ii = 1:N_ele
        num_sol(1:N_dof,ii) = A_loc(:,:,ii) * uhat_vector(ii:ii+1) + b_loc(:,ii);
    end
    
    num_sol(end-1,:) = uhat_vector(1:end-1)';
    num_sol(end,:)   = uhat_vector(2:end)';
    
    
    
end