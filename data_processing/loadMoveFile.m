% updated 10/27/16 to get movement from straight, rather than circular,t
% racker
function [ times, vels_new, stop ] = loadMoveFile( file )
    load(file);
    vels_new = diffs(:,2);
end

