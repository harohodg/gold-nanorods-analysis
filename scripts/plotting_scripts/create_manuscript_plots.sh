#!/usr/bin/env bash

LOW=1.7
HIGH=4.2
STD='0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0'

echo 'Deleting previous svg/zip files'
rm *.svg *.zip

echo 'CD spectra'
for std in ${STD}
do
    gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=0;low=$LOW;high=$HIGH;std=$std;desired_ylabel='δε(L mol^{-1} cm^{-1})';file_name='CD_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_fancy_ylabel.svg'" plot_manuscript_spectra.plt

    gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=0;low=$LOW;high=$HIGH;std=$std;desired_ylabel='';file_name='CD_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_no_ylabel.svg'" plot_manuscript_spectra.plt

    gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=0;low=$LOW;high=$HIGH;std=$std;desired_ylabel='arb. units';file_name='CD_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_arb_ylabel.svg'" plot_manuscript_spectra.plt
done


echo 'AVCD spectra'
for std in ${STD}
do
    gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=1;low=$LOW;high=$HIGH;std=$std;desired_ylabel='abs(δε)(L mol^{-1} cm^{-1})';file_name='AVCD_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_fancy_ylabel.svg'" plot_manuscript_spectra.plt

    gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=1;low=$LOW;high=$HIGH;std=$std;desired_ylabel='';file_name='AVCD_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_no_ylabel.svg'" plot_manuscript_spectra.plt

    gnuplot -e "plot_eV=1;plot_AB=0;plot_abs=1;low=$LOW;high=$HIGH;std=$std;desired_ylabel='arb. units';file_name='AVCD_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_arb_ylabel.svg'" plot_manuscript_spectra.plt
done


echo 'AB spectra'
for std in ${STD}
do
    gnuplot -e "plot_eV=1;plot_AB=1;plot_abs=0;low=$LOW;high=$HIGH;std=$std;desired_ylabel='ε(L mol^{-1} cm^{-1})';file_name='AB_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_fancy_ylabel.svg'" plot_manuscript_spectra.plt

    gnuplot -e "plot_eV=1;plot_AB=1;plot_abs=0;low=$LOW;high=$HIGH;std=$std;desired_ylabel='';file_name='AB_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_no_ylabel.svg'" plot_manuscript_spectra.plt

    gnuplot -e "plot_eV=1;plot_AB=1;plot_abs=0;low=$LOW;high=$HIGH;std=$std;desired_ylabel='arb. units';file_name='AB_Spectra_${LOW}_to_${HIGH}_eV_std=${std}_arb_ylabel.svg'" plot_manuscript_spectra.plt
done

echo 'Zipping up plots'
zip -r $(date +%B_%d_%Y)_manuscript_plots.zip *.svg