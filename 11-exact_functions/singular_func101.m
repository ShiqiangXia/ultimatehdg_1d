function out = singular_func101(x,flag)
% exact solution 
% u = 0  when x<a or x>b
% u = w(x-a/(b-a)) when a<x<b
% where w(s) = sin^2(pi x)cos(pi/2 x)

my_pi = numeric_t('pi');
my_two = numeric_t('2');
my_half_pi = numeric_t('pi/2');
a = numeric_t('0');
b = numeric_t('1');
out = zeros(size(x),numeric_t);

idx = (x>a) == (x<b);
dis = (abs(b-a));
temp = (x(idx) - a) ./dis;

if flag == 0 % exact solution u
   
   out(idx) = sin(my_pi*temp).^my_two .* cos(my_half_pi*temp);
   
    
elseif flag == 1 % exact q: -grad u
    %- \[Pi] Cos[(\[Pi] x)/2]^2 (-1 + 5 Cos[\[Pi] x]) Sin[(\[Pi] x)/2]
    out(idx) =numeric_t('1')/dis * (  - my_pi * cos(my_half_pi *temp ).^my_two  .* (numeric_t('-1')+numeric_t('5')*cos(my_pi*temp)).*sin(my_half_pi * temp));
    
else             % div*q, namely - Laplace u
    % - 1/16 \[Pi]^2 (-2 Cos[(\[Pi] x)/2] + 9 Cos[(3 \[Pi] x)/2] + 25 Cos[(5 \[Pi] x)/2])
    out(idx) = numeric_t('1')/dis^2 * ( -numeric_t('pi^2/16')* (-my_two * cos(my_half_pi * temp) + numeric_t('9')*cos(3*my_half_pi*temp)+numeric_t('25')*cos(5*my_half_pi*temp)));


end