function output = ISIconverter(SPKC,n)
%Chris Ki, June 2017, Gittis Lab
%ISIconverter : Takes in a vector of a Spike Train and returns a series of
%   ISIs that is n-1 long
%
%Inputs: 
%   SPKC = A spike train vector of timestamps at which a spike occurred
%   n = the number of ISIs you want

%Output: 
%   output: An (n, 1) vector of ISIs
    output = zeros(n,1);
    for i = 1:n
        output(i) = SPKC(i+1) - SPKC(i);
    end
end