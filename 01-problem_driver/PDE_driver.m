function PDE_driver(pde_info)
% script to solve PDEs based on pde_info


%% set up
type = pde_info.pb;
exact_func = pde_info.exact_func;

mesh0 = pde_info.mesh0;
num_iter = pde_info.num_iteration;

N_GQ = pde_info.GQ;
numerical_method_info = pde_info.numerical_method_info;


postprocessing = pde_info.postprocessing;
refine_number = pde_info.refinement
if  refine_number == 1
    refine_flag = "uniform";
    
else
    refine_flag = "non-uniform";
end



if type == 101 % simple Laplacian equation
    
    mesh_nodes = linspace(0,1,mesh0+1);
    
    error_list_uh = zeros(num_iter,1,numeric_t);
    error_list_qh = zeros(num_iter,1,numeric_t);
    error_list_uhat = zeros(num_iter,1,numeric_t);
    num_element_list = zeros(num_iter,1,numeric_t);
    
    if postprocessing ~=0
        error_list_uh_star = zeros(num_iter,1,numeric_t);
        error_list_qh_star = zeros(num_iter,1,numeric_t);
        error_list_uhat_star = zeros(num_iter,1,numeric_t);
    end
    
    
%% for loops  
    % initial mesh
    my_mesh      = mesh(mesh_nodes,refine_flag);
    
    for ii = 1:num_iter
        
        num_element_list(ii) = my_mesh.N_elemets;
        % Solve the problem
        if numerical_method_info.method == 1 % HDG method
            num_sol = HDG_solver(type,exact_func,my_mesh,N_GQ,numerical_method_info);
        end
        
        % No postprocessing
        post_flag = 0;
        num_sol_0 = Post_processor(num_sol,N_GQ,numerical_method_info,post_flag);
        
        % Calculate error
        [error_list_qh(ii),error_list_uh(ii),error_list_uhat(ii)] = Error_cal(my_mesh,exact_func,num_sol_0,N_GQ,numerical_method_info);
        
        if postprocessing ~= 0
            % Postprocessing
            num_sol_star = Post_processor(num_sol,N_GQ,numerical_method_info,postprocessing);
            % Calculate error
            [error_list_qh_star(ii),error_list_uh_star(ii),error_list_uhat_star(ii)] = Error_cal(exact_func,num_sol_star,N_GQ,numerical_method_info);
        end
        
        % Refine the mesh
        if refine_number == 1
            my_mesh = my_mesh.mesh_uniform_refine();
        elseif refine_number == 2
            refine_vector = Adaptivity(refine_number,num_sol_0,N_GQ);
            my_mesh = my_mesh.mesh_nonuniform_refine(refine_vector);
        elseif refine_number == 3
            refine_vector = Adaptivity(refine_number,num_sol_star.N_GQ);
            my_mesh = my_mesh.mesh_nonuniform_refine(refine_vector);
        end
           
    end
    
end



%% error and results

end