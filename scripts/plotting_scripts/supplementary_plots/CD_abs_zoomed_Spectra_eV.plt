#Plot parameters - Edit these to change plot

eV_column=1
nm_column=2
AB_column=3
CD_column=7

std=1
root_folder='..'
file_name=sprintf('CD_abs_zoomed_Spectra_ev_multi_std.png')

num_samples=1000
vpixels=1080
hpixels=1920
xcolumn=eV_column
ycolumn=AB_column

title_offset=-3.5
line_thickness=3

low=1.7
high=4.1

xmax= 6

bottom_margin = 0.1
top_margin    = 0.005
gap           = 0.01
num_plots     = 4
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
std=0.2
function(i, file, std)=sprintf("<  if [ -f '%s' ];then awk  'function abs(v) {return v < 0 ? -v : v} BEGIN{ORS=\" \";print \"f%d(x)=0\"}NR>1&&$1>=1.70&&$1<=4.10{print \" + Sde(\"  abs($7)  \",\" $1 \", %.2f ) * gaussian(x, \" $1 \", %.2f) \" }' %s;else echo 'f%d(x)=0';fi", file, i, std, std, file, i)

#Gaussian functions of the form fi(x)=0+gaussian(x,a,b,s)+guassian(x,c,d,s)...
#where a,b,c,d etc are from the data file

set lmargin 20
set rmargin 20
set samples num_samples
set terminal pngcairo size vpixels,hpixels enhanced font 'Verdana,10'
set xrange [0:xmax]
set output file_name
set title font "Helvetica,20"
set tics font "Helvetica,15"
set ylabel font "Helvetica,20"
set xlabel font "Helvetica,20"
set key font "Helvetica,20"

set multiplot layout num_plots ,1 columnsfirst upwards
#set tmargin 1          # switch off the top axis


#set arrow 1 from 1.7, graph 1 to 1.7, graph 0
#set arrow 2 from 4.1, graph 0 to 4.1, graph 1
#set key top left Right
set key below
#set title "Smoothed Absorbance Spectra" offset 0,title_offset
set title 'std 0.02'
#set title printf('%.2d eV', std)
set xlabel "eV"
set ylabel "abs(δε)(L mol^{-1} cm^{-1})" offset -4,0


#Get stats so we can label max peak location
##########################################
max(x,y) = (x > y) ? x : y
SCALE_MAX=0
set table 'stats.dat'



do for [i=1:4] {
    std=i*0.2
    load function(1, data_file1, std)
    load function(2, data_file2, std)
    load function(3, data_file3, std)
    load function(4, data_file4, std)
    load function(5, data_file5, std)

    plot  \
    f1(x) lw line_thickness title smoothed_plot_1_title, \
    f2(x) lw line_thickness title smoothed_plot_2_title, \
    f3(x) lw line_thickness title smoothed_plot_3_title, \
    f4(x) lw line_thickness title smoothed_plot_4_title, \
    f5(x) lw line_thickness title smoothed_plot_5_title, \
    0 title ''
    SCALE_MAX=max(GPVAL_Y_MAX,SCALE_MAX)
}

unset table
system("rm stats.dat")

###################Plot raw data so we can set scale#######################
#set table 'stats.dat'
#plot data_file1 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses, \
#data_file2 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses, \
#data_file3 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses, \
#data_file4 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses, \
#data_file5 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses
#unset table
#stats 'stats.dat' nooutput
#MAX=GPVAL_Y_MAX
#MIN=0
#system("rm stats.dat")




##########################################
ntics = 4
#set ytics 0,50000,250000
set yrange [0:SCALE_MAX*1.05]
#set bmargin at screen get_bmargin(1)
set tmargin at screen get_tmargin(1)
plot_title=sprintf('std=%.2f', std)
set title plot_title offset 0,title_offset
#Plot Smoothed plot
plot  \
f1(x) lw line_thickness title smoothed_plot_1_title, \
f2(x) lw line_thickness title smoothed_plot_2_title, \
f3(x) lw line_thickness title smoothed_plot_3_title, \
f4(x) lw line_thickness title smoothed_plot_4_title, \
f5(x) lw line_thickness title smoothed_plot_5_title, \
0 title ''

unset key
unset xtics
unset ylabel
unset xlabel
set bmargin 0

do for [i=2:4] {
    std=1-i*0.2

    load function(1, data_file1, std)
    load function(2, data_file2, std)
    load function(3, data_file3, std)
    load function(4, data_file4, std)
    load function(5, data_file5, std)

    set bmargin at screen get_bmargin(i)
    set tmargin at screen get_tmargin(i)
    plot_title=sprintf('std=%.2f', std)
    set title plot_title offset 0,title_offset
    plot  \
    f1(x) lw line_thickness title smoothed_plot_1_title, \
    f2(x) lw line_thickness title smoothed_plot_2_title, \
    f3(x) lw line_thickness title smoothed_plot_3_title, \
    f4(x) lw line_thickness title smoothed_plot_4_title, \
    f5(x) lw line_thickness title smoothed_plot_5_title, \
    0 title ''

}



#unset arrow 1
#unset arrow 2
#set format x ""        # ... and eliminate tic labels for the x-axis

#Raw data plots
######################
#unset xtics
#unset ylabel
#unset xlabel
#set bmargin 0
#set yrange [0:MAX*1.05]


#set bmargin at screen get_bmargin(2)
#set tmargin at screen get_tmargin(2)
#set title plot_1_title offset 0,title_offset
#plot data_file1 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses

#set bmargin at screen get_bmargin(3)
#set tmargin at screen get_tmargin(3)
#set title plot_2_title offset 0,title_offset
#plot data_file2 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses

#set bmargin at screen get_bmargin(4)
#set tmargin at screen get_tmargin(4)
#set title plot_3_title offset 0,title_offset
#plot data_file3 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses

#set bmargin at screen get_bmargin(5)
#set tmargin at screen get_tmargin(5)
#set title plot_4_title offset 0,title_offset
#plot data_file4 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses

#set bmargin at screen get_bmargin(6)
#set tmargin at screen get_tmargin(6)
#set title plot_5_title offset 0,title_offset
#plot data_file5 using  (column(xcolumn)):((column(xcolumn) >= low && column(xcolumn) <= high ? (column(ycolumn)) : 1/0)) with impulses



unset multiplot
