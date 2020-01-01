function HDG_solver(type,exact_func,my_mesh,N_GQ,numerical_method_info)

N_ele = my_mesh.N_elemets();
%N_nds = my_mesh.N_nodes();

N_u = numerical_method_info.pk_u + 1;
N_q = numerical_method_info.pk_q + 1;
N_uhat = 2;

tau_pow = numerical_method_info.tau_pow;

basis_u =numerical_method_info.basis_u;
basis_q =numerical_method_info.basis_q;

%% Step 1: get local matrix on reference elements

[A,B,C,D,E] = Local_matrix_ref(N_u,N_q,basis_u,basis_q,N_GQ);

%% Step 2? call local solver for each element ; store in matrix form
A_loc = zeros(N_q+N_u,N_uhat,N_ele,numeric_t);
b_loc = zeros(N_q+N_u,1,N_ele,numeric_t);
M = zeros(2,N_uhat,N_ele,numeric_t);

taus = zeros(N_ele,1,numeric_t);

N = zeros(2,N_ele,numeric_t);

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

%% Step 3: Call global solver


temp_diag = [numeric_t('1'), -(taus(1:end-1)+taus(2:end)),numeric_t('1')];

ML = [reshape(M(2,1,:),N_ele,1),numeric_t('0')];
Mmid =[numeric_t('0'), reshape(M(2,2,:),1:N_ele-1,1)+reshape(M(1,1,:),2:N_ele,1),numeric_t('0')];
MR = [numeric_t('0'),reshape(M(1,2,:),N_ele,1)];

NN = reshape(N(1,:),N_ele,1);

A_global = numeric_t(diag(temp_diag))+numeric_t(diag(Mmid)) +numeric_t(diag(ML,-1))+numeric_t(diag(MR,1)) ;
b_global = [exact_func(numeric_t('0'),0), -NN(1:end-1)-NN(2:end),exact_func(numeric_t('1'),0)];

A_global = numeric_t( sparse(A_global));

uhat_vector = A_global\b_global;



%% Step 4: Recovery local DOF

%% Step 5: Return (u, q, u_hat)

end