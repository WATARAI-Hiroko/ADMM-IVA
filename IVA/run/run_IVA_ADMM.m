function y = run_IVA_ADMM(x, opt)
%RUN_IVA_ADMM Run IVA using basic ADMM
%
%   y = RUN_IVA_ADMM(x, opt) performs independent vector analysis (IVA)
%   on a time-domain mixture x using the ADMM algorithm.
%
% Syntax
%   y = run_IVA_ADMM(x)
%   y = run_IVA_ADMM(x, Name, Value)
%
% Inputs
%   x                 Time-domain mixture, size T-by-N (T: samples, N: channels).
%
% Name-Value Argument
%   'numIter'         Number of iterations. Default: 200
%   'windowLength'    STFT window length (samples). Default: 2048
%   'windowShift'     STFT hop size (samples). Default: 1024
%   'rho'             ADMM step size (rho > 0). Default: 0.4
%   'alpha'           ADMM relaxation parameter (0 < alpha < 2). Default: 1.4
%   'lambda'          Regularization weight for the source model term. Default: 1
%
% Output
%   y                 Estimated sources in the time domain, size T-by-N.

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
%   Hiroko Watarai, Kazuki Matsumoto, Kohei Yatabe, "Fast and flexible algorithm
%   for determined blind source separation based on alternating direction 
%   method of multipliers", 47(1), pp. XX–XX (2026).

arguments
    x 
    opt.numIter      = 200; 
    opt.windowLength = 2048; 
    opt.windowShift  = 1024;
    opt.rho          = 0.4;
    opt.alpha        = 1.4;
    opt.lambda       = 1;
end

[STFT,iSTFT] = util_createSTFTOperator(opt.windowLength, opt.windowShift);
Xref = STFT(x);
X    = proc_whitening(Xref);                                 
Y    = algo_IVA_ADMM(X,opt.numIter,opt.rho,opt.alpha,opt.lambda);  
Y    = proc_projectionBack(Y,Xref);                        
y    = iSTFT(Y);
end