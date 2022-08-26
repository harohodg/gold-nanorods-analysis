#Plot parameters - Edit these to change plot
#Still hard coded for spectra files and plot titles

eV_column=1
nm_column=2
AB_column=3
CD_column=7

#Determine what we are plotting
#If not told otherwise will be AB spectra with eV xaxis
if (!exists("plot_eV"))  plot_eV=1
if (!exists("plot_AB"))  plot_AB=1
if (!exists("plot_abs")) plot_abs=0

#Determine where to look for files
#What axis labels to use
#What filename to use
if (!exists("min_std")) min_std=0.2
if (!exists("delta_std")) delta_std=0.2
if (!exists("num_std")) num_std=4

#Determine where to look for files
#What axis labels to use
#What filename to use
if (!exists("std"))            std=1.0
if (!exists("root_folder"))    root_folder='..'
if (!exists("desired_xlabel")) desired_xlabel= plot_eV != 0 ? 'E (eV)' : 'λ (nm)'
if (!exists("desired_ylabel")) desired_ylabel= plot_AB != 0 ? 'ε(L mol^{-1} cm^{-1})' : plot_abs != 0 ? 'abs(δε)(L mol^{-1} cm^{-1})' : 'δε(L mol^{-1} cm^{-1})'
if (!exists("xmax")) xmax=6
if (!exists("low"))  low=0
if (!exists("high")) high=10*xmax

plot_type  = plot_AB != 0 ? 'AB' : plot_abs != 0 ? 'AVCD' :'CD'
plot_xaxis = plot_eV != 0 ? 'eV' : 'nm'
if (!exists("file_name")) file_name=sprintf('%s_Spectra_%.2f_to_%.2f_%s_std=%.2f.svg',plot_type,low,high,plot_xaxis, std)
plot_title = sprintf('Smoothed %s Spectra', plot_type)


if (!exists("num_samples")) num_samples=1000
if (!exists("vpixels"))     vpixels=6000
if (!exists("hpixels"))     hpixels=vpixels/2

if (!exists("left_margin"))  left_margin=5
if (!exists("right_margin")) right_margin=left_margin

if (!exists("plot_font"))   plot_font='Helvetica,100'
if (!exists("title_font"))  title_font=plot_font
if (!exists("tics_font"))   tics_font=plot_font
if (!exists("ylabel_font")) ylabel_font=plot_font
if (!exists("xlabel_font")) xlabel_font=plot_font
if (!exists("legend_font")) legend_font=plot_font


xcolumn=plot_eV != 0 ? eV_column : nm_column
ycolumn=plot_AB != 0 ? AB_column : CD_column


if (!exists("title_offset")) title_offset=0
if (!exists("ylabel_offset")) ylabel_offset=-2
if (!exists("xlabel_offset")) xlabel_offset=0
if (!exists("line_spectra_thickness")) line_spectra_thickness=1
if (!exists("smoothed_spectra_thickness")) smoothed_spectra_thickness=5



bottom_margin = 0.1
top_margin    = 0.005
gap           = 0.01
num_plots     = num_std
num_gaps      = num_plots - 1
plot_1_scale  = 1.0
plot_1_height = ((1-top_margin-bottom_margin-gap*num_gaps)/num_plots)*plot_1_scale
other_plot_height = (1-plot_1_height-top_margin-bottom_margin-gap*num_gaps)/(num_plots-1)

get_bmargin(plot) = plot == 1 ? bottom_margin : bottom_margin + plot_1_height + (plot-1)*gap + (plot-2)*other_plot_height
get_tmargin(plot) = plot == 1 ? bottom_margin + plot_1_height : bottom_margin + plot_1_height + (plot-1)*gap + (plot-1)*other_plot_height



plot_1_title='Au24'
plot_2_title='Au32'
plot_3_title='Au40'
plot_4_title='Au48'
plot_5_title='Au56'

spaces='     '
smoothed_plot_1_title=sprintf('%s%s',spaces,plot_1_title)
smoothed_plot_2_title=sprintf('%s%s',spaces,plot_2_title)
smoothed_plot_3_title=sprintf('%s%s',spaces,plot_3_title)
smoothed_plot_4_title=sprintf('%s%s',spaces,plot_4_title)
smoothed_plot_5_title=sprintf('%s%s',spaces,plot_5_title)



data_file1=sprintf('%s/%s',root_folder,'Au24_264states_Spectra.txt')
data_file2=sprintf('%s/%s',root_folder,'Au32_224states_Spectra.txt')
data_file3=sprintf('%s/%s',root_folder,'Au40_800states_Spectra.txt')
data_file4=sprintf('%s/%s',root_folder,'Au48_432states_Spectra.txt')
data_file5=sprintf('%s/%s',root_folder,'Au56_392states_Spectra.txt')


#Key functions
Se(v, delta_e) = 16196.016 * v / delta_e
Sde(v, E_i, delta_e) = 0.02456756 * v * E_i / delta_e
gaussian(x,mu,std)=exp( -1*( ( (x-mu)/std )**2 ) )


