# The FOTO toolbox

FOTO (Fourier Transform Textural Ordination) method as used in [Couteron et al. 2005](http://onlinelibrary.wiley.com/doi/10.1111/j.1365-2664.2005.01097.x/abstract;jsessionid=359DD0662C272A59AF94FAEF3F213156.f02t04), [Proisy et al. 2007](http://linkinghub.elsevier.com/retrieve/pii/S0034425707000430), [Barbier et al. 2010](http://doi.wiley.com/10.1111/j.1466-8238.2009.00493.x) and [Ploton et al. 2012](http://www.esajournals.org/doi/abs/10.1890/11-1606.1). The FOTO method uses a principal component analysis (PCA) on radially averaged 2D fourier spectra to characterize (greyscale) image texture.

Although the techique as presented in these papers is applied on a canopy level, the principle works as well on a smaller scale (at a higher resolution). A proof of concept using a UAV over a grassland can be found in [one of my blog posts](http://www.khufkens.com/2013/08/29/uav-vegetation-monitoring/).

Code is provided for MATLAB and R.

## Installation

clone the project to your home computer using

	git clone https://khufkens@bitbucket.org/khufkens/foto.git

alternatively, download the project using [this link](https://bitbucket.org/khufkens/foto/get/master.zip).

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

The structure of the function call is identical to MATLAB one (see above).

	FOTO(/foo/bar/myimage.jpg,20)

However, no output variables can be declared. Instead, a set of global variables is created in the R workspace, containing all necessary information.

The raw rspectra are stored in a table called, output. The normalized values are located in noutput. The results of the principal component ordination is stored in the pcfit variable. A final classification image is stored in a rasterBrick called RGB.

A visualization of the textural ordination is provided at the end of the function run, but is optional (can be disabled).

## Partitioned normalization

Partiotioned normalization as described in [Barbier et al. 2010](http://doi.wiley.com/10.1111/j.1466-8238.2009.00493.x) is not provided but easily accomplished once all images are processed. I refer to this paper for the appropriate routines. If you have no access to this work due to paywall restrictions please email me or the original author for a copy.