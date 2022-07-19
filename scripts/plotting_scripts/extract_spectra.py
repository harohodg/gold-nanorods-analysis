#!/usr/bin/env python3

'''
Code to extract Absorbance and CD spectra from Gaussian 09 log files

Usage
./extract_spectra [input_file=./*.log] [output_file=./Spectra.txt]
'''

import re, sys
from os.path import isfile, dirname
from glob import glob


AB_REGEX = r'''Excited\sState\s+(?P<excited_state_ab>\d+):#Absorbance Excited state #
.*?(?P<ev>[-+]?[0-9]*\.?[0-9]+)\seV#eV value
\s+(?P<nm>[-+]?[0-9]*\.?[0-9]+)\snm#nm value
\s+f=(?P<f>[-+]?[0-9]*\.?[0-9]+)#f  value
\s+<S\*\*2>=(?P<s_squared>[-+]?[0-9]*\.?[0-9]+)#S**2 value
'''

R_VELOCITY_REGEX = r'''\s+(?P<excited_state_velocity>\d+)\s+#excited state
(?P<XX_velocity>[-+]?[0-9]*\.?[0-9]+)\s+#XX
(?P<YY_velocity>[-+]?[0-9]*\.?[0-9]+)\s+#YY
(?P<ZZ_velocity>[-+]?[0-9]*\.?[0-9]+)\s+#ZZ
(?P<R_velocity>[-+]?[0-9]*\.?[0-9]+)\s+#R(velocity)
(?P<EM_angle>[-+]?[0-9]*\.?[0-9]+)$#E-M Angle'''

R_VELOCITY_DATA_REGEX = r'''^\s+state\s+XX\s+YY\s+ZZ\s+R\(velocity\)\s+E-M\s+Angle$
(
{}
)+'''.format(R_VELOCITY_REGEX)


R_LENGTH_REGEX = r'''\s+(?P<excited_state_length>\d+)\s+#excited state
(?P<XX_length>[-+]?[0-9]*\.?[0-9]+)\s+#XX
(?P<YY_length>[-+]?[0-9]*\.?[0-9]+)\s+#YY
(?P<ZZ_length>[-+]?[0-9]*\.?[0-9]+)\s+#ZZ
(?P<R_length>[-+]?[0-9]*\.?[0-9]+)$#R(length)'''

R_LENGTH_DATA_REGEX = r'''^\s+state\s+XX\s+YY\s+ZZ\s+R\(length\)$
(
{}
)+
''' .format(R_LENGTH_REGEX)


HEADER = '{:>15}{:>15}{:>15}{:>15}{:>15}{:>15}{:>15}{:>15}{:>15}{:>15}{:>15}'.format('eV', 'nm', 'Absorbance(f)', 'XX(length)', 'YY(length)', 'ZZ(length)', 'R(length)', 'XX(velocity)', 'YY(velocity)', 'ZZ(velocity)', 'R(velocity)' )
LINE   = '{ev:>15.4f}{nm:>15.4f}{f:>15.4f}{XX_length:>15.4f}{YY_length:>15.4f}{ZZ_length:>15.4f}{R_length:>15.4f}{XX_velocity:>15.4f}{YY_velocity:>15.4f}{ZZ_velocity:>15.4f}{R_velocity:>15.4f}'

#Set input and output files
input_file  = sys.argv[1] if len(sys.argv) > 1 else glob('./*.log')[0]
output_file = sys.argv[2] if len(sys.argv) > 2 else '{}/Spectra.txt'.format( dirname(input_file) )

if isfile(input_file):
	with open(input_file, 'r') as f:
		input_data = f.read()
		
	CD_velocity_data = re.search(R_VELOCITY_DATA_REGEX, input_data, re.MULTILINE | re.VERBOSE | re.DOTALL)
	CD_length_data   = re.search(R_LENGTH_DATA_REGEX, input_data, re.MULTILINE | re.VERBOSE | re.DOTALL)
	
	try:
		assert CD_velocity_data is not None, 'Unable find CD R(velocity) Data'
		assert CD_length_data is not None,   'Unable find CD R(length) Data'

		Absorbance_results  = re.findall(AB_REGEX, input_data, re.MULTILINE | re.VERBOSE | re.DOTALL )
		CD_velocity_results = re.findall(R_VELOCITY_REGEX, CD_velocity_data.group(0), re.MULTILINE | re.VERBOSE | re.DOTALL )
		CD_length_results   = re.findall(R_LENGTH_REGEX, CD_length_data.group(0), re.MULTILINE | re.VERBOSE | re.DOTALL )
		
		assert len(Absorbance_results)  != [], 'No absorbance data found'
		assert len(CD_velocity_results) != [], 'No CD(velocity) results extracted'
		assert len(CD_length_results)   != [], 'No CD(length) results extracted'
		
		assert len(Absorbance_results) != 0, 'No absorbance data found'
		assert len(Absorbance_results) == len(CD_velocity_results) and len(CD_velocity_results) == len(CD_length_results), 'Number of AB({}) and CD(length={},velocity={}) states found not equal'.format(len(Absorbance_results), len(CD_length_results),len(CD_velocity_results) )
		
	
		with open(output_file, 'w') as f:
			print(HEADER, file=f)
			for index, ab_match in enumerate(Absorbance_results):
				cd_length_match   = CD_length_results[index]
				cd_velocity_match = CD_velocity_results[index]
				
				line_data = {}
				line_data['ev'] = float(ab_match[1])
				line_data['nm'] = float(ab_match[2])
				line_data['f']  = float(ab_match[3])
				line_data['XX_length'] = float(cd_length_match[1])
				line_data['YY_length'] = float(cd_length_match[2])
				line_data['ZZ_length'] = float(cd_length_match[3])
				line_data['R_length']  = float(cd_length_match[4])
				line_data['XX_velocity'] = float(cd_velocity_match[1])
				line_data['YY_velocity'] = float(cd_velocity_match[2])
				line_data['ZZ_velocity'] = float(cd_velocity_match[3])
				line_data['R_velocity']  = float(cd_velocity_match[4])

				print( LINE.format( **line_data), file=f )
				
	except Exception as e:
		sys.stderr.write( str(e) )
		sys.stderr.write('\n')
		sys.exit(2)
		
	
else:
	sys.stderr.write( '{} not found'.format(input_file) )
	sys.exit(1)
