function [g, d] = my_lens ( f, x )

%getting size of the input image
rowSize = size(f,1);
colSize = size(f,2);

imgGray = rgb2gray ( f );

%Find corners

colMean = mean(imgGray, 2);
colMean = reshape(colMean, 1, []);
colMeanDelta = [];
for i=2:size(colMean, 2)
   colMeanDelta = [colMeanDelta, colMean(1, i-1) - colMean(1,i)];
end
maxColDeltaIndex = find(colMeanDelta == max(colMeanDelta), 1);
minColDeltaIndex = find(colMeanDelta == min(colMeanDelta), 1);

rowMean = mean(imgGray, 1);
rowMeanDelta = [];
for i=2:size(rowMean,2)
    rowMeanDelta = [rowMeanDelta, rowMean(1,i-1) - rowMean(1, i)];
end
maxRowDeltaIndex = find(rowMeanDelta == max(rowMeanDelta), 1);
minRowDeltaIndex = find(rowMeanDelta == min(rowMeanDelta), 1);

%[topleftcornercoordinates bottomrightcornercoordinates]
%maxRowDeltaIndex, maxColDeltaIndex
%[topleftcornerX topleftcornerY rowSize colSize]
%x(1), x(2)
corners = [minRowDeltaIndex, minColDeltaIndex, x(1), x(2)];
d = corners;
% if (minColDeltaIndex >= rowSize/2)
%    disp('MISSALIGNED'); 
% end
disp([minRowDeltaIndex, minColDeltaIndex, maxRowDeltaIndex, maxColDeltaIndex]);
disp(corners);

%crop
g = imcrop(f,corners);

%Rotate

%Equalize Color
% g = histEqualize(g);

% resize
g = imresize ( g, x );
% g = 1;

function [o] = histEqualize(f)
    % convert to grayscale
    im_g = rgb2gray ( f );
    % histogram equalization 
    hist   = imhist(im_g(:,:)); 
    maxIntensity = 255;  
    cdf_v(1)= hist(1);
    for i=2:maxIntensity+1
        cdf_v(i) = hist(i) + cdf_v(i-1);
    end
    cdf_v = cdf_v/double(numel(im_g))*255.0;
    im_e = uint8( cdf_v ( im_g+1));
    % do not crop.  convert to color
    o = cat ( 3, im_e, im_e, im_e );