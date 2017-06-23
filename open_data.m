function [data] = open_data(input)
%% Tim Whalen, June 2017 , Gittis Lab
% Struct-based loading of pl2 in vivo data
%% HOW TO USE
% This function loads a set of specified .pl2 files and associated movement
% tracking .mat files and generates a "data" struct which contains all
% relevant spiking, LFP, opto stim and movement data.

% This function takes no inputs - instead, see below how to edit a few
% variables to load the desired data

% All analysis functions should take "data" as their sole input and output
% a data struct which contains additional fields for the output. No 
% function should overwrite fields in the original data struct - it should
% only produce new fields.
% A polished function should detail which fields must be present in your
% data struct to run correctly.

%% To load data, you MUST SPECIFY:
% files - cell array of filenames (make sure files are in your path
%         Associated movement files are assumed to be [first nine
%         characters of the pl2 files].mat (eg. 'KM01012017a.mat')
% animalcodes - code for each file representing animal recorded from
% multilight - 0 if one light or no stim, 1 if multiple light sources
%% You also MIGHT WANT TO SPECIFY
% data.depleted - code for each file; % 0 = naive, 1 = acute bi, 2 = acute uni, 3 = gradual
% data.dpd - days post depletion

%% Modifications Chris made
%  Added input parameter which specifies input.files and input.animalCodes
%  Also added input.type field for easier processing of data. 
%  Mapper.m makes use of these new fields

files = input.files;
animalcodes = input.animalcodes;
multilight = 0; % 1 if multiple light sources, e.g. switched color during file
%% Loading process starts here - edit beyond this point with caution!
% Adding new fields to data should be okay. Editing existing fields may
% make code unstable.

data = struct();
data.type = input.type;
data.files = files;
data.files_trunc = cellfun(@(x) x(1:9),files,'UniformOutput',0);
data.nfiles = length(files);
data.animalcodes = animalcodes;
data.LFP_FS = 1000; % LFP samp freq
data.SPK_FS = 40000;
data.prepost_T = 120; % secs of time to examine pre and post stim
data.prepost_latency = 1; % secs between window start/stop to stimulus

data.info_time = 'All times (ts, T, lighton, prelight, movet, etc.) in sec.';
data.info_index = 'All non-constant fields ae indexed by file number. For data concatenated across files, see data.byunit';
data.byunit = struct();
data.byunit.info_index = 'Spiking data concatenated across all files. Index by unit number';

data.islight = zeros(data.nfiles,1)-1;
data.pre_short = zeros(data.nfiles,1); % stim started too soon after recording
data.post_short = zeros(data.nfiles,1); % recording ended too soon after stim
data.T = zeros(data.nfiles,1);
data.ts = cell(data.nfiles,1);
data.ts_pre = cell(data.nfiles,1);
data.ts_post = cell(data.nfiles,1);
data.rates = cell(data.nfiles,1);
data.rates_pre = cell(data.nfiles,1);
data.rates_post = cell(data.nfiles,1);
data.wf = cell(data.nfiles,1);
data.wf_std = cell(data.nfiles,1);
data.lfp = cell(data.nfiles,1);
data.lighton = cell(data.nfiles,1);
data.lightoff = cell(data.nfiles,1);
if multilight
    data.lighton2 = cell(data.nfiles,1); % for multilight
    data.lightoff2 = cell(data.nfiles,1);
end
data.prelight = cell(data.nfiles,1);
data.postlight = cell(data.nfiles,1);
data.spkchans = cell(data.nfiles,1); % channel on which each unit was recorded
data.lfpchans = cell(data.nfiles,1);
data.movet_raw = cell(data.nfiles,1);
data.movey_raw = cell(data.nfiles,1);
data.movet_rs = cell(data.nfiles,1); % raw = original sampling, rs = resampled to match LFP
data.moving_rs = cell(data.nfiles,1); % movey = amplitude, moving = binary moving or not

for f = 1:data.nfiles
    filename = files{f}
    filename_trunc = data.files_trunc{f}; % to gert associated mvmt file
    pl2 = PL2GetFileIndex(filename);
    nsc = size(pl2.SpikeChannels,1); % #spike channels
    Tsecs = pl2.DurationOfRecordingTicks/40000; % total time of recording
    data.T(f) = Tsecs;
    
%     longs = []; % must reset in case ons and offs are different sizes
    
    %% Get spikes
    ts = cell(1,1); % will change size
    wavem = zeros(32,1);
    wavestd = zeros(32,1);
    
    nu = 0; % running count of units - INCLUDES BAD UNITS FROM XLS
    chans = []; % channel for each unit
    chanNumbers = [];
    for c = 1:nsc
        chan = pl2.SpikeChannels{c};
        chanNum = chan.Channel; % order is not necessarily numerical as in xls
        us = find(chan.UnitCounts); % possible units
        us = us(us>=3);
        chans = [chans c*ones(1,length(us))];
        chanNumbers = [chanNumbers chanNum*ones(1,length(us))];
        for q = 1:length(us)
            u = us(q);
            nu = nu+1;
            % switch to importing waveforms and ts simultaneously
            w = PL2Waves(filename,c,u-1);
            ts{nu,1} = w.Ts;
            wavem(:,nu) = mean(w.Waves);
            wavestd(:,nu) = std(w.Waves);
        end
    end
%     [~, sortOrder] = sort(chanNumbers);
%     ts = ts(sortOrder);
%     
%     ts = ts(logical(goodunit{f})); % remove units manually tagged as bad in xls
%     goodchans = chans(logical(goodunit{f}));
%     data.spkchans{f} = goodchans;
    data.ts{f} = ts;
    data.wf{f} = wavem;
    data.wf_std{f} = wavestd;
    
    rates = cellfun(@(x) length(x), ts)/Tsecs;
    data.rates{f} = rates;
    data.spkchans{f} = chans;
    
    %% Get light times
    if ~multilight
        if exist('lightin','var') % if channel is known
            lightswitch = (lightin-2)*4;
        else
            lightswitch = 0;
        end
        on = PL2EventTs(filename,32+lightswitch); % event channel 24
        if isempty(on.Ts)
            disp('Disregard channel 32 error (but do not disregard an error after this message)')
            on = PL2EventTs(filename,28);
            ons = on.Ts;
            off = PL2EventTs(filename,26);
            offs = off.Ts;
        else
            ons = on.Ts;
            off = PL2EventTs(filename,30+lightswitch);
            offs = off.Ts;
        end
        ons = floor(ons*1000)/1000;
        offs = floor(offs*1000)/1000;
        if isempty(ons)
            %    disp('No light stim - using start and end of file')
            ons = data.prepost_T+5;
            offs = Tsecs-(data.prepost_T+5);
            allstop = Tsecs-5;
            data.islight(f) = 0;
        else
            data.islight(f) = 1;
            allstop = ons(1)-5; % if looking at all file, only consider before light turns on
        end
        pre = floor([ons(1)-data.prepost_T-data.prepost_latency ons(1)-data.prepost_latency]);
        post = ceil([offs(end)+data.prepost_latency offs(end)+data.prepost_T+data.prepost_latency]);
        if pre(1) < 0
            data.pre_short(f) = 1;
            pre(1) = 0;
        end
    else
        on2 = PL2EventTs(filename,32);
        on = PL2EventTs(filename,28);
        off2 = PL2EventTs(filename,30);
        off = PL2EventTs(filename,26);
        try
            ons = on.Ts;
        catch
            ons = [];
        end
        try
            ons2 = on2.Ts;
        catch
            ons2 = [];
        end
        try
            offs = off.Ts;
        catch
            offs = [];
        end
        try
            offs2 = off2.Ts;
        catch
            offs2 = [];
        end
        ons = floor(ons*1000)/1000;
        offs = floor(offs*1000)/1000;
        ons2 = floor(ons2*1000)/1000;
        offs2 = floor(offs2*1000)/1000;
        if (isempty(ons) && isempty(ons2))
            %    disp('No light stim - using start and end of file')
            allstop = Tsecs-5;
            data.islight(f) = 0;
        else
            data.islight(f) = 1;
            allstop = min([ons;ons2])-5; % if looking at all file, only consider before light turns on
        end
        pre = floor([min([ons;ons2])-data.prepost_T-data.prepost_latency min([ons;ons2])-data.prepost_latency]);
        post = ceil([max([offs;offs2])+data.prepost_latency max([offs;offs2])+data.prepost_T+data.prepost_latency]);
        if pre(1) < 0
            data.pre_short(f) = 1;
            pre(1) = 0;
        end
        data.lighton2{f} = ons2;
        data.lightoff2{f} = offs2;
    end
    
    data.lighton{f} = ons;
    data.lightoff{f} = offs;
    data.prelight{f} = pre;

    %% Get movement
    ev = PL2EventTs(filename,1);
    movestart = ev.Ts; % should be one value
    if isempty(movestart) % if no event dropped
        movestart = 0;
    end
    try
        % movex = time of each mvmt smapling, movey = velocity at time,
        % movedur = length of mvmt recording
        mvtol = 0.5; % frac of mvmt bout which must be moving to consider mvmt
        mvlen = 1.5; % minimum length to consider movement (sec)
        [movet,movey] = loadMoveFile(filename_trunc); % loads associated movement file
        disp('loaded')
        movet = movet-movet(1)+movestart;
        movet = movet(movet<=Tsecs);
        movey = movey(1:length(movet));
        [~, moving] = detectMove(movet,movey,mvtol,mvlen);
        [movexrs, moveyrs] = resampleMove(movet,moving,1000);
        
        data.movet_raw{f} = movet;
        data.movey_raw{f} = movey;
        data.movet_rs{f} = movexrs;
        data.moving_rs{f} = moveyrs;
   catch
        disp(['No movement file for ' filename_trunc])
   end
    
    %% Get LFPs
    % If want LFP's pre, post and dur, check this 9and light section) in
    % "open_all_beta"
    nac = size(pl2.AnalogChannels,1);
    fpchans = [];
    for a = 1:nac % run through once to pre-allocate
        if sum(pl2.AnalogChannels{a}.Name(1:2)=='FP')==2
            fpchans = [fpchans a];
            fplen = pl2.AnalogChannels{a}.NumValues; % assumes all FP channels have same length
        end
    end
    nfp = length(fpchans);
    fps = zeros(fplen,nfp); % LFP's

    for i = 1:length(fpchans)
        ad = PL2Ad(filename,fpchans(i));
        try % sometimes marked as recording but no data
            fps(:,i) = ad.Values;
        catch
            disp(['note LFP missing channel ' int2str(fpchans(i))]);
        end
    end
    data.lfp{f} = fps;
    data.lfpchans{f} = fpchans;
    
    end_fp = size(fps,1)/1000;
    if post(end) > end_fp
        data.post_short(f) = 1;
        post(2) = floor(end_fp);
    end
    
    %% Other pre, post thingas after post LFP correction
    data.postlight{f} = post;
    
    ts_pre = cell(size(ts));
    ts_post = ts_pre;
    
    for u = 1:length(ts)
        ts_pre{u} = ts{u}(ts{u}>pre(1) & ts{u}<pre(2))-pre(1);
        ts_post{u} = ts{u}(ts{u}>post(1) & ts{u}<post(2))-post(1);
    end
    data.ts_pre{f} = ts_pre;
    data.ts_post{f} = ts_post;
    rates_pre = cellfun(@(x) length(x), ts_pre)/(pre(2)-pre(1));
    data.rates_pre{f} = rates_pre;
    rates_post = cellfun(@(x) length(x), ts_post)/(post(2)-post(1));
    data.rates_post{f} = rates_post;
end

data.byunit.animalcodes = zeros(0,1);
for f = 1:data.nfiles
    code = animalcodes(f);
    data.byunit.animalcodes = [data.byunit.animalcodes; code*ones(size(data.ts{f},1),1)];
end
    
data.byunit.rates_pre = cell2mat(data.rates_pre);
data.byunit.rates_post = cell2mat(data.rates_post);
data.byunit.ratess = cell2mat(data.rates);
