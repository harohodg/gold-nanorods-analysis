#!/usr/bin/env python
# coding: utf-8

import argparse, copy, re, os
import pandas as pd
import numpy as np
from itertools import cycle
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots


FILE_DATA_COLUMN_DATA_TYPES = {'atoms' : int,
                     'numerator' : int,
                     'denominator' : int,
                     'cylinder_radius' : float,
                     'cylinder_dz' : float,
                     'lambda_start' : int,
                     'lambda_end' : int,
                     'num_lambda' : int,
                     'sphere_radius' : float,
                     'lmax' : int
                    }
CONSTANT_FILE_DATA_COLUMNS = ('denominator','cylinder_radius','cylinder_dz','lambda_start','lambda_end','num_lambda','sphere_radius','lmax')
DATA_COLUMNS = ('wavelength',
                'Parallel_Left_scat','Parallel_Left_absorb','Parallel_Left_extinct',
                'Parallel_Right_scat','Parallel_Right_absorb','Parallel_Right_extinct',
                'Perpendicular_Left_scat','Perpendicular_Left_absorb','Perpendicular_Left_extinct',
                'Perpendicular_Right_scat','Perpendicular_Right_absorb','Perpendicular_Right_extinct')



FILE_REGEX_PATTERN = r"Au(?P<atoms>\d+)_(?P<numerator>-?\d+)_(?P<denominator>\d+)_r(?P<cylinder_radius>\d+.?\d+)_dz(?P<cylinder_dz>\d+.?\d+)-(?P<lambda_start>\d+.?\d+)-(?P<lambda_end>\d+.?\d+)-(?P<num_lambda>\d+.?\d+)-r(?P<sphere_radius>\d+.?\d+)-l(?P<lmax>\d+).txt"
FILE_REGEX = re.compile(FILE_REGEX_PATTERN, flags=0)
nm_to_eV = lambda nm : 1239.8 / nm

DEFAULT_OUTPUT_FILE   = 'test.svg'
DEFAULT_MARKER_SIZE   = 30
DEFAULT_MIN_NUMERATOR = -np.inf
DEFAULT_MAX_NUMERATOR =  np.inf
DEFAULT_SPECTRA_TYPE  = 'AB'

DEFAULT_OVERALL_PLOT_HEIGHT    = 1000
DEFAULT_FONT_NAME              = 'Times New Roman'
DEFAULT_TICS_FONT_NAME         = 'Times New Roman'
DEFAULT_LEGEND_FONT_SIZE       = 39
DEFAULT_FONT_SIZE              = 40
DEFAULT_TICS_FONT_SIZE         = 40
DEFAULT_TEXT_COLOR             = 'Black'


DEFAULT_LEGEND_X_OFFSET        = 0.3
DEFAULT_LEGEND_Y_OFFSET        = -0.15


DEFAULT_MIEPY_CALC_TYPE = 'absorb'

parser = argparse.ArgumentParser( prog='plot_miepy_max_wavelengths.py', description='Generate one of miepy plots')
parser.add_argument('--output_file',   default=DEFAULT_OUTPUT_FILE)
parser.add_argument('--marker_size',type=int, default=DEFAULT_MARKER_SIZE)
parser.add_argument('--plot_title', default='')
parser.add_argument('--min_numerator', type=int, default=DEFAULT_MIN_NUMERATOR)
parser.add_argument('--max_numerator', type=int, default=DEFAULT_MAX_NUMERATOR)
parser.add_argument('--y_range', type=float, nargs=2)
parser.add_argument('--y_tics',  type=float, nargs='+')
parser.add_argument('--degrees', action='store_true', default=False)
parser.add_argument('--miepy_calc_type', choices=['scat', 'absorb', 'extinct'], default=DEFAULT_MIEPY_CALC_TYPE)
parser.add_argument('--spectra_type', choices=['AB','CD'], default=DEFAULT_SPECTRA_TYPE)
parser.add_argument('--overall_plot_height',          type=int, default=DEFAULT_OVERALL_PLOT_HEIGHT)

