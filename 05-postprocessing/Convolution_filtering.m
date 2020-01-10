function out=Convolution_filtering(BB,odd_extend_coeff)

[N_pts,Nu,JJ] = size(BB);
[Nu2,temp_ele] = size(odd_extend_coeff);
k = Nu-1;
N_ele = temp_ele - 2*k -2*k;
temp_M = zeros(N_pts,JJ,numeric_t);
out = zeros(N_pts,N_ele);

for ii = 1:N_ele
    for jj = -2*k:1:2*k
        temp_M(:,jj+2*k+1) =  BB(:,:,jj+2*k+1)*odd_extend_coeff(:,ii+2*k+jj);   
    end
    out(:,ii) = sum(temp_M,2);
    
end


%{
[N_pts,Nu,~,JJ] = size(AA);
[Nu2,temp_ele] = size(odd_extend_coeff);
k = Nu-1;
N_ele = temp_ele - 2*k -2*k;

out = zeros(N_pts,N_ele);

for i = 2*k+1 : 1 :N_ele+2*k
    for n = 1:1:N_pts
        sum = 0;
        for j = -2*k:1:2*k
             %sum = sum +  mp('0.5') *  cr * transpose( mtrix(:,:,j+2*k+1,n))*u_h(:,i+j);
             for m=1:1:(Nu)
                 for tao = 1:1:2*k+1
                     sum = sum + numeric_t('0.5')*cr(tao)*odd_extend_coeff(m,i+j)*AA(n,m,tao,j+2*k+1);
                 end
             end
             
        end
        out(n,i-2*k) = sum ;
    end
    
end

%}
end