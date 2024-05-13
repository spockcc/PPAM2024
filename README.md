This repository contains all software and data necessary to replicated every number, table and figure printed in the manuscript "The need for accuracy and smoothness in numerical simulations".
This manuscript has been submitted to the conference Parallel Processing and Applied Mathematics, PPAM-2024.
The authors are Carl Chrisian Kjelgaard Mikkelsen (spock@cs.umu.se) from Umeaa University, Sweden and Lorien Lopez-Villellas (lorien.lopez@bsc.se) from Barcelona Supercomputing Center, Spain.

The reader should clone the repository. 

This is the structure of the repository
.
├── gromacs-2021 </br>
├── gromacs_install_double.sh
├── gromacs_process_results.py
├── gromacs_run.sh
├── lysozyme
├── report
└── requirements.txt

If the reader does not wish to work with GROMACS, then the only relevant folder is "report"
We include the output from GROMACS in the form of MATLAB .mat files.
This is the structure of the folder "report"

.
├── experiments
├── fig
├── makefile
├── matlab
├── readme.txt
├── scripts
└── src

The folders "experiment" and "matlab" should be added to the user's MATLAB path.
Some of our MATLAB functions assume that the current folder is "matlab", so please run all functions from this folder to avoid errors.

The relevant MATLAB functions are rint_mwe1, rint_mwe2, maxrange_rk1, maxrange_rk2, plot_shells, gromacs_figures
They have been developed and tested on MATLAB 2020b. 

The MATLAB files are distributed under a CC-BY-SA licence. You are free to use them at your own risk.
