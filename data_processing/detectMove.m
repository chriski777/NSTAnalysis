function [ bin_hi, bin_lo ] = detectMove( times, mv, tol, len )
% Tim Whalen, 4 Oct 2016
% Given a time series of wheel velocities, returns binary vector where 1 is
% moving > 10 px/sec (bin_hi), and low frequency version (bin_lo) where
% short bursts of non-movement during movemenet are considered movement
% Inputs - times: vector of sampling times
%             mv: corresponding vector of movement at times
%            tol: what frac of sec must be mvmt to call whole thing mvmt? Try 0.2
%            len: min length of time of mvmt in seconds. Try 1.0
% See above for outputs (I only use bin_lo)

per = mean(diff(times)); % approx sampling period in sec
n4sec = ceil(len/per); % # indices to get 1.5 sec (worked better than 1sec)
bin_hi = abs(mv)>=3;
bin_lo = [bin_hi; zeros(n4sec*2,1)]; % pad with zeros to avoid index out of bounds
st = 1; % end of last bout of mvmt
while (true)
    m = st + find(bin_lo(st+1:end),1); % locate mvmt start
    if isempty(m) % if no more mvmt
        break % we're done here
    end

    if sum(bin_lo(m:m+n4sec))> n4sec*tol % is the next sec at least tol% moving?
        while (true) % until found period with little mvmt
            bin_lo(m:m+n4sec) = 1; % call all of this sec mvmt
            next = m+n4sec+ find(bin_lo(m+n4sec+1:end)==0,1); % find next not moving sample
            if next+n4sec > length(bin_lo)
                break
            end
            if sum(bin_lo(next:next+n4sec))> n4sec*tol/2 % if next second still has tol/2 % mvmt
                bin_lo(next) = 1;
            else
                bin_lo(next:next+n4sec) = 0;
                st = next+n4sec; % start looking for movement again at end of this bout + 1sec
                break % out of "in mvmt" while loop
            end
        end
    else
        bin_lo(m)=0;
        st = m;
    end
    try
        if next+n4sec > length(bin_lo) % 10/4/16 - solution to strange infinite loop
            break
        end
    catch
    end

end
bin_lo = bin_lo(1:length(bin_hi)); % remove pad

end

