#!/bin/bash

NTHREADS=1 # 1 thread produces the most reproducible results
SIM_TIME=1 # Simulation time in picoseconds
# Number of steps to simulate (time-step = SIM_TIME / NSTEPS)
NSTEPS=(250 500 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 3000 4000 \
        5000 6000 7000 8000 9000 10000 11000 12000 13000 14000 15000 16000)
TOLS=(0.0001 0.000000000001)

PROT="lysozyme"

RESULTS_DIR="run_$PROT"

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

GMX="$SCRIPT_DIR/bin_double_gcc/bin/gmx_d"

# Each subfolder of $SIM_DIR is a different force field.
SIM_DIR="$SCRIPT_DIR/$PROT"

NPTGRO="npt.gro"
NPTCPT="npt.cpt"
TOPOLTOP="topol.top"
MDMDP="prod.mdp"

export  GMX_MAXBACKUP=-1

# Run GROMACS simulation given a tpr file.
# $1 = tpr file
run_solver() {
    tpr="$1"

    $GMX mdrun -ntmpi 1 -ntomp $NTHREADS -reprod -s "$tpr" 1>out.out 2>err.err

    # Need to do this in order to avoid wrong output when NSTEPS is not divisible 
    # by SIM_TIME
    SIM_TIME_APROX=$(echo "$SIM_TIME - 0.000001" | bc)
    out="$(echo -e "Kinetic\nPotential\n\n" | $GMX energy -f ener.edr -b $SIM_TIME_APROX 2>/dev/null)"
    echo "$out" | grep -q "All statistics are over 1 points"
    if [[ $? -ne 0 ]]; then
        echo "Error in energy output"
        exit 1
    fi

    echo "Kinetic (kJ/mol), Potential (kJ/mol)" > ener.csv
    echo "$out" | grep "Kinetic En." | tr -s ' ' | cut -d ' ' -f 3 | tr -d '\n' >> ener.csv
    echo -n "," >> ener.csv
    echo "$out" | grep "Potential" | tr -s ' ' | cut -d ' ' -f 2 | tr -d '\n' >> ener.csv
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
    nptgro="$1"
    nptcpt="$2"
    topoltop="$3"
    old_mdp="$4"
    new_mdp="$5"
    new_tpr="$6"
    new_parameters="$7"

    generate_mdp "$old_mdp" "$new_mdp" "$new_parameters"

    # Create the tpr file
    $GMX grompp -f "$new_mdp" -c "$nptgro" -r "$nptgro" -t "$nptcpt" \
                -p "$topoltop" -o "$new_tpr" &> "$new_tpr.txt"
}

for ff in $(ls -d $SIM_DIR/*/); do
    ff="$(basename $ff)"
    sim_dir="$SIM_DIR/$ff"
    for tol in ${TOLS[@]}; do
        for nsteps in ${NSTEPS[@]}; do
            # Compute ts and remove trailing zeros
            ts=$(bc <<<"scale=16; $SIM_TIME / $nsteps" | sed '/\./ s/\.\{0,1\}0\{1,\}$//')

            res_dir="${RESULTS_DIR}/$ff/tol${tol}/ts${ts}"
            mkdir -p "$res_dir"
            pushd "$res_dir" &>/dev/null

            echo -n "Simulation: $res_dir | Tolerance: $tol | Time step: $ts ps | "
            echo "Simulated time: $SIM_TIME ps | Number of steps: $nsteps"

            echo "Generating tpr..."

            shake_mdp="shake.mdp"
            shake_tpr="shake.tpr"

            nptgro="$sim_dir/$NPTGRO"
            nptcpt="$sim_dir/$NPTCPT"
            topoltop="$sim_dir/$TOPOLTOP"
            mdmdp="$SIM_DIR/$MDMDP"

            generate_tpr "$nptgro" "$nptcpt" "$topoltop" "$mdmdp" "$shake_mdp" "$shake_tpr" \
                         "constraint-algorithm=shake
                          shake-tol=${tol}
                          nsteps=${nsteps}
                          dt=${ts}
                          nstxout=$nsteps
                          nstvout=$nsteps
                          nstfout=$nsteps"

            echo "Running simulation..."

            run_solver "$shake_tpr"

            popd &>/dev/null # sim folder
        done
    done
done
