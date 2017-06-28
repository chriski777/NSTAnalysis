function output = phi_AppEntHelper(m, n ,x_matrix,r)
%Chris Ki, June 2017, Gittis Lab

    C = zeros(n-m+1,1);
    for k = 1 : (n - m + 1)
        %Vectorization 
        %DiffMatrix is a matrix of the difference of the original matrix
        %   x_matrix and a matrix consisting of one window repeated n-m+1
        %   times
        counter = 0;
        repeated = repmat(x_matrix(k,:),n-m+1,1);
        diffMatrix = abs(x_matrix - repeated);
        %Get the rowwise maximum difference 
        maxVector = max(diffMatrix,[],2);
        %Counter is the number of elements of j such that the maximum
        %difference is less than or equal to r. 
        counter = sum(maxVector <= r);
        C(k) = counter/(n - m + 1.0);
    end
    output = sum(log(C))/(n - m + 1.0);
end