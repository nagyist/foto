#------------------------------------------------------------------------
# NAME: FOTO.r
# PROJECT: canopy structure project
# PURPOSE: classify image data based upon r-specta
# CATEGORY:
# CALLING SEQUENCE: FOTO(x=rasterlayer,windowsize=61)
# INPUTS: a raster layer, a block window size
# PARAMETERS: plt = plot, TRUE or FALSE
# OUTPUTS: zones (blocks that are processed with the rspectrum.r),
#          output (filled by rspectrum.r, matrix with fft spectra),
#          noutput (normalized output matrix),
#          pcfit (first 3 PC of the noutput file)
#          RGB (rasterbrick containing the first 3 PC for visualization)
# NOTES:
# CREATION DATE: 01/07/2013
# AUTHOR: Koen Hufkens, koen.hufkens@gmail.com
# UPDATE:
#------------------------------------------------------------------------

FOTO_mw <- function(x='',windowsize=61,plt=FALSE,rspectrum.n=TRUE){
  
  # 1. load libraries and helper function rspectrum / normalize 
  require(raster)
  source('rspectrum_mw.r')
  source('normalize.r')
  
  # standard normalization between 0 and 1
  # this code saves some space further down
  normalize <- function(x){
    (x - min(x, na.rm=TRUE))/(max(x,na.rm=TRUE) - min(x, na.rm=TRUE))
  }
  
  # 2. read the image / matrix file and apply extract the r-spectra
  if (class(x)[1]!="RasterLayer" || class(x)[1]!="RasterBrick" ){  
    # if not a raster object read as image
    img <- brick(x)
    
    # calculate the mean (grayscale)
    # image if there is more than one
    # image band
    if(nbands(img)>1){
      img <- mean(img)
    }
  }
  
  if (class(x)[1]=="RasterLayer"){
    img <- x 
  }
  
  if (class(x)[1]=="RasterBrick"){
    img <- x
    
    # calculate the mean (grayscale)
    # image if there is more than one
    # image band
    if(nbands(img)>1){
      img <- mean(img)
    }
  }
  
  # get number of cells to be aggregated to
  N <- img@nrows
  M <- img@ncols
  cells <- N*M
  
  # output matrix has a maximum vector length of 29
  if( windowsize/2 < 29){
    output <<- matrix(0,cells,windowsize/2)
  }else{
    output <<- matrix(0,cells,29)
  }
  
  # define output matrix and global increment, i
  # see rspectrum function above
  i <<- 0
  
  # for every zone execute the r-spectrum function
  zones <<- focal(img,matrix(rep(1,windowsize*windowsize),ncol=windowsize,nrow=windowsize), fun=function(x,...){rspectrum_mw(x=x,w=windowsize,n=rspectrum.n,...)},expand=TRUE,na.rm=TRUE)
  
  # 3. reformat the r-spectrum output (normalize) and apply a PCA
  # set all infinite values to NA
  output[is.infinite(output)] <- NA
  
  # normalize matrix column wise (ignoring NA values)
  # (this routine doesn't increase the accuracy of the
  # resulting map, if not it produces worse output. 
  # uncomment the code if wanted)
  
  # normalize column wise by substracting the mean
  # and dividing with the standard deviation
  # keep original input file for reference
  # look up reference!
  noutput <<- (output - apply(output,2,function(output)mean(output,na.rm=T))[col(output)])/apply(output,2,function(output)sd(output,na.rm=T))[col(output)]
  
  # set NA/Inf values to 0 as the pca analys doesn't take NA values
  noutput[is.infinite(noutput) | is.na(noutput)] <- 0
  
  # the principal component analysis
  pcfit <<- princomp(noutput)
  
  # create reclass files based upon PCA scores
  # only the first 3 PC will be considered
  for (i in 1:3){
    assign(paste('rcl.',i,sep=''),cbind(1:length(pcfit$scores[,i]),normalize(pcfit$scores[,i])),envir=.GlobalEnv)
  }  
  
  # reclassify using the above reclass files
  for (i in 1:3){
    # get() reclass matrix and reclassify the zones file
    assign(paste('PC.',i,sep=''),reclassify(zones,get(paste('rcl.',i,sep=''))),envir=.GlobalEnv)                                
  }
  
  # create a raster brick and plot the RGB image
  # made of pca scores, colours correspond to
  # different scores as split between the scores
  # of the first three pca axis
  #Changed to imgRGB instead of RGB to avoid conflicts with function RGB{raster}
  imgRGB <- brick(PC.1,PC.2,PC.3)
  #assign PC_stack as an object with the brick of the first three PC
  assign('PC_stack',imgRGB,envir=.GlobalEnv)
  
  # 4. plot the classification using an RGB representation of the first 3 PC
  if (plt=="T" | plt=="TRUE"){ # if print is true print the pca classification results
    plot(img)
    plotRGB(PC_stack,stretch='hist',add=TRUE,alpha=128)
  }
  
}