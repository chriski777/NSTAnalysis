function output = classISIHists(sepData,currType)
%Chris Ki, July 2017, Gittis Lab
%classISIHists: Produces ISI histograms that are grouped by classes
%(No Class, Regular, Irregular, and Bursty) Neurons

%
    titleSet = {'No class', 'Regular', 'Irregular', 'Burst'};
    keySet = [1,2,3,4];
    titleMap = containers.Map(keySet,titleSet);
    binLength = 0.005;
    figure
    for i = 1:4
        subplot(4,1,i);
        %Combine ISIs of one specific class into a single vector
        classCell = sepData{i};
        if ~isempty(classCell)
            ISIcols = getit(classCell(:,2));
            singVect= vertcat(ISIcols{:});
            ctrs = [0:binLength:1.0];
            histogram(singVect, ctrs);
            title([titleMap(i) ' with bin = ' num2str(binLength) 'ms'])
        end
    end
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,['\bf Class ISI Histograms for the ' currType ' condition' ],'HorizontalAlignment' ,'center','VerticalAlignment', 'top')
end