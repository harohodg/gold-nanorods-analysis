#!/usr/bin/env bash

LOW=1.7
HIGH=4.2
MIN_STD=0.2
DELTA_STD=0.2
NUM_STD=4

echo 'Deleting previous svg/zip files'
rm *.svg *.zip


echo 'CD multi std spectra'
gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=0;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='δε(L mol^{-1} cm^{-1})';file_name='CD_Spectra_${LOW}_to_${HIGH}_eV_multi_std_fancy_ylabel.svg'" plot_supplementary_spectra.plt

gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=0;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='';file_name='CD_Spectra_${LOW}_to_${HIGH}_eV_multi_std_no_ylabel.svg'" plot_supplementary_spectra.plt

gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=0;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='arb. units';file_name='CD_Spectra_${LOW}_to_${HIGH}_eV_multi_std_arb_ylabel.svg'" plot_supplementary_spectra.plt



echo 'AVCD multi std spectra'
gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=1;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='abs(δε)(L mol^{-1} cm^{-1})';file_name='AVCD_Spectra_${LOW}_to_${HIGH}_eV_multi_std_fancy_ylabel.svg'" plot_supplementary_spectra.plt

gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=1;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='';file_name='AVCD_Spectra_${LOW}_to_${HIGH}_eV_multi_std_no_ylabel.svg'" plot_supplementary_spectra.plt

gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=1;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='arb. units';file_name='AVCD_Spectra_${LOW}_to_${HIGH}_eV_multi_std_arb_ylabel.svg'" plot_supplementary_spectra.plt


echo 'AB multi std spectra'
gnuplot -e "plot_eV=1;plot_AB=1;plot_abs=0;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='ε(L mol^{-1} cm^{-1})';file_name='AB_Spectra_${LOW}_to_${HIGH}_eV_multi_std_fancy_ylabel.svg'" plot_supplementary_spectra.plt

gnuplot -e "plot_eV=1;plot_AB=1;plot_abs=0;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='';file_name='AB_Spectra_${LOW}_to_${HIGH}_eV_multi_std_no_ylabel.svg'" plot_supplementary_spectra.plt

gnuplot -e "plot_eV=1;plot_AB=1;plot_abs=0;low=$LOW;high=$HIGH;min_std=$MIN_STD;delta_std=$DELTA_STD;num_std=$NUM_STD;desired_ylabel='arb. units';file_name='AB_Spectra_${LOW}_to_${HIGH}_eV_multi_std_arb_ylabel.svg'" plot_supplementary_spectra.plt

echo 'Zipping up plots'
zip -r $(date +%B_%d_%Y)_supplementary_plots.zip *.svg