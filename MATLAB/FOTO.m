%------------------------------------------------------------------------
% NAME: FOTO.m
% PROJECT: canopy structure project
% PURPOSE: classify image data based upon r-specta
% CATEGORY:
% CALLING SEQUENCE: FOTO(imagefile,windowsize)
% INPUTS: an image layer, a block window size
% PARAMETERS:
% OUTPUTS: rspectra of image blocks
% NOTES: included rank normalization of the image
%        to deal with hazy clouds and uneven illumination
%	 depends on rspectra.m (should be in the matlab path)
% CREATION DATE: 01/07/2013
% AUTHOR: Koen Hufkens, koen.hufkens@gmail.com
% UPDATE: 20/08/2013
%------------------------------------------------------------------------

function rspectra = FOTO(imagefile,windowsize)

	% define global variables for the increment vector
	% and the final output matrix (with rspectra)
	global i output;

	% set counter
	i = 0;

	% convert image to double and average
	% image bands if necessary
	img = imread(imagefile);
	Z = size(img,3);

	if Z == 1;
	    img = double(img);
	else
	    img = double(mean(img,3));
	end

	% get number of blocks that will be processed
	% using the blockproc function below
	[M N] = size(img);
	M = ceil(M/windowsize);
	N = ceil(N/windowsize);
	cells = M*N;

	% output matrix has a maximum vector length of 29
	% only use the first 29 harmonics, if less are
	% produce reduce the output file dimensions
	if windowsize/2 < 29;
	   output = zeros(cells,floor(windowsize/2));
	else
	   output = zeros(cells,29);
	end

	% blockprocess r spectra using rspectrum.m
	% I'm currently working on an octave implementation to go completely GPL
	fun = @(block_struct) rspectrum(block_struct.data,windowsize);
	block_count = blockproc(img,[windowsize windowsize],fun,'PadPartialBlocks',true,'PadMethod','symmetric','TrimBorder',true);

	% finally, write output to csv files
	% reshape the block_count file to get the
	% correct order in the final output file
	% blockproc doesn't calculate blocks perfectly row or column wise
	loc_spectra = reshape(block_count',numel(block_count),1);
	rspectra = output(loc_spectra,:);

	% write rspectra to file, useful when calling
	% the function from a non interactive matlab cli session
	csvwrite('rspectra.csv',output(loc_spectra,:));

	% visualize the rspectra, reduce the dimensionality of the matrix using a
	% principal component analysis, mapping the first 3 PC to RGB colours

	% center the rspectra matrix by subtracting the column mean and dividing by
	% the standard deviation
	norm_rspectra = (rspectra - ones(size(rspectra,1),1)*mean(rspectra)) ./ (ones(size(rspectra,1),1)*var(rspectra).^2);
	norm_rspectra(isnan(norm_rspectra)) = 0; % set NaN to 0, not allowed by princomp
	 
	[~,score,~,~]=princomp(norm_rspectra);
	 
	RGB = zeros(M,N,3);
	RGB(:,:,1) = reshape(score(:,1),M,N);
	RGB(:,:,2) = reshape(score(:,2),M,N);
	RGB(:,:,3) = reshape(score(:,3),M,N);
	 
	% visualize the texture classification
	imshow(RGB);

end 
