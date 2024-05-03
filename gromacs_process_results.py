import os
import subprocess
import pandas as pd
import numpy as np
import MDAnalysis as mda
import csv


# def read_gro(file):
#     xs = []
#     vs = []
#     with open(file, 'r') as f:
#         # Ignore the first two lines
#         for _ in range(2):
#             next(f)

#         for line in f.readlines():
#             res = line[5:10].strip()
#             if res == 'SOL':
#                 break

#             xx = float(line[20:28])
#             xy = float(line[28:36])
#             xz = float(line[36:44])
#             xs.append((xx, xy, xz))

#             vx = float(line[44:52])
#             vy = float(line[52:60])
#             vz = float(line[60:68])
#             vs.append((vx, vy, vz))

#     return xs, vs


# def read_g96(file):
#     xs = []
#     vs = []

#     with open(file, 'r') as f:
#         while True:
#             block = f.readline().strip()
#             if block == '':
#                 break
#             elif block[0] == '#':
#                 pass
#             elif block == 'TITLE' or block == 'BOX' or block == 'TIMESTEP':
#                 # Skip until END
#                 while f.readline().strip() != 'END':
#                     pass
#             elif block == 'POSITION' or block == 'VELOCITY':
#                 while True:
#                     line = f.readline()

#                     if line[0] == '#':
#                         continue

#                     if line.strip() == 'END':
#                         break

#                     res = line[6:11]
#                     if res == 'SOL':
#                         continue

#                     x = float(line[26:41])
#                     y = float(line[42:57])
#                     z = float(line[58:73])

#                     if block == 'POSITION':
#                         xs.append((x, y, z))
#                     else:
#                         vs.append((x, y, z))
#             else:
#                 print("Unknown block: ", block)
#                 exit(1)

#     return xs, vs


# def read_trr_dump(file, first_atom, last_atom):
#     natoms = last_atom - first_atom + 1

#     xs = [None] * natoms
#     vs = [None] * natoms

#     with open(file, 'r') as f:
#         for line in f.readlines():
#             line = line.replace(' ', '')
#             line = line.replace('\t', '')
#             line = line.replace('\n', '')

#             if line[0:2] == 'x[' or line[0:2] == 'v[':
#                 atom = int(line[2:line.find(']')]) - 1

#                 if atom < first_atom or atom > last_atom:
#                     continue

#                 values = line[line.find('{')+1:line.find('}')].split(',')

#                 if line[0:2] == 'x[':
#                     xs[atom] = (float(values[0]), float(
#                         values[1]), float(values[2]))
#                 else:
#                     vs[atom] = (float(values[0]), float(
#                         values[1]), float(values[2]))
#                 break

#     return xs, vs


def read_sim_out(gro, trr, enercsv):
    u = mda.Universe(gro, trr)

    prot = u.select_atoms('protein')

    last_frame_index = len(u.trajectory) - 1
    u.trajectory[last_frame_index]

    # Positions of the atoms.
    xs = []
    xs = prot.atoms.positions
    xs = mda.units.convert(xs, 'Angstrom', 'nm')
    xs = [(x, y, z) for x, y, z in xs]

    # Velocities of the atoms.
    vs = []
    vs = prot.atoms.velocities
    vs = mda.units.convert(vs, 'Angstrom/ps', 'nm/ps')
    vs = [(x, y, z) for x, y, z in vs]

    # Kinetic and potential energy of the protein.
    enercsv_file = open(enercsv, 'r')
    enercsv_reader = csv.reader(enercsv_file, delimiter=',')
    next(enercsv_reader) # Skip the header
    ke, pe = next(enercsv_reader)

    # masses = prot.atoms.masses
    # # Convert from u to kg. No function available.
    # masses = masses * 1.66053906660e-27

    # # Kinetic energy of the protein.
    # vs_m_s = prot.atoms.velocities
    # vs_m_s = mda.units.convert(vs_m_s, 'Angstrom/ps', 'm/s')
    # # print("vs_m_s", vs_m_s)
    # ke = 0.5 * masses * np.linalg.norm(vs_m_s, axis=1)**2 # Jules
    # avogadros = 6.02214076e23
    # ke = ke.sum() * avogadros # Jules/mol
    # ke = ke / 1000 # kJ/mol

    return xs, vs, ke, pe

def richardson_df(timess_coor):
    """
    Compute Richardson's fraction and error estimate for a single atom and 
    coordinate.

    :param timess_coor: Dictionary with time-step as key and a list of
           triplets as value.
    :return: DataFrame with time-step, Atom/coordinate value, Richardson's 
             fraction and error estimate.
    """
    # x coordinate of first atom.

    atom = 0
    coor = 0

    p = 2  # Theoretical order of the method.

    timess_coor_sorted = dict(sorted(timess_coor.items(), reverse=True))

    df = pd.DataFrame(columns=['time-step', 'A_h', 'F_h', 'E_h'])
    for ts, coors in timess_coor_sorted.items():
        df.loc[len(df)] = [ts, coors[atom][coor], 0, 0]

    # Compute Richardson's fraction
    for i in range(2, len(df)):
        df.iloc[i, 2] = (df.iloc[i-1, 1] - df.iloc[i-2, 1]) / \
            (df.iloc[i, 1] - df.iloc[i-1, 1])

    # Compute Richardson's error estimate
    for i in range(1, len(df)):
        df.iloc[i, 3] = (df.iloc[i, 1] - df.iloc[i-1, 1]) / (2 ^ p-1)

    return df

def energies_df(timess_energies):
    timess_energies_sorted = dict(sorted(timess_energies.items(), reverse=True))

    df = pd.DataFrame(columns=['time-step', 'Kinetic En. (kJ/mol)', 'PE (kJ/mol)'])
    for ts, energies in timess_energies_sorted.items():
        df.loc[len(df)] = [ts, energies[0], energies[1]]

    return df

def main():
    results_dir = 'run_lysozyme'
    natoms = 1960  # Lysozyme

    for ff_folder in os.listdir(results_dir):
        path_ff = results_dir + '/' + ff_folder
        for tol_folder in os.listdir(path_ff):
            path_tol = path_ff + '/' + tol_folder

            tol = float(tol_folder[4:])

            xs_dict = {}
            vs_dict = {}
            energies_dict = {}
            for ts_folder in os.listdir(path_tol):
                ts = float(ts_folder[2:])

                path_ts = path_tol + '/' + ts_folder
                xs, vs, ke, pe = read_sim_out(path_ts + '/confout.gro', path_ts + '/traj.trr', path_ts + '/ener.csv')
                xs_dict[ts] = xs
                vs_dict[ts] = vs
                energies_dict[ts] = (ke, pe)

            # pd.set_option("display.precision", 40)
            header = "Force field: " + ff_folder + " | Tolerance: " + str(tol) + " | Parameter: "

            print(header + "positions")
            print(richardson_df(xs_dict))
            print("\n")
            print(header + "velocities")
            print(richardson_df(vs_dict))
            print("\n")
            print(header + "energies")
            print(energies_df(energies_dict))
            print("\n")


if __name__ == '__main__':
    main()
