classdef Numerical_method_info
    properties
        method % 1: HDG; 2:
        pk_u % polynomail degree for u variable
        pk_q % % polynomail degree for q variable
        basis_u % choice of u basis 
        basis_q % choice of q basis
        tau_pow % h^tau_pow
             
        
    end
    
    methods
        function obj = Numerical_method_info(method, pk_u,pk_q,basis_u,basis_q,tao_pow)
            obj.method = method;
            obj.pk_u = pk_u;
            obj.pk_q = pk_q;
            obj.basis_u = basis_u;
            obj.basis_q = basis_q;
            obj.tau_pow = tao_pow;
            
            
        end
    end
end