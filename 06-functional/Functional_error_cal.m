function [error_jh,error_jh_adj,temp1,temp4] = Functional_error_cal(functional_type,hs,gq_pts_phy,exact_primal_func,exact_adjoint_func,primal_num_sol,adjoint_num_sol,GQ_weights,tau_pow,grad_lag)

% grad_grad_lag: 0 use qh; 1: use -grad uh as qh
%% set up

[n_pt,~] = size(gq_pts_phy);

%n_pt : GQ+end points

nn = n_pt - 2; 


taus = (hs').^tau_pow;

normal_vector = [numeric_t('-1');numeric_t('1')];
%%% Get the all GQ values for the primal and adjoint solution
if grad_lag == 0
    qh = primal_num_sol(1:nn,:);
    qh_n_trace = normal_vector.* primal_num_sol(nn+1:n_pt,:);
    
else
    %qh = primal_num_sol(1:nn,:);
    %qh_n_trace = normal_vector.* primal_num_sol(nn+1:n_pt,:);
    qh = - primal_num_sol(2*n_pt+1:2*n_pt+nn,:);
    qh_n_trace = - normal_vector.* primal_num_sol(2*n_pt+nn+1:3*n_pt,:);
end


uh = primal_num_sol(n_pt+1:n_pt+nn,:);
uh_trace = primal_num_sol(n_pt+nn+1:2*n_pt,:);
graduh =primal_num_sol(2*n_pt+1:2*n_pt+nn,:);
uh_hat = primal_num_sol(3*n_pt+1:end,:);
qh_hat_n = qh_n_trace + taus.*(uh_trace - uh_hat);

if grad_lag == 0
    ph = adjoint_num_sol(1:nn,:);
    ph_n_trace = normal_vector.* adjoint_num_sol(nn+1:n_pt,:);
    
else
    %ph = adjoint_num_sol(1:nn,:);
    %ph_n_trace = normal_vector.* adjoint_num_sol(nn+1:n_pt,:);
    ph = -adjoint_num_sol(2*n_pt+1:2*n_pt+nn,:);
    ph_n_trace =- normal_vector.* adjoint_num_sol(2*n_pt+nn+1:3*n_pt,:);
end



vh = adjoint_num_sol(n_pt+1:n_pt+nn,:);
vh_trace = adjoint_num_sol(n_pt+nn+1:2*n_pt,:);
gradvh =adjoint_num_sol(2*n_pt+1:2*n_pt+nn,:);
vh_hat = adjoint_num_sol(3*n_pt+1:end,:);
ph_hat_n = ph_n_trace + taus.*(vh_trace - vh_hat);



%% compute J(u) and J(u_h)

if functional_type == 1
    %J(u) = (u,g)
    temp_g = exact_adjoint_func(gq_pts_phy(1:nn,:),2);
    
    % u*g at GQ points 
    J_matrix = exact_primal_func(gq_pts_phy(1:nn,:),0).*temp_g;
    % get J(u)
    element_J_eval = (GQ_weights'*J_matrix).*hs'/numeric_t('2');
    J_eval = sum(element_J_eval);
    %J_eval = (GQ_weights'*J_matrix)*hs/numeric_t('2');
    
    % u_h*g at GQ points
    Jh_matrix = uh.*temp_g;
    % get J(u_h)
    element_Jh_eval = (GQ_weights'*Jh_matrix).*hs'/numeric_t('2');
    Jh_eval = sum(element_Jh_eval);
    %Jh_eval = (GQ_weights'*Jh_matrix)*hs/numeric_t('2');
    
    % error of J(u) - J(u_h)
    error_jh = abs(J_eval - Jh_eval);
    
    %%% compute correction terms
    % good to check in the case of HDG method
    
    temp_f = exact_primal_func(gq_pts_phy(1:nn,:),2);
    
    % first adjoint-correction term
    % (f,vh) + (qh, grad_vh) - <qh_hat_n,vh>
    temp1 = ( GQ_weights'*(temp_f.*vh + qh.* gradvh) ).*hs' /numeric_t('2') - sum( qh_hat_n.*vh_trace);
    %AC1 = ( GQ_weights'*(temp_f.*vh + qh.* gradvh) )*hs /numeric_t('2') - sum(sum( qh_hat_n.*vh_trace));
    AC1 = sum(temp1);
    % second adjoint-correction term
    % (qh + grad_uh, ph) - <uh-uh_hat,ph_n>;
    temp2 = (GQ_weights'*((qh+graduh).*ph)).*hs' /numeric_t('2') - sum((uh_trace - uh_hat).*ph_n_trace );
    %AC2 = (GQ_weights'*((qh+graduh).*ph))*hs /numeric_t('2') - sum(sum((uh_trace - uh_hat).*ph_n_trace ));
    AC2 = sum(temp2);
    % third adjoint-correcton term
    % <qh_hat_n, vh_hat>_{all interior faces}
    temp_AC3 = qh_hat_n.*vh_hat;
    AC3 = sum(sum(temp_AC3)) - temp_AC3(1,1)-temp_AC3(end,end);
    
    % fourth adjoint-correction term
    % <uh - uh_hat, ph_n - ph_hat_n>
    temp4 = sum( (uh_trace - uh_hat).*(ph_n_trace - ph_hat_n));
    AC4 = sum(temp4);
    %fprintf("%d\n",AC4);
    
    AC_total = AC1+AC2+AC3+AC4;
    element_Jh_adj_eval = element_Jh_eval+temp1+temp2+temp4;
    Jh_adj_eval = Jh_eval + AC_total;
    
    error_jh_adj = abs(J_eval - Jh_adj_eval);
    
    close all;
    plot(abs(element_J_eval-element_Jh_eval),"x-");
    hold on
    plot(abs(temp4),"o-");
%    hold on
 %   plot(abs(element_J_eval-element_Jh_adj_eval),"*-");
    title("Compare");
    %}
elseif functional_type == 2
    
    %J(u) = <-u', g>
    
    
end


end