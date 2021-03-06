%Michael Pedersen
function [g] = my_lens ( f, x )
%getting size of the input image
rowSize = size(f,1);
colSize = size(f,2);

%Enable all = 2;
%Enable orig and cropped = 2;
%Enable charts = 1;
%just org and cropped = -1;
enableFigures = 0;

%||||||||||||| >-|-[0-:] FIND THE CORNERS [:-0]-|-< |||||||||||||||||||||

a = rgb2gray(f);
b = rgb2ind(f,2);


%-------------------------------  ROW  -------------------------------
centerRow = a(int16(rowSize/2), :)+0;
bCenterRow = b(int16(rowSize/2), :)+0;

if(enableFigures >= 1)
    figure;
    plot(1:size(centerRow, 2), centerRow);
    title('center row');
end

%This will take the scale array and calculate the following for every point
%in the data(this case its colOutput):
% for n=1:size(colOutput,2)
% sum = 0;
% for k=1:size(colOutput,2)
%     sum = sum + colOutput(k) * scale(n-k);
% end
% end
% Thereby producing an array where the values before and after the
% currently examined pixel are weighted into the new value for that
% location. This means I can emphasize locations of an image that change
% between dark and white by using the below scaling function.

scale = [0.5, 0.5, 0.5, 0.5, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,   1,    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5];
colOutput = conv(single(scale), single(centerRow));
bColOutput = conv(single(scale), single(bCenterRow));

if(enableFigures >= 1)
    figure;
    plot(1:size(colOutput,2), colOutput);
    title('col output')
end

%Find the highest peak(start of the paper) and the lowest valley(end of paper)
[~, leftCol] = max(colOutput);
[~, rightCol] = min(colOutput);
[~, bLeftCol] = max(bColOutput);
[~, bRightCol] = min(bColOutput);
% leftCol = find(colOutput == max(max(colOutput)));
% rightCol = find(colOutput == min(min(colOutput)));
% 
% leftCol = index(end);
% rightCol = index(1);

%Something is wrong if the edge columns are too close (say, 500px)
if ((rightCol - leftCol) < 1000)
    disp('ERROR!!!!!  rightCOl - leftCOl < 1000');
%     fprintf('rightCol:%d   leftCol:%d\n', rightCol, leftCol);
%     [~, index] = sort(colOutput); %Sort all values from lowest to highest
%     leftCol = index(end-1);
%     rightCol = index(2);
        leftCol = bLeftCol;
        rightCol = bRightCol;
%     %Sort the index values of the 2 highest magnitudes(the possible positions for the left edge of the page)
%     [ leftSorted, leftIndex] = sort(index(end-2:end));
%     %Take the Lowest index from this sorted list (closer to the left of the image)
%     leftCol = leftSorted(end - 1);
% 
%     %Sort the index values of the lowest 2 magnitudes(the possible positions for the right edge of paper)
%     [ rightSorted, rightIndex ] = sort(index(1:2));
%     %Take the highest index from the sorted list(closer to the right of the image)
%     rightCol = rightSorted(2);
%     fprintf('rightCol:%d   leftCol:%d \n', rightCol, leftCol);
end



%-------------------------------  COLUMN   -------------------------------
centerCol = a(:, int16(colSize/2));
bCenterCol = b(:,int16(colSize/2));
% centerCol = centerCol(:);

if(enableFigures >= 1)
    figure;
    plot(1:size(centerCol, 1), centerCol);
    title('center col');
end

rowOutput = conv(single(scale), single(centerCol));
bRowOutput = conv(single(scale), single(bCenterCol));

if(enableFigures >= 1)
    figure;
    plot(1:size(rowOutput,1), rowOutput);
    title('row output');
end

%Sort entire col by magnitude
% numCenterPixelsToRemove = 200;
% midpoint = int16(size(rowOutput,2)/2);
% leftCutoff = midpoint-(numCenterPixelsToRemove/2);
% rightCutoff = midpoint+(numCenterPixelsToRemove/2);
% disp(size(rowOutput,2))
% rowOutput = int16(rowOutput);
% placeholderZeros = zeros(1,numCenterPixelsToRemove,'int16');
% disp(size(zeros));
% rowOutput = rowOutput(1:leftCutoff) + placeholderZeros + rowOutput(rightCutoff:end);
% disp(size(rowOutput,2))


%Find the highest peak(start of the paper) and the lowest valley(end of paper)
[ ~, topRow] = max(rowOutput);
[ ~, bottomRow] = min(rowOutput);
[~, bTopRow] = max(bRowOutput);
[~, bBottomRow] = min(bRowOutput);

% bottomRow = find(rowOutput == min(min(rowOutput)));
% disp(topRow);
% disp(bottomRow);
%Something is wrong if the edge columns are too close (say, 500px)
if ((bottomRow - topRow) < 1000)
    disp('ERROR!!!!!  bottomRow - topRow < 1000');
%     fprintf('topRow:%d   bottomRow:%d\n', topRow, bottomRow);
     [~, index] = sort(rowOutput); %Sort all values from lowest to highest
     topRow = index(end-4);
     bottomRow = index(4);
%         topRow = bTopRow;
%         bottomRow = bBottomRow;
%     topRow = index(end-1);
%     bottomRow = index(2);
%     %Sort the index values of the 10 highest magnitudes(the possible positions for the left edge of the page)
%     [ topSorted, topIndex] = sort(index(end-10:end));
%     %Sort the index values of the lowest 10 magnitudes(the possible positions for the right edge of paper)
%     [ bottomSorted, bottomIndex ] = sort(index(1:10));
%     %Take the Lowest index from this sorted list (closer to the left of the image)
%     topRow = topSorted(end);
%     %Take the highest index from the sorted list(closer to the right of the image)
%     bottomRow = topSorted(1);
%     fprintf('topRow:%d   bottomRow:%d\n', topRow, bottomRow);
end

%DONE WITH CONVOLUTIONNNNNNN!

%Got the corners!
fprintf('TopLeft:  %d  %d\nBotRight: %d  %d\n',leftCol, topRow, rightCol, bottomRow);%leftCol,topRow, rightCol, bottomRow);

% ||||||||||||||||||||||||| CROPPING |||||||||||||||||||||||||||||||||||
if(enableFigures >= 2  || enableFigures == -1)
    figure;
    imshow(f);
end

if (leftCol >= rightCol)
%    disp('ERROR left edge is further right than right edge'); 
   leftCol = 0;
   rightCol = 10;
end

if (topRow >= bottomRow)
%    disp('ERROR top edge is further down than bottom edge');
   topRow = 0;
   bottomRow = 10;
end

try
cropped = imcrop(f,[leftCol, topRow, rightCol-leftCol, bottomRow-topRow]);

if(enableFigures >= 2 || enableFigures == -1)
    figure;
    imshow(cropped);
end

%|||||||||||||||||||||||| RESIZING |||||||||||||||||||||||||||||||||||||
cropped = imresize(cropped,x);

%|||||||||||||||||||||||||  EQUALIZE ||||||||||||||||||||||||||||||||
%cropped = histEqualize(cropped);
g = cropped;
catch
    g = 0;
end


end

function [c] = fcheckCorner(im)
    c = 0;
end
    
function [o] = otsu(im)
%     o = graythresh(im);
    o = 0.40;
end

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
end

function [o] = isWhite(pixel)
    o = pixel < 0.5;
end

function [o] = isBlack(pixel)
    o = ~isWhite(pixel);
end