%#codegen
function Y = algo_IVA_PDS(X, numIter, mu1, mu2, alpha, lambda)
%ALGO_IVA_PDS Algorithm for IVA using Primal-Dual Splitting (PDS)
%
%   Y = ALGO_IVA_PDS(X, numIter, mu1, mu2, alpha, lambda) performs independent vector 
%   analysis (IVA) on a mixture X in the time-frequency domain using the PDS algorithm.
%
% Syntax
%   Y = algo_IVA_PDS(X, numIter, mu1, mu2, alpha, lambda)
%
% Inputs
%   X                 Mixture in the time-frequency domain, size N-by-T-by-F
%                     (N: channels/sources, T: time frames, F: frequency bins).
%   numIter           Number of iterations.
%   mu1               Primal step size (mu1 > 0).
%   mu2               Dual step size (mu2 > 0).
%   alpha             Relaxation parameter (0 < alpha < 2).
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
%   K. Yatabe and D. Kitamura, “Determined BSS based on time-frequency masking 
%   and its application to harmonic vector analysis,” IEEE/ACM Trans. Audio Speech 
%   Lang. Process., 29, 1609–1625 (2021).

[N,~,F] = size(X);
E       = eye(N);
W       = complex(repmat(E,[1,1,F]));
xi      = 0*X;

for i = 1:numIter
    Wold  = W;
    xiOld = xi;
    W     = prox_logDet(W - mu1*mu2*pagemtimes(xi,"none",X,"ctranspose"), mu1);
    z     = xi + pagemtimes(2*W - Wold,X);
    xi    = z  - prox_IVA(z,lambda/mu2);
    xi    = alpha*xi + (1-alpha)*xiOld;
    W     = alpha*W  + (1-alpha)*Wold;
end
Y    = pagemtimes(W,X);
end