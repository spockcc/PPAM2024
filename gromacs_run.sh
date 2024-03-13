#!/bin/bash

NTHREADS=8
SIM_TIME=100 # Simulation time in picoseconds
TIME_STEPS=(4 2 1 0.5 0.25 0.125 0.0625) # In femtoseconds
TOLS=(0.000000000001)

PROT="lysozyme"

RESULTS_DIR="run_$PROT"

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

GMX="$SCRIPT_DIR/bin_double_gcc/bin/gmx_d"

SIM_DIR="$SCRIPT_DIR/$PROT"

NPTGRO="$SIM_DIR/equil3.gro"
NPTCPT="$SIM_DIR/state.cpt"
TOPOLTOP="$SIM_DIR/topol.top"
MDMDP="$SIM_DIR/prod.mdp"

export  GMX_MAXBACKUP=-1

# Run GROMACS simulation given a tpr file.
# $1 = tpr file
run_solver() {
    tpr="$1"

    $GMX mdrun -ntmpi 1 -ntomp $NTHREADS -reprod -s "$tpr" -noconfout \
               -g gromacs.log 1>out.out 2>err.err
}

# Generate mdp file based on an old mdp file and a string of parameters.
# $1 = old mdp file
# $2 = new mdp file
# $3 = new parameters
generate_mdp() {
    old_mdp="$1"
    new_mdp="$2"
    new_parameters="$3"

    cp "$old_mdp" "$new_mdp"

    echo "; Added by the script" >> "$new_mdp"

    for line in $new_parameters; do
        trilled_line=$(echo "$line" | sed 's/\s//g')
        option=$(echo "$trilled_line" | cut -d'=' -f1)
        value=$(echo "$trilled_line" | cut -d'=' -f2)

        # The option can use both - and _ as separators.
        option_regex=$(echo "$option" | sed -r 's/[-_]/\[-_\]/g')

        # Comment the option if it already exists.
        sed -i -E "s/^[[:space:]]*${option_regex}[[:space:]]*=.*$/;&/gI" "$new_mdp"
        # Append the new option at the end of the new mdp file.
        echo "${option}=${value}" >> "$new_mdp"
    done
}

# Generate trp file based on an mdp file and a string of parameters.
# $1 = old mdp file
# $2 = new mdp file
# $3 = new tpr file
# $4 = new parameters
generate_tpr() {
    old_mdp="$1"
    new_mdp="$2"
    new_tpr="$3"
    new_parameters="$4"

    generate_mdp "$old_mdp" "$new_mdp" "$new_parameters"

    # Create the tpr file
    $GMX grompp -f "$new_mdp" -c "$NPTGRO" -r "$NPTGRO" -t "$NPTCPT" \
                -p "$TOPOLTOP" -o "$new_tpr" &> "$new_tpr.txt"
}

for tol in ${TOLS[@]}; do
    for ts in ${TIME_STEPS[@]}; do
        ts_ps=$(bc <<<"scale=6; $ts / 1000")
        nsteps=$(bc <<<"scale=0; $SIM_TIME / $ts_ps")

        echo -n "Tolerance: $tol | Time step: $ts_ps ps | "
        echo "Simulated time: $SIM_TIME ps | Number of steps: $nsteps"

        sim_folder="${RESULTS_DIR}/tol${tol}ts${ts}"
        mkdir -p "$sim_folder"
        pushd "$sim_folder" &>/dev/null

        echo "Generating tpr..."

        shake_mdp="shake.mdp"
        shake_tpr="shake.tpr"

        generate_tpr "$MDMDP" "$shake_mdp" "$shake_tpr" \
                     "constraint-algorithm=shake
                      shake-tol=${tol}
                      nsteps=${nsteps}
                      dt=${ts_ps}"

        echo "Running simulation..."

        run_solver "$shake_tpr"

        popd &>/dev/null # sim folder
    done
done
