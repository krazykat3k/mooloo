#!/bin/bash

#http://moinkhans.blogspot.com/2015/06/steghide-beginners-tutorial.html


# example cmd to embed the text file to an image file
# steghide embed -ef myblogpassword.txt -cf arch.jpg
# -ef: specify to steghide the name
# -cf: specify the image file we want to embed

# to extract
# steghide extract -sf arch.jpg -xf mybloggpass.txt
# steghide extract -sf arch.jpg
