function [x] = JacobiGL(alpha,beta,N)

% function [x] = JacobiGL(alpha,beta,N)
% Purpose: Compute the N'th order Gauss Lobatto quadrature 
%          points, x, associated with the Jacobi polynomial,
%          of type (alpha,beta) > -1 ( <> -0.5). 

% Gauss-Lobatto Quadrature points: JacobiGL(0,0,N)
% Return N+1 points (col vector) and N+1 weights (col vector)

x = zeros(N+1,1,numeric_t);
if (N==1) 
    x(1)=numeric_t('-1.0'); 
    x(2)=numeric_t('1.0'); 
    return; 
end

[xint,w] = JacobiGQ(alpha+1,beta+1,N-2);
x = [numeric_t('-1'), xint', numeric_t('1')]';

return;