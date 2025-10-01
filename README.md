# MATLAB Implementation of Independent Vector Analysis (IVA) for Audio Source Separation Compatible with Code Generation
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=WATARAI-Hiroko/ADMM-IVA) [![DOI](https://zenodo.org/badge/1050193071.svg)](https://doi.org/10.5281/zenodo.17068241) 
## About

Paper: "Fast and flexible algorithm for determined blind source separation based on alternating direction method of multipliers," Acoustical Science and Technology (2025).


This repository presents fast MATLAB implementations of independent vector analysis (IVA) for multichannel audio source separation. All the algorithms are compatible with code generation, i.e., they can be converted to C/C++ codes.

## Contents

This repository covers following algorithms:

* ADMM-IVA, FastADMM-IVA (proposed method) [1]
* PDS-IVA [2]
* AuxIVA-IP [3]
* AuxIVA-IP2 [4,5]
* AuxIVA-ISS [6]

It also provides sample codes: 
* `sample1_QuickStart.mlx` is a minimum code to run ADMM-IVA.
* `sample2_BuildMEX.mlx` explains procedures to generate C/C++ codes, build MEX files and run MEX-compiled algorithms. It also provides runtime benchmark reproducing Table 1 in our paper [1].
* `sample3_SeparationPerformanceEvaluation.mlx` reproduces the result in Section 5.2. in our paper [1].

## Requirements
* MATLAB R2025a
* MATLAB Toolbox
  * Audio Toolbox
  * MATLAB Coder
* C/C++ Compiler 
  * We recommend Microsoft Visual C++ 2022. 
  * See [R2025a Supported and Compatible Compilers](https://jp.mathworks.com/support/requirements/supported-compilers.html) for more detail.

## Quick Start

Add path to `"./IVA"` and all the subfolders (e.g., `"./IVA/run"`).
```MATLAB
addpath(genpath("./IVA"))
```
Create a two-channel mixture of two speech signals. 

For your first run, a pop-up window will ask whether to download the [dev1 dataset from SiSEC2011](http://sisec2011.wiki.irisa.fr/tiki-indexbfd7.html). 

Click "Yes" to continue.

```MATLAB
[signal1, signal2, fs] = util_loadSampleMixture;
mixture                = signal1 + signal2
```
Apply FastADMM-IVA [1] with default settings.
```MATLAB
separated = run_IVA_FastADMM(mixture)
```
Check the result.
```MATLAB
util_visualizeAndPlay(mixture,separated,fs);
```

## Implementation Details

For each method, there are four MATLAB code categories (`algo`, `run`, `runmex`, and `buildmex`) and one MEX file (`algomex`), which are indicated by their prefixes, as summarized in the following table.

| Prefix          | Role                                                         | Shape of signal                                              |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `run_IVA_`      | Calls `algo_IVA_.*` to separate sources. Internally performs preprocessing such as Short-Time Fourier Transform (STFT) and whitening, then executes `algo_IVA_.*`. Projection back and inverse STFT are applied to reconstruct the time-domain signal. | `T x N`                                                      |
| `runmex_IVA_`   | Calls `algomex_IVA_.*` to separate sources. Otherwise the same as `run_IVA_.*`. Requires `buildmex_IVA_.*` to be executed beforehand. | `T x N`                                                      |
| `algo_IVA_`     | Separates the mixture after spacial whitening via IVA. Supports MATLAB's `codegen`. | `N x T x F` for ADMM, PDS, IP, IP2, and `F x T x N` for ISS. |
| `algomex_IVA_`  | MEX compiled version of `algo_IVA_.*`.                       | `N x T x F` for ADMM, PDS, IP, IP2, and `F x T x N` for ISS. |
| `buildmex_IVA_` | Function to compile `algo_IVA_.*`. Input arguments are the same as those for `run_IVA_.*`. | `T x N`                                                      |

The default values of the name-value arguments for each algorithm are as follows.  

| Algorithm                   | `rho` | `mu1` | `mu2` | `alpha` | `lambda` | Note                                                         |
| --------------------------- | ----- | ----- | ----- | ------- | -------- | ------------------------------------------------------------ |
| `FastADMM`                  | 0.3   | ―     | ―     | 1.4     | 1        |                                                              |
| `ADMM`                      | 0.4   | ―     | ―     | 1.4     | 1        |                                                              |
| `PDS`                       | ―     | 1     | 1     | 1.7     | 1        |                                                              |
| `IP2`                       | ―     | ―     | ―     | ―       | ―        |                                                              |
| `ISS`                       | ―     | ―     | ―     | ―       | ―        | Slow on MATLAB, but accelerated via MEX compilation.         |
| `ISS_without_if_statements` | ―     | ―     | ―     | ―       | ―        | Computes ISS without if statements. This implementation is faster than `ISS` on MATLAB. |
| `IP`                        | ―     | ―     | ―     | ―       | ―        |                                                              |

The default settings for STFT is `windowLength = 2048` and `windowShift = 1024`.

## Reference
1. H. Watarai, K. Matsumoto, and K. Yatabe, "Fast and flexible algorithm for determined blind source separation based on alternating direction method of multipliers," Acoustical Science and Technology (under review) (2025).
2. K. Yatabe and D. Kitamura, "Determined BSS based on time-frequency masking and its application to harmonic vector analysis," IEEE/ACM Trans. Audio Speech Lang. Process., 29, 1609–1625 (2021).
3. N. Ono, "Stable and fast update rules for independent vector analysis based on auxiliary function technique," Proc. IEEE Workshop Appl. Signal Process. Audio Acoust. (WASPAA), pp. 189–192 (2011).
4. N. Ono, "Fast stereo independent vector analysis and its implementation on mobile phone," Proc. Int. Workshop Acoust. Signal Enhanc. (IWAENC), pp. 1–4 (2012).
5. T. Nakashima, R. Scheibler, Y. Wakabayashi and N. Ono, "Faster independent low-rank matrix analysis with pairwise updates of demixing vectors," Proc. Eur. Signal Process. Conf. (EUSIPCO), pp. 301–305 (2021).
6. R. Scheibler and N. Ono, "Fast and stable blind source separation with rank-1 updates," Proc. IEEE Int. Conf. Acoust. Speech Signal Process. (ICASSP), pp. 236–240 (2020).
