function buildmex_IVA_PDS(x, opt)
%BUILDMEX_IVA_PDS Build MEX file for IVA using Primal-Dual Splitting (PDS)
%
%   buildmex_IVA_PDS(x, opt) generates MEX file from MATLAB implementation of
%   the independent vector analysis (IVA) algorithm using Primal-Dual Splitting (PDS).
%
% Syntax
%   buildmex_IVA_PDS(x)
%   buildmex_IVA_PDS(x, Name, Value)
%
% Inputs
%   x                 Example time-domain mixture, size T-by-N
%                     (T: samples, N: channels).
%
% Name-Value Arguments
%   'numIter'         Number of iterations. Default: 200
%   'windowLength'    STFT window length (samples). Default: 2048
%   'windowShift'     STFT hop size (samples). Default: 1024
%   'mu1'             Primal step size parameter (mu1 > 0). Default: 1
%   'mu2'             Dual step size parameter (mu2 > 0). Default: 1
%   'alpha'           Relaxation parameter (0 < alpha < 2). Default: 1.7
%   'lambda'          Regularization weight for the source model term. Default: 1

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
%   K. Yatabe and D. Kitamura, “Determined BSS based on time-frequency masking 
%   and its application to harmonic vector analysis,” IEEE/ACM Trans. Audio Speech 
%   Lang. Process., 29, 1609–1625 (2021).

arguments
    x 
    opt.numIter      = 200; 
    opt.windowLength = 2048; 
    opt.windowShift  = 1024;
    opt.mu1          = 1;
    opt.mu2          = 1;
    opt.alpha        = 1.7
    opt.lambda       = 1;
end

[STFT,~] = util_createSTFTOperator(opt.windowLength, opt.windowShift);
Xref = STFT(x);                  
X    = proc_whitening(Xref);

thisPath     = mfilename("fullpath");
buildmexPath = fileparts(thisPath);           
IVAPath      = fileparts(buildmexPath);        
outPath      = fullfile(IVAPath, "algomex", "algomex_IVA_PDS");  
[~, ~, ~]    = mkdir(IVAPath,"algomex");


args = {coder.typeof(X), ...
        coder.typeof(opt.numIter), ...
        coder.typeof(opt.mu1), ...
        coder.typeof(opt.mu2), ...
        coder.typeof(opt.alpha), ...
        coder.typeof(opt.lambda)};

codegen("algo_IVA_PDS","-args",args,...
        "-O","disable:inline", ...
        "-o",outPath,...
        "-report");
end