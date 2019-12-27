function [P] = JacobiP(x,alpha,beta,N)

% function [P] = JacobiP(x,alpha,beta,N)
% Origila Code from Nodal DG book
% Purpose: Evaluate Jacobi Polynomial of type (alpha,beta) > -1
%          (alpha+beta <> -1) at points x for order N and returns P[1:length(xp))]
% Note   : They are normalized to be orthonormal.


% Legendre Polynomial: Jacobip(x,0,0,N)


% Turn points into row if needed.

xp = numeric_t(x); dims = size(xp);
if (dims(2)==1) 
    xp = xp'; 
end

alpha = numeric_t(alpha);
beta = numeric_t(beta);
N = numeric_t(N);

PL = zeros(N+1,length(xp),numeric_t); 
%PL = zeros(N+1,length(xp));


% Initial values P_0(x) and P_1(x)
gamma0 = numeric_t('2')^(alpha+beta+numeric_t('1'))/(alpha+beta+numeric_t('1'))*gamma(alpha+numeric_t('1'))*...
    gamma(beta+numeric_t('1'))/gamma(alpha+beta+numeric_t('1'));
PL(1,:) = numeric_t('1')/sqrt(gamma0);

if (N==0) 
    P=PL'; 
    return; 
end

gamma1 = (alpha+numeric_t('1'))*(beta+numeric_t('1'))/(alpha+beta+numeric_t('3'))*gamma0;
PL(2,:) = ((alpha+beta+numeric_t('2'))*xp/numeric_t('2') + (alpha-beta)/numeric_t('2'))/sqrt(gamma1);
if (N==1) 
    P=PL(N+1,:)'; 
    return; 
end

% Repeat value in recurrence.
aold = numeric_t('2')/(numeric_t('2')+alpha+beta)*sqrt((alpha+numeric_t('1'))*(beta+numeric_t('1'))/(alpha+beta+numeric_t('3')));

% Forward recurrence using the symmetry of the recurrence.
for i=1:N-1
  h1 = numeric_t('2')*i+alpha+beta;
  anew = numeric_t('2')/(h1+numeric_t('2'))*sqrt( (i+1)*(i+1+alpha+beta)*(i+1+alpha)*...
      (i+1+beta)/(h1+1)/(h1+3));
  bnew = - (alpha^2-beta^2)/h1/(h1+2);
  PL(i+2,:) = 1/anew*( -aold*PL(i,:) + (xp-bnew).*PL(i+1,:));
  aold =anew;
end

P = PL(N+1,:)';

return