function out = poly_func(x,flag)
% exact solution sin(pi*x)


%my_pi = numeric_t('pi');

if flag == 0 % exact solution u
    out = x.^2-x;
    
elseif flag == 1 % exact q: -grad u
    out = - (2*x-1);
    
else             % div*q, namely - Laplace u
    out = -2*(x.^0);
end


end