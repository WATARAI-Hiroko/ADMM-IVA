function [x,s,fs] = util_reproduceExperiment1Mixture(mixingSystemIdx,sourcePairIdx)

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

arguments
    mixingSystemIdx {mustBeInRange(mixingSystemIdx,1,4 )} = 1
    sourcePairIdx   {mustBeInRange(sourcePairIdx  ,1,56)} = 1
end

sources   = audioDatastore("dev1").Files;
sources   = sources(contains(sources,"male4")&contains(sources,"src"));
angles    = [30 345;
             30 285;
             60 345;
             60 285];

pairs_idx = perms(1:8);
pairs_idx = pairs_idx(:,1:2);
pairs_idx = unique(pairs_idx, 'rows'); 
pairs     = string(sources(pairs_idx));

RIRdir    = "Impulse_response_Acoustic_Lab_Bar-Ilan_University_(Reverberation_0.160s)_3-3-3-8-3-3-3";
RIR1      = helper_loadRIR(angles(mixingSystemIdx,1), RIRdir);
RIR2      = helper_loadRIR(angles(mixingSystemIdx,2), RIRdir);

[s1, ~ ]  = audioread(pairs(sourcePairIdx,1));
[s2, fs]  = audioread(pairs(sourcePairIdx,2));

x1(:,1)   = conv(s1,RIR1(:,1),"full");
x1(:,2)   = conv(s1,RIR1(:,2),"full");
x2(:,1)   = conv(s2,RIR2(:,1),"full");
x2(:,2)   = conv(s2,RIR2(:,2),"full");
x         = x1 + x2;
s         = [x1(:,1), x2(:,2)];
end

function RIR16k = helper_loadRIR(angle, RIRdir)
RIR48k = load(fullfile(RIRdir, ...
             sprintf("Impulse_response_Acoustic_Lab_Bar-Ilan_University_" + ...
                     "(Reverberation_0.160s)_3-3-3-8-3-3-3_" + ...
                     "1m_%03d.mat",angle))).impulse_response;
RIR48k = RIR48k(:,4:5);
RIR16k = resample(RIR48k,16,48);
RIR16k = RIR16k(1:8000,:);
end