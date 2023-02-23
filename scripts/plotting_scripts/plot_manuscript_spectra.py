#!/usr/bin/env python
# coding: utf-8

import argparse
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from itertools import cycle
from plotly.subplots import make_subplots

from plotting_functions import *

DEFAULT_OUTPUT_FILE            = 'test.svg'
DEFAULT_OVERALL_PLOT_HEIGHT    = 1000
DEFAULT_FONT_NAME              = 'Times New Roman'
DEFAULT_TICS_FONT_NAME         = 'Times New Roman'
DEFAULT_LEGEND_FONT_SIZE       = 39
DEFAULT_FONT_SIZE              = 40
DEFAULT_TICS_FONT_SIZE         = 20
DEFAULT_TEXT_COLOR             = 'Black'

DEFAULT_SMOOTHED_SPECTRA_LABEL = 'Smoothed Spectra<br>(arb. units)'
DEFAULT_STICK_SPECTRA_LABEL    = 'Stick Spectra (arb. units)'
DEFAULT_SPECTRA_LABEL_X        = -0.07
DEFAULT_LEGEND_Y_OFFSET        = -0.05
DEFAULT_LEGEND_X_OFFSET        = -0.20


DEFAULT_SMOOTH_LINE_WIDTH      = 3
DEFAULT_STICK_LINE_WIDTH       = 3
DEFAULT_SMOOTHED_PLOT_HEIGHT   = 0.25
DEFAULT_INTER_PLOT_DISTANCE    = 0.01
DEFAULT_GAUSSIAN_STD           = 1.0
DEFAULT_NUM_POINTS             = 1000

DEFAULT_X_AXIS = 'eV'
AB_COLUMN = 'Absorbance(f)'
CD_COLUMN = 'R(length)'


# In[3]:


parser = argparse.ArgumentParser( prog='plot_manuscript_spectra.py', description='Generate one of the manuscript plots')

parser.add_argument('--output_file',   default=DEFAULT_OUTPUT_FILE)
parser.add_argument('--spectra_files', nargs='+')

parser.add_argument('--plot_type', choices=['AB','CD'], default='AB')
parser.add_argument('--plot_abs',  action="store_true")
parser.add_argument('--x_axis',    choices=['eV','nm'], default=DEFAULT_X_AXIS)
parser.add_argument('--y_axis',    choices=['Absorbance(f)','R(length)','R(velocity)'], default=AB_COLUMN )

parser.add_argument('--x_range',        type=float, nargs=2)
parser.add_argument('--smooth_y_range', type=float, nargs=2)
parser.add_argument('--stick_y_range',  type=float, nargs=2)
parser.add_argument('--x_tics',  type=float, nargs='+')
parser.add_argument('--smooth_y_tics',  type=float, nargs='+')
parser.add_argument('--stick_y_tics',  type=float, nargs='+')

parser.add_argument('--smoothed_spectra_label', default=DEFAULT_SMOOTHED_SPECTRA_LABEL)
parser.add_argument('--stick_spectra_label',    default=DEFAULT_STICK_SPECTRA_LABEL)
parser.add_argument('--smoothed_spectra_label_x_loc', type=float, default=DEFAULT_SPECTRA_LABEL_X)
parser.add_argument('--smoothed_spectra_label_y_loc', type=float)
parser.add_argument('--stick_spectra_label_x_loc',    type=float, default=DEFAULT_SPECTRA_LABEL_X)
parser.add_argument('--stick_spectra_label_y_loc',    type=float)
parser.add_argument('--legend_x_offset',              type=float, default=DEFAULT_LEGEND_X_OFFSET)
parser.add_argument('--legend_y_offset',              type=float, default=DEFAULT_LEGEND_Y_OFFSET)
parser.add_argument('--overall_plot_height',          type=int, default=DEFAULT_OVERALL_PLOT_HEIGHT)

