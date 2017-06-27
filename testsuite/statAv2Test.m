%Chris Ki, June 2017, Test Suite for statAv2

%% Test 1: Even length SPKC Train
%Even Length SPKC train 
% make sure to set numofSegements = 2]
addpath('Functions')
endTime = 2;
evenLengthSPKC = [0.25 0.33 0.5 0.8 1 1.5];
data.end = endTime;
data.SPKC = evenLengthSPKC;
data.numOfEqualSegs = 2;
result = statAv2(data);
assert(round(result,4) == 0.2829)


%% Test 2: odd length SPKC Train
%Odd Length SPKC train 
addpath('Functions')
endTime = 3;
oddLengthSPKC = [ 0.01 0.3 0.4 0.6 0.7 0.9 1.4 1.66 1.9 2 2.1 2.2 3];
data2.end = endTime;
data2.SPKC = oddLengthSPKC;
data2.numOfEqualSegs = 3;
result = statAv2(data2);
assert(round(result,4) == 0.9078)

%% Test 3: Empty Interval
endTime = 3;
emptyLengthSPKC = [ 0.01 0.3 0.4 0.6 0.7 0.9 2 2.1 2.2 3];
data3.end = endTime;
data3.SPKC = emptyLengthSPKC;
data3.numOfEqualSegs = 3;
result = statAv2(data3);
assert(round(result,4) == 0.6650)

%% Test 4: Stationary Interval
endTime = 3;
statSPKC = [0.3 0.4 0.5 1.5 1.6 1.7 2.1 2.2 2.3];
data4.end = endTime;
data4.SPKC = statSPKC;
data4.numOfEqualSegs = 3;
result = statAv2(data4);
assert(round(result,4) == 1);