# gold-nanorods-analysis
Code and data for the gold nanorods analysis

## Table of Contents
- geometry_files
  - miepy_geometries : Files are named according to the number of atoms (n), the twist (i/d)*(2pi/7), cylinder radius (r), and distance between rings (delta_z). Au(n)_(i)_(d)_r(r)_dz(delta_z).xyz
  - nanorods : Files are named according to the number of gold atoms (n). Au(n).xyz
- scripts
  - Gaussian_scripts : Example scripts used with Gaussian 09
  - Miepy_scripts    : Scripts used with the miepy calculations
  - plotting_scripts : Scripts used to plot the Gaussian spectra and Miepy data using Plotly 5.11.0 and Kaleido 0.2.1 and to generate nice images of the nanorods with Jmol 14.32.82
- data_files
  - miepy_data            : the Miepy calculation results used for the miepy plots
  - gaussian_spectra_data : the extracted Gaussian spectra data
