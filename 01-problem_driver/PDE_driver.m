%Oliver Xia 12/28/2020
% script to solve PDEs based on pde_info

function PDE_driver(pde_info)


%% set up
type = pde_info.pb;
exact_func = pde_info.exact_func;

mesh0 = pde_info.mesh0;
num_iter = pde_info.num_iteration;

N_GQ = pde_info.GQ;
numerical_method_info = pde_info.numerical_method_info;


postprocessing = pde_info.postprocessing;

refine_number = pde_info.refinement;
if  refine_number == 1
    refine_flag = "uniform";  
else
    refine_flag = "non-uniform";
end

final_plot_flag = false;


if type == 101 % simple Laplacian equation
    
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
            
            [pts,~] = my_quadrature(N_GQ);
            pts = [pts;numeric_t('-1');numeric_t('1')];
            
            kk = numerical_method_info.pk_u;
            Nu = kk+1;
            AA = Convolution_matrix(kk,Nu,pts,N_GQ);
            str = ['c', num2str(kk)];
            cr = numeric_t(struct2array( load("Convolution_Cr_deg1_5.mat",str)));
            % old script
            %[AA,cr] = kernel_DB(kk,kk,pts);
            BB = zeros(length(pts),Nu,4*kk+1,numeric_t);
            for ss = 1:2*kk+1
                BB(:,:,:) = BB(:,:,:) + cr(ss)*squeeze(AA(:,:,ss,:))*numeric_t('0.5');
            end
            
            
        end
        
    end
    
    
%% for loops  
    % initial mesh
    my_mesh      = mesh(mesh_nodes,refine_flag);
    
    for ii = 1:num_iter
        
        % plot or not
        if ii == num_iter
            final_plot_flag = true;
        end
        
        num_element_list(ii) = my_mesh.N_elemets; % store the # of elements
        % Solve the problem
        if numerical_method_info.method == 1 % HDG method
            % num_sol: (N_q+N_u+N_hat) x N_ele matrix , it stores the
            % coefficents of the HDG solution in order q_h, u_h, uhat
            num_sol = HDG_solver(type,exact_func,my_mesh,N_GQ,numerical_method_info);
        end
        
        % No postprocessing, compute values at Quadrature points
        post_flag = 0;
        
        % num_sol_0: (2*(N_GQ+1)+N_uhat) x N_ele
        % store the GQ point values of q_h, u_h and the end point values of
        % uhat
        num_sol_0 = Post_processor(num_sol,N_GQ,numerical_method_info,post_flag);
        
        % Calculate error
        [error_list_qh(ii),error_list_uh(ii),error_list_uhat(ii)] = Error_cal(my_mesh,exact_func,num_sol_0,N_GQ);
        
        if postprocessing ~= 0
            % Postprocessing, compute values at Quadrature points
            % num_sol_star: (2*(N_GQ+1)+N_uhat) x N_ele
            % store the GQ point values of q_hstar, u_hstar and the end point values of
            % u_hstar
            num_sol_star = Post_processor(num_sol,N_GQ,numerical_method_info,postprocessing,BB);
            % Calculate error
            [error_list_qh_star(ii),error_list_uh_star(ii),error_list_uhat_star(ii)] = Error_cal(my_mesh,exact_func,num_sol_star,N_GQ);
        end
        
        if final_plot_flag
            if postprocessing == 0
                Plot_comp1(my_mesh,exact_func,num_sol_0,N_GQ);
            else
                Plot_comp2(my_mesh,exact_func,num_sol_0,num_sol_star,N_GQ)
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
    
end

 

%% error and results

fprintf("HDG method\nk = %d, tau = h^%d \n", numerical_method_info.pk_u,numerical_method_info.tau_pow);

fprintf('\n%s\n','HDG Error');
% compute error order 
[order_q,order_u,order_uhat] = Error_order(num_element_list,error_list_qh,error_list_uh,error_list_uhat);
% print the result
Print_error_result(num_element_list,error_list_qh,error_list_uh,error_list_uhat,order_q,order_u,order_uhat);


if postprocessing == 1 % Convolution Filter
fprintf("\nConvolution Filtering Error\n");
% compute error order 
[order_q_star,order_u_star,order_uhat_star] = Error_order(num_element_list,error_list_qh_star,error_list_uh_star,error_list_uhat_star);
% print the result
Print_error_result(num_element_list,error_list_qh_star,error_list_uh_star,error_list_uhat_star,order_q_star,order_u_star,order_uhat_star);
end

end