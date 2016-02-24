function [g, a, b, c] = my_lens ( f, x )
a = 0;
b = 0;
c = 0;
g = 0;

f = imresize(f,x);

%getting size of the input image
rowSize = size(f,1);
colSize = size(f,2);

resized = f;

%Find corners
%bw = im2bw(resized, 0.5);
%a = 100*im2bw(resized, otsu(resized));
a = rgb2gray(resized);

%get center row
% disp(rowSize);
% disp(colSize);
% disp(int16(rowSize/2));

%ROW
centerRow = a(int16(rowSize/2), :);

% figure;
% plot(1:size(centerRow, 2), centerRow);
% title('center row');

% figure;
scale = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,   1,   -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
colOutput = conv((scale), (centerRow));
% plot(1:size(colOutput,2), colOutput);
% title('col output')

topMaxCol = max(colOutput)
bottomMinCol = min(colOutput)

leftCol = find(colOutput == topMaxCol);     %Column of left edge of paper
rightCol = find(colOutput == bottomMinCol);     %Column of right edge of paper

% if ((abs(rightCol)-leftCol) > 500)
%    disp('Difference between lowest and highest values in convolved set is off...') 
% end

%COLUMN
centerCol = a(:, int16(colSize/2));
% centerCol = centerCol(:);

figure;
plot(1:size(centerCol, 1), centerCol);
title('center col');

figure;
scale = [0.50,0.55,0.60,0.65,0.70,0.75,0.80,0.85,0.90,0.95,1,2,2,2,   1,   -2,-2,-2,1, -0.95, -0.90, -0.85, -0.80, -0.75, -0.70, -0.65, -0.60, -0.55, -0.5];
rowOutput = conv((scale), (centerCol));
plot(1:size(rowOutput,1), rowOutput);
title('row output')

topMaxRow = max(rowOutput)
bottomMinRow = min(rowOutput)


topRow = find(rowOutput == topMaxRow);         %Row of top edge of paper
bottomRow = find(rowOutput == bottomMinRow);      %Row of bottom of paper

%Got the corners!
fprintf('TopLeft:  %d  %d\nBotRight: %d  %d\n',leftCol,topRow, rightCol, bottomRow);

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