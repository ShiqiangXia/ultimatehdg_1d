% test script
% Test the PDE driver
% Oliver Xia 01/01/2020

%%  set precision
close all;

precision = 'double';

%%  define pde problem
pb = 101;
%exact_func = @smooth_func101; % exact solution sin(Pi*x)
%exact_func = @poly_func;
%exact_func = @singular_func101; % C1 not C2
exact_func = @singular_func102;% 1st derivative blows up at x =0
%exact_func = @singular_func103; % C1 not C2

mesh0 = 20; % initial number of elements
num_iter = 4; % number of refinements
GQ = 6; % Gauss Quadrature order  ---> accuracy 2N+1


%% define numerical method
method = 1 ; % HDG method
pk_u = 1;  % polynomial order u
pk_q = 1;  % polynomial order q
basis_u_type = 1; % basis type (so far we only have 1)
basis_q_type = 1; % basis type (so far we only have 1)
tao_pow = 0; % tau (h^power)
numerical_method = Numerical_method_info(method, pk_u,pk_q,basis_u_type,basis_q_type,tao_pow);
postprocessing = 0; % postprocessing or not 0: no, 1: Conv; 2: Recovery
refine = 1; % refinement method: 1-->Uniform, 2-->non-uniform
%final_plot = false;
final_plot = true;

%% define PDE info
my_pde_info = PDE_info(pb,exact_func,mesh0,num_iter,GQ,numerical_method,postprocessing,refine,final_plot);


%% define the whole user info
my_user_info = User_info(0,my_pde_info);

%% call the main driver(solve the problem);
main_driver(my_user_info,precision);





