function output = AppEntropy(data)
%Chris Ki, June 2017, Gittis Lab
%Approximate Entropy: Provides a measure of the degree of statistical
%   irregularity. Higher AppEn values correspond to higher irregularity.
%   Approximate entropy is independent of the mean and SD of the input
%   data. Approximate entropy is sensitive to the order of the input data
%   (Darin, Soares, Wichmann 2006).
%
%   SPKC = A single spike train vector where each entry is the timepoint at
%       occurence of a spike
    % numSpikes is the n parameter of the ApEn Value
    numSpikes = 3000;
    
    subsetSpikes = data.SPKC(1:3001);
    
    % embedding dimension is represented as m
    m = 2;
    %
    output = 1;
end