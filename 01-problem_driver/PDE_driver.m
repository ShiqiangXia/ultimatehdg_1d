%Oliver Xia 12/28/2020
% script to solve PDEs based on pde_info

function PDE_driver(pde_info)


%% 1. set up
type = pde_info.pb;
exact_func = pde_info.exact_func;

mesh0 = pde_info.mesh0;
num_iter = pde_info.num_iteration;

N_GQ = pde_info.GQ;
[GQ_pts,GQ_weights] = my_quadrature(N_GQ);
numerical_method_info = pde_info.numerical_method_info;


postprocessing = pde_info.postprocessing;

refine_number = pde_info.refinement;


final_plot_flag = false;



%mesh_nodes = linspace(0,1,mesh0+1);
h0 = numeric_t('1')/mesh0;
mesh_nodes = (0:mesh0)*h0; % initial mesh 

% store errors
error_list_uh = zeros(num_iter,1,numeric_t);
error_list_qh = zeros(num_iter,1,numeric_t);
error_list_uhat = zeros(num_iter,1,numeric_t);
num_element_list = zeros(num_iter,1,numeric_t);

% store errors if postprocessing
if postprocessing ~=0
    error_list_uh_star = zeros(num_iter,1,numeric_t);
    error_list_qh_star = zeros(num_iter,1,numeric_t);
    error_list_uhat_star = zeros(num_iter,1,numeric_t);
    if postprocessing == 1 % Convolution Filter
        % precompute necessary matrix
        % sum_r ( Cr * A_nmrj)
        % points of interests on ref element(Quadrature points)

        
        pts = [GQ_pts;numeric_t('-1');numeric_t('1')];

        kk = numerical_method_info.pk_u;
        Nu = kk+1;
        AA = Convolution_matrix(kk,Nu,pts,GQ_pts,GQ_weights);
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

    % plot or not
    if ii == num_iter
        final_plot_flag = true;
    end
    
    % h and physical GQ+end points in each element
    [hs,gq_pts_phy] = Mesh_phy_GQ_points(my_mesh,GQ_pts);

    num_element_list(ii) = my_mesh.N_elemets; % store the # of elements
    % Solve the problem
    if numerical_method_info.method == 1 % HDG method
        % num_sol: (N_q+N_u+N_hat) x N_ele matrix , it stores the
        % coefficents of the HDG solution in order q_h, u_h, uhat
        num_sol = HDG_solver(type,exact_func,my_mesh,N_GQ,numerical_method_info);
    end

    % First No postprocessing, compute values at Quadrature points
    % num_sol_0: (2*(N_GQ+1)+N_uhat) x N_ele
    % store the GQ point values of q_h, u_h and the end point values of
    % uhat
    post_flag = 0;
    num_sol_0 = Post_processor(num_sol,GQ_pts,numerical_method_info,post_flag);

    % Calculate error
    [error_list_qh(ii),error_list_uh(ii),error_list_uhat(ii)] = Error_cal(hs,gq_pts_phy,exact_func,num_sol_0,GQ_weights);

    if postprocessing ~= 0
        % Postprocessing, compute values at Quadrature points
        % num_sol_star: (2*(N_GQ+1)+N_uhat) x N_ele
        % store the GQ point values of q_hstar, u_hstar and the end point values of
        % u_hstar

        if my_mesh.mesh_type == "uniform"

            num_sol_star = Post_processor(num_sol,GQ_pts,numerical_method_info,postprocessing,Conv_matrix);

        else
            if postprocessing == 1
                % Post-processing by projectio to background mesh and convolution
                background_mesh = my_mesh.get_background_uniform_mesh;
                
                [proj_num_sol,mesh_relation] = L2Projection_to_coarse_mesh(my_mesh,background_mesh,num_sol,num_sol_0,hs,gq_pts_phy(1:N_GQ+1,:),GQ_weights,numerical_method_info);
                
                proj_num_sol_star = Post_processor(proj_num_sol,GQ_pts,numerical_method_info,postprocessing,Conv_matrix);
                
                num_sol_star = Eval_on_finer_mesh(background_mesh,my_mesh,mesh_relation,proj_num_sol_star,GQ_pts,gq_pts_phy,numerical_method_info);
            end
        end


        % Calculate error
        [error_list_qh_star(ii),error_list_uh_star(ii),error_list_uhat_star(ii)] = Error_cal(hs,gq_pts_phy,exact_func,num_sol_star,GQ_weights);
    end

    if final_plot_flag && pde_info.final_plot
        if postprocessing == 0
            Plot_comp1(hs,gq_pts_phy,exact_func,num_sol_0,GQ_weights);
        else
            Plot_comp2(hs,gq_pts_phy,exact_func,num_sol_0,num_sol_star,GQ_weights)
        end
    end

    % Refine the mesh
    if refine_number == 1 % uniform refinement
        my_mesh = my_mesh.mesh_uniform_refine();
    elseif refine_number == 2 % refine the mesh by Adptive method 1
        refine_vector = Adaptivity(refine_number,num_sol_0,N_GQ);
        my_mesh = my_mesh.mesh_nonuniform_refine(refine_vector);
    elseif refine_number == 3 % refine the mesh by Adptive method 2
        refine_vector = Adaptivity(refine_number,num_sol_star,N_GQ);
        my_mesh = my_mesh.mesh_nonuniform_refine(refine_vector);
    end

end





%% 3. error and results
fprintf('Problem Info:\n')
if type == 101
    fprintf("1. PDE: Laplace equation\n");
end
fprintf("2. HDG method\n   k = %d, tau = h^%d \n", numerical_method_info.pk_u,numerical_method_info.tau_pow);

fprintf("--------------------\n")
fprintf('No Post-processing:\n');
fprintf('\n%s\n','HDG Error');
% compute error order 
[order_q,order_u,order_uhat] = Error_order(num_element_list,error_list_qh,error_list_uh,error_list_uhat);
% print the result
Print_error_result(num_element_list,error_list_qh,error_list_uh,error_list_uhat,order_q,order_u,order_uhat);

fprintf("--------------------\n")

if postprocessing ~= 0 % Convolution Filter
fprintf('Post-processing:');
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
end

end