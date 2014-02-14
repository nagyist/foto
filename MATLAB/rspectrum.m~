%------------------------------------------------------------------------
% NAME: rspectrum.m
% PROJECT: canopy structure project
% PURPOSE: calculate the r-spectra for a matrix (helper function)
% CATEGORY:
% CALLING SEQUENCE:
% INPUTS: x a square matrix, w size of the matix
% PARAMETERS:
% OUTPUTS:
% NOTES: the matrix (img) should be square or results will be discarded 
%        the output is an increment to i (global) and data that is
%        written to matrix 'output' (global) to be defined beforehand. 
% CREATION DATE: 01/07/2013
% AUTHOR: Koen Hufkens, koen.hufkens@gmail.com
% UPDATE: 29/07/2013
%------------------------------------------------------------------------

function i = rspectrum(img,windowsize)

	% set global variables, these are defined in the final
	% FOTO.m algorithm as well. If not called, data won't
	% be written to these global variables and stay internal
	% to the function.
	% These variables should also be declared as global in the
	% FOTO function, otherwise these will be overwritten with
	% an empty matrix by the rspectrum function.
	global i output;

	% get the nr of pixels of the image fed
	% into the function, will be used to
	% determine if an image is square (to be processed)
	% or not
	[M, N] = size(img);
	cells = M*N;

	% check if 
	if windowsize == sqrt(cells)

	    % increase increment
	    i = i + 1;
	    
	    % calculate the variance
	    img_var=var(reshape(img,N*M,1));
	     
	    % FFT transform
	    tf = (abs(fft2(img))/(N*M)).^2;
	    
	    % eliminates central peak
	     low = min(min(tf));
	     tf(1,2)=low;
	     tf(2,1)=low;
	     tf(1,end)=low;
	     tf(end,1)=0;
	      
	    % center fft
	    tf = fftshift(tf);

	    % Make Cartesian grid
	    [X Y] = meshgrid(-M/2:M/2-1,-M/2:M/2-1);
	    [theta rho] = cart2pol(X, Y);
	    
	    % get distances (round them)
	    rho = round(rho);
	    
	    % create a matrix to contain the
	    % locations of given distance class
	    % pixels
	    count = cell(floor(M/2) + 1, 1);
	   
	    % find locations of pixels 
	    % for a given distance from the center of the image
	    for r = 0:floor(M/2)
		count{r + 1} = find(rho == r); 
	    end
	    
	    % create a vector to hold the distance averaged
	    % spectral data
	    Pf = zeros(1, floor(M/2)+1);
	    
	    % fill this vector with the averaged data per
	    % distance class
	    for r = 0:floor(M/2)
		Pf(1, r + 1) = nanmean(tf(count{r+1}))/img_var;
		% set first two values to zero, inherent to image structure
		Pf(1:2) = 0;
	    end
	    
	    if length(Pf) < 29
		 output(i,1:length(Pf)) = Pf;
	    else
		 output(i,1:29) = Pf(1:29);
	    end

	else
	    
	    % in case of non square data
	    % output increment value, nothing else
	    i = i + 1;
	end

end
