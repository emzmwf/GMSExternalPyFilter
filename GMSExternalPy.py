## NOTE needs python v 3.4 on for pathlib

import sys
if sys.version_info[0] < 3:
    raise Exception("Must be using Python 3 or later")

from PIL import Image
import cv2
import numpy as np
from pathlib import Path
import os
from os import path

# load in tiff file, location determined by the 
# ExternalPythonProcessImage script

# Version 0.1 written by EMZMWF, Dec 2022
# Update 0.1a, use pathlib to identify folder location automatically
p = Path(__file__).with_name('ExtPyTIFF.tif')
f = os.path.dirname(p)
print(p)
print(f)

#im = cv2.imread(fdir+"/ExtPyTIFF.tif", cv2.IMREAD_GRAYSCALE)
im = cv2.imread(str(p), cv2.IMREAD_GRAYSCALE)

# im.show() # only for testing

#ensure right format for cv2, convert to float32
result = im.astype(np.float32)

# v0.1 - run simple filter. In future, either code to check a second temp file saying what filter, 
# or use tkinter to ask via python for a selection from a list
# Apply Convolution
kernel = np.ones((5,5),np.float32)/25
Conv = cv2.filter2D(result,-1,kernel)

#cv2.imshow('Convolved', Conv)  `#for testing

# Save the file to the predefined folder with the predefined name
cv2.imwrite(f+"/ExtPyTIFFPRO.tif", Conv)

# should we close things here? Probably.
del im
del Conv
