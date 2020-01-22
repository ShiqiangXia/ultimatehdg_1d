% test script
% Oliver Xia 01/01/2020

%%  set precision
precision = 'double';

%%  define pde problem
pb = 101;
%exact_func = @smooth_func101; % exact solution
%exact_func = @poly_func;
exact_func = @singular_func101;
%exact_func = @singular_func102;
mesh0 = 10; % initial number of elements
num_iter = 3; % number of refinements
GQ = 3; % Gauss Quadrature order  ---> accuracy 2N+1

%% define numerical method
method = 1 ; % HDG method
pk_u = 1;  % polynomial order u
pk_q = 1;  % polynomial order q
basis_u_type = 1; % basis type (so far we only have 1)
basis_q_type = 1; % basis type (so far we only have 1)
tao_pow = 0; % tau (h^power)
numerical_method = Numerical_method_info(method, pk_u,pk_q,basis_u_type,basis_q_type,tao_pow);
postprocessing = 1; % postprocessing or not
refine = 1; % refinement method: 1-->Uniform, 2-->non-uniform

%% define PDE info
my_pde_info = PDE_info(pb,exact_func,mesh0,num_iter,GQ,numerical_method,postprocessing,refine);


%% define the whole user info
my_user_info = User_info(0,my_pde_info);

%% call the main driver(solve the problem);
main_driver(my_user_info,precision);