parser.add_argument('--smooth_line_width', type=int, default=DEFAULT_SMOOTH_LINE_WIDTH)
parser.add_argument('--stick_line_width',  type=int, default=DEFAULT_STICK_LINE_WIDTH)

parser.add_argument('--x_axis_label')
parser.add_argument('--font_name',                  default=DEFAULT_FONT_NAME)
parser.add_argument('--tics_font_name',             default=DEFAULT_TICS_FONT_NAME)
parser.add_argument('--font_size',        type=int, default=DEFAULT_FONT_SIZE)
parser.add_argument('--tics_font_size',   type=int, default=DEFAULT_TICS_FONT_SIZE)
parser.add_argument('--legend_font_size', type=int, default=DEFAULT_LEGEND_FONT_SIZE)
parser.add_argument('--text_color',                 default=DEFAULT_TEXT_COLOR)
parser.add_argument('--plot_labels', nargs='+')
parser.add_argument('--left_margin',   type=int)
parser.add_argument('--right_margin',  type=int)
parser.add_argument('--top_margin',    type=int)
parser.add_argument('--bottom_margin', type=int)

parser.add_argument('--min_x', type=float)
parser.add_argument('--max_x', type=float)

parser.add_argument('--smooth_min_y', type=float)
parser.add_argument('--smooth_max_y', type=float)
parser.add_argument('--stick_min_y',  type=float)
parser.add_argument('--stick_max_y',  type=float)
parser.add_argument('--num_points', type=int, default=DEFAULT_NUM_POINTS)

parser.add_argument('--smoothed_plot_height', type=float, default=DEFAULT_SMOOTHED_PLOT_HEIGHT)
parser.add_argument('--interplot_distance',   type=float, default=DEFAULT_INTER_PLOT_DISTANCE)
parser.add_argument('--gaussian_std',         type=float, default=DEFAULT_GAUSSIAN_STD)

args = parser.parse_args()
#args = parser.parse_args(['--output_file', 'test.svg',
#                          '--spectra_files','../Au24_264states_Spectra.txt','../Au32_224states_Spectra.txt','../Au40_800states_Spectra.txt','../Au48_432states_Spectra.txt','../Au56_392states_Spectra.txt',
#                          '--plot_labels','Au<sub>24</sub>','Au<sub>32</sub>','Au<sub>40</sub>','Au<sub>48</sub>','Au<sub>56</sub>',
#                          '--min_x', '1.7', '--max_x', '4.2',
#                          '--x_range', '0', '6',
#                          '--x_tics', '0','1','2','3','4','5','6',
#                          '--smooth_max_y', '10',
#                          '--stick_max_y', '10',
#                          '--smooth_y_range','0','15',
#                          '--smooth_y_tics', '0', '5', '10',
#                          '--stick_y_range', '0', '15',
#                          '--stick_y_tics', '0', '5', '10',
#                          '--smoothed_spectra_label','Smoothed AB Spectra<br>(arb. units)',
#                          '--stick_spectra_label','Stick AB Spectra (arb. units)',
#                          '--x_axis_label','E (eV)',
#                          '--overall_plot_height','1800',
#                          '--y_axis','Absorbance(f)',
#                          '--smooth_line_width', '4',
#                          '--stick_line_width','6',
#                          '--font_size', '30',
#                          '--legend_font_size', '39',
#                          '--legend_y_offset', '-0.07',
#                          '--legend_x_offset', '-0.20',
#                          '--tics_font_size', '20'
#                         ])


# In[5]:


assert args.plot_labels is None or len(args.spectra_files) == len(args.plot_labels)
assert args.x_tics is None or len(args.x_tics) >= 2
assert args.overall_plot_height > 0

num_files = len(args.spectra_files)
plot_bottom_margin, plot_top_margin = get_plot_margins( args.smoothed_plot_height, args.interplot_distance, num_files )

x_column = args.x_axis
y_column = args.y_axis

