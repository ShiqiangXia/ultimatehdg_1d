function functional_driver(functional_info)
% script to approximate functional based on functional_info

%% 1. Set up
%--------------------------------------------------------------------------

tol =  numeric_t('1e-4');
%%%% Functional type, PDE type and exact solutions
functional_type = functional_info.functional_type;
pde_type = functional_info.pde_type;

exact_primal_func = functional_info.exact_primal_func;
exact_adjoint_func = functional_info.exact_adjoint_func;

%%%% Initial mesh and Iterations
mesh0 = functional_info.mesh0;
num_iter = functional_info.num_iteration;

%%%% GQ points and weights
N_GQ = functional_info.GQ;
[GQ_pts,GQ_weights] = my_quadrature(N_GQ);

%%%% Numerical method
numerical_method_info = functional_info.numerical_method_info;

%%%% Post-process and Refinement
postprocessing = functional_info.postprocessing;
refine_number = functional_info.refinement;
final_plot_flag = false;

%%%% store errors
% primal
error_list_uh = zeros(num_iter,1,numeric_t);
error_list_qh = zeros(num_iter,1,numeric_t);
error_list_uhat = zeros(num_iter,1,numeric_t);

% adjoint
error_list_vh = zeros(num_iter,1,numeric_t);
error_list_ph = zeros(num_iter,1,numeric_t);
error_list_vhat = zeros(num_iter,1,numeric_t);

error_list_j         = zeros(num_iter,1,numeric_t);
error_list_j_adj         = zeros(num_iter,1,numeric_t);

error_bound_list    = zeros(num_iter,1,numeric_t);


num_element_list = zeros(num_iter,1,numeric_t);

%%%% store errors if postprocessing
if postprocessing ~=0
    % primal
    error_list_uh_star = zeros(num_iter,1,numeric_t);
    error_list_qh_star = zeros(num_iter,1,numeric_t);
    error_list_uhat_star = zeros(num_iter,1,numeric_t);

    % adjoint
    error_list_vh_star = zeros(num_iter,1,numeric_t);
    error_list_ph_star = zeros(num_iter,1,numeric_t);
    error_list_vhat_star = zeros(num_iter,1,numeric_t);

    error_list_jstar         = zeros(num_iter,1,numeric_t);
    error_list_jstar_adj     = zeros(num_iter,1,numeric_t);
    error_bound_adj_list    = zeros(num_iter,1,numeric_t);
    
    



    if postprocessing == 1 % Convolution Filter
        % precompute necessary matrix
        % sum_r ( Cr * A_nmrj)
        
        % points of interests on ref element(Quadrature points)
        pts = [GQ_pts;numeric_t('-1');numeric_t('1')];
        kk = numerical_method_info.pk_u;
        Nu = kk+1;
        
        Conv_matrix = Get_convolution_matrix(pts,kk,Nu,GQ_pts,GQ_weights);

    end

end

%% 2. for loops  
%--------------------------------------------------------------------------

% initial mesh
h0 = numeric_t('1')/mesh0;
mesh_nodes = (0:mesh0)*h0; % initial mesh 
my_mesh      = mesh(mesh_nodes);

for ii = 1:num_iter
    
%---------------------- Start new mesh ------------------------------------

    % plot final mesh result or not
    if ii == num_iter
        final_plot_flag = true;
    end

    % h and physical GQ+end points in each element
    [hs,GQ_End_points_phy] = Mesh_phy_GQ_points(my_mesh,GQ_pts);
    
    num_element_list(ii) = my_mesh.N_elemets; % store the # of elements
    
%---------------------- Solve the problem  --------------------------------

 
    if numerical_method_info.method == 1 % HDG method
        % num_sol: (N_q+N_u+N_hat) x N_ele matrix , it stores the
        % coefficents of the HDG solution in order q_h, u_h, uhat
        primal_num_sol = HDG_solver(pde_type,exact_primal_func,my_mesh,N_GQ,numerical_method_info);
        
        if pde_type == 101 % simple Laplacian equation
             % Adjoint problem is the same problem
            adjoint_num_sol = HDG_solver(pde_type,exact_adjoint_func,my_mesh,N_GQ,numerical_method_info);
        end
        
    end
    

    % First No postprocessing, compute values at Quadrature points
    % num_sol_0: (2*(N_GQ+1)+N_uhat) x N_ele
    % store the GQ point values of q_h, u_h and the end point values of uhat
    post_flag = 0;
    primal_num_sol_0 = Post_processor(primal_num_sol,GQ_pts,numerical_method_info,post_flag);
    adjoint_num_sol_0 = Post_processor(adjoint_num_sol,GQ_pts,numerical_method_info,post_flag);

