function [STFT, iSTFT] = util_createSTFTOperator(windowLength, windowShift)
%UTIL_CREATESTFTOPERATOR Create STFT / iSTFT function handles
%
%   [STFT, iSTFT] = UTIL_CREATESTFTOPERATOR(windowLength, windowShift) returns
%   two function handles, STFT and iSTFT, implemented using DGTtool with a
%   Hann window. The STFT implementation performs zero-padding.
%
% Syntax
%   [STFT, iSTFT] = util_createSTFTOperator(windowLength, windowShift)
%
% Inputs
%   windowLength     STFT window length (samples).
%   windowShift      STFT hop size (samples).
%
% Outputs
%   STFT             Function handle: X = STFT(x), where x is T-by-N (time by channels)
%                    and X is N-by-T-by-F (channels by time frames by frequency bins).
%   iSTFT            Function handle: x = iSTFT(X), inverse transform compatible with STFT.

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

F     = DGTtool("windowLength", windowLength, ...
                "windowShift", windowShift, ...
                "windowName", "hann");
STFT  = @(x)STFTfcn(x,F,windowLength);
iSTFT = @(x)iSTFTfcn(x,F,windowLength);

end

function x = STFTfcn(x,F,windowLength)
z = zeros(windowLength, size(x,2));
x = permute(F([z;x;z]),[3 2 1]);
end

function x = iSTFTfcn(x,F,windowLength)
x = F.pinv(ipermute(x,[3 2 1]));
x(1:windowLength,:) = [];
end