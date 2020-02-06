function Conv_matrix=Get_convolution_matrix(pts,kk,Nu,GQ_pts,GQ_weights)


AA = Convolution_matrix(kk,Nu,pts,GQ_pts,GQ_weights);

str = ['c', num2str(kk)];

cr = numeric_t(struct2array( load("Convolution_Cr_deg1_5.mat",str)));

Conv_matrix = zeros(length(pts),Nu,4*kk+1,numeric_t);

for ss = 1:2*kk+1
    Conv_matrix(:,:,:) = Conv_matrix(:,:,:) + cr(ss)*squeeze(AA(:,:,ss,:))*numeric_t('0.5');
end

end