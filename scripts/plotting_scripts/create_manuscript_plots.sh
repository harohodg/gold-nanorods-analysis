#!/usr/bin/env bash

LOW=1.7
HIGH=4.2
STD='1.0'
HEIGHT='12000'
WIDTH='6000'
MARGIN='10'
PLOT_FONT='Helvetica,100'
TITLE_OFFSET='-2'
YLABEL_OFFSET='2'
ARB_MAX='10'


COMMON_PLOT_PARAMETERS="hpixels=${WIDTH};vpixels=${HEIGHT};left_margin=${MARGIN};plot_font='${PLOT_FONT}';plot_eV=1;low=${LOW};high=${HIGH};std=${STD};title_offset=${TITLE_OFFSET};ylabel_offset=${YLABEL_OFFSET};"
COMMON_FANCY_YLABEL='(L mol^{-1} cm^{-1})'
COMMON_FILE_NAME="${LOW}_to_${HIGH}_eV_std=${STD}"

PLOT_TYPES=('CD spectra' 'AVCD spectra' 'AB spectra')
FILENAME_PREFIXES=('CD_Spectra' 'AVCD_Spectra' 'AB_Spectra')
FILENAME_SUFFIXES=('fancy_ylabel' 'no_ylabel' 'arb_ylabel')
PLOT_PARAMETERS=('plot_AB=0;plot_abs=0;' 'plot_AB=0;plot_abs=1;' 'plot_AB=1;plot_abs=0;')
YLABEL_PREFIXES=('δε' 'abs(δε)' 'ε')
PLOT_SMOOTHED_MAX=('0' '0' "${ARB_MAX}")


echo 'Deleting previous zip files'
rm *.zip *.svg


for auto_scale in '0' '1'
do
    echo "Auto scale = ${auto_scale}"
    for ((i=0;i<${#PLOT_TYPES[@]};i++))
    do
       echo plotting "${PLOT_TYPES[i]}"

        ylabel_prefix="${YLABEL_PREFIXES[i]}"
        plot_ylabels=("${ylabel_prefix}${COMMON_FANCY_YLABEL}" '' 'arb. units')
        for ((j=0;j<${#plot_ylabels[@]};j++))
        do
           ylabel="${plot_ylabels[j]}"
           plot_parameters="arb_smoothed_max=${PLOT_SMOOTHED_MAX[j]};auto_scale=${auto_scale};${COMMON_PLOT_PARAMETERS}${PLOT_PARAMETERS[i]};desired_ylabel='${ylabel}';file_name='${FILENAME_PREFIXES[i]}_${COMMON_FILE_NAME}_${FILENAME_SUFFIXES[j]}.svg'"
           gnuplot -e "${plot_parameters}" plot_manuscript_spectra.plt
        done
    done
    echo 'Zipping up plots'
    zip -r $(TZ=America/New_York date +%B_%d_%Y)_manuscript_plots-auto_scale="${auto_scale}".zip *.svg
    rm ./*.svg
done





