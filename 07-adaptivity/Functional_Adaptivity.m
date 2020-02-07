function refine_vector = Functional_Adaptivity(refine_number,error_estimator,tol,adp_strategy)
[~,N_ele] = size(error_estimator);
error_estimator = abs(error_estimator);
refine_vector = zeros(1,N_ele,numeric_t);
percent = 30;
if refine_number == 2 % First Adaptive method 
    if adp_strategy == 1
        %e_tol = tol/N_ele;
        e_tol = sum(error_estimator)/N_ele;
        %e_tol = prctile(error_estimator,percent);
        
        idx = (error_estimator>e_tol);
        refine_vector(idx) = 1;
    end
    
else % second apative method
    
end

end