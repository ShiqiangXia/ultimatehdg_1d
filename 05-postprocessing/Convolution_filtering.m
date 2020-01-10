function out=Convolution_filtering(BB,odd_extend_coeff)

[N_pts,Nu,JJ] = size(BB);
[Nu2,temp_ele] = size(odd_extend_coeff);
k = Nu-1;
N_ele = temp_ele - 2*k -2*k;
temp_M = zeros(N_pts,JJ,numeric_t);
out = zeros(N_pts,N_ele,numeric_t);

for ii = 1:N_ele
    for jj = -2*k:1:2*k
        temp_M(:,jj+2*k+1) =  BB(:,:,jj+2*k+1)*odd_extend_coeff(:,ii+2*k+jj);   
    end
    out(:,ii) = sum(temp_M,2);
    
end



end