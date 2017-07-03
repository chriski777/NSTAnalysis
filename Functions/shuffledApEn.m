function output = shuffledApEn(data)
%Chris Ki, June 2017, Gittis Lab
% shuffledApEn: Provides a measure of the degree of statistical
%   irregularity for a shuffled sequence of the original data sequence.
%   Follows the methods presented in Pincus (1991), Lim,Sanghera, et al. (2010)
%   and Darbin, Soares, Wichmann(2006)
%   
% 
    
    % numISIs is the n parameter of the ApEn Value
    numISIs = data.AppEnumISIs;    
    if numISIs <= length(data.SPKC) - 1
        subsetISIs = zeros(numISIs,1);
        %Calculate the first numISIs ISIs
        for k = (1:numISIs)
            subsetISIs(k) = data.SPKC(k+1) - data.SPKC(k);
        end

        % embedding dimension is represented as m
        m = data.m;
        % comparison length should be 15% of SD of the subsetISIs
        r = 0.15* std(subsetISIs);
        
        
        %Create population of 100 shuffled data series of original time series
        numSegments = data.shuffPop;
        
        original = repmat(transpose(subsetISIs),numSegments,1);
        [M,N] = size(original);
        
        rowIndices = repmat((1:M)',[1 N]);
        [~, perm] = sort(rand(size(original)),2);
        linIndex = sub2ind([M,N],rowIndices,perm);
        shuffled = original(linIndex);
        outPutVector = zeros(numSegments,1);
        for k = 1:numSegments
            rowShuff = shuffled(k,:);
            %Initialize matrix for phi m
            x_matrix = zeros((numISIs - m + 1), m);
            %for phi m+1
            x_matrix2 = zeros((numISIs - (m +1) + 1 ), m+1);
            %initialize the sequences of windows 
            for i = 1: (numISIs - m + 1)
                x_matrix(i,:) = rowShuff(i:i+m-1);
            end
            for j = 1: (numISIs - (m+1) + 1)
                x_matrix2(j,:) = rowShuff(j:j+m);
            end
            outPutVector(k) = phi_AppEntHelper(m, numISIs ,x_matrix,r) - ...
                phi_AppEntHelper(m+1, numISIs ,x_matrix2,r);
        end
        output = median(outPutVector);    
    else
        warning(['The length of the spike train is ' num2str(length(data.SPKC)) ...
            ' less than ' num2str(numISIs)])
        output = NaN;
    end
end