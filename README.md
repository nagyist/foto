# The FOTO toolbox

FOTO (Fourier Transform Textural Ordination) method as described by Proisy et al. 2007 / Barbier et al. 2011 / Ploton et al. 2012. The FOTO method uses a principal component analysis (PCA) on radially averaged 2D fourier spectra to characterize (greyscale) image texture. Code is provided for MATLAB and R, an Octave version is planned.

## Installation

clone the project to your home computer using

	git clone https://khufkens@bitbucket.org/khufkens/foto.git

Add the path of the project on your home computer to the MATLAB PATH.

	addpath(/foo/bar/MATLAB)

In R set the working path to the R script folder and source the FOTO script file in R.

	setwd(/foo/bar/R)
	source(/foo/bar/R/FOTO.r)

The function relies on the R raster() library, so make sure the library and all it's dependencies are installed.

## Use
### MATLAB

To run the script provide a path to an image and the size of the window size to use (in pixels).

	myspectra = FOTO(/foo/bar/myimage.jpg,20)

The above code will process the myimage.jpg file using a window size of 20 pixels. The resulting (raw) rspectra are stored in the myspectra variable.

In addition these spectra are written to a csv file (rspectra.csv) for processing in external programs. This file will be overwritten on each function call.

A visualization of the textural ordination is provided at the end of the function run.

### R

The structure of the function call is identical to MATLAB one.

	FOTO(/foo/bar/myimage.jpg,20)

However, no output variables can be declared. Instead, a set of global variables is created in the R workspace, containing all necessary information.

The raw rspectra are stored in a table called, output. The normalized values are located in noutput. The results of the principal component ordination is stored in the pcfit variable. A final classification image is stored in a rasterBrick called RGB.

A visualization of the textural ordination is provided at the end of the function run.
