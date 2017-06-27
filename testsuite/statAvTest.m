%Chris Ki, June 2017, Test Suite for statAv

%% Test 1: odd length SPKC Train
%Odd Length SPKC train 
% make sure to set numofSegements = 2]
addpath('Functions')
endTime = 1;
oddLengthSPKC = [0.25 0.3 0.5 0.83 0.95];
data.end = endTime;
data.SPKC = oddLengthSPKC;
data.numOfEqualSegs = 2;
result = statAv(data);
assert(round(result,4) == 0.5886);

%%Test 2: even legnth SPKC Train
endTime = 1;
evenLengthSPKC1 = [0.25 0.3 0.83 0.95];
data.end = endTime;
data.SPKC = evenLengthSPKC1;
data.numOfEqualSegs = 2;
result = statAv(data);
%numerator should be 0.0495
%allStdISI should be 0.2593
assert(round(result,4) == 0.1909);

%Test 3: Empty Segments
%Stationary data.
endTime = 1;
oddLengthSPKC2 = [0.5 0.71 0.75 0.83 0.95 ];
%all ISIs are [0.21 0.04 0.08 0.12]
data.end = endTime;
data.SPKC = oddLengthSPKC2;
data.numOfEqualSegs = 2;
result = statAv(data);
assert(round(result,4) == 0);

%% Test 4: Stationary Interval
% has constant mean and variance 
endTime = 3;
statSPKC = [0.3 0.4 0.5 1.5 1.6 1.7 2.1 2.2 2.3];
data4.end = endTime;
data4.SPKC = statSPKC;
data4.numOfEqualSegs = 3;
result = statAv2(data4);
assert(round(result,4) == 0);