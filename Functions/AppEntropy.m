function output = AppEntropy(data)
%Chris Ki, June 2017, Gittis Lab
%Approximate Entropy: Provides a measure of the degree of statistical
%   irregularity. Higher AppEn values correspond to higher irregularity.
%   Approximate entropy is independent of the mean and SD of the input
%   data. Approximate entropy is sensitive to the order of the input data
%   (Darin, Soares, Wichmann 2006).
%
%   data = A struct with a single spike train vector where each entry is the timepoint at
%       occurence of a spike

    % numISIs is the n parameter of the ApEn Value
    numISIs = data.AppEnumISIs;
    if numISIs <= length(data.SPKC) - 1
        subsetSpikes = data.SPKC(1:numISIs + 1);
        subsetISIs = zeros(numISIs,1);
        %Calculate ISIs for each intervals
        for k = (1:numISIs)
            subsetISIs(k) = subsetSpikes(k+1) - subsetSpikes(k);
        end
        % embedding dimension is represented as m
        m = 2;
        % comparison length should be 15% of SD
        r = 0.15* allstdISI(data);
        %Initialize matrix 
        x_matrix = zeros((numISIs - m + 1), m);
        %initialize the sequences of windows 
        for i = 1: (numISIs - m + 1)
            for j = 1:m
                x_matrix(i,j) = subsetISIs(i+j-1);
            end
        end
        %
        output = abs(phi_AppEntHelper(m+1, numISIs ,x_matrix,r) ...
            - phi_AppEntHelper(m, numISIs ,x_matrix,r));
    else
        warning(['The length of the spike train is ' num2str(length(data.SPKC)) ...
            ' less than ' num2str(numISIs)])
        output = NaN;
    end
end