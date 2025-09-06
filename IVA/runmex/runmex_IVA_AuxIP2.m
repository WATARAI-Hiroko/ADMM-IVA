function y = runmex_IVA_AuxIP2(x, opt)
%RUNMEX_IVA_AUXIP2 Run IVA using AuxIP2 with pair-wise updates (MEX version)
%
%   y = RUNMEX_IVA_AUXIP2(x, opt) performs independent vector analysis (IVA)
%   on a time-domain mixture x using the AuxIP2 algorithm with pair-wise updates.
%   This function calls the MEX-compiled version of the algorithm. Before using
%   this function, call buildmex_IVA_AuxIP2 to compile the MEX file.
%
% Syntax
%   y = runmex_IVA_AuxIP2(x)
%   y = runmex_IVA_AuxIP2(x, Name, Value)
%
% Inputs
%   x                 Time-domain mixture, size T-by-N (T: samples, N: channels).
%
% Name-Value Arguments
%   'numIter'         Number of iterations. Default: 100
%   'windowLength'    STFT window length (samples). Default: 2048
%   'windowShift'     STFT hop size (samples). Default: 1024
%
% Output
%   y                 Estimated sources in the time domain, size T-by-N.

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

% References:
%   N. Ono, “Fast stereo independent vector analysis and its implementation 
%   on mobile phone,” Proc. Int. Workshop Acoust. Signal Enhanc. (IWAENC), 
%   pp. 1–4 (2012).
% 
%   T. Nakashima, R. Scheibler, Y. Wakabayashi and N. Ono, “Faster independent 
%   low-rank matrix analysis with pairwise updates of demixing vectors,” Proc. 
%   Eur. Signal Process. Conf. (EUSIPCO), pp. 301–305 (2021).

arguments
    x 
    opt.numIter      = 100; 
    opt.windowLength = 2048; 
    opt.windowShift  = 1024;
end

[STFT,iSTFT] = util_createSTFTOperator(opt.windowLength, opt.windowShift);
Xref = STFT(x);
X    = proc_whitening(Xref);                 
Y    = algomex_IVA_AuxIP2(X,opt.numIter); 
Y    = proc_projectionBack(Y,Xref);                  
y    = iSTFT(Y);
end