parser.add_argument('--font_name',                  default=DEFAULT_FONT_NAME)
parser.add_argument('--tics_font_name',             default=DEFAULT_TICS_FONT_NAME)
parser.add_argument('--font_size',        type=int, default=DEFAULT_FONT_SIZE)
parser.add_argument('--tics_font_size',   type=int, default=DEFAULT_TICS_FONT_SIZE)
parser.add_argument('--legend_font_size', type=int, default=DEFAULT_LEGEND_FONT_SIZE)
parser.add_argument('--text_color',                 default=DEFAULT_TEXT_COLOR)

parser.add_argument('--legend_x_offset',              type=float, default=DEFAULT_LEGEND_X_OFFSET)
parser.add_argument('--legend_y_offset',              type=float, default=DEFAULT_LEGEND_Y_OFFSET)

parser.add_argument('input_folder')
args = parser.parse_args()
#args = parser.parse_args(['--min_numerator=1',
#                          '--max_numerator=11',
#                          '--y_range',' 540', '570',
#                          '--y_tics', '545', '550', '555', '560', '565',
#                          '--marker_size', '30',
#                          '--spectra_type', 'CD',
#                          '--plot_title', 'CD Max Wavelength/Energy',
#                          '../miepy_results'])
assert args.min_numerator <= args.max_numerator


data_sets = pd.DataFrame( [ dict({'fname':f}, **FILE_REGEX.match(f).groupdict() ) for f in os.listdir(args.input_folder) if FILE_REGEX.match(f) ] )
for column in FILE_DATA_COLUMN_DATA_TYPES:
    data_sets[column] = data_sets[column].astype( FILE_DATA_COLUMN_DATA_TYPES[column] )

filtered_data_sets = data_sets.query(f'numerator >= {args.min_numerator} and numerator <= {args.max_numerator}').copy()
number_of_unique_values = [len( filtered_data_sets[column].unique() ) for column in CONSTANT_FILE_DATA_COLUMNS]
assert sum( number_of_unique_values ) == len(CONSTANT_FILE_DATA_COLUMNS), f'Files respresenting multiple miepy configurations found in {args.input_folder}'


filtered_data_sets['data'] = filtered_data_sets['fname'].apply( lambda fname :  pd.read_csv(f'{args.input_folder}/{fname}', delimiter='\s+', names=DATA_COLUMNS, skiprows=1, index_col='wavelength') )
for index in range( len(filtered_data_sets) ):
    for label in ['scat', 'absorb', 'extinct']:
        for orientation in ['Parallel', 'Perpendicular']:
            AB_column_name = f'{orientation}_{label}_AB'
            CD_column_name = f'{orientation}_{label}_CD'
            left_column  = f'{orientation}_Left_{label}'
            right_column = f'{orientation}_Right_{label}'
            filtered_data_sets.iloc[index]['data'][AB_column_name] = filtered_data_sets.iloc[index]['data'][left_column] + filtered_data_sets.iloc[index]['data'][right_column]
            filtered_data_sets.iloc[index]['data'][CD_column_name] = filtered_data_sets.iloc[index]['data'][left_column] - filtered_data_sets.iloc[index]['data'][right_column]

        for spectra in ['AB', 'CD']:
            first_column  = f'Parallel_{label}_{spectra}'
            second_column = f'Perpendicular_{label}_{spectra}'
            averaged_column_name = f'Average_{label}_{spectra}'
            filtered_data_sets.iloc[index]['data'][averaged_column_name] = (1/3)*filtered_data_sets.iloc[index]['data'][first_column] + (2/3)*filtered_data_sets.iloc[index]['data'][second_column]

