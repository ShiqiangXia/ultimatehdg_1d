% Oliver Xia 01/02/2020
%
% Return matrix (N_q+N_u+N_hat) x N_ele
% it stores the coefficents of the HDG solution in order q_h, u_h, uhat

function num_sol= HDG_solver(type,exact_func,my_mesh,N_GQ,numerical_method_info)

%% Step 0: Set up
%N_ele = my_mesh.N_elemets();
%N_nds = my_mesh.N_nodes();

N_u = numerical_method_info.pk_u + 1;
N_q = numerical_method_info.pk_q + 1;
N_uhat = 2;

tau_pow = numerical_method_info.tau_pow;

basis_u =numerical_method_info.basis_u;
basis_q =numerical_method_info.basis_q;

%% Step 1: get local matrix on reference elements

[A,B,C,D,E] = Local_matrix_ref(N_u,N_q,basis_u,basis_q,N_GQ);

%% Step 2: call local solver for each element ; store in matrix form

[A_loc,b_loc,M,N,taus] = Local_solver_hdg(type,my_mesh,A,B,C,D,E,N_u,N_q,N_uhat,tau_pow,N_GQ,exact_func);


%% Step 3: Call global solver, get u_hat

uhat_vector = Global_solver_hdg(M,N,taus,exact_func(numeric_t('0'),0),exact_func(numeric_t('1'),0));


%% Step 4: Recovery local DOF
%  Step 5: Return (u, q, u_hat)

num_sol = Local_recover_hdg(A_loc,b_loc,uhat_vector);



end