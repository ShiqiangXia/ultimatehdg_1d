% 05-03
% In this script, we test the idea that solving HDG on a non-uniform mesh and
% projecting the solution to a uniform mesh is as good as solving HDG on
% the later unifor mesh. 

%%%% PDE type and exact solution
function test_Mesh_Projection()
type = 101;
exact_func = @singular_func102;

N_GQ = 5;
[GQ_pts,GQ_weights] = my_quadrature(N_GQ);

%%%% Meshes
N0=10;
h0 = numeric_t('1')/N0;
mesh_nodes = (0:N0)*h0; % initial mesh nodes
%mesh_nodes = linspace(numeric_t('0'),numeric_t('1'),N0+1);
mesh1 = mesh(mesh_nodes);% uniform mesh

refine_vec = zeros(N0,1,numeric_t);
refine_vec(1) = 1;
refine_vec(2) = 1;
refine_vec(7) = 1;
mesh2 = mesh1.mesh_nonuniform_refine(refine_vec); % non-uniform mesh

%% define numerical method
method = 1 ; % HDG method
pk_u = 1;  % polynomial order u
pk_q = 1;  % polynomial order q
basis_u_type = 1; % basis type (so far we only have 1)
basis_q_type = 1; % basis type (so far we only have 1)
tao_pow = 0; % tau (h^power)
numerical_method_info = Numerical_method_info(method, pk_u,pk_q,basis_u_type,basis_q_type,tao_pow);

num_iter = 2;
error_list_uh = zeros(num_iter,1,numeric_t);
error_list_qh = zeros(num_iter,1,numeric_t);
error_list_uhat = zeros(num_iter,1,numeric_t);

% Solve problem
%% Uniform mesh

[hs,GQ_End_points_phy] = Mesh_phy_GQ_points(mesh1,GQ_pts);
if numerical_method_info.method == 1 % HDG method
        % num_sol: (N_q+N_u+N_hat) x N_ele matrix , it stores the
        % coefficents of the HDG solution in order q_h, u_h, uhat
        num_sol1 = HDG_solver(type,exact_func,mesh1,N_GQ,numerical_method_info);
end

post_flag = 0;
num_sol_1 = Post_processor(num_sol1,GQ_pts,numerical_method_info,post_flag);

% Calculate numerical method error
[error_list_qh(1),error_list_uh(1),error_list_uhat(1)] = Error_cal(hs,GQ_End_points_phy,exact_func,num_sol_1,GQ_weights);
Plot_comp1(hs,GQ_End_points_phy,exact_func,num_sol_1,GQ_weights);

%% Non-uniform mesh

[hs2,GQ_End_points_phy2] = Mesh_phy_GQ_points(mesh2,GQ_pts);
if numerical_method_info.method == 1 % HDG method
        % num_sol: (N_q+N_u+N_hat) x N_ele matrix , it stores the
        % coefficents of the HDG solution in order q_h, u_h, uhat
        num_sol2 = HDG_solver(type,exact_func,mesh2,N_GQ,numerical_method_info);
end

post_flag = 0;
num_sol_2 = Post_processor(num_sol2,GQ_pts,numerical_method_info,post_flag);
%background_mesh=mesh1;
background_mesh = mesh2.get_background_uniform_mesh;
[proj_num_sol,mesh_relation] = L2Projection_to_coarse_mesh(mesh2,background_mesh,num_sol2,num_sol_2,hs2,GQ_End_points_phy2(1:N_GQ+1,:),GQ_weights,numerical_method_info);

proj_num_sol_star = Post_processor(proj_num_sol,GQ_pts,numerical_method_info,post_flag);

% Calculate numerical method error
[error_list_qh(2),error_list_uh(2),error_list_uhat(2)] = Error_cal(hs,GQ_End_points_phy,exact_func,proj_num_sol_star,GQ_weights);
Plot_comp1(hs2,GQ_End_points_phy2,exact_func,num_sol_2,GQ_weights);
Plot_comp1(hs,GQ_End_points_phy,exact_func,proj_num_sol_star,GQ_weights);

my_table = table(error_list_qh,error_list_uh,error_list_uhat);
disp(my_table)
end