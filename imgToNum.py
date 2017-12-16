from PIL import Image

im = Image.open("cat.jpg")
im.save("cat.ppm")

filepath = 'cat.ppm'
output = open("cat-stripped.ppm","w")
with open(filepath) as fp:  
	fileFormat = fp.readline()
	dims = fp.readline()
	maxVal = fp.readline()
	line = fp.readline()
	while line:
		output.write(line)
		line = fp.readline()