plot_labels = args.plot_labels if args.plot_labels is not None else args.spectra_files


spectra_data = [ pd.read_csv(fname,skipinitialspace=True, delimiter=' ') for fname in args.spectra_files ]


x_min        = args.min_x if args.min_x is not None else min( [data[x_column].min() for data in spectra_data] )
x_max        = args.max_x if args.max_x is not None else max( [data[x_column].max() for data in spectra_data] )
filtered_spectra_data = [ data.query(f'{x_column} >= {x_min} and {x_column} <= {x_max}').copy() for data in spectra_data ]

if args.plot_abs is True:
    for index, data in enumerate(filtered_spectra_data):
        filtered_spectra_data[index][y_column] = data[y_column].abs()


smooth_x_min       = x_min if args.x_range is None else args.x_range[0]
smooth_x_max       = x_max if args.x_range is None else args.x_range[-1]
smooth_x_values    = np.linspace(smooth_x_min, smooth_x_max, args.num_points)

if args.plot_type == 'AB':
    smoothing_function = lambda x,y,std, x_values : Se(y,std)*gaussian(x_values,x,std)
else:
    smoothing_function = lambda x,y,std, x_values : Sde(y,x,std)*gaussian(x_values,x,std)
smoothed_data      = [ data.apply( lambda row : smoothing_function(row[x_column], row[y_column], args.gaussian_std, smooth_x_values), axis=1).sum() for data in filtered_spectra_data ]



#Scale plots to be within max/min if provided
smooth_min_y_value = min( [min(curve) for curve in smoothed_data] )
smooth_max_y_value = max( [max(curve) for curve in smoothed_data] )

smooth_min_ratio = args.smooth_min_y / smooth_min_y_value if args.smooth_min_y is not None and smooth_min_y_value != 0 else 1
smooth_max_ratio = args.smooth_max_y / smooth_max_y_value if args.smooth_max_y is not None and smooth_max_y_value != 0 else 1
smooth_scaling_ratio = min( [smooth_min_ratio, smooth_max_ratio] )

for index, curve in enumerate(smoothed_data):
    smoothed_data[index] = smooth_scaling_ratio*curve


stick_spectra_data = []
for data in filtered_spectra_data:
    stick_spectra_x_values = sum( data[x_column].apply( lambda x : [x,x,np.nan] ), [])
    stick_spectra_y_values = sum( data[y_column].apply( lambda y : [0,y,np.nan]), [] )
    tmp_data = pd.DataFrame({x_column:stick_spectra_x_values, y_column:stick_spectra_y_values})
    stick_spectra_data.append( tmp_data )

#Scale plots to be within max/min if provided
if args.stick_min_y is not None or args.stick_max_y is not None:
    for index, data in enumerate(stick_spectra_data):
        stick_min_y_value = data[y_column].min()
        stick_max_y_value = data[y_column].max()

        stick_min_ratio = args.stick_min_y / stick_min_y_value if args.stick_min_y is not None and stick_min_y_value != 0 else np.nan
        stick_max_ratio = args.stick_max_y / stick_max_y_value if args.stick_max_y is not None and stick_max_y_value != 0 else np.nan
        stick_scaling_ratio = min( [x for x in [stick_min_ratio, stick_max_ratio] if x is not np.nan] )
        stick_spectra_data[index][y_column] = stick_scaling_ratio*data[y_column]

num_plots    = num_files + 1
plot_margins = {'yaxis'+str(index+1):{'domain':[plot_bottom_margin(index), plot_top_margin(index)]} for index in range(num_plots)}
colors = cycle(px.colors.qualitative.Plotly[:num_files])

smoothed_spectra_label_x_loc = args.smoothed_spectra_label_x_loc
smoothed_spectra_label_y_loc = args.smoothed_spectra_label_y_loc if args.smoothed_spectra_label_y_loc is not None else args.smoothed_plot_height / 2

