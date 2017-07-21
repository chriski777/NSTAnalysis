function output = binarySpikes(SPKC,dt)
%Chris Ki, July 2017, Gittis Lab
%binarySpikes : binarizes a spike train that is represented in time stamps

%Input Parameters:
%   SPKC =  n x 1 Time stamps of spikes
%   dt = bin size

%Output Parameters:
%   output = Times vector spaced out by dt with 0's for non spikes and
%   1's for spikes
    endTime = round(SPKC(end)/dt)*dt; 
    times = 0:dt:endTime;
    binaryTrain = zeros(length(times),1);
    binaryTrain(floor(SPKC/dt)+1) = 1;
    output = binaryTrain;
end