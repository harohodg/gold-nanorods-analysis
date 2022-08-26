#!/usr/bin/env bash

LOW=1.7
HIGH=4.2
MIN_STD=0.2
DELTA_STD=0.2
NUM_STD=4
HEIGHT='12000'
WIDTH='6000'
MARGIN='10'
PLOT_FONT='Helvetica,100'
TITLE_OFFSET='-2'
YLABEL_OFFSET='2'

COMMON_PLOT_PARAMETERS="auto_scale=0;min_std=${MIN_STD};delta_std=${DELTA_STD};num_std=${NUM_STD};hpixels=${WIDTH};vpixels=${HEIGHT};left_margin=${MARGIN};plot_font='${PLOT_FONT}';plot_eV=1;low=${LOW};high=${HIGH};title_offset=${TITLE_OFFSET};ylabel_offset=${YLABEL_OFFSET};"
COMMON_FANCY_YLABEL='(L mol^{-1} cm^{-1})'
COMMON_FILE_NAME="${LOW}_to_${HIGH}_eV_multi_std"

PLOT_TYPES=('CD spectra' 'AVCD spectra' 'AB spectra')
FILENAME_PREFIXES=('CD_Spectra' 'AVCD_Spectra' 'AB_Spectra')
FILENAME_SUFFIXES=('fancy_ylabel' 'no_ylabel' 'arb_ylabel')
PLOT_PARAMETERS=('plot_AB=0;plot_abs=0;' 'plot_AB=0;plot_abs=1;' 'plot_AB=1;plot_abs=0;')
YLABEL_PREFIXES=('δε' 'abs(δε)' 'ε')


echo 'Deleting previous svg/zip files'
rm *.svg *.zip



for ((i=0;i<${#PLOT_TYPES[@]};i++))
do
   echo plotting "${PLOT_TYPES[i]}"

    ylabel_prefix="${YLABEL_PREFIXES[i]}"
    plot_ylabels=("${ylabel_prefix}${COMMON_FANCY_YLABEL}" '' 'arb. units')
    for ((j=0;j<${#plot_ylabels[@]};j++))
    do
       ylabel="${plot_ylabels[j]}"
       plot_parameters="${COMMON_PLOT_PARAMETERS}${PLOT_PARAMETERS[i]};desired_ylabel='${ylabel}';file_name='${FILENAME_PREFIXES[i]}_${COMMON_FILE_NAME}_${FILENAME_SUFFIXES[j]}.svg'"
       gnuplot -e "${plot_parameters}" plot_supplementary_spectra.plt
    done
done
echo 'Zipping up plots'
zip -r $(TZ=America/New_York date +%B_%d_%Y)_supplementary_plots.zip *.svg
rm ./*.svg



