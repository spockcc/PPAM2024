This repository contains all software and data necessary to replicated every number, table and figure printed in the manuscript "The need for accuracy and smoothness in numerical simulations".
This manuscript has been submitted to the conference Parallel Processing and Applied Mathematics, PPAM-2024.
The authors are Carl Chrisian Kjelgaard Mikkelsen (spock@cs.umu.se) from Umeaa University, Sweden and Lorién López-Villellas (lorien.lopez@unizar.es) from University of Zaragoza, Spain.

The reader who wishes to replicate the experiments or examine the output in greater detail should clone the repository.

This is the structure of the repository</br>
. </br>
├── gromacs </br>
└── report</br>

If the reader does not wish to work with GROMACS, then the only relevant folder is "report"
We include the output from GROMACS in the form of MATLAB .mat files.
This is the structure of the folder "report"

.</br>
├── experiments</br>
├── fig</br>
├── makefile</br>
├── matlab</br>
├── readme.txt</br>
├── scripts</br>
└── src</br>

The folders "experiment" and "matlab" should be added to the user's MATLAB path.
Some of our MATLAB functions assume that the current folder is "matlab", so please run all functions from this folder to avoid errors.

The relevant MATLAB functions are rint_mwe1, rint_mwe2, maxrange_rk1, maxrange_rk2, plot_shells, gromacs_figures
They have been developed and tested on MATLAB 2020b. 

The MATLAB files are distributed under a CC-BY-SA licence. You are free to use them at your own risk.

To reproduce the GROMACS experiments conducted in the paper, start by downloading the GROMACS-v2021 submodule by executing the following commands:

```
git submodule init
git submodule update
```

To compile GROMACS following the approach employed in the paper, utilize the `install_double` script.

Ensure that all Python dependencies necessary for processing the execution results are installed by running:

```
pip install -r requirements.txt
```

Following the installation of dependencies, execute the experiments using the `run.sh` script. Subsequently, extract the relevant results using `process_results.py`.
