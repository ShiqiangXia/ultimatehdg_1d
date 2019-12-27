classdef Functional_info
    properties
        type % type of functional
             % 1  J(u) = (u,g)
             % 2  J(u) = < du*n, psi>
        primal_pde % info about the primal problem
        adjoint_pde % infor about the adjoint problem
        GQ
        
    end
    methods
        function obj = Functional_info(type, primal_pde, adjoint_pde,GQ)
            obj.type = type;
            obj.primal_pde = primal_pde;
            obj.adjoint_pde = adjoint_pde;
            obj.GQ = GQ;
            
        end
        
    end
end