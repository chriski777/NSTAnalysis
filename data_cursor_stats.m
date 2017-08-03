function output_txt = data_cursor_stats(obj,event_obj)
    currAxes = get(get(event_obj, 'Target'), 'Parent');
    dataStats = getappdata(currAxes, 'dataStats');
    pos = get(event_obj, 'Position');
    xIndex = find(dataStats.x == pos(1));
    yIndex = find(dataStats.y == pos(2));
    zIndex = find(dataStats.z == pos(3));
    corrIndex = intersect(intersect(xIndex, yIndex), zIndex);
    numExt = length(fieldnames(dataStats)) - 5;
    extraTips = cell(1,numExt);
    for k = 1:numExt
        extension = ['ext', num2str(k)];
        currField = dataStats.(extension);
        extraTips{k} = [[extension ': '], num2str(currField{corrIndex})]
    end
    output_txt = [{
                  ['FileName: ', dataStats.fileName{corrIndex}],...
                  ['SPKC: ',  dataStats.SPKC{corrIndex}],...
                  ['X: ',num2str(pos(1),4)], ...
                  ['Y: ',num2str(pos(2),4)], ...
                  ['Z: ',num2str(pos(3),4)]
                  }, extraTips];
   
end