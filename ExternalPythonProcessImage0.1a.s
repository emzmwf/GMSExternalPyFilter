// GMS script using External Python
// V0.1 EMZMWF Dec 2022

// Note the external directory needs to be defined the same
// in both this and the python script
string ExDir = "C:/Users/VALUEDGATANCUSTOMER/Documents/Scripts"
// This defines the temporary directory 


// The directory is stored as a global tag for each version of GMS
// The following will check for the directory, and define it if it isn't there
// check if the tag is present
// and ask for the directory if it isnt. 
TagGroup tg = GetPersistentTagGroup( )
number Val1 = TagGroupDoesTagExist( tg, "DM2Python String" )
if (Val1 = 1){
	Result("\n Using globally defined folder")
	tg.TagGroupGetTagAsString( "DM2Python String", ExDir )
	Result("\n Setting director to "+ExDir)
	}
else{
	Result("Python Shared folder not defined")
	string folder
	if ( !GetDirectoryDialog( "Select folder where GMSExternalPy.py is installed" , "" , folder ) )
	ExDir = folder
	tg.TagGroupSetTagAsString( "DM2Python String", folder )
	number PyCheck
	PyCheck = DoesFileExist( ExDir + "GMSExternalPy.py" )
	if (PyCheck == 0)
	{
	Result("GMSExternalPy.py not found in this directory")
	}
		}	

//Tag copying routine modified from D Mitchell
void CopyAllTags( image imgsource, image imgtarget  )
{
image imgsource, imgtarget
try
	//gettwoimageswithprompt("0 = Source Image, 1 = Target Image","Copy ALL tags between images", imgsource, imgtarget)
	gettwoimageswithprompt("0 = Target Image, 1 = Source Image","Copy ALL tags between images", imgtarget, imgsource)
catch
	Result("Error in getting images")
string targetname, sourcename
targetname=getname(imgtarget)
sourcename=getname(imgsource)
TagGroup sourcetags=imagegettaggroup(imgsource)
TagGroup targettags=imagegettaggroup(imgtarget)
taggroupcopytagsfrom(targettags,sourcetags)

ImageCopyCalibrationFrom(imgtarget, imgsource)
ImageSetName(imgtarget, sourcename+"Processed")

}

// Routine to display a scale bar
void NowScaleBar( image img){
ImageDisplay imgDisp
imgDisp = img.ImageGetImageDisplay(0)

number kSCALEBAR = 31
//Get the pixel sizes of the processed image so we can put the scalebar the right size and place
number sx, sy
GetSize(img, sx, sy )

//want to set 90 pct from top, 5pct from left, bottom, right

//component - x1, y1, x2, y2
component scalebar = NewComponent( kSCALEBAR, 0,0,1,1 )
scalebar.ComponentSetRect( 0.9 * sy, 0.05 * sx, 0.95 * sy, 0.95 * sx )
imgDisp.ComponentAddChildAtEnd( scalebar )
}

////////////////////


// Get front image
image front:=getfrontimage()

// extract image data, esport as TIF


String file_name = ExDir+ "/ExtPyTIFF"+".tif"
number saveType = 1 	//1 = save data,  2 = save display
try
	SaveAsTiff(front, file_name, saveType )

catch
	Result("existing output file is in use")

////////////////////////////////////////

// Call external python to process TIF
String CSA = "python "
String CSB = "/GMSExternalPy.py"
String callString = CSA+ExDir+CSB

Result(callString)

if ( TwoButtonDialog( "Launch Python Script", "Asynchronous", "Synchronous" ) )
	LaunchExternalProcessAsync( callString )
else
	LaunchExternalProcess( callString )
	
/////////////////////////	
//note - test version only runs convolution
//in future, will code to either pick filter from a selection via a dialog here
//and passing that via a tag to the python script
//or having the python script pop up a box using tkinter and ask us what filter we want
	

// Check if the processed file exists
OKDialog( "Click OK once the black Python window has closed" )

number DFE = 42

// Check if there is a processed TIF


try
	DFE =  DoesFileExist( ExDir + "/ExtPyTIFFPRO.tif" )
catch
	Result("Unable to locate output file in "+ExDir)

Result(DFE)

// Load in processed TIF
// There will be a file called ExtPyTIFFPRO.tif if it has been

Image ProIm	//define before the If or there will be an error

if (DFE = 1)
	ProIm = OpenImage(ExDir + "/ExtPyTIFFPRO.tif")
else
	Result("Error opening file in "+ExDir)

showImage(ProIm)

// Copy calibrations and tags to new file
// NOTE - only run processes that do not change the pixel size if 
// you are doing this
// TO DO - check the pixel size of both the original and new image
CopyAllTags( front, ProIm  )

//Display the scale bar on the processed image
NowScaleBar(ProIm)

// Remove the temporary tiff file
DeleteFile(ExDir + "/ExtPyTIFFPRO.tif")

// Here in case we in future have this part of a batch process:
// Save final file as .dm4 with processed in the title
//SaveAsGatan( ImageReference image, string fileName )
