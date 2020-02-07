function out = singular_func103(x,flag)
% exact solution 
% u = h((x-0)/(a)) ; when 0<x<=a 
% u = w(x-a/(b-a)) when a<x<b
% u = h((x-b)/(1-b)) when b=<x<1
% where h(s) = (cos(2pi x) -1)^2
%      w(s) = sin^2(pi x)cos(pi/2 x)

% if a = 0.3, b = 0.7 (of course some other numbers work too)
% u is in C1, but not C2
% to be more specific, u is not in C2 at a, u is not in C3 at b

my_pi = numeric_t('pi');
my_two = numeric_t('2');
my_one = numeric_t('1');
my_half_pi = numeric_t('pi/2');
a = numeric_t('0.3');
b = numeric_t('0.7');
out = zeros(size(x),numeric_t);

idx1 = (x<=a); %x<a
dis1 = (abs(a));
temp1 = (x(idx1))./dis1;

idx2 = (x>a) == (x<b); % a<x<b
dis2 = (abs(b-a));
temp2 = (x(idx2) - a) ./dis2;

idx3 = (x>=b); %x>b
dis3 = abs(my_one-b);
temp3 = (x(idx3)-b)./dis3;



if flag == 0 % exact solution u
    out(idx1) = (cos(my_two*my_pi*temp1) - my_one).^2;
    out(idx2) = sin(my_pi*temp2).^my_two .* cos(my_half_pi*temp2);
    out(idx3) = (cos(my_two*my_pi*temp3) - my_one).^2;
   
    
elseif flag == 1 % exact q: -grad u
    %- 16 \[Pi] Cos[\[Pi] x] Sin[\[Pi] x]^3
    out(idx1) = numeric_t('1')/dis1 * (numeric_t('-16*pi')*cos(my_pi*temp1).* (sin(my_pi*temp1).^3));
    out(idx3) = numeric_t('1')/dis3 * (numeric_t('-16*pi')*cos(my_pi*temp3).* (sin(my_pi*temp3).^3));
    %- \[Pi] Cos[(\[Pi] x)/2]^2 (-1 + 5 Cos[\[Pi] x]) Sin[(\[Pi] x)/2]
    out(idx2) =numeric_t('1')/dis2 * (  - my_pi * cos(my_half_pi *temp2 ).^my_two  .* (numeric_t('-1')+numeric_t('5')*cos(my_pi*temp2)).*sin(my_half_pi * temp2));
    
else             % div*q, namely - Laplace u
    % - 16 \[Pi]^2 (1 + 2 Cos[2 \[Pi] x]) Sin[\[Pi] x]^2
    out(idx1)  = numeric_t('1')/dis1^2 * (numeric_t('-16*pi^2')*(my_one + my_two*cos(my_two*my_pi*temp1)).*(sin(my_pi*temp1).^2));
    out(idx3)  = numeric_t('1')/dis3^2 * (numeric_t('-16*pi^2')*(my_one + my_two*cos(my_two*my_pi*temp3)).*(sin(my_pi*temp3).^2));
    % - 1/16 \[Pi]^2 (-2 Cos[(\[Pi] x)/2] + 9 Cos[(3 \[Pi] x)/2] + 25 Cos[(5 \[Pi] x)/2])
    out(idx2) = numeric_t('1')/dis2^2 * ( -numeric_t('pi^2/16')* (-my_two * cos(my_half_pi * temp2) + numeric_t('9')*cos(3*my_half_pi*temp2)+numeric_t('25')*cos(5*my_half_pi*temp2)));


end