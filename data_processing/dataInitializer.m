function data = dataInitializer(type)
input = struct();
input.type = type;
switch lower(type)
    case 'naive'
        input.files = {
         %1
         'AW012517aAWsorttt.pl2';
         'AW012517bAWsorttt.pl2';
         'AW012517cAWsorttt.pl2';
         'AW012517dAWsorttt.pl2';
         'AW012517eAWsorttt.pl2';
         'AW012517fAWsorttt.pl2';
         'AW012517gAWsorttt.pl2';
         'AW012517hAWsorttt.pl2';
         'AW012517iAWsorttt.pl2';
         %2
         'AW033017_2aAWsorttt.pl2';
         'AW033017_2bAWsorttt.pl2';
         'AW033017_2cAWsorttt.pl2';
         'AW033017_2dAWsorttt.pl2';
         'AW033017_2fAWsorttt.pl2';
         'AW033017_2gAWsorttt.pl2';
         'AW033017_2hAWsorttt.pl2';
         'AW033017_2iAWsorttt.pl2';
         'AW033017_2jAWsorttt.pl2';
         %3
         'KM111315aAWsorttt-01.pl2';
         'KM111315bAWsorttt-01.pl2';
         'KM111315cAWsorttt-01.pl2';
         'KM111315dAWsorttt-01.pl2';
         'KM111315eAWsorttt-01.pl2';
         'KM111315fAWsorttt-01.pl2';
         'KM111315gAWsorttt-01.pl2';
         'KM111315hAWsorttt-01.pl2';
         'KM111315iAWsorttt-01.pl2';
         %4
         'AW033117aAWsorttt.pl2';
         'AW033117bAWsorttt.pl2';
         'AW033117cAWsorttt.pl2';
         'AW033117dAWsorttt.pl2';
         'AW033117eAWsorttt.pl2';
         'AW033117fAWsorttt.pl2';
         'AW033117gAWsorttt.pl2';
         'AW033117hAWsorttt.pl2';};
        input.animalcodes = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 ...
            2 2 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4];
        data = open_data(input);
    case 'acute'
        input.files = {
            %1
            'AW112015aAWsorttt-01.pl2';
            'AW112015bAWsorttt-01.pl2';
            'AW112015cAWsorttt-01.pl2';
            'AW112015dAWsorttt-01.pl2';
            'AW112015fAWsorttt-01.pl2';
            'AW112015gAWsorttt-01.pl2';
            'AW112015hAWsorttt-01.pl2';
            'AW112015iAWsorttt-01.pl2';
            'AW112015jAWsorttt-01.pl2';
            'AW112015kAWsorttt-01.pl2';
            'AW112015lAWsorttt-01.pl2';
            'AW112015mAWsorttt-01.pl2';
            'AW112015nAWsorttt-01.pl2';
            'AW112015oAWsorttt-01.pl2';
            'AW112015pAWsorttt-01.pl2';
            %2
            'KM011116aAWsorttt-01.pl2';
            'KM011116bAWsorttt-01.pl2';
            'KM011116cAWsorttt-01.pl2';
            'KM011116dAWsorttt-01.pl2';
            'KM011116eAWsorttt-01.pl2';
            'KM011116fAWsorttt-01.pl2';
            %3 
            'KM090815c_4.094AWsorttt-01.pl2';
            'KM090815d_4.151AWsorttt-01.pl2';
            'KM090815e_4.231AWsorttt-01.pl2';
            'KM090815f_3.181AWsorttt-01.pl2';
            'KM090815g_3.261AWsorttt-01.pl2';
            'KM090815h_3.341AWsorttt-01.pl2';
            'KM090815i_3.746AWsorttt-01.pl2';
            'KM090815j_3.822AWsorttt-01.pl2';
            'KM090815k_3.902AWsorttt-01.pl2';};
        input.animalcodes = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ...
            2 2 2 2 2 2 3 3 3 3 3 3 3 3 3];
        data = open_data(input);
end