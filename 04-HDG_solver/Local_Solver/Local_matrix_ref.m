function [A,B,C,D,E]=Local_matrix_ref(Nu,Nq,basis_u,basis_q,N_GQ)
    
    % compute necessary matrix
    % see my notes for details
    
    A = volume_integral_q_q(Nq,N_GQ);
    
    B = volume_integral_divq_u(Nq,Nu,N_GQ);
    
    temp_u_L = my_vandermonde_u(numeric_t("-1"),Nu);
    
    temp_u_R = my_vandermonde_u(numeric_t("1"),Nu);
    
    C = temp_u_L'*(temp_u_L)+temp_u_R'*(temp_u_R);
    
    temp_q_L = my_vandermonde_q(numeric_t("-1"),Nq);
    
    temp_q_R =  my_vandermonde_q(numeric_t("1"),Nq);
    
    D = [temp_q_L', -temp_q_R'];
    
    E = [temp_u_L',temp_u_R'];
    
    
end