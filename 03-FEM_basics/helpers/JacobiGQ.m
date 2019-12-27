function [x,w] = JacobiGQ(alpha,beta,N)

% function [x,w] = JacobiGQ(alpha,beta,N)
% Purpose: Compute the N'th order Gauss quadrature points, x, 
%          and weights, w, associated with the Jacobi 
%          polynomial, of type (alpha,beta) > -1 ( <> -0.5).

% Gauss-Legendre Quadrature points: JacobiGQ(0,0,N)
% Return N+1 points (col vector) and N+1 weights (col vector)


alpha = numeric_t(alpha);
beta = numeric_t(beta);
N = numeric_t(N);

if (N==0) 
    x(1)= -(alpha-beta)/(alpha+beta+2); 
    w(1) = numeric_t('2'); 
    return; 
end

% Form symmetric matrix from recurrence.
J = zeros(N+1,numeric_t);

h1 = numeric_t('2')*(0:N)+alpha+beta;

J = diag(-1/2*(alpha^2-beta^2)./(h1+2)./h1) + ...
    diag(2./(h1(1:N)+2).*sqrt((1:N).*((1:N)+alpha+beta).*...
    ((1:N)+alpha).*((1:N)+beta)./(h1(1:N)+1)./(h1(1:N)+3)),1);
if (alpha+beta<10*eps) 
    J(1,1)=0.0;
end
J = J + J';

%Compute quadrature by eigenvalue solve
[V,D] = eig(J); x = diag(D);
w = (V(1,:)').^numeric_t('2')*numeric_t('2')^(alpha+beta+1)/(alpha+beta+1)*gamma(alpha+1)*...
    gamma(beta+1)/gamma(alpha+beta+1);
return;