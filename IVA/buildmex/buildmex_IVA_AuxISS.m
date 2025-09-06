function buildmex_IVA_AuxISS(x, opt)
%BUILDMEX_IVA_AUXISS Build MEX file for IVA using Auxiliary-function-based Iterative Source Steering (AuxISS)
%
%   buildmex_IVA_AuxISS(x, opt) generates MEX file from MATLAB implementation of
%   the independent vector analysis (IVA) algorithm using Auxiliary-function-based
%   Iterative Source Steering (AuxISS).
%
% Syntax
%   buildmex_IVA_AuxISS(x)
%   buildmex_IVA_AuxISS(x, Name, Value)
%
% Inputs
%   x                 Example time-domain mixture, size T-by-N
%                     (T: samples, N: channels).
%
% Name-Value Arguments
%   'numIter'         Number of iterations. Default: 200
%   'windowLength'    STFT window length (samples). Default: 2048
%   'windowShift'     STFT hop size (samples). Default: 1024

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

[STFT,~] = util_createSTFTOperator(opt.windowLength, opt.windowShift);
Xref = STFT(x);
X    = permute(proc_whitening(Xref),[3 2 1]);             

thisPath     = mfilename("fullpath");
buildmexPath = fileparts(thisPath);           
IVAPath      = fileparts(buildmexPath);        
outPath      = fullfile(IVAPath, "algomex", "algomex_IVA_AuxISS");  

args = {coder.typeof(X), ...
        coder.typeof(opt.numIter)};

codegen("algo_IVA_AuxISS","-args",args,...
        "-O","disable:inline", ...
        "-o",outPath,...
        "-report");

end