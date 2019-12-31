classdef PDE_info
    properties
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % problem 
        pb  % problem type number
            % 101 Laplace equation
        exact_sol % exact solution
        
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
        
        postprocessing % prost-processing
        refinement % 1: "uniform"; 2: Adapt I; 3:Adapt II
               
    end
    
    methods
        function obj = PDE_info(pb,exact_sol,mesh0,num_iter,GQ,numerical_method,postprocessing,refine)
            obj.pb = pb;
            obj.exact_sol = exact_sol;
            
            obj.mesh0 = mesh0;
            obj.num_iteration = num_iter;
            
            obj.GQ = GQ;
            obj.numerical_method_info = numerical_method;
            
            obj.postprocessing = postprocessing;
            obj.refinement = refine;
        end
    end
end