%----------------------  Calculate Error   --------------------------------
    
    [error_list_qh(ii),error_list_uh(ii),error_list_uhat(ii)] = Error_cal(hs,GQ_End_points_phy,exact_primal_func,primal_num_sol_0,GQ_weights);
    [error_list_ph(ii),error_list_vh(ii),error_list_vhat(ii)] = Error_cal(hs,GQ_End_points_phy,exact_adjoint_func,adjoint_num_sol_0,GQ_weights);
    
    temp_Nu = numerical_method_info.pk_u+1;
    temp_Nq = numerical_method_info.pk_q+1;
    
    [primal_num_sol_0_ex,adjoint_num_sol_0_ex] = Points_extension(hs,temp_Nu,temp_Nq,GQ_pts,primal_num_sol_0,adjoint_num_sol_0);
    [error_list_j(ii),error_list_j_adj(ii),error_estimator] = Functional_error_cal(functional_type,hs,GQ_End_points_phy,exact_primal_func,exact_adjoint_func,primal_num_sol_0_ex,adjoint_num_sol_0_ex,GQ_weights,numerical_method_info.tau_pow,post_flag);
    error_bound_list(ii) = abs(sum(error_estimator));
    %error_bound_list(ii) = sum(abs(error_estimator));

%----------------------  Post-processing   --------------------------------
 
    if postprocessing ~= 0
        % Postprocessing, compute values at Quadrature points
        % num_sol_star: (2*(N_GQ+1)+N_uhat) x N_ele
        % store the GQ point values of q_hstar, u_hstar and the end point values of
        % u_hsta

        if my_mesh.mesh_type == "uniform"

            primal_num_sol_star = Post_processor(primal_num_sol,GQ_pts,numerical_method_info,postprocessing,Conv_matrix);
            adjoint_num_sol_star = Post_processor(adjoint_num_sol,GQ_pts,numerical_method_info,postprocessing,Conv_matrix);


        else
            if postprocessing == 1
                % Post-processing by projectio to background mesh and convolution
                background_mesh = my_mesh.get_background_uniform_mesh;
                
                [proj_primal_num_sol,mesh_relation] = L2Projection_to_coarse_mesh(my_mesh,background_mesh,primal_num_sol,primal_num_sol_0,hs,GQ_End_points_phy(1:N_GQ+1,:),GQ_weights,numerical_method_info);
                [proj_adjoint_num_sol, ~ ] = L2Projection_to_coarse_mesh(my_mesh,background_mesh,adjoint_num_sol,adjoint_num_sol_0,hs,GQ_End_points_phy(1:N_GQ+1,:),GQ_weights,numerical_method_info);

                proj_primal_num_sol_star = Post_processor(proj_primal_num_sol,GQ_pts,numerical_method_info,postprocessing,Conv_matrix);
                proj_adjoint_num_sol_star = Post_processor(proj_adjoint_num_sol,GQ_pts,numerical_method_info,postprocessing,Conv_matrix);
                
                primal_num_sol_star = Eval_on_finer_mesh(background_mesh,my_mesh,mesh_relation,proj_primal_num_sol_star,GQ_pts,GQ_End_points_phy,numerical_method_info);
                adjoint_num_sol_star = Eval_on_finer_mesh(background_mesh,my_mesh,mesh_relation,proj_adjoint_num_sol_star,GQ_pts,GQ_End_points_phy,numerical_method_info);
   
            end
        end

%----------------------  Calculate Error   --------------------------------

        [error_list_qh_star(ii),error_list_uh_star(ii),error_list_uhat_star(ii)] = Error_cal(hs,GQ_End_points_phy,exact_primal_func,primal_num_sol_star,GQ_weights);
        [error_list_ph_star(ii),error_list_vh_star(ii),error_list_vhat_star(ii)] = Error_cal(hs,GQ_End_points_phy,exact_adjoint_func,adjoint_num_sol_star,GQ_weights);
        
        [primal_num_sol_star_ex,adjoint_num_sol_star_ex] = Points_extension(hs,2*temp_Nu,2*temp_Nq,GQ_pts,primal_num_sol_star,adjoint_num_sol_star);

        [error_list_jstar(ii),error_list_jstar_adj(ii),Post_error_estimator] = Functional_error_cal(functional_type,hs,GQ_End_points_phy,exact_primal_func,exact_adjoint_func,primal_num_sol_star_ex,adjoint_num_sol_star_ex,GQ_weights,numerical_method_info.tau_pow,postprocessing);
        error_bound_adj_list(ii) = abs(sum(Post_error_estimator));
        %error_bound_adj_list(ii) = sum(abs(Post_error_estimator));

    end

%----------------------        Plot        --------------------------------

    if final_plot_flag && functional_info.final_plot
        if postprocessing == 0
            Plot_comp1(hs,GQ_End_points_phy,exact_primal_func,primal_num_sol_0,GQ_weights);
            % Plot functional error
        else
            Plot_comp2(hs,GQ_End_points_phy,exact_primal_func,primal_num_sol_0,primal_num_sol_star,GQ_weights);
            % Plot functional error
        end
    end

