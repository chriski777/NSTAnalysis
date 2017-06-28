function output = AppEntropy(data)
%Chris Ki, June 2017, Gittis Lab
%Approximate Entropy: Provides a measure of the degree of statistical
%   irregularity(Pincus 1991). Higher AppEn values correspond to higher irregularity.
%   Approximate entropy is independent of the mean and SD of the input
%   data. Approximate entropy is sensitive to the order of the input data
%   (Darin, Soares, Wichmann 2006). Approximate entropy is distinct from
%   Kolmogorov-Sinai Entropy as it is not susceptible to tiny amounts of
%   noise that is present in in-vivo recordings.
%
%   Input: 
%       data = A struct that MUST HAVE the following fields:
%           data.AppEnumISIs = the fixed length of the data series you would like to examine.
%               AppEntropy is dependent on the length of the data. 
%           data.SPKC = Spike train vector where each entry is the timepoint at occurence of 
%               a spike.

    % numISIs is the n parameter of the ApEn Value
    numISIs = data.AppEnumISIs;
    if numISIs <= length(data.SPKC) - 1
        subsetISIs = zeros(numISIs,1);
        %Calculate the first numISIs ISIs
        for k = (1:numISIs)
            subsetISIs(k) = data.SPKC(k+1) - data.SPKC(k);
        end
        % embedding dimension is represented as m
        m = 2;
        % comparison length should be 15% of SD of the subsetISIs
        r = 0.15* std(subsetISIs);
        %Initialize matrix for phi m
        x_matrix = zeros((numISIs - m + 1), m);
        %for phi m+1
        x_matrix2 = zeros((numISIs - (m +1) + 1 ), m+1);
        %initialize the sequences of windows 
        for i = 1: (numISIs - m + 1)
            x_matrix(i,:) = subsetISIs(i:i+m-1);
        end
        for j = 1: (numISIs - (m+1) + 1)
            x_matrix2(j,:) = subsetISIs(j:j+m);
        end
        output = phi_AppEntHelper(m, numISIs ,x_matrix,r) - ...
            phi_AppEntHelper(m+1, numISIs ,x_matrix2,r);
    else
        warning(['The length of the spike train is ' num2str(length(data.SPKC)) ...
            ' less than ' num2str(numISIs)])
        output = NaN;
    end
end