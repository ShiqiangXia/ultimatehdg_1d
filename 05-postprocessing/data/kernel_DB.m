function [AA,cr] = kernel_DB(k,Np,pts)
% compute kernel with doule precision
% k: kernel degree
% Np:polynomial degree
%%% pts: Symbolic  points

Digi = 64;
%step 1 compute psi_(k+1)
syms x y
basis(x) = symfun( heaviside(x+sym(0.5)) - heaviside(x-sym(0.5)),x );

psi = basis;
if k ~= 0
    for i = 1:1:k
        psi(x) = int(psi(x-y)*basis(y),y,-inf,inf);
    end
end
%step 2 compute Cr
%A = zeros(2*k+1,2*k+1);
A =sym('a',[2*k+1,2*k+1]);
%b = zeros(2*k+1,1);
b = sym('b',[2*k+1,1]);
b(1,1) = sym(1);
for jj = 2:1:2*k+1
    b(jj,1) =sym(0);
end

if k~=0
    for l = 0:1:2*k
        for tao = -k:1:k
            A(l+1,tao+k+1) = int(psi(x-sym(tao))* x^l,x,-2*k,2*k);
        end
    end
end
if k == 0
    A(1,1) =1;
end


Cr = A\b;
%cr= mp(zeros(2*k+1,1));
cr = zeros(2*k+1,1);
for jj = 1: 1: 2*k+1
    cr(jj,1) =  vpa(Cr(jj),Digi);
end
%step 3 compute convolution matrix
n = length(pts);
%AA = mp(zeros(Np+1,2*k+1,4*k+1,n));
if k>0
    AA = zeros(n,Np+1,2*k+1,4*k+1);
%AA = sym('aa',[Np+1,2*k+1,4*k+1,n]);

% use legendre polynomail,  normalized.!
    for mm=0:1:Np
        for ss = -k:1:k
            for jj = -2*k:1:2*k
                for nn = 1:1:n
                    AA(nn,mm+1,ss+k+1,jj+2*k+1) =  vpa( int( psi( pts(nn)/sym(2) - sym(jj) - x/sym(2) - sym(ss) ) * legendreP(sym(mm),x)*sqrt(sym(2*mm+1)/sym(2)) ,x,-1,1),Digi);
                end
            end
        end
    end

else
    AA = zeros(Np+1,2*k+1,3,n);
    for mm=0:1:Np
        for ss = -k:1:k
            for jj = -1:1:1
                for nn = 1:1:n
                    AA(mm+1,ss+k+1,jj+2,nn) =  vpa( int( psi( pts(nn)/sym(2) - sym(jj) - x/sym(2) - sym(ss) ) * legendreP(sym(mm),x)*sqrt(sym(2*mm+1)/sym(2)) ,x,-1,1),Digi);
                end
            end
        end
    end
    
end
%}
end