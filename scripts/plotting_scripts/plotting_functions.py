#!/usr/bin/env python3

import numpy as np
from io import StringIO

Se       = lambda v, delta_e : 16196.016 * v / delta_e
Sde      = lambda v, E_i, delta_e : 0.02456756 * v * E_i / delta_e
gaussian = lambda x, mu, std : np.exp( -1*( ( (x-mu)/std )**2 ) )

def export_html(figure, fname):
    PRE_TEXT  ='{"responsive": true}'
    POST_TEXT ='{"responsive": true, modeBarButtonsToRemove: ["toImage", "sendDataToCloud"], modeBarButtonsToAdd: [{name: "download as SVG", icon: Plotly.Icons.camera, click: function(gd) { Plotly.downloadImage(gd, {format: "svg"}) } }] } '

    tmp_file = StringIO()
    figure.write_html(tmp_file,include_plotlyjs='cdn', include_mathjax='cdn')

    tmp_file.seek(0)
    updated_html = tmp_file.read().replace(PRE_TEXT, POST_TEXT)
    with open(fname, 'w') as html_file:
        html_file.write( updated_html )
    tmp_file.close()

def get_plot_margins( smoothed_plot_height, interplot_distance, num_stick_plots ):
    stick_spectra_plot_height = (1 - smoothed_plot_height - interplot_distance*num_stick_plots)/num_stick_plots
    plot_bottom_margin = lambda plot_index : 0                    if plot_index == 0 else smoothed_plot_height + interplot_distance +(plot_index -1)*(interplot_distance + stick_spectra_plot_height)
    plot_top_margin    = lambda plot_index : smoothed_plot_height if plot_index == 0 else smoothed_plot_height +    plot_index*(interplot_distance + stick_spectra_plot_height)
    return plot_bottom_margin, plot_top_margin
