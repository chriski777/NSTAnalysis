function data = dataInitializer(type)
%Chris Ki, June 2017, Gittis Lab
%dataInitializer: Function that preprocesses data before it is sent into
%   mapper and function scripts

%Input Parameter
%   type: A character vector that contains what type of Cell you would like
%       to examine

%Output Parameter
%   data: data structure that contains output of open_data for specific
%   cell types

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
         'AW033117hAWsorttt.pl2';
         
         %5
         'AW051017bAWsorttt.pl2';
         'AW051017cAWsorttt.pl2';
         'AW051017dAWsorttt.pl2';
         'AW051017eAWsorttt.pl2';
         'AW051017fAWsorttt.pl2';
         'AW051017gAWsorttt.pl2';
         'AW051017hAWsorttt.pl2';
         'AW051017iAWsorttt.pl2';
         };
        input.animalcodes = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 ...
            2 2 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5];
        data = open_data(input);
    case 'acute'
        input.files = {
            %1
            'AW112015cAWsorttt-01.pl2';
            'AW112015dAWsorttt-01.pl2';
            'AW112015iAWsorttt-01.pl2';
            'AW112015jAWsorttt-01.pl2';
            'AW112015kAWsorttt-01.pl2';
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
            'KM090815cAWsorttt-01.pl2';
            'KM090815dAWsorttt-01.pl2';
            'KM090815eAWsorttt-01.pl2'; };

        input.animalcodes = [1 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 ];
        data = open_data(input);
    case 'unilateral intact'
        input.files = {
            %1
            'AW030717dAWsorttt.pl2';
            'AW030717eAWsorttt.pl2';
            'AW030717fAWsorttt.pl2';
            'AW030717gAWsorttt.pl2';
            'AW030717hAWsorttt.pl2';
            %2
            'AW081916uAWsorttt.pl2';
            'AW081916vAWsorttt.pl2';
            'AW081916wAWsorttt.pl2';
            'AW081916xAWsorttt.pl2';
            'AW081916yAWsorttt.pl2';
            'AW081916zAWsorttt.pl2';
            %3
            'AW120716dAWsorttt.pl2';
            'AW120716eAWsorttt.pl2';
            'AW120716fAWsorttt.pl2';
            'AW120716gAWsorttt.pl2';
            'AW120716hAWsorttt.pl2';
            %4
            'KM081716oAWsorttt.pl2';
            'KM081716pAWsorttt.pl2';
            };
        input.animalcodes = [1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 4 4];
        data = open_data(input);
    case 'gradual'
        input.files = {
            %1
            'AW010716bAWsorttt-01.pl2';
            'AW010716cAWsorttt-01.pl2';
            'AW010716dAWsorttt-01.pl2';
            'AW010716eAWsorttt-01.pl2';
            'AW010716fAWsorttt-01.pl2';
            'AW010716gAWsorttt-01.pl2';
            'AW010716hAWsorttt-01.pl2';
            %2
            'AW112515dAWsorttt-01.pl2';
            'AW112515eAWsorttt-01.pl2';
            'AW112515gAWsorttt-01.pl2';
            'AW112515hAWsorttt-01.pl2';
            'AW112515iAWsorttt-01.pl2';
            'AW112515jAWsorttt-01.pl2';
            'AW112515kAWsorttt-01.pl2';
            'AW112515mAWsorttt-01.pl2';
            };
        input.animalcodes = [1 1 1 1 1 1 1 2 2 2 2 2 2 2 2];
        data = open_data(input);
    case 'unilateral depleted'
        input.files = {
            %1
            'AW030817dAWsorttt.pl2';
            'AW030817eAWsorttt.pl2';
            'AW030817fAWsorttt.pl2';
            'AW030817gAWsorttt.pl2';
            'AW030817hAWsorttt.pl2';
            'AW030817iAWsorttt.pl2';
            'AW030817jAWsorttt.pl2';
            
            %2
            'AW081216bAWsorttt.pl2';
            'AW081216cAWsorttt.pl2';
            'AW081216dAWsorttt.pl2';
            'AW081216eAWsorttt.pl2';
            
            %3
            'AW081916hAWsorttt.pl2';
            'AW081916iAWsorttt.pl2';
            'AW081916jAWsorttt.pl2';
            'AW081916kAWsorttt.pl2';
            'AW081916lAWsorttt.pl2';
            'AW081916mAWsorttt.pl2';
            
            %4 
            'AW120816fAWsorttt.pl2';
            'AW120816gAWsorttt.pl2';
            'AW120816hAWsorttt.pl2';
            
            %5
            'KM081716cAWsorttt.pl2';
            'KM081716dAWsorttt.pl2';
            'KM081716eAWsorttt.pl2';
            'KM081716fAWsorttt.pl2';
            'KM081716gAWsorttt.pl2';
            'KM081716iAWsorttt.pl2';
            'KM081716jAWsorttt.pl2';
            
            %6
            'AW042417bAWsorttt.pl2';
            'AW042417cAWsorttt.pl2';
            'AW042417dAWsorttt.pl2';
            'AW042417eAWsorttt.pl2';
            'AW042417fAWsorttt.pl2';
            'AW042417gAWsorttt.pl2';
            'AW042417hAWsorttt.pl2';
            'AW042417iAWsorttt.pl2';
            };  
        input.animalcodes = [1 1 1 1 1 1 1 2 2 2 2 3 3 3 3 3 3 4 4 4 ...
            5 5 5 5 5 5 5 6 6 6 6 6 6 6 6];
        data = open_data(input);
    case 'gradual 35%'
        input.files = {
            %1
            'AW012916eAWsorttt.pl2';
            'AW012916fAWsorttt.pl2';
            'AW012916gAWsorttt.pl2';
            'AW012916hAWsorttt.pl2';
            
            %2
            'AW120115bAWsorttt-01.pl2';
            'AW120115cAWsorttt-01.pl2';
            'AW120115dAWsorttt-01.pl2';
            'AW120115eAWsorttt-01.pl2';
            'AW120115fAWsorttt-01.pl2';
            'AW120115hAWsorttt.pl2';
            'AW120115iAWsorttt.pl2';
            'AW120115jAWsorttt.pl2';
            'AW120115kAWsorttt.pl2';
            'AW120115lAWsorttt.pl2';
            };
        input.animalcodes = [1 1 1 1 2 2 2 2 2 2 2 2 2 2];
        data = open_data(input);
    case 'gradual 65%'     
        input.files = {
            %1
            'AW081116aAWsorttt.pl2';
            'AW081116bAWsorttt.pl2';
            'AW081116cAWsorttt.pl2';
            'AW081116dAWsorttt.pl2';
            'AW081116eAWsorttt.pl2';
            'AW081116jAWsorttt.pl2';
            'AW081116kAWsorttt.pl2';
            'AW081116lAWsorttt.pl2';
            'AW081116mAWsorttt.pl2';
            'AW081116nAWsorttt.pl2';
            'AW081116oAWsorttt.pl2';
            %2
            'AW092216aAWsorttt.pl2';
            'AW092216bAWsorttt.pl2';
            'AW092216cAWsorttt.pl2';
            'AW092216fAWsorttt.pl2';
            'AW092216gAWsorttt.pl2';
            'AW092216hAWsorttt.pl2';
            'AW092216iAWsorttt.pl2';
            'AW092216jAWsorttt.pl2';
            'AW092216kAWsorttt.pl2';
            'AW092216lAWsorttt.pl2';

            };
        input.animalcodes = [1 1 1 1 1 1 1 1 1 1 1 ...
            2 2 2 2 2 2 2 2 2 2];
        data = open_data(input);
    case 'alpha-syn'
        input.files = {
            %1
            'AW062816aAWsorttt.pl2';
            'AW062816bAWsorttt.pl2';
            'AW062816cAWsorttt.pl2';
            'AW062816dAWsorttt.pl2';
            'AW062816eAWsorttt.pl2';
            'AW062816fAWsorttt.pl2';
            'AW062816gAWsorttt.pl2';
            'AW062816hAWsorttt.pl2';
            'AW062816iAWsorttt.pl2';
            
            %2
            'AW121516aAWsorttt.pl2';
            'AW121516bAWsorttt.pl2';
            'AW121516cAWsorttt.pl2';
            'AW121516dAWsorttt.pl2';
            'AW121516eAWsorttt.pl2';
            'AW121516fAWsorttt.pl2';
            'AW121516gAWsorttt.pl2';
            'AW121516hAWsorttt.pl2';
            'AW121516rAWsorttt.pl2';
            'AW121516sAWsorttt.pl2';
            'AW121516tAWsorttt.pl2';
            'AW121516uAWsorttt.pl2';
            'AW121516vAWsorttt.pl2';
           'AW121516wAWsorttt.pl2';
           'AW121516xAWsorttt.pl2';
           'AW121516yAWsorttt.pl2';
           'AW121516zAWsorttt.pl2';
            %3
            'AW122216aaAWsorttt.pl2';
            'AW122216cAWsorttt.pl2';
            'AW122216dAWsorttt.pl2';
            'AW122216eAWsorttt.pl2';
            'AW122216fAWsorttt.pl2';
            'AW122216gAWsorttt.pl2';
            'AW122216hAWsorttt.pl2';
            'AW122216iAWsorttt.pl2';
            'AW122216jAWsorttt.pl2';
            'AW122216uAWsorttt.pl2';
            'AW122216vAWsorttt.pl2';
            'AW122216wAWsorttt.pl2';
            'AW122216xAWsorttt.pl2';
            'AW122216yAWsorttt.pl2';
            'AW122216zAWsorttt.pl2';
            
            %4
            'AW070616aAWsorttt.pl2';
            'AW070616cAWsorttt.pl2';
            'AW070616eAWsorttt.pl2';
            'AW070616fAWsorttt.pl2';
            'AW070616gAWsorttt.pl2';
            'AW070616hAWsorttt.pl2';
            'AW070616kAWsorttt.pl2';
            'AW070616lAWsorttt.pl2';
            'AW070616mAWsorttt.pl2';
            'AW070616nAWsorttt.pl2';
            'AW070616oAWsorttt.pl2';
            
            };
        input.animalcodes = [1 1 1 1 1 1 1 1 1 ...
             2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ...
             3 3 3 3 3 3 3 3 3 3 3 3 3 3 3  ...
             4 4 4 4 4 4 4 4 4 4 4];
        data = open_data(input);
    case 'test'
        input.files = {
            'TW062417eTWsort.pl2';
            'TW041517eTWsort.pl2'
        };
        input.animalcodes =[ 1 2];
        data = open_data(input);
end