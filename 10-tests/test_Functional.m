% test script
% Test the Functional driver
% Oliver Xia 02/05/2020

%%  set precision
close all;

precision = 'double';

%%  define functional problem
functional_type = 1;
pb = 101;
exact_primal_func = @smooth_func101; % exact solution sin(Pi*x)
exact_adjoint_func = @smooth_func101;
%exact_primal_func = @poly_func;
%exact_primal_func = @singular_func101; % C1 not C2
%exact_primal_func = @singular_func102;% 1st derivative blows up at x =0
mesh0 = 10; % initial number of elements
num_iter = 4; % number of refinements
GQ = 5; % Gauss Quadrature order  ---> accuracy 2N+1

%% define numerical method
method = 1 ; % HDG method
pk_u = 2;  % polynomial order u
pk_q = 2;  % polynomial order q
basis_u_type = 1; % basis type (so far we only have 1)
basis_q_type = 1; % basis type (so far we only have 1)
tao_pow = 0; % tau (h^power)
numerical_method = Numerical_method_info(method, pk_u,pk_q,basis_u_type,basis_q_type,tao_pow);
postprocessing = 1; % postprocessing or not 0: no, 1: Conv; 2: Recovery
refine = 1; % refinement method: 1-->Uniform, 2-->non-uniform
final_plot = false;
%final_plot = true;

%% define functional info
my_functional_info = Functional_info(functional_type,pb,exact_primal_func,exact_adjoint_func,mesh0,num_iter,GQ,numerical_method,postprocessing,refine,final_plot);


%% define the whole user info
my_user_info = User_info(1,my_functional_info);

%% call the main driver(solve the problem);
main_driver(my_user_info,precision);

