#!/usr/bin/env python3

import argparse
import numpy as np

#Generates coordinates for cylinderical helix
#Based on code by JF

DEFAULT_NUM_RINGS       = 5
DEFAULT_POINTS_PER_RING = 7
DEFAULT_CYLINDER_RADIUS = 30
DEFAULT_DELTA_Z         = 25
DEFAULT_DELTA_THETA     = 2*np.pi/DEFAULT_POINTS_PER_RING/2

def helix_ccordinates(num_rings, num_points_per_ring, cylinder_radius, delta_z, delta_theta, has_core=True):
    '''
    Function for generating a cylinderical helix
        using rotated slices of a cylinder aligned along the z axis

    Preconditions:
        num_rings (int>0)             : The number of slices
        num_points_per_ring (int > 0) : How many point on each slice
        cylinder_radius (float > 0)   : How wide is our cylinder
        delta_z (float > 0)           : How far apart are each slice
        delta_theta (float)           : How much do we rotate each slice in radians
        has_core (boolean)            : Do we add a point in the center of the ring (default=True)
    '''
    n            = num_rings * (num_points_per_ring + has_core)
    points       = np.zeros( (n,3) )
    theta_values = np.linspace(0, 2*np.pi-2*np.pi/num_points_per_ring, num_points_per_ring )
    for ring in range(num_rings):
        for r, theta in enumerate(theta_values + ring*delta_theta):
            x, y, z = cylinder_radius*np.cos(theta), cylinder_radius*np.sin(theta), ring*delta_z
            row = ring*(num_points_per_ring + has_core) + r
            points[row, : ] = x, y, z
        if has_core:
            points[row+1, : ] = 0, 0, z
    return points

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate coordinates for helical cylinder")
    parser.add_argument("--num_rings",
                        type=int,
                        help="How many rings are we generating? (default={})".format(DEFAULT_NUM_RINGS),
                        default = DEFAULT_NUM_RINGS)
    parser.add_argument("--num_points_per_ring",
                        type=int,
                        help="How many points per ring? (default={})".format(DEFAULT_POINTS_PER_RING),
                        default= DEFAULT_POINTS_PER_RING)
    parser.add_argument("--cylinder_radius",
                        type=float,
                        help="What is the radius of the cylinder? (default={})".format(DEFAULT_CYLINDER_RADIUS),
                        default=DEFAULT_CYLINDER_RADIUS)
    parser.add_argument("--delta_z",
                        type=float,
                        help="How far are the rings along the z axis? (default={})".format(DEFAULT_DELTA_Z),
                        default=DEFAULT_DELTA_Z)
    parser.add_argument("--delta_theta",
                        type=float,
                        help="How much do we twist each ring relative to the last one in radians? (default={:.2f})".format(DEFAULT_DELTA_THETA),
                        default=DEFAULT_DELTA_THETA)
    parser.add_argument("--no_core",
                        action='store_true',
                        help='Do not include a point at the center of each ring.',
                        default=False)
    parser.add_argument("filename",
                        help='Where do we put the results?')

    args = parser.parse_args()
    assert args.num_rings > 0
    assert args.num_points_per_ring > 0
    assert args.cylinder_radius > 0
    assert args.delta_z > 0
    #assert args.delta_theta >= 0

    with open(args.filename, 'w') as points_file:
        helix_points = helix_ccordinates(args.num_rings, args.num_points_per_ring, args.cylinder_radius, args.delta_z, args.delta_theta, args.no_core == False)
        print(len(helix_points), file=points_file)
        print(file=points_file)
        for x, y, z in helix_points:
            print('{:<2} {:>15.10f} {:>15.10f} {:>15.10f}'.format('Au',x,y,z), file=points_file)
