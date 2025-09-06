function y = runmex_IVA_AuxISS(x, opt)
%RUNMEX_IVA_AUXISS Run IVA using Auxiliary-function-based Iterative Source Steering (AuxISS, MEX version)
%
%   y = RUNMEX_IVA_AUXISS(x, opt) performs independent vector analysis (IVA)
%   on a time-domain mixture x using the AuxISS algorithm. This function
%   calls the MEX-compiled version of the algorithm. Before using this function,
%   call buildmex_IVA_AuxISS to compile the MEX file.
%
% Syntax
%   y = runmex_IVA_AuxISS(x)
%   y = runmex_IVA_AuxISS(x, Name, Value)
%
% Inputs
%   x                 Time-domain mixture, size T-by-N (T: samples, N: channels).
%
% Name-Value Arguments
%   'numIter'         Number of iterations. Default: 200
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
%   R. Scheibler and N. Ono, “Fast and stable blind source separation with rank-1 
%   updates,” Proc. IEEE Int. Conf. Acoust. Speech Signal Process. (ICASSP), 
%   pp. 236–240 (2020).

arguments
    x 
    opt.numIter      = 200; 
    opt.windowLength = 2048; 
    opt.windowShift  = 1024;
end

[STFT,iSTFT] = util_createSTFTOperator(opt.windowLength, opt.windowShift);
Xref = STFT(x);
X    = permute(proc_whitening(Xref),[3 2 1]);                
Y    = algomex_IVA_AuxISS(X,opt.numIter);
Y    = proc_projectionBack(permute(Y,[3 2 1]),Xref);   
y    = iSTFT(Y);
end