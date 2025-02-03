# GMSExternalPyFilter
Gatan Microscopy Suite script that triggers a python script for filtering of an image externally, to avoid compatibility or instability issues that can occur when running within GMS

The scripts will need to be installed in a folder with read/write access. The python script uses pathlib to identify this folder, the GMS script will ask the user the first time it is run if this isn't in a default folder, and save this to GMS global tags. 

v0.1a Feb 2023 - test version, simple convolution filter only. External python needs to have cv2 installed. 