function(i, file, std, low, high)=sprintf("<  if [ -f '%s' ];then awk  'function abs(v) {return v < 0 ? -v : v} BEGIN{ORS=\" \";print \"f%d(x)=0\"}NR>1&&$1>=%.2f&&$1<=%.2f{print \" + %s  * gaussian(x, \" $1 \", %.2f) \" }' %s;else echo 'f%d(x)=0';fi", file, i, low, high, targetFunction, std, file, i)


#Gaussian functions of the form fi(x)=0+gaussian(x,a,b,s)+guassian(x,c,d,s)...
#where a,b,c,d etc are from the data file

set lmargin left_margin
set rmargin right_margin
set samples num_samples
set terminal svg size hpixels,vpixels enhanced font plot_font
set xrange [0:xmax]
set output file_name
set title font  title_font
set tics font   tics_font
set ylabel font ylabel_font
set xlabel font xlabel_font
set key font    legend_font

set multiplot layout num_plots ,1 columnsfirst upwards
#set tmargin 1          # switch off the top axis



set key below
set title plot_title offset 0,title_offset
set xlabel desired_xlabel offset 0,xlabel_offset
set ylabel desired_ylabel offset ylabel_offset,0



###################Loop over all plots to get axis scales###################
max(x,y) = (x >= y) ? x : y
min(x,y) = (x < y) ? x : y

SCALE_MAX=0
SCALE_MIN=0
set table 'stats.dat'

do for [i=1:num_plots] {
    std=min_std + (i-1)*delta_std
    targetFunction=plot_AB != 0 ? sprintf('Se("$3",%.2f)', std) :  plot_abs != 0 ? sprintf('Sde("  abs($7)  "," $1 ", %.2f )', std) : sprintf('Sde("  $7  "," $1 ", %.2f )', std)

    load function(1, data_file1, std, low, high)
    load function(2, data_file2, std, low, high)
    load function(3, data_file3, std, low, high)
    load function(4, data_file4, std, low, high)
    load function(5, data_file5, std, low, high)

    plot  \
    f1(x) lw smoothed_spectra_thickness title smoothed_plot_1_title, \
    f2(x) lw smoothed_spectra_thickness title smoothed_plot_2_title, \
    f3(x) lw smoothed_spectra_thickness title smoothed_plot_3_title, \
    f4(x) lw smoothed_spectra_thickness title smoothed_plot_4_title, \
    f5(x) lw smoothed_spectra_thickness title smoothed_plot_5_title, \
    0 title ''
    SCALE_MAX=max(GPVAL_Y_MAX,SCALE_MAX)
    SCALE_MIN=min(GPVAL_Y_MIN,SCALE_MIN)
}

unset table
system("rm stats.dat")

smoothed_scale_max = max( abs(SCALE_MIN), SCALE_MAX )
smoothed_scale_min = plot_AB !=0 ? 0 : plot_abs != 0 ? 0 : -smoothed_scale_max

################Plot first dataset on it's own###############
######Which conveniently still has the last arget function defined#############33
ntics = 4
set yrange [smoothed_scale_min*1.10:smoothed_scale_max*1.10]
set tmargin at screen get_tmargin(1)
plot_title=sprintf('%.2f %s', std, plot_eV ? 'eV' : 'nm')
set title plot_title offset 0,title_offset
#Plot Smoothed plot
plot  \
f1(x) lw smoothed_spectra_thickness title smoothed_plot_1_title, \
f2(x) lw smoothed_spectra_thickness title smoothed_plot_2_title, \
f3(x) lw smoothed_spectra_thickness title smoothed_plot_3_title, \
f4(x) lw smoothed_spectra_thickness title smoothed_plot_4_title, \
f5(x) lw smoothed_spectra_thickness title smoothed_plot_5_title, \
0 title ''

unset key
unset xtics
unset ylabel
unset xlabel
set bmargin 0


####################Plot remaining datasets
do for [i=2:num_plots] {
    std=(min_std + num_std*delta_std) - i*delta_std
    targetFunction=plot_AB != 0 ? sprintf('Se("$3",%.2f)', std) :  plot_abs != 0 ? sprintf('Sde("  abs($7)  "," $1 ", %.2f )', std) : sprintf('Sde("  $7  "," $1 ", %.2f )', std)


    load function(1, data_file1, std, low, high)
    load function(2, data_file2, std, low, high)
    load function(3, data_file3, std, low, high)
    load function(4, data_file4, std, low, high)
    load function(5, data_file5, std, low, high)

    set bmargin at screen get_bmargin(i)
    set tmargin at screen get_tmargin(i)
    plot_title=sprintf('%.2f %s', std, plot_eV ? 'eV' : 'nm')
    set title plot_title offset 0,title_offset
    plot  \
    f1(x) lw smoothed_spectra_thickness title smoothed_plot_1_title, \
    f2(x) lw smoothed_spectra_thickness title smoothed_plot_2_title, \
    f3(x) lw smoothed_spectra_thickness title smoothed_plot_3_title, \
    f4(x) lw smoothed_spectra_thickness title smoothed_plot_4_title, \
    f5(x) lw smoothed_spectra_thickness title smoothed_plot_5_title, \
    0 title ''

}

unset multiplot
