function [classes] =  customClassify(x_y_z, orderFxns)
%Chris Ki, July 2017, Gittis Lab
%CustomClassify: classifies data points based on FanoFactors, SampSkew and
%   ExpFit

sizex_y_z = size(x_y_z);
classes = zeros(sizex_y_z(1), 1);
fanoCol = strcmpi(orderFxns, 'fanofactor');
skewCol = strcmpi(orderFxns, 'sampleSkew');
expFitCol = strcmpi(orderFxns, 'expFitResults');

for i = 1:sizex_y_z(1)
    currRow = x_y_z(i,:);
    skewVal = currRow(skewCol);
    fanoVal = currRow(fanoCol);
    eFitVal = currRow(expFitCol);
    %Regular Thresholds
    if skewVal <= 0.7 && fanoVal <= 0.6 
        classes(i) = 1;
    %Irregular Thresholds
    elseif 0.55<= skewVal && skewVal <= 1.2 && 0.6 < fanoVal && fanoVal <= 0.95 & -1.5 <= eFitVal
        classes(i) = 2;
    elseif 0.6 < fanoVal && fanoVal < 0.87 && skewVal > 0.5 
        classes(i) = 2;
    %Bursty Thresholds
    elseif fanoVal >= 0.9
        classes(i) = 3;
    else
        classes(i) = 0;
    end
end