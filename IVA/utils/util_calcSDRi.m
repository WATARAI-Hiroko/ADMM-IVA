function SDRi = util_calcSDRi(s,x,y)

% Copyright 2025 Hiroko Watarai, Kazuki Matsumoto, Kohei Yatabe.
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the "Software"), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

    [separated,source] = util_alignData(y,s);
    SDR_separated      = bss_eval_sources(separated',source');

    [mixture,source]   = util_alignData(x,s);
    SDR_mixture        = bss_eval_sources(mixture',source');

    SDRi = mean(SDR_separated) - mean(SDR_mixture);
end

function [aligned1,aligned2] = util_alignData(data1,data2)

data1 = correctPermutation(data1,data2);

aligned1 = zeros(size(data1));
aligned2 = zeros(size(data2));
for n = 1:size(data1,2)
    [tmp1,tmp2] = aligning(data1(:,n),data2(:,n));
    aligned1 = substituteTmp2Aligned(aligned1,tmp1,n);
    aligned2 = substituteTmp2Aligned(aligned2,tmp2,n);
end
aligned1 = aligned1(1:minLen(aligned1,aligned2),:);
aligned2 = aligned2(1:minLen(aligned1,aligned2),:);
end

function data1 = correctPermutation(data1,data2)
% permutations
p = perms(1:size(data1,2));

% calc xcorr for each pemutation
coeff = zeros(size(p,1),1);
for i = 1:size(p,1)
    c = 0;
    for m = 1:size(data2,2)
        c = c + max(abs(xcorr(data1(:,p(i,m)),data2(:,m))));
    end
    coeff(i) = c;
end

% find permutation with maximam xcorr
[~,maxIdx] = max(coeff);

% permute
data1 = data1(:,p(maxIdx,:));
end

function [aligned1,aligned2] = aligning(data1,data2)
[coeff,lag] = xcorr(data1,data2);
[~,maxIdx] = max(abs(coeff));
maxLag = lag(maxIdx);

if maxLag > 0
    aligned1 = data1(maxLag+1:end);
    aligned2 = data2(1:minLen(aligned1,data2));
else
    aligned2 = data2(-maxLag+1:end);
    aligned1 = data1(1:minLen(data1,aligned2));
end
end

function aligned = substituteTmp2Aligned(aligned,tmp,n)
aligned = aligned(1:minLen(aligned,tmp),:);
aligned(:,n) = tmp(1:size(aligned,1));
end

function ml = minLen(x,y)
ml = min(length(x),length(y));
end