function out = singular_func102(x, flag)

% exact solution 
% u = x^(alpha)


my_alpha = numeric_t('5/3');
my_alpha_1 = my_alpha - numeric_t('1');
my_alpha_2 = my_alpha_1 -  numeric_t('1');

if flag == 0 % exact solution u
   
   out = x.^my_alpha;
   
    
elseif flag == 1 % exact q: -grad u
    
    out =- my_alpha * x.^(my_alpha_1);
    
else             % div*q, namely - Laplace u
    
    out =- my_alpha * my_alpha_1*x.^my_alpha_2;



end