/*
CT_PixLib
2020-09-20

Pix format functions library for CarmaTools
--
*/

struct colourHelper (
	val,
	
	fn R8G8D8ToColour val = (
		a = 255
		r = (bit.shift (bit.and val 0xff0000) -16) 
		g = (bit.shift (bit.and val 0xff00) -8)
		b = (bit.and val 0xff)
		dnColor c:[r,g,b] a:a
	),
	
	fn R5G6B5ToColour val = (
		a = bit.shift 255 24
		r = bit.shift (bit.and val 0xF800) 8
		g = bit.shift (bit.and val 0x7E0) 5
		b = bit.shift (bit.and val 0x1F) 3
		dnColor c:[r,g,b] a:a
	),
	
	fn A4R4G4B4ToColour val = (
		a = bit.shift (bit.and val 0xF000) -12
		r = bit.shift (bit.and val 0xF00) -8
		g = bit.shift (bit.and val 0xF0) -4
		b = bit.and val 0xF
		dnColor c:[r*17,g*17,b*17] a:a*17
	)
)

struct pixieClass (
	PixelmapFormat,
    Name,
    width,
	height,
	halfWidth,
	halfHeight,
	rowSize,
	pixelCount,
	pixelSize,
	data,
	
	fn getColorAtPixel x y pixelmapFormat= (
		colourHelper = colourHelper()
		
		colourValue = color 255 0 128
		if pixelmapFormat == 3 then (
			--
		)
		if pixelMapFormat == 5 then (
			color = ColourHelper.R5G6B5ToColour bit.shift data[x + (y * rowSize)] 8 --or bit.shift data[x + (y * rowSize) + 1]
		)
		if pixelMapFormat == 18 then (
			color = ColourHelper.A4R4G4B4ToColour bit.shift data[x + (y * rowSize)] 8 --or bit.shift data[x + (y * rowSize) + 1]
		)
	)
)

pixFile = @"D:\Games\Carma 2\Data\CARS\PSXJ220\PIX16\PSXJBAK2.PIX"

fn PixToTif pixFile tifTile = (
	if pixFile != undefined then (
		f = fopen pixFile "rb"
		
		--determine filesize
		fseek f 0 #seek_end
		filesize = ftell f 
		fseek f 0 #seek_set
		
		--read header and check
		--header1 = freadlong f
		--header2 = freadlong f
		--header3 = freadlong f
		--header4 = freadlong f
		
		if (freadlong f) != 0x12 or (freadlong f) != 0x8 or (freadlong f) != 0x2 or (freadlong f) != 0x2 then (
			print "uhoh"
		)
		pixies = #()
		
		while (ftell f < filesize)  do (
			pTag = freadLong f
			pLength = freadLong f
			
			if (ftell f + 8) > fileSize then (
				break
			)
			
			pixie = pixieClass()
			
			case pTag of 
			(
				0x03: (
					pixie = pixieClass()
					pixie.pixelmapFormat = freadByte f
					pixie.rowSize = freadShort f
					pixie.width = freadShort f
					pixie.height = freadShort f
					pixie.halfWidth = freadShort f
					pixie.halfHeight = freadShort f
					pixie.name = freadString f
				)
				0x3D: (
					pixie = pixieClass()
					pixie.pixelmapFormat = freadByte f
					pixie.rowSize = freadShort f
					pixie.width = freadShort f
					pixie.height = freadShort f
					
					for i=1 to 6 do freadByte f
					
					pixie.name = freadString f
					
				)
				0x21: (
					pixelCount = freadLong f
					pixelSize = freadLong f
					pixie.data = for i=1 to pixelCount collect freadByte f
				)
				0x22: (
				)
				0x00: (
					append pixies pixie
				)
			)
		)
		fclose f
		
		colourHelper = colourHelper()
		
		for pixie in pixies do (
			print pixie.width
			bm = bitmap pixie.width pixie.height
			for y=1 to pixie.height do (
				for x=1 to pixie.width do (
					setPixels bm [x,y] pixie.getColourAtPixel (x*pixie.pixelSize) y
				)
			)
			display bm
		)
	)
)

pixToTif pixFile ""
