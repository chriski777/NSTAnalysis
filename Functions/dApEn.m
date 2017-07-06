function dApEn()
%Chris Ki, June 2017, Gittis Lab
%dApEnCalculator: Calculates  the dApEn which is given by ApEn_raw -
%   ApEn_shuffled (Darbin, Soares, Wichmann 2006). A high dApEn indicates
%   there is a difference in the temporal organization between the shuffled
%   series and the original time series. Also calculates the
%   Apen_raw/Apen_shuffled ratio. A ratio closer to 1 means the entropy
%   depends on the distribution of ISIs while values different from 1 mean
%   the spike train has temporal organization.

%This function is used differently from the other functions. No data struct
%   input is needed. You should only use this function AFTER calculating
%   AppEntropy and shuffledApEn. Also, make sure that this function is run
%   inside the Functions folder. This function should not be run from
%   master. 

%Lastly, please make sure to use the same M, N, and r parameters for
%   shuffledApEn and AppEntropy.

    %Checks to see if AppEntropy & shuffledApEn contain results
    addpath('..\results')
    if and(exist('..\results\AppEntropy', 'file') == 7, exist('..\results\shuffledApEn', 'file') ...
            == 7)
        addpath('..\results\AppEntropy')
        addpath('..\results\shuffledApEn')
        dir1 = dir(['..\results\AppEntropy', '\*.csv']);
        dir2 = dir(['..\results\shuffledApEn', '\*.csv']);
        numFiles1 = length(dir1(not([dir1.isdir])));
        numFiles2 = length(dir2(not([dir2.isdir])));
        if or(numFiles1 ==0, numFiles2 == 0)
            msg = 'One of the two directories is empty.';
            error(msg)
        end
        if numFiles1 ~= numFiles2
            msg = ['The number of result files in both directories ' ...
                'are not equal. '];
            error(msg)
        end
        if exist('..\results\dApEn', 'file') ~= 7
            mkdir('..\results\dApEn')
        end
        for i = 1:numFiles1
            %Make sure both files correspond to the same model
            fileName1 = ['..\results\AppEntropy\', dir1(i).name];
            fileName2 = ['..\results\shuffledApEn\', dir1(i).name];
            [~,~,cell1] = xlsread(fileName1);
            ApEni = cell1(:,5);
            [~,~,cell2] = xlsread(fileName2);
            shuffApEni = cell2(:,5);
            resultVector1 = zeros(length(ApEni) -1,1);
            resultVector2 = zeros(length(ApEni) -1, 1);
            for k = 2:length(ApEni)
                ApEnRaw = cell2mat(ApEni(k));
                shuffApEn = cell2mat(shuffApEni(k));
                %For conversion, NaN becomes a vector with length 4. Thus,
                % if we do isnan on Nan, it produces a length 4 vector with
                % logicals. I chose to distignuish Nans this particular
                % way.
                if (length(~isnan(ApEnRaw)) ==1 && length(~isnan(shuffApEn)) ==1)
                    resultVector1(k-1) = abs(ApEnRaw - shuffApEn)/(shuffApEn);
                    resultVector2(k-1) = ApEnRaw/shuffApEn;
                else
                    resultVector1(k-1) = NaN;
                    resultVector2(k-1) = NaN;
                end
            end
            dApEn = num2cell(resultVector1);
            ratio = num2cell(resultVector2);
            column1 = [{'dApEn'};dApEn];
            column2 = [{'original/shuffled'};ratio];
            M = [cell1(:,(1:4)),column1, column2];
            M(strcmp(M,' NaN')) = {NaN};
            %Writes file
            fileName = ['..\results\dApEn\', dir1(i).name];
            fid = fopen(fileName,'wt');
            if fid > 0
               %Writes column headers
               fprintf(fid,'%s, %s, %s, %s, %s, %s\n', M{1,1}, M{1,2},  M{1,3}, M{1,4}, M{1,5}, M{1,6});
               for j = 2:size(M,1)
                fprintf(fid,'%s, %d, %f, %f, %f, %f\n',M{j,1}, M{j,2},  M{j,3}, M{j,4}, M{j,5}, M{j,6});
               end
               fclose(fid);
            end
        end
    else 
        msg = ['One or both of the directories: results\AppEntropy, results\shuffledApEn are missing. ' ...
        'Please make sure to run AppEntropy and shuffledApEn before you run this. ' ...
        'Make sure to be in the Functions directory.'];
        error(msg)
    end