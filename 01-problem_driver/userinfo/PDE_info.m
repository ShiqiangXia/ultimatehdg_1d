classdef PDE_info
    properties
        pb  % problem type number
            % 101 Laplace equation
        exact_u % exact solution
        mesh0 % initial mesh
        pk_u % polynomail degree for u variable
        pk_q % % polynomail degree for q variable
        basis % choice of basis
              % 1 Pk x Pk
        GQ % Gauss Quadrature points
        postprocessing % prost-processing
               
    end
    
    methods
        function obj = PDE_info(pb,exact_u,mesh0,pk_u,pk_q,basis,GQ,postprocessing)
            obj.pb = pb;
            obj.exact_u = exact_u;
            obj.mesh0 = mesh0;
            obj.pk_u = pk_u;
            obj.pk_q = pk_q;
            obj.basis = basis;
            obj.GQ = GQ;
            obj.postprocessing = postprocessing;
        end
    end
end