stick_spectra_label_x_loc = args.stick_spectra_label_x_loc
stick_spectra_label_y_loc = args.stick_spectra_label_y_loc if args.stick_spectra_label_y_loc is not None else args.smoothed_plot_height  + (1-args.smoothed_plot_height)/2


fig = make_subplots(rows=num_plots, cols=1, start_cell="bottom-left", shared_xaxes=True, subplot_titles=[], vertical_spacing=args.interplot_distance)
fig.update_layout(plot_margins,
                  showlegend=True,
                  height=args.overall_plot_height,
                  font=dict(family=args.font_name, size=args.font_size, color=args.text_color),
                  margin=dict(l=args.left_margin, r=args.right_margin, t=args.top_margin, b=args.bottom_margin)
                 )

#Plot the individual smoothed data curves
for index, curve in enumerate( smoothed_data ):
    fig.add_trace(go.Scatter(x=smooth_x_values, y=curve, mode='lines', line=dict(color=next(colors),width=3), name=plot_labels[index] ), row=1, col=1)

#Plot the individual stick spectra
for index, data in enumerate(stick_spectra_data):
    x_values = data[x_column]
    y_values = data[y_column]
    fig.add_trace(go.Scatter(x=x_values, y=y_values,mode='lines', line=dict(color=next(colors),width=3), showlegend=False), row=index+2,col=1)

#Set the legend at the bottom
fig.update_layout(legend=dict(
    orientation="h",
    yanchor="top",
    y=args.legend_y_offset,
    xanchor="left",
    x=args.legend_x_offset,
    itemsizing ='constant',
    font=dict(size=args.legend_font_size)
))

#Add x axis label if provided
if args.x_axis_label is not None:
    fig.update_layout(xaxis_title=args.x_axis_label)


#Add smoothed and stick plot y axis labels
#This doesn't work correctly when exported
#fig.add_annotation(text=args.smoothed_spectra_label,
#                  xref="paper", yref="paper",
#                  x=smoothed_spectra_label_x_loc, y=smoothed_spectra_label_y_loc, showarrow=False,textangle=-90,align='center',valign="middle")
#fig.add_annotation(text=args.stick_spectra_label,
#                  xref="paper", yref="paper",
#                 x=stick_spectra_label_x_loc, y=stick_spectra_label_y_loc, showarrow=False,textangle=-90,align='center')
#So instead we use the axis labels instead
desired_plot = num_plots//2 + num_plots%2 + 1
fig.update_layout(yaxis_title=args.smoothed_spectra_label)
fig.update_layout({f'yaxis{desired_plot}_title':args.stick_spectra_label})


#Update x/y ranges if provided
if args.x_range is not None:
    fig.update_xaxes(range=(args.x_range[0],args.x_range[-1]))
if args.smooth_y_range is not None:
    fig.update_yaxes(range=(args.smooth_y_range[0],args.smooth_y_range[-1]), row=1, col=1)
if args.stick_y_range is not None:
    for plot_row in range(2, num_plots+1):
        fig.update_yaxes(range=(args.stick_y_range[0],args.stick_y_range[-1]), row=plot_row, col=1)

#Update the x/y tics if provided
if args.x_tics is not None:
    fig.update_xaxes(tickmode = 'array', tickvals = args.x_tics)
if args.smooth_y_tics is not None:
    fig.update_yaxes(tickmode = 'array', tickvals = args.smooth_y_tics, row=1, col=1)
if args.stick_y_tics is not None:
    for plot_row in range(2, num_plots+1):
        fig.update_yaxes(tickmode = 'array', tickvals = args.stick_y_tics, row=plot_row, col=1)

fig.update_xaxes(tickfont_size=args.tics_font_size, tickfont_family=args.tics_font_name)
fig.update_yaxes(tickfont_size=args.tics_font_size, tickfont_family=args.tics_font_name)
#fig.show()
#export_html(fig, args.output_file)
fig.write_image(args.output_file)