stats = []
for index in range( len(filtered_data_sets) ):
    data_set = copy.deepcopy( filtered_data_sets.iloc[index].to_dict() )
    data = data_set.pop('data')

    current_info = data_set
    max_values=data.max()
    min_values=data.min()

    max_locs=data.idxmax()
    min_locs=data.idxmin()

    current_max_values = {f'{key}_MAX_VALUE':value for key,value in max_values.items()}
    current_min_values = {f'{key}_MIN_VALUE':value for key,value in min_values.items()}

    current_max_locs = {f'{key}_MAX_WAVELENGTH':value for key,value in max_locs.items()}
    current_min_locs = {f'{key}_MIN_WAVELENGTH':value for key,value in min_locs.items()}

    stats.append( {**current_info, **current_max_values, **current_min_values, **current_max_locs, **current_min_locs} )
stats_table = pd.DataFrame.from_dict(stats)
twist_in_degrees = lambda twist : np.degrees( twist*(2*np.pi/(7*stats_table.iloc[0]['denominator'])) )


num_labels = len(stats_table.atoms.unique())
colors = cycle(px.colors.qualitative.Plotly[:num_labels])
fig = make_subplots(specs=[[{"secondary_y": True}]])
fig.update_layout(showlegend=True,
                  height=args.overall_plot_height,width=2*args.overall_plot_height,
                  font=dict(family=args.font_name, size=args.font_size, color=args.text_color),
#                  margin=dict(l=args.left_margin, r=args.right_margin, t=args.top_margin, b=args.bottom_margin)
                 legend=dict(orientation="h", yanchor="top", y=args.legend_y_offset, xanchor="left", x=args.legend_x_offset, itemsizing ='constant', font=dict(size=args.legend_font_size) ),
                 title=dict(text=args.plot_title, x=0.5,y=0.95, xanchor='center',yanchor='top')
                 )


for num_atoms in sorted( stats_table['atoms'].unique() ):
    data_to_plot = stats_table.query(f'atoms == {num_atoms}').sort_values(by = 'numerator')
    plot_label = f'Au<sub>{num_atoms}</sub>'
    y_axis_column = f'Average_{args.miepy_calc_type}_{args.spectra_type}_MAX_WAVELENGTH'

    x_axis_data  = twist_in_degrees( data_to_plot['numerator'] ) if args.degrees is True else data_to_plot['numerator']
    y_axis_data  = data_to_plot[y_axis_column]
    y_axis_data2 = nm_to_eV( y_axis_data )
    trace_color = next(colors)

    fig.add_trace(go.Scatter(x=x_axis_data, y=y_axis_data, mode='markers', marker=dict(size=args.marker_size, color=trace_color), name=plot_label, showlegend=True),  secondary_y=False)
    fig.add_trace(go.Scatter(x=x_axis_data, y=y_axis_data2, showlegend=False, visible=False), secondary_y=True)

fig.update_yaxes(range=(args.y_range[0],args.y_range[-1]), tickmode='array', tickvals=args.y_tics, secondary_y=False)
fig.update_yaxes(range=(nm_to_eV(args.y_range[0]), nm_to_eV(args.y_range[-1])), tickmode='array', tickvals = [nm_to_eV(tic) for tic in args.y_tics], secondary_y=True)


fig.update_xaxes(tickfont_size=args.tics_font_size, tickfont_family=args.tics_font_name, title='twist')
fig.update_yaxes(tickfont_size=args.tics_font_size, tickfont_family=args.tics_font_name, secondary_y=False)
fig.update_yaxes(tickfont_size=args.tics_font_size, tickfont_family=args.tics_font_name, secondary_y=True)

fig.update_layout(xaxis_title='twist (degrees)' if args.degrees is True else 'twist')
fig.update_yaxes(title='Max Wavelength (nm)', secondary_y=False)
fig.update_yaxes(title='Max Energy (eV)', secondary_y=True, showgrid=False, tickformat=".2f")

#fig.show()
fig.write_image(args.output_file)
