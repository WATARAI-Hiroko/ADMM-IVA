%#codegen
function Y = algo_IVA_FastADMM(X, numIter, rho, alpha, lambda)
%ALGO_IVA_FASTADMM Algorithm for IVA using FastADMM
%
%   Y = ALGO_IVA_FASTADMM(X, numIter, rho, alpha, lambda) performs independent vector 
%   analysis (IVA) on a mixture X in the time-frequency domain using the FastADMM algorithm.
%
% Syntax
%   Y = algo_IVA_FastADMM(X, numIter, rho, alpha, lambda)
%
% Inputs
%   X                 Mixture in the time-frequency domain, size N-by-T-by-F
%                     (N: channels/sources, T: time frames, F: frequency bins).
%   numIter           Number of iterations.
%   rho               ADMM step size (rho > 0).
%   alpha             ADMM relaxation parameter (0 < alpha < 2).
%   lambda            Regularization weight for the source model term.
%
% Output
%   Y                 Estimated sources in the time-frequency domain, size N-by-T-by-F.

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
%   Hiroko Watarai, Kazuki Matsumoto, Kohei Yatabe, "Fast and flexible algorithm
%   for determined blind source separation based on alternating direction 
%   method of multipliers" (2025).

Ytil    = X;
Y       = X;
u_y     = 0*Ytil;

for i = 1:numIter
    xi_y = alpha*prox_IVA(Y - u_y, lambda/rho) + (1-alpha)*Y;
    Y    = pagemtimes(prox_logDet(pagemtimes(xi_y + u_y,"none",X,"ctranspose"), 1/rho),X);
    u_y  = u_y + xi_y - Y;
end
end
