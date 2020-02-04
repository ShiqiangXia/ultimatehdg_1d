classdef PDE_info
    properties
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % problem 
        pb  % problem type number
            % 101 Laplace equation
        exact_func % exact solution
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % mesh 
        mesh0 % initial mesh
        num_iteration % number of iteration
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % method
        GQ % Gauss Quadrature points
        numerical_method_info % numerical method class
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % post processing
        
        postprocessing % prost-processing 0: no; 1: Conv; 2 Recov 
        refinement % 1: "uniform"; 2: Adapt I; 3:Adapt II
        final_plot % plot or not;
               
    end
    
    methods
        function obj = PDE_info(pb,exact_func,mesh0,num_iter,GQ,numerical_method,postprocessing,refine,final_plot)
            obj.pb = pb;
            obj.exact_func = exact_func;
            
            obj.mesh0 = mesh0;
            obj.num_iteration = num_iter;
            
            obj.GQ = GQ;
            obj.numerical_method_info = numerical_method;
            
            obj.postprocessing = postprocessing;
            obj.refinement = refine;
            obj.final_plot = final_plot;
        end
    end
end