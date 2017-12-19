from subprocess import call

filepath = 'burger.ppm'
output = open("burger-stripped.ppm","w")
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
call(['sh', './testall.sh', './tests/demo-edge-burger.num'])
with open('burger-check-edge.ppm', 'r') as original: data = original.read()
with open('burger-check-edge.ppm', 'w') as modified: modified.write(fileFormat + dims + maxVal + data)

