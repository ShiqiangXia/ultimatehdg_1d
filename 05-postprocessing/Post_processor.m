%Oliver Xia 01/06/2020
% Post-processing script

function out = Post_processor(num_sol,N_GQ,numerical_method_info,post_flag,BB)

%% set up
[~,N_ele] = size(num_sol);
N_u = numerical_method_info.pk_u + 1;
N_q = numerical_method_info.pk_q + 1;
N_uhat = 2;
[r,~] = my_quadrature(N_GQ);
n = length(r);

out = zeros(2*n+N_uhat,N_ele,numeric_t);

%% Case 0: just evaluate at quadrature points
if post_flag == 0 
    temp_q = my_vandermonde_q(r,N_q);
    temp_u = my_vandermonde_u(r,N_u);
    out(1:n,:) =temp_q* num_sol(1:N_q,:);
    out(n+1:2*n,:) = temp_u * num_sol(N_q+1:N_q+N_u,:);
    out(2*n+1:end,:) = num_sol(N_q+N_u+1:end,:);
%% Case 1: Convolution filtering 
elseif post_flag == 1
    % load coefficents
    % Compute Gauss quadrture point values 
    
    odd_extend_uh_coeff     = Odd_extension(num_sol(N_q+1:N_q+N_u,:));
    out(n+1:2*n+N_uhat,:)   = Convolution_filtering(BB,odd_extend_uh_coeff);
    
    odd_extend_qh_coeff     = Even_extension( num_sol(1:N_q,:));
    temp_qhstar             = Convolution_filtering(BB,odd_extend_qh_coeff);
    out(1:n,:)              = temp_qhstar(1:n,:);
    
%% Case 2: Recovery method
else
    
end

end