
function val = Even_extension(u_h)
[Nu,~] = size(u_h);

idty = zeros(Nu,1,numeric_t);
bd = 2*(Nu-1);

for ii = 1:1:Nu
    idty(ii)= (-1)^(ii-1);
end
temp1 = idty.* u_h(:,1:bd);
temp2 = idty.* u_h(:,end-bd+1:end);
val = [fliplr(temp1),u_h,fliplr(temp2)];

end