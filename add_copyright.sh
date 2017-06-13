#!/bin/bash

# Verify parameters exist
if [[ $# -lt 2 ]]
then
	echo 'Usage: ./add_copyright.sh "COPYRIGHT TEXT" {image}'
	exit 1
fi

PLACEMENT="southeast"
TEXT_SIZE="20"
COPYRIGHT_TEXT="$1"

for INPUT_IMAGE in "$@"
do
	BASE=${INPUT_IMAGE%.*}
	OUTPUT_IMAGE="output/$BASE-cc.jpg"
	echo "$INPUT_IMAGE"

	# Create the copyright text image
	convert -size 300x50 xc:grey30 -font Arial -pointsize $TEXT_SIZE -gravity center \
		  -draw "fill grey70  text 0,0  '$COPYRIGHT_TEXT'" \
		  stamp_fgnd.png
	convert -size 300x50 xc:black -font Arial -pointsize $TEXT_SIZE -gravity center \
		  -draw "fill white  text  1,1  '$COPYRIGHT_TEXT'  \
				     text  0,0  '$COPYRIGHT_TEXT'  \
			 fill black  text -1,-1 '$COPYRIGHT_TEXT'" \
		  +matte stamp_mask.png
	composite -compose CopyOpacity  stamp_mask.png  stamp_fgnd.png  stamp.png
	mogrify -trim +repage stamp.png

	# Add the text to the given image
	composite -gravity $PLACEMENT -geometry +5+5 stamp.png $INPUT_IMAGE $OUTPUT_IMAGE

	echo "Output at $OUTPUT_IMAGE"
done
