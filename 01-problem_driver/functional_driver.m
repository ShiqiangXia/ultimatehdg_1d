function functional_driver(functional_info)
% script to approximate functional based on functional_info

%% 1. Set up
functional_type = functional_info.functional_type;
pde_type = functional_info.pde_type;

exact_primal_func = functional_info.exact_primal_func;
exact_adjoint_func = functional_info.exact_adjoint_func;

mesh0 = functional_info.mesh0;
num_iter = functional_info.num_iteration;

N_GQ = functional_info.GQ;
numerical_method_info = functional_info.numerical_method_info;

postprocessing = functional_info.postprocessing;
refine_number = functional_info.refinement;
final_plot_flag = false;


h0 = numeric_t('1')/mesh0;
mesh_nodes = (0:mesh0)*h0; % initial mesh 

% store errors
% primal
error_list_uh = zeros(num_iter,1,numeric_t);
error_list_qh = zeros(num_iter,1,numeric_t);
error_list_uhat = zeros(num_iter,1,numeric_t);

%adjoint
error_list_vh = zeros(num_iter,1,numeric_t);
error_list_ph = zeros(num_iter,1,numeric_t);
error_list_vhat = zeros(num_iter,1,numeric_t);

error_list_j         = zeros(num_iter,1,numeric_t);


num_element_list = zeros(num_iter,1,numeric_t);

% store errors if postprocessing
if postprocessing ~=0
    %primal
    error_list_uh_star = zeros(num_iter,1,numeric_t);
    error_list_qh_star = zeros(num_iter,1,numeric_t);
    error_list_uhat_star = zeros(num_iter,1,numeric_t);

    %adjoint
    error_list_vh_star = zeros(num_iter,1,numeric_t);
    error_list_ph_star = zeros(num_iter,1,numeric_t);
    error_list_vhat_star = zeros(num_iter,1,numeric_t);

    error_list_jstar         = zeros(num_iter,1,numeric_t);


    if postprocessing == 1 % Convolution Filter
        % precompute necessary matrix
        % sum_r ( Cr * A_nmrj)
        % points of interests on ref element(Quadrature points)

        [pts,~] = my_quadrature(N_GQ);
        pts = [pts;numeric_t('-1');numeric_t('1')];

        kk = numerical_method_info.pk_u;
        Nu = kk+1;
        AA = Convolution_matrix(kk,Nu,pts,N_GQ);
        str = ['c', num2str(kk)];
        cr = numeric_t(struct2array( load("Convolution_Cr_deg1_5.mat",str)));
        % old script
        %[AA,cr] = kernel_DB(kk,kk,pts);
        Conv_matrix = zeros(length(pts),Nu,4*kk+1,numeric_t);
        for ss = 1:2*kk+1
            Conv_matrix(:,:,:) = Conv_matrix(:,:,:) + cr(ss)*squeeze(AA(:,:,ss,:))*numeric_t('0.5');
        end


    end

end

%% 2. for loops  
% initial mesh
my_mesh      = mesh(mesh_nodes);

for ii = 1:num_iter

    % plot final mesh result or not
    if ii == num_iter
        final_plot_flag = true;
    end

    num_element_list(ii) = my_mesh.N_elemets; % store the # of elements



    % Solve the problem
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
    % store the GQ point values of q_h, u_h and the end point values of
    % uhat
    post_flag = 0;
    primal_num_sol_0 = Post_processor(primal_num_sol,N_GQ,numerical_method_info,post_flag);
    adjoint_num_sol_0 = Post_processor(adjoint_num_sol,N_GQ,numerical_method_info,post_flag);

    % Calculate error
    [error_list_qh(ii),error_list_uh(ii),error_list_uhat(ii)] = Error_cal(my_mesh,exact_primal_func,primal_num_sol_0,N_GQ);
    [error_list_ph(ii),error_list_vh(ii),error_list_vhat(ii)] = Error_cal(my_mesh,exact_adjoint_func,adjoint_num_sol_0,N_GQ);

    error_list_j(ii) = Functional_error_cal(functional_type,my_mesh,exact_primal_func,exact_adjoint_func,primal_num_sol_0,adjoint_num_sol_0,N_GQ);

    if postprocessing ~= 0
        % Postprocessing, compute values at Quadrature points
        % num_sol_star: (2*(N_GQ+1)+N_uhat) x N_ele
        % store the GQ point values of q_hstar, u_hstar and the end point values of
        % u_hsta

        if my_mesh.mesh_type == "uniform"

            primal_num_sol_star = Post_processor(primal_num_sol,N_GQ,numerical_method_info,postprocessing,Conv_matrix);
            adjoint_num_sol_star = Post_processor(adjoint_num_sol_0,N_GQ,numerical_method_info,postprocessing,Conv_matrix);


        else
            if postprocessing == 1
                % Post-processing by projectio to background mesh and convolution
                background_mesh = my_mesh.get_background_uniform_mesh;

                [proj_primal_num_sol,proj_adjoint_num_sol] = Primal_Adjoint_Mesh_projection(my_mesh,background_mesh,primal_num_sol,adjoint_num_sol_0,N_GQ,numerical_method_info);
                proj_primal_num_sol_star = Post_processor(proj_primal_num_sol,N_GQ,numerical_method_info,postprocessing,Conv_matrix);
                proj_adjoint_num_sol_star = Post_processor(proj_adjoint_num_sol,N_GQ,numerical_method_info,postprocessing,Conv_matrix);

                [primal_num_sol_star, adjoint_num_sol_star] = Primal_Adjoint_Mesh_lifting(background_mesh,my_mesh,proj_primal_num_sol_star,proj_adjoint_num_sol_star,N_GQ,numerical_method_info);
            end


        end

        % Calculate error
        [error_list_qh_star(ii),error_list_uh_star(ii),error_list_uhat_star(ii)] = Error_cal(my_mesh,exact_primal_func,primal_num_sol_star,N_GQ);
        [error_list_ph_star(ii),error_list_vh_star(ii),error_list_vhat_star(ii)] = Error_cal(my_mesh,exact_adjoint_func,adjoint_num_sol_star,N_GQ);

        error_list_jstar(ii) = Functinal_error_cal(functional_type,my_mesh,exact_primal_func,exact_adjoint_func,primal_num_sol_star,adjoint_num_sol_star,N_GQ);


    end

    if final_plot_flag && functional_info.final_plot
        if postprocessing == 0
            Plot_comp1(my_mesh,exact_primal_func,primal_num_sol_0,N_GQ);
            % Plot functional error
        else
            Plot_comp2(my_mesh,exact_primal_func,primal_num_sol_0,primal_num_sol_star,N_GQ);
            % Plot functional error
        end
    end

    % Refine the mesh
    if refine_number == 1 % uniform refinement
        my_mesh = my_mesh.mesh_uniform_refine();
    elseif refine_number == 2 % refine the mesh by Adptive method 1
        refine_vector = Functional_Adaptivity(refine_number,N_GQ);
        my_mesh = my_mesh.mesh_nonuniform_refine(refine_vector);
    elseif refine_number == 3 % refine the mesh by Adptive method 2
        refine_vector = Functional_Adaptivity(refine_number,N_GQ);
        my_mesh = my_mesh.mesh_nonuniform_refine(refine_vector);
    end


end


%% 3. error and results


end