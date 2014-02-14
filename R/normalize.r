# these are various helper functions needed
# to process the rspectra with the FOTO method

# standard normalize between 0 - 1
normalize <- function(x){
  (x - min(x, na.rm=TRUE))/(max(x,na.rm=TRUE) - min(x, na.rm=TRUE))
}

normalize.raster <- function(x){
  (x - min(getValues(x), na.rm=TRUE))/(max(getValues(x),na.rm=TRUE) - min(getValues(x), na.rm=TRUE))
}

# row or column wise normalization of a matrix
# by substraction of the mean and division by
# the standard deviation
pca_normalize <- function(x,d=2){
  # set the row or column direction
  if (d==2){
    x <- (x - apply(x,d,function(x)mean(x,na.rm=T))[col(x)])/apply(x,d,function(x)sd(x,na.rm=T))[col(x)]
  }else{
    x <- (x - apply(x,d,function(x)mean(x,na.rm=T))[row(x)])/apply(x,d,function(x)sd(x,na.rm=T))[row(x)]
  }
  # remove Inf, NA, NaN
  # replace by 0 - princomp() does not allow NA/Inf
  x[is.infinite(x) | is.na(x)] <- 0
  return(x)
}

# increment function
# adds 1 to a globally defined variable i
count <- function(x,...){
  i<<-i+1
  return(i)
}