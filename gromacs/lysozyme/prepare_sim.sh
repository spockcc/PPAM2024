#!/bin/bash

# export OMP_NUM_THREADS=4

PROT="1AKI_clean"
#  1: AMBER03 protein, nucleic AMBER94 (Duan et al., J. Comp. Chem. 24, 1999-2012, 2003)
#  2: AMBER94 force field (Cornell et al., JACS 117, 5179-5197, 1995)
#  3: AMBER96 protein, nucleic AMBER94 (Kollman et al., Acc. Chem. Res. 29, 461-469, 1996)
#  4: AMBER99 protein, nucleic AMBER94 (Wang et al., J. Comp. Chem. 21, 1049-1074, 2000)
#  5: AMBER99SB protein, nucleic AMBER94 (Hornak et al., Proteins 65, 712-725, 2006)
#  6: AMBER99SB-ILDN protein, nucleic AMBER94 (Lindorff-Larsen et al., Proteins 78, 1950-58, 2010)
#  7: AMBERGS force field (Garcia & Sanbonmatsu, PNAS 99, 2782-2787, 2002)
#  8: CHARMM27 all-atom force field (CHARM22 plus CMAP for proteins)
#  9: CHARMM36 all-atom force field
# 10: GROMOS96 43a1 force field
# 11: GROMOS96 43a2 force field (improved alkane dihedrals)
# 12: GROMOS96 45a3 force field (Schuler JCC 2001 22 1205)
# 13: GROMOS96 53a5 force field (JCC 2004 vol 25 pag 1656)
# 14: GROMOS96 53a6 force field (JCC 2004 vol 25 pag 1656)
# 15: GROMOS96 54a7 force field (Eur. Biophys. J. (2011), 40,, 843-856, DOI: 10.1007/s00249-011-0700-9)
# 16: OPLS-AA/L all-atom force field (2001 aminoacid dihedrals)
FORCE_FIELD="16"

# END OF USER INPUT

set -e # Exit if any command fails

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

OUT_DIR="$SCRIPT_DIR/${PROT}_${FORCE_FIELD}"

GMX="$SCRIPT_DIR/../bin_double_gcc/bin/gmx_d"

mkdir -p "$OUT_DIR"
pushd "$OUT_DIR"

# Generate topology
$GMX pdb2gmx -f "../$PROT.pdb" -o "${PROT}_processed.gro" -water spce <<EOF
$FORCE_FIELD
EOF

# Define box and solvate
$GMX editconf -f "${PROT}_processed.gro" -o "${PROT}_newbox.gro" -c -d 1.0 -bt cubic

$GMX solvate -cp "${PROT}_newbox.gro" -cs spc216.gro -o "${PROT}_solv.gro" -p topol.top

# Add Ions
$GMX grompp -f "../ions.mdp" -c "${PROT}_solv.gro" -p topol.top -o ions.tpr

# 13 -> SOL
$GMX genion -s ions.tpr -o "${PROT}_solv_ions.gro" -p topol.top -pname NA -nname CL -neutral <<EOF
13
EOF

# Energy minimization
$GMX grompp -f "../minim.mdp" -c "${PROT}_solv_ions.gro" -p topol.top -o em.tpr

$GMX mdrun -deffnm em

# Equilibration phase 1
$GMX grompp -f "../nvt.mdp" -c em.gro -r em.gro -p topol.top -o nvt.tpr

$GMX mdrun -deffnm nvt

# Equilibration phase 2

$GMX grompp -f "../npt.mdp" -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr

$GMX mdrun -deffnm npt

popd
