function output = phi_AppEntHelper(m, n ,x_matrix,r)
%Chris Ki, June 2017, Gittis Lab

    C = zeros(n-m+1,1);
    for k = 1 : (n - m + 1)
        counter = 0;
        for l = 1: (n - m + 1)
            %output: maximum difference in respective scalar components
            if max(abs(x_matrix(k,:) - x_matrix(l,:))) <= r
                 counter = counter + 1;
            end
        end
        C(k) = counter/(n - m + 1.0);
    end
    output = sum(log(C))/(n - m + 1.0);
    