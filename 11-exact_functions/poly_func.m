function out = poly_func(x,flag)
% exact solution x^2-x

k = 4;
if k ==2

    if flag == 0 % exact solution u
    out = x.^2-x;
    %out = x.^numeric_t('0')*numeric_t('1/sqrt(2)');
    elseif flag == 1 % exact q: -grad u
    out = - (2*x-1);
    %out = x.^numeric_t('0')*0;
    else             % div*q, namely - Laplace u
    out = -2*(x.^0);
    %out = x.^numeric_t('0')*0;
    end
elseif k==3
    if flag == 0 % exact solution u
    out = 5*x.^3-3*x;
    %out = x.^numeric_t('0')*numeric_t('1/sqrt(2)');
    elseif flag == 1 % exact q: -grad u
    out = - (15*x.^2-3);
    %out = x.^numeric_t('0')*0;
    else             % div*q, namely - Laplace u
    out = -30*(x);
    %out = x.^numeric_t('0')*0;
    end
elseif k == 4
    if flag == 0 % exact solution u
    out = x.^4;
    %out = x.^numeric_t('0')*numeric_t('1/sqrt(2)');
    elseif flag == 1 % exact q: -grad u
    out = - 4*x.^3;
    %out = x.^numeric_t('0')*0;
    else             % div*q, namely - Laplace u
    out = -12*x.^2;
    %out = x.^numeric_t('0')*0;
    end
    
    
end

end