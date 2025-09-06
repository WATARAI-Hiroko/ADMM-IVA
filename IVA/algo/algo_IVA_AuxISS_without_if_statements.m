%#codegen
function Yp = algo_IVA_AuxISS_without_if_statements(Xp, numIter)
%ALGO_IVA_AUXISS Algorithm for IVA using Auxiliary-function-based Iterative Source Steering (AuxISS)
%
%   Yp = ALGO_IVA_AUXISS(Xp, numIter) performs independent vector analysis (IVA)
%   on a mixture Xp in the time-frequency domain using the AuxISS algorithm.
%
% Syntax
%   Yp = algo_IVA_AuxISS(Xp, numIter)
%
% Inputs
%   Xp                Mixture in the time-frequency domain, size F-by-T-by-N
%                     (F: frequency bins, T: time frames, N: channels/sources).
%   numIter           Number of iterations.
%
% Output
%   Yp                Estimated sources in the time-frequency domain, size F-by-T-by-N.

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

[~,~,N] = size(Xp);
Yp      = Xp;

for iter = 1:numIter
    R = sqrt(sum(max(abs(Yp).^2, eps), 1));

    for kk = 1:N
        YY = Yp .* conj(Yp(:,:,kk));

        d         = sum(real(YY(:,:,kk))./R, 2);
        u         = sum(YY./R, 2) ;
        v         = u ./ d;
        v(:,1,kk) = 1 - 1./sqrt(d(:,:,kk));

        Yp = Yp - v.*Yp(:,:,kk);
    end
    
end

end