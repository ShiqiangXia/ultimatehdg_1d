function out = poly_func(x,flag)
% exact solution sin(pi*x)


%my_pi = numeric_t('pi');

if flag == 0 % exact solution u
    %out = x.^2-x;
    out = x.^numeric_t('0')*numeric_t('1/sqrt(2)');
elseif flag == 1 % exact q: -grad u
    %out = - (2*x-1);
    out = x.^numeric_t('0')*0;
else             % div*q, namely - Laplace u
    %out = -2*(x.^0);
    out = x.^numeric_t('0')*0;
end


end