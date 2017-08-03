function result = spikeDensityFunction(data)
%spikeDensityFunction: Calculates sdf based on movement data
    if isempty(data.movet_rs) || isempty(data.moving_rs)
        msg = ['There is no movement file associated with this ' data.fileName{1}];
        warning(msg)
    else
        allTimes = data.movet_rs;
        movements = data.moving_rs;
        %vector of all Onsets
        onSets = find(diff(movements) == 1);
        offSets = find(diff(movements) == -1);
        %Identify correct region of subplot
        index = data.iteration;
        modVal = mod(index,4);
        if modVal == 0
            modVal = 4;
        end
        subplot(2,2,modVal)
        if isempty(onSets) && isempty(offSets)
            plot(allTimes,movements)
        else
            %if movement continues all the way to the end
            if onSets(end) > offSets(end)
                offSets = [offSets; length(movements)- 1];
            end
            %if mouse starts moving at beginning of recording
            if offSets(1) < onSets(1)
                onSets = [0; onSets];
            end
           
            beforeOnS = 5; %5 seconds before movement Onset
            timeAfterOffS = 2;
            
            stdeviation = 0.35;
            dt = 0.001;
            lo = 0;
            hi = data.end;
            binm = 1/dt;
            nbins = length(lo:dt:hi);
            delt = zeros(1,nbins);
            delt(round(binm*data.SPKC(data.SPKC< hi)) + 1) = 1;
            gauss = normpdf(-stdeviation*3:dt:stdeviation*3,0,stdeviation);
            sdf_full = conv(delt,gauss,'same');
            sdf = sdf_full(binm*stdeviation*3+1:end-binm*stdeviation*3);
            sdfTimes = (lo+stdeviation*3):dt:(hi-stdeviation*3);
            
            %check each onset/offset value to make sure time preceding movement
            %   is not a negative index
            offSets = offSets((onSets + 1 - beforeOnS*1000- (lo + stdeviation*3)*1000) > 0);
            onSets = onSets((onSets + 1 - beforeOnS*1000- (lo + stdeviation*3)*1000) > 0);
            
            %Make sure time before onSet is no movement
            toDelete = zeros(1,length(onSets));
            for i = 1: length(onSets)
                preIndex = onSets(i) + 1 - beforeOnS*1000;
                %delete if there is movement in the time before the movement
                %   onSet
                if sum(movements(preIndex:onSets(i) + 1)) > 1
                    toDelete(i) = 1;
                end
            end
            onSets = onSets(toDelete==0);
            offSets = offSets(toDelete == 0);
            if length(onSets) ~= 0
                totalSDF = zeros(length(onSets), beforeOnS*1000 + timeAfterOffS*1000 + 1);
                times = (-beforeOnS:0.001:timeAfterOffS);
                sdfTimes = (lo + stdeviation*3):dt:(hi-stdeviation*3);
                hold on
                for i = 1: length(onSets)
                    begin = onSets(i) + 1  - beforeOnS*1000 - (lo + stdeviation*3)*1000;
                    endIndex = onSets(i) + 1 + timeAfterOffS*1000 - (lo + stdeviation*3)*1000;
                    firstMoveT = allTimes(onSets(i) + 1 - beforeOnS*1000);
                    endMoveT = allTimes(onSets(i) + 1 + timeAfterOffS*1000);
                    totalSDF(i,:) = sdf(begin: endIndex);
                    movePhase = ['Time ' num2str(firstMoveT) ' to ' num2str(endMoveT) ];
                    plot(times, totalSDF(i,:),'DisplayName',movePhase)
                end
                yL = get(gca,'YLim');
                line([0 0], yL, 'Color', 'k');
                plot(times,mean(totalSDF,1), '-k','LineWidth', 2,'DisplayName', 'Average')
                hold off
                title([data.type ' Mvmt Avg SDF in ' data.fileName])
                xlabel('Time from movement Onset')
                ylabel('SDF value')
                lgd = legend('show');
            else
               plot(allTimes,movements)
               msg = ['There is movement in a phase before this onset in ' data.fileName{1}];
               warning(msg)            
            end
        end
    end
    result = 1;
end