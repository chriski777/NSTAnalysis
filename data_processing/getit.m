function c=getit(c)
%getit : helper function that converts cells into smaller cells. Used mainl
%       for data processing in mapper.
if iscell(c)
    c = cellfun(@getit, c, 'UniformOutput', 0);
    c = cat(2,c{:});
else
    c = {c};
end
end