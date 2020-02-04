classdef Functional_info
    properties
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % problem 
        functional_type % type of functional
             % 1  J(u) = (u,g)
             % 2  J(u) = < du*n, psi>
        pde_type % PDE type for the primal problem
                 % 101  Laplace
             
        exact_primal_func % exact function for the primal problem
        exact_adjoint_func % exact function for the adjoint problem
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % mesh 
        mesh0 % initial mesh
        num_iteration % number of iteration
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % method
        GQ % Gauss Quadrature points
        numerical_method_info % numerical method class
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        
        postprocessing % prost-processing 0: no; 1: Conv; 2 Recov 
        refinement % 1: "uniform"; 2: Adapt I; 3:Adapt II
        final_plot % plot or not;
        
        

        
    end
    methods
        function obj = Functional_info(type, pde_type,exact_primal_func, exact_adjoint_func,mesh0,num_iteration,GQ,numerical_method_info,postprocessing,refinement,final_plot)
            obj.functional_type = type;
            obj.pde_type        = pde_type;
            obj.exact_primal_func = exact_primal_func;
            obj.exact_adjoint_func = exact_adjoint_func;
            obj.mesh0 = mesh0;
            obj.num_iteration = num_iteration;
            obj.GQ = GQ;
            obj.numerical_method_info = numerical_method_info;
            obj.postprocessing = postprocessing;
            obj.refinement = refinement;
            obj.final_plot = final_plot;
            
        end
        
    end
end