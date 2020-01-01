function out = smooth_func(x,flag)
my_pi = numeric_t('pi');
if flag == 0 % exact solution u
    out = sin(my_pi*x);
elseif flag == 1 % exact q: -grad u
    out = - cos(my_pi*x);
else             % div*q, namely - Laplace u
    out = sin(my_pi*x);
end
end