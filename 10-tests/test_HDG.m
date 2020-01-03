% test script


% set precision
precision = "double";

% define pde problem
pb = 101;
exact_func = @smooth_func101;
mesh0 = 10;
num_iter = 3;
GQ = 3;
method = 1 ; % HDG method
pk_u = 1;
pk_q = 1; 
basis_u = 1;
basis_q = 1; 
tao_pow = 0;
numerical_method = Numerical_method_info(method, pk_u,pk_q,basis_u,basis_q,tao_pow);
postprocessing = 0;
refine = 1;
my_pde_info = PDE_info(pb,exact_func,mesh0,num_iter,GQ,numerical_method,postprocessing,refine);

% define user info
my_user_info = User_info(0,my_pde_info);

% call the driver;
main_driver(my_user_info,precision);