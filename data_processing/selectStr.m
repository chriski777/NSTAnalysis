function output = selectStr(dataCell)
%Chris Ki, June 2017, Gittis Lab
%selectStr: Takes in a datacell and outputs the string up to the .pl2 extension
   extension = {'AWsorttt.pl2', 'AWsorttt-01.pl2', 'TWsort.pl2' };
   rmIndex = strfind(dataCell,extension{1}) - 1;
   if isempty(rmIndex)
       rmIndex = strfind(dataCell,extension{2}) -1;
   end
   if isempty(rmIndex)
       rmIndex = strfind(dataCell, extension{3}) -1;
   end   
   output = dataCell(1:rmIndex);
   
