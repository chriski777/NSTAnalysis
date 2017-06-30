%Chris Ki, June 2017, Test Suite for appEntropy
addpath('Functions')
increments = [85 80 89];
z(1) = 1;
for i = 2:52
    k = mod(i,3);
    if k == 0
        k = 3;
    end
    z(i) = z(i-1) + increments(k);
end
data.SPKC = z;
data.numOfEqualSegs = 2;
data.AppEnumISIs = 51;
assert(round(AppEntropy(data),9) == 1.0997e-05);