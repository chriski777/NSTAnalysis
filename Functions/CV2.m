function result = CV2(data)
%Chris Ki, June 2017, Gittis Lab
%CV2: Involves calculating the Coefficient of Variation with respect to
%adjacent time windows rather than the whole distribution

%Input: data must have one field
%       data.SPKC = Timestamps of a single spike train
    ISIs = ISIconverter(data.SPKC,length(data.SPKC)-1);
    allCV2 = zeros(length(ISIs) - 1, 1);
    for i = 1:length(ISIs) -1 
        allCV2(i) = 2*(abs(ISIs(i) -ISIs(i+1)))/(ISIs(i) + ISIs(i+1));
    end
    result = mean(allCV2);
end