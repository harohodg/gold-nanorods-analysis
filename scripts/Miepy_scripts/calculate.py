#!/usr/bin/env python3

"""
Code to calculate the CD and Absorbance spectra of gold nanorods using generalized multiparticle Mie theory (GMMT)
Based on SKG code
Assumptions:
    - spherical gold particles
    - the xyz file is an  x,y,z file, first line number of atoms, then a blank line
         white space delimited
    - xyz file units are in nm
    - constant medium
"""
import code
import argparse
import numpy as np
import matplotlib.pyplot as plt
import miepy
from os.path import exists
from os import rename

from functions import *

DEFAULT_MIN_LAMBDA = 400
DEFAULT_MAX_LAMBDA = 750
DEFAULT_NUM_LAMBDA = 150
DEFAULT_MEDIUM_EPSILON = 1.0
DEFAULT_LMAX           = 3
DEFAULT_RADIUS         = 12.5
DEFAULT_THETA          = 0.0
DEFAULT_OUTPUT_FILE    = "./spectra.txt"
DATA_HEADER='wavelength scat1 absorb1 extinct1 scat2 absorb2 extinct2 scat3 absorb3 extinct3 scat4 absorb4 extinct4'


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="calculate CD and Absorbance spectra of gold nanorods using generalized multiparticle Mie theory (GMMT)")
    parser.add_argument("--min_lambda", help="minimum wavelength in nm. (default={})".format(DEFAULT_MIN_LAMBDA),
                        type=float,
                        default=DEFAULT_MIN_LAMBDA)
    parser.add_argument("--max_lambda", help="maximum wavelength in nm. (default={})".format(DEFAULT_MAX_LAMBDA),
                        type=float,
                        default=DEFAULT_MAX_LAMBDA)
    parser.add_argument("--num_lambda", help="How many lambda do we calculate from min lambda to max lambda inclusive. (default={})".format(DEFAULT_NUM_LAMBDA),
                        type=int,
                        default=DEFAULT_NUM_LAMBDA)
    parser.add_argument("--medium_epsilon", help="The epsilon value of the medium. (default={0:.2f})".format(DEFAULT_MEDIUM_EPSILON),
                       type=float,
                       default=DEFAULT_MEDIUM_EPSILON)
    parser.add_argument("--lmax", help="The convergence parameter. (default={})".format(DEFAULT_LMAX),
                       type=int,
                       default=DEFAULT_LMAX)
    parser.add_argument("--radius", help="Radius of the particles in nm. (default={0:.2f})".format(DEFAULT_RADIUS),
                       type=float,
                       default=DEFAULT_RADIUS)
    parser.add_argument("--output_file", help="What do we put the results? (default='{}')".format(DEFAULT_OUTPUT_FILE), default=DEFAULT_OUTPUT_FILE)
    parser.add_argument("--disable_tqdm", help="Doen't display progress bars.", action='store_true', default=False)
    parser.add_argument("--continue", help="Try to continue calculation. Assumes if output file exists it was being run with the same parameters")
    parser.add_argument("geometry_file", help="The file to read the x,y,z coordinates from.")
    args = parser.parse_args()

    assert args.max_lambda > args.min_lambda, "max_lambda({}) must be greater then min_lambda({})".format(args.max_lambda, args.min_lambda)
    assert args.num_lambda > 2, "num_lambda({}) must be greater then 2".format(args.num_lambda)
    assert args.medium_epsilon > 0, "medium_epsilon({}) must be greater then zero".format(args.medium_epsilon)
    assert args.lmax   > 0, "lmax({}) must be greater then zero".format(args.lmax)
    assert args.radius > 0, "radius({}) must be greater then zero".format(args.radius)

    # Based on SKG code for Au NPs placed along a helix -- chiral plasmonics.
    # Here, both types of circular polarization are carried out
    # and the CD spectrum, the difference in absorption spectra
    # for these cases, as well as the absolute one, is calculated.
    # Updated to calculate parallel and perpendicular in the same program

    nm = 1e-9
    um = 1e-6

    ### parameters
    wavelengths = np.linspace(args.min_lambda, args.max_lambda, args.num_lambda)*nm
    radius      = args.radius*nm
    material    = miepy.materials.Au()
    medium      = miepy.constant_material(args.medium_epsilon)


    lmax = args.lmax  # convergence parameter
    # may need to INCREASE lmax to verify convergence.


    # read positions from a file with x y z 's for each particle
    # assumed to be oriented along the z axis
    points = load_xyz( args.geometry_file, scale=nm )
    rotated_points = rotate_xyz( points, np.pi/2 )
    print(' no. particles = ',len(points))

    temporary_filename = '{}.partial'.format( args.output_file )

    if exists(temporary_filename):
        with open(temporary_filename, 'r') as temp_file:
            num_lines = len( temp_file.readlines() )
            print('Found {} with {} lines'.format(temporary_filename, num_lines) )
            first_wavelength_index = num_lines - 1
    else:
        with open(temporary_filename, 'w') as temp_file:
            print(DATA_HEADER, file=temp_file)
            
        first_wavelength_index = 0
    
    wavelengths = wavelengths[first_wavelength_index:]
    print('Running calculations from {} to {}'.format( wavelengths[0]/nm, wavelengths[-1]/nm ) )
    
    rotated_points = rotate_xyz( points, np.pi/2 )
    with open( temporary_filename, 'a' ) as temp_file:
        for wavelength in tqdm(wavelengths, disable=args.disable_tqdm):
            target_wavelengths = np.array([wavelength])
            #Run the caculation with the light parallel to the cylinder
            #print("Parallel Calculations")
            scat1, absorb1, extinct1 = calc_values(points, [1,1j],  target_wavelengths, radius, material, medium, lmax, True)
            scat2, absorb2, extinct2 = calc_values(points, [1,-1j], target_wavelengths, radius, material, medium, lmax, True)

            #Rotate the cylinder and rerun the calculations
            #print("Perpendicular Calculations")
            scat3, absorb3, extinct3 = calc_values(rotated_points, [1,1j],  target_wavelengths, radius, material, medium, lmax, True)
            scat4, absorb4, extinct4 = calc_values(rotated_points, [1,-1j], target_wavelengths, radius, material, medium, lmax, True)
             
            data_to_export = np.array( [
                  target_wavelengths/nm,
                  scat1/um**2,
                  absorb1/um**2,
                  extinct1/um**2,
                  scat2/um**2,
                  absorb2/um**2,
                  extinct2/um**2,
                  scat3/um**2,
                  absorb3/um**2,
                  extinct3/um**2,
                  scat4/um**2,
                  absorb4/um**2,
                  extinct4/um**2
                ]
               ).transpose()
            row_format_string = ' '.join(['{:.8f}']*data_to_export.shape[1])   
            for row in data_to_export:
                print( row_format_string.format(*row), file=temp_file)
            temp_file.flush()
    rename( temporary_filename, args.output_file )
    
