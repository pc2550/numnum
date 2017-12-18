from PIL import Image
from subprocess import call

im = Image.open("cat.jpg")
im.save("cat.ppm")

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
call(['sh', './testall.sh', './tests/test-demo.num'])
with open('cat-check.ppm', 'r') as original: data = original.read()
with open('cat-check.ppm', 'w') as modified: modified.write(fileFormat + dims + maxVal + data)

