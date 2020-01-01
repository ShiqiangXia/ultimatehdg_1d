function [A_loc,b_loc,M,N,taus]=Local_solver_hdg(type,my_mesh,A,B,C,D,E,N_u,N_q,N_uhat,tau_pow,N_GQ,exact_func)

N_ele = my_mesh.N_elemets();

A_loc = zeros(N_q+N_u,N_uhat,N_ele,numeric_t);
b_loc = zeros(N_q+N_u,1,N_ele,numeric_t);
M = zeros(2,N_uhat,N_ele,numeric_t);
N = zeros(2,N_ele,numeric_t);
taus = zeros(N_ele,1,numeric_t);


temp_M = zeros(N_q+N_u,N_q+N_u,numeric_t);

for ii = 1:N_ele
    
    
    
    nds = my_mesh.get_faces(ii);
    h = abs(nds(2)-nds(1));
    tau_loc = h^(tau_pow);
    taus(ii) = tau_loc;
    
    loc_f =[ zeros(N_q,1,numeric_t); Source_f(exact_func,nds(1),nds(2),N_GQ,N_u)];
    
    if type == 101 % solve laplaican problem
        
        temp_M(1:N_q,1:N_q) = A * h /numeric_t('2');
        temp_M(1:N_q,N_q+1:end) = - B;
        temp_M(N_q+1:end,1:N_q) = B';
        temp_M(N_q+1:end,N_q+1:end) = tau_loc*C;
    
        DE = [D;tau_loc*E];
        
    end
    
    temp1 = temp_M\DE;
    temp2 = temp_M\loc_f;
    
    A_loc(:,:,ii) = temp1;
    b_loc(:,ii) = temp2;
    
    G = [-D;tau_loc*E]';
    M(:,:,ii) = G * temp1; % M(1,:,ii)= ML; M(2,:,ii) = MR
    N(:,ii) = G * temp2;
    
    
    
end


end