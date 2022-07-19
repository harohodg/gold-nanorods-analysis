"""
Functions to help calculate the CD and Absorbance spectra of gold nanorods using generalized multiparticle Mie theory (GMMT)
Based on SKG code
"""
import miepy
from tqdm import tqdm
import numpy as np
from copy import deepcopy

def load_xyz(filename, scale=1):
    """
    Function to load an xyz file and return a numpy array of values
    Assumes whitespace delimiter, and a proper xyz file with the first row being
    The number of atoms and the second being blank or a comment

    Preconditions:
        filename(str) : The name of the file to read in
        scale(float>0): What each point gets multiplied by
    Postconditions:
        returns a 2D numpy array (nx3) where each row represents the x,y,z of an atom
    """
    assert scale > 0
    return np.loadtxt(open(filename, "rb"), skiprows=2, usecols=(1,2,3) )*scale

def rotate_xyz(points, rotation_angle):
    """
    Function to rotate an 3D array of points about the y axis

    Preconditions:
        points(2D numpy array (nx3)) : The points to rotate
        rotation_angle(float)        : The angle to rotate by in radians
    Postconditions:
        returns 2D numpy array (nx3) of rotated points
    """
    R_y = [ [np.cos(rotation_angle),0.0,np.sin(rotation_angle)],   \
            [0.0,1.0,0.0],                               \
            [-np.sin(rotation_angle),0.0,np.cos(rotation_angle)] ]

    new_points = np.zeros_like(points)

    for index, point in enumerate( points ):
        new_points[index] = np.dot(R_y,point)

    return new_points

def calc_values(points, polarization, wavelengths, radius, material, medium, lmax, disable_tqdm=False):
    """
    Function to perform the actual calculation for a given geometry, polarization of light,
        material, in a given medium, over a set of wavelengths
    
    Precondtions:
        points(2D numpy array) (nx3) : the xyz values of the individual spheres
        polarization()
    """
    scat    = np.zeros_like(wavelengths)
    absorb  = np.zeros_like(wavelengths)
    extinct = np.zeros_like(wavelengths)

    source = miepy.sources.plane_wave(polarization=polarization)

    for i, wavelength in enumerate( tqdm(wavelengths, desc="polarization={}".format(polarization), disable=disable_tqdm) ):
        sol = miepy.sphere_cluster(position=points,
                                   radius=radius,
                                   material=material,
                                   source=source,
                                   medium=medium,
                                   wavelength=wavelength,
                                   lmax=lmax)

        scat[i], absorb[i], extinct[i] = sol.cross_sections()
    return scat, absorb, extinct
