import sys
from subprocess import call

filepath = 'cat.ppm'
output = open("cat-stripped.ppm","w")
fileFormat = ""
dims = ""
maxVal = ""
with open(filepath) as fp:  
	fileFormat = fp.readline()
	dims = fp.readline()
	maxVal = fp.readline()
	line = fp.readline()
	while line:
		output.write(line)
		line = fp.readline()
effect = sys.argv[1] 
call(['sh', './testall.sh', './tests/demo-' + effect + '.num'])
with open('cat-check-' + effect + '.ppm', 'r') as original: data = original.read()
with open('cat-check-' + effect + '.ppm', 'w') as modified: modified.write(fileFormat + dims + maxVal + data)

