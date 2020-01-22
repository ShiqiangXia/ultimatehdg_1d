function out = singular_func102(x, flag)

% exact solution 
% u = x^(2/3)




if flag == 0 % exact solution u
   
   out = x.^numeric_t('2/3');
   
    
elseif flag == 1 % exact q: -grad u
    %- \[Pi] Cos[(\[Pi] x)/2]^2 (-1 + 5 Cos[\[Pi] x]) Sin[(\[Pi] x)/2]
    out =- numeric_t('2/3') * x.^numeric_t('-1/3');
    
else             % div*q, namely - Laplace u
    % - 1/16 \[Pi]^2 (-2 Cos[(\[Pi] x)/2] + 9 Cos[(3 \[Pi] x)/2] + 25 Cos[(5 \[Pi] x)/2])
    out = numeric_t('2/9')*x.^numeric_t('-4/3');



end