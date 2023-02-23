#!/usr/bin/env bash

TOP_MARGIN='0'

#MANUSCRIPT PLOTS
##Miepy plots
echo 'Manuscript Miepy AB'
python3 plot_miepy_max_wavelengths.py \
'--min_numerator=1' \
'--max_numerator=11' \
'--y_range' ' 515' '570' \
'--y_tics' '520' '530' '540' '550' '560' \
'--spectra_type' 'AB' \
'--plot_title' 'AB Max Wavelength/Energy' \
'--output_file' 'miepy_AB_plot.svg' \
'../miepy_results'


echo 'Manuscript Miepy CD'
python3 plot_miepy_max_wavelengths.py \
'--min_numerator=1' \
'--max_numerator=11' \
'--y_range'  '540' '570' \
'--y_tics' '545' '550' '555' '560' '565' \
'--spectra_type' 'CD' \
'--plot_title' 'CD Max Wavelength/Energy' \
'--output_file' 'miepy_CD_plot.svg' \
'../miepy_results'


#AB Spectra, scale adjusted to max = 10
echo 'Manuscript AB Spectra'
python3 plot_manuscript_spectra.py \
'--output_file' 'manuscript_AB_spectra.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--plot_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smooth_max_y' 10 \
'--stick_max_y' 10 \
'--smooth_y_range' 0 15 \
'--smooth_y_tics' 0 5 10 \
'--stick_y_range' 0 15 \
'--stick_y_tics' 0 5 10 \
'--smoothed_spectra_label' 'Smoothed AB Spectra<br>(arb. units)' \
'--stick_spectra_label' 'Stick AB Spectra (arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'Absorbance(f)' \
'--smooth_line_width' 4 \
'--stick_line_width' 6 \
'--top_margin' ${TOP_MARGIN} \
'--font_name' 'Times New Roman' \
'--tics_font_name' 'Times New Roman' \


#CD Spectra, scale adjusted to max = 10
echo 'Manuscript CD Spectra'
python3 plot_manuscript_spectra.py \
'--output_file' 'manuscript_CD_spectra.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--plot_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smooth_min_y' -10 \
'--smooth_max_y' 10 \
'--stick_min_y' -10 \
'--stick_max_y' 10 \
'--smooth_y_range' -15 15 \
'--smooth_y_tics' -10 -5 0 5 10 \
'--stick_y_range' -15 15 \
'--stick_y_tics' -10 -5 0 5 10 \
'--smoothed_spectra_label' 'Smoothed CD Spectra<br>(arb. units)' \
'--stick_spectra_label' 'Stick CD Spectra (arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'R(length)' \
'--smooth_line_width' 4 \
'--stick_line_width' 6 \
'--top_margin' ${TOP_MARGIN} \
'--font_name' 'Times New Roman' \
'--tics_font_name' 'Times New Roman' \

#AVCD Spectra, scale adjusted to max = 10
echo 'Manuscript AVCD Spectra'
python3 plot_manuscript_spectra.py \
'--output_file' 'manuscript_AVCD_spectra.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--plot_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smooth_max_y' 10 \
'--stick_max_y' 10 \
'--smooth_y_range' 0 15 \
'--smooth_y_tics' 0 5 10 \
'--stick_y_range' 0 15 \
'--stick_y_tics' 0 5 10 \
'--smoothed_spectra_label' 'Smoothed AVCD Spectra<br>(arb. units)' \
'--stick_spectra_label' 'Stick AVCD Spectra (arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'R(length)' \
'--smooth_line_width' 4 \
'--stick_line_width' 6 \
'--plot_abs' \
'--top_margin' ${TOP_MARGIN} \
'--font_name' 'Times New Roman' \
'--tics_font_name' 'Times New Roman' \


#SUPPLEMENTARY PLOTS

#AB Spectra, smooth scale adjusted to max = 10, stick spectra same range, auto max
echo 'SI AB auto-max Spectra'
python3 plot_manuscript_spectra.py \
'--output_file' 'supplementary_AB_spectra-auto_max.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--plot_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smoothed_spectra_label' 'Smoothed AB Spectra<br>(arb. units)' \
'--stick_spectra_label' 'Stick AB Spectra (arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'Absorbance(f)' \
'--smooth_line_width' 4 \
'--stick_line_width' 6 \
'--smooth_max_y' 10 \
'--smooth_y_range' 0 15 \
'--smooth_y_tics' 0 5 10 \
'--stick_y_range' 0 2.5 \
'--stick_y_tics' 0 1 2 \
'--smoothed_spectra_label_x_loc' -0.04 \
'--stick_spectra_label_x_loc'    -0.04 \
'--top_margin' ${TOP_MARGIN} \
'--font_name' 'Times New Roman' \
'--tics_font_name' 'Times New Roman' \