%----------------------   Refine Mesh      --------------------------------

    if refine_number == 1 % uniform refinement
        
        my_mesh = my_mesh.mesh_uniform_refine();
        
    else  % refine the mesh by Adptive method
        my_adptive_strategy = 2;
        
        if postprocessing == 0
            refine_vector = Functional_Adaptivity(refine_number,error_estimator,tol,my_adptive_strategy);
        elseif postprocessing == 1
            refine_vector = Functional_Adaptivity(refine_number,Post_error_estimator,tol,my_adptive_strategy);
        end
        
        my_mesh = my_mesh.mesh_nonuniform_refine(refine_vector);
    
    end


end
%--------------------------------------------------------------------------


%% 3. error and results
%--------------------------------------------------------------------------

%----------------------  Problem Info      --------------------------------

fprintf('Problem Info:\n')
if functional_type == 1 
    fprintf("1. Functional: J(u) = (u,g)\n");
end
if pde_type == 101
    fprintf("2. PDE: Laplace equation\n");
end
fprintf("3. HDG method\n   k = %d, tau = h^%d \n", numerical_method_info.pk_u,numerical_method_info.tau_pow);

%---------------------- Result: numerical method     ----------------------

fprintf("--------------------\n")
fprintf('No Post-processing:\n');
%%%%%%%% compute and print pde error order 
fprintf('\n%s\n','Solution Error');
[order_q,order_u,order_uhat] = Error_order(num_element_list,error_list_qh,error_list_uh,error_list_uhat);
Print_error_result(num_element_list,error_list_qh,error_list_uh,error_list_uhat,order_q,order_u,order_uhat);

%%%%%%%% compute and print functional error order
fprintf('\n%s\n','Functional Error');
[order_j,order_j_adj] = Error_order(num_element_list,error_list_j,error_list_j_adj,0);
Print_func_error_result(num_element_list,error_list_j,error_list_j_adj,order_j,order_j_adj);

figure;
plot(log10(num_element_list),log10(error_list_j),'x-');
xlabel('log(N)');
ylabel('log(|J(u)-J(u_h)|)');
title({'Convergence result for HDG method'; 'log(|J(u)-J(u_h)|) vs log(N)'});

figure;
plot(log10(num_element_list),log10(error_list_j_adj),'x-');
xlabel('log(N)');
ylabel('log(|J(u)-Jh|)');
title({'Convergence result for HDG method'; 'log(|J(u)-J(u_h)-AC_h|) vs log(N)'});


fprintf("--------------------\n")

%if refine_number~=1
    fprintf('Results for estimator\n')
    fprintf('%-4s | %-14s %-14s %-6s \n','N','J(u)-J(u_h)','esti_1','ratio')
    Print_Estimator_result(num_element_list,error_list_j,error_bound_list);
    fprintf('\n');
    fprintf('%-4s | %-14s %-14s %-6s \n','N','J(u)-Jh(u_h)','esti_1','ratio')
    Print_Estimator_result(num_element_list,error_list_j_adj,error_bound_list);
    
    
    
%end

%----------------------  Result: Post-processing    -----------------------

fprintf("--------------------\n")

if postprocessing ~= 0 % Post-processing
fprintf('Post-processing: ');
if postprocessing == 1 %Convolution Filter
    fprintf("Convolution Filtering\n")
else
    fprintf("Recovery method\n")
end
fprintf("\nSoltuion Error\n");
% compute error order 
[order_q_star,order_u_star,order_uhat_star] = Error_order(num_element_list,error_list_qh_star,error_list_uh_star,error_list_uhat_star);
% print the result
Print_error_result(num_element_list,error_list_qh_star,error_list_uh_star,error_list_uhat_star,order_q_star,order_u_star,order_uhat_star);

%%%%%%%% compute and print functional error order
fprintf('\n%s\n','Functional Error');
[order_jstar,order_jstar_adj] = Error_order(num_element_list,error_list_jstar,error_list_jstar_adj,0);
Print_func_error_result(num_element_list,error_list_jstar,error_list_jstar_adj,order_jstar,order_jstar_adj);

fprintf("--------------------\n")
    fprintf('Results for estimator\n')
    fprintf('%-4s | %-14s %-14s %-6s \n','N','J(u)-J(u*_h)','esti_2','ratio')
    Print_Estimator_result(num_element_list,error_list_jstar,error_bound_adj_list);
    fprintf('\n');
    fprintf('%-4s | %-14s %-14s %-6s \n','N','J(u)-Jh(u*_h)','esti_2','ratio')
    Print_Estimator_result(num_element_list,error_list_jstar_adj,error_bound_adj_list);

end

end