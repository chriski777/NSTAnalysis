%Chris Ki, July 2017, Test Suite for fanoFactor
%First Test Case
addpath('Functions')
timeStamps = [0.1 0.2  0.3 1 1.4 1.6 2 3 4.7 4.8 4.9 5.0 5.2 5.3 5.4 5.5 6 7 8 9 10];
data.SPKC = timeStamps;
data.end = 10;
segs = [12,9];
result = fanoFactor(data);
check = var(segs)/mean(segs);
assert(result == check);
%Second Test Case
timeStamps2 = [1 1.1 1.15 1.2 1.3 1.4 1.6 2 3 4.5 5 11 12 13 14 15 ];
data2.SPKC = timeStamps2;
data2.end = 15;
segs2 = [11,0,5];
result2 = fanoFactor(data2);
check2 = var(segs2)/mean(segs2);
assert(result2 == check2)