#CD Spectra, smooth scale adjusted to max = 10, stick spectra same range, auto max
echo 'SI CD auto-max Spectra'
python3 plot_manuscript_spectra.py \
'--output_file' 'supplementary_CD_spectra-auto_max.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--plot_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smoothed_spectra_label' 'Smoothed CD Spectra<br>(arb. units)' \
'--stick_spectra_label' 'Stick CD Spectra (arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'R(length)' \
'--smooth_line_width' 4 \
'--stick_line_width' 6 \
'--smooth_min_y' -10 \
'--smooth_max_y' 10 \
'--smooth_y_range' -15 15 \
'--smooth_y_tics' -10 -5 0 5 10 \
'--stick_y_range' -300 300 \
'--stick_y_tics' -300 -200 -100 0 100 200 300 \
'--smoothed_spectra_label_x_loc' -0.04 \
'--stick_spectra_label_x_loc'    -0.04 \
'--interplot_distance' 0.015 \
'--top_margin' ${TOP_MARGIN} \
'--font_name' 'Times New Roman' \
'--tics_font_name' 'Times New Roman' \

#AVCD Spectra, smooth scale adjusted to max = 10, stick spectra same range, auto max
echo 'SI AVCD auto-max Spectra'
python3 plot_manuscript_spectra.py \
'--output_file' 'supplementary_AVCD_spectra-auto_max.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--plot_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smoothed_spectra_label' 'Smoothed AVCD Spectra<br>(arb. units)' \
'--stick_spectra_label' 'Stick AVCD Spectra (arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'R(length)' \
'--smooth_line_width' 4 \
'--stick_line_width' 6 \
'--plot_abs' \
'--smoothed_spectra_label_x_loc' -0.04 \
'--stick_spectra_label_x_loc'    -0.04 \
'--smooth_max_y' 10 \
'--smooth_y_range' 0 15 \
'--smooth_y_tics' 0 5 10 \
'--stick_y_range' 0 350 \
'--stick_y_tics' 0 100 200 300 \
'--top_margin' ${TOP_MARGIN} \
'--font_name' 'Times New Roman' \
'--tics_font_name' 'Times New Roman' \

#AB with variable gaussian smoothing
echo 'SI AB variable smoothing Spectra'
python3 plot_supplementary_spectra.py \
'--output_file' 'supplementary_AB_spectra-variable_smoothing.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--data_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smoothed_spectra_label' 'Smoothed AB Spectra<br>(arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'Absorbance(f)' \
'--smooth_line_width' 4 \
'--smooth_max_y' 10 \
'--smooth_y_range' 0 15 \
'--smooth_y_tics' 0 5 10 \
'--gaussian_std' 0.2 0.4 0.6 0.8  1.0 \
'--plot_titles' '0.2 eV' '0.4 eV' '0.6 eV' '0.8 eV' '1.0 eV' \
'--top_margin' ${TOP_MARGIN} \
'--font_name' 'Times New Roman' \
'--tics_font_name' 'Times New Roman' \

#CD with variable gaussian smoothing
echo 'SI CD variable smoothing Spectra'
python3 plot_supplementary_spectra.py \
'--output_file' 'supplementary_CD_spectra-variable_smoothing.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--data_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smoothed_spectra_label' 'Smoothed CD Spectra<br>(arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'R(length)' \
'--smooth_line_width' 4 \
'--smooth_min_y' -10 \
'--smooth_max_y' 10 \
'--smooth_y_range' -15 15 \
'--smooth_y_tics' -10 -5 0 5 10 \
'--gaussian_std' 0.2 0.4 0.6 0.8  1.0 \
'--plot_titles' '0.2 eV' '0.4 eV' '0.6 eV' '0.8 eV' '1.0 eV' \
'--top_margin' ${TOP_MARGIN} \


#AVCD with variable gaussian smoothing
echo 'SI AVCD variable smoothing Spectra'
python3 plot_supplementary_spectra.py \
'--output_file' 'supplementary_AVCD_spectra-variable_smoothing.svg' \
'--spectra_files' '../Au24_264states_Spectra.txt' '../Au32_224states_Spectra.txt' '../Au40_800states_Spectra.txt' '../Au48_432states_Spectra.txt' '../Au56_392states_Spectra.txt' \
'--data_labels' 'Au<sub>24</sub>' 'Au<sub>32</sub>' 'Au<sub>40</sub>' 'Au<sub>48</sub>' 'Au<sub>56</sub>' \
'--min_x' 1.7 \
'--max_x' 4.2 \
'--x_range' 0 6 \
'--x_tics' 0 1 2 3 4 5 6 \
'--smoothed_spectra_label' 'Smoothed AVCD Spectra<br>(arb. units)' \
'--x_axis_label' 'E(eV)' \
'--overall_plot_height' 1800 \
'--y_axis' 'R(length)' \
'--smooth_line_width' 4 \
'--plot_abs' \
'--smooth_max_y' 10 \
'--smooth_y_range' 0 15 \
'--smooth_y_tics' 0 5 10 \
'--gaussian_std' 0.2 0.4 0.6 0.8  1.0 \
'--plot_titles' '0.2 eV' '0.4 eV' '0.6 eV' '0.8 eV' '1.0 eV' \
'--top_margin' ${TOP_MARGIN} \
'--font_name' 'Times New Roman' \
'--tics_font_name' 'Times New Roman' \