function out = smooth_func101(x,flag)
% exact solution sin(pi*x)


my_pi = numeric_t('pi');

if flag == 0 % exact solution u
    out = sin(my_pi*x);
    
elseif flag == 1 % exact q: -grad u
    out = - my_pi*cos(my_pi*x);
    
else             % div*q, namely - Laplace u
    out = my_pi*my_pi*sin(my_pi*x);
end


end