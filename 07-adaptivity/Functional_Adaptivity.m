function refine_vector = Functional_Adaptivity(refine_number,error_estimator,tol,adp_strategy)
[~,N_ele] = size(error_estimator);
error_estimator = abs(error_estimator);
refine_vector = zeros(1,N_ele,numeric_t);
percent = 0.3;
if refine_number == 2 % First Adaptive method 
    if adp_strategy == 1
        % adaptive strategy 1
        % refine elements such that 
        % local_error_estimate > max_local_error_estimate * x%
        e_tol = max(error_estimator);     
        idx = (error_estimator>percent*e_tol);
        refine_vector(idx) = 1;
    elseif adp_strategy == 2
        % adaptive strategy 1
        % refine elements such that 
        % rank local error esimators in decreasing order
        % refine the first x percent
        e_N = floor(percent*N_ele);
        
        %[~,idx] = maxk(error_estimator,e_N);
        %refine_vector(idx) = 1;
        
        [~,idx] = sort(error_estimator,'descend');
        refine_vector(idx(1:e_N)) = 1;
        
    elseif adp_strategy == 3
        % adaptive strategy 1
        % refine elements such that 
        % refine: local_error_estimate > TOL/N
        e_tol = tol/N_ele;
        idx = (error_estimator>e_tol);
        refine_vector(idx) =1;
        
        
    end
    
else % second apative method
    
end

end