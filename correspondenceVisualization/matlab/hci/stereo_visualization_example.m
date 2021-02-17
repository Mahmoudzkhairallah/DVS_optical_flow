%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This file is part of the HCI-Correspondence Estimation Benchmark.
%
%   More information on this benchmark can be found under:
%       http://hci.iwr.uni-heidelberg.de/Benchmarks/
%
%    Copyright (C) 2011  <Sellent, Lauer>
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
%%%%%%%%%%%%%%%%
%Generate test disparity and constant gray-image as test image
%%%%%%%%%%%%%%%%
width  = 300;
height = 200;

%the maximal value in the example flow field
range = 120;
disparityOffset = 0;

%test disparity map
disparity = ( 0 : height - 1 )';
disparity = repmat( disparity, [ 1, width ] ); 
disparity = range * disparity / ( height - 1) + disparityOffset;

%Pixel where the test disparity map is valid are visualized. Invalid pixels remain black
valid = true( height, width );
valid( :, 1:floor( 0.1 * width ) + 1 )       = false;   % "+1" to get same results as in c++ example
valid( :,   floor( 0.9 * width ) + 1 : end ) = false;   % "+1" to get same results as in c++ example

%constant gray-image
%e.g. the left image of a stereo pair
I = uint8( 128 * ones( height, width, 3 ) );

%%%%%%%%%%%%%%%%
%Determine the visualization
%%%%%%%%%%%%%%%%
%valid max and min values to stretch the colour map optimally
minDisparity = min( disparity(valid) );
maxDisparity = max( disparity(valid) );
fprintf( 'Valid disparity values range from %5.2f to %5.2f pixels.\n', minDisparity, maxDisparity);

%Determine all visualization and providing all optional arguments
[ rgbImage1, rgbImage2, rgbImage3 ] = stereo_visualization( disparity, valid, minDisparity, maxDisparity );

%Determine only the standard encoding and use default parameter whenever possible
[ rgbImageAll ] = stereo_visualization( disparity );

%%%%%%%%%%%%%%%%
%Display the visualization
%%%%%%%%%%%%%%%%
figure(1);

%overlay of image and visualization to detect edges
overlay = createOverlayImage( I, rgbImage1 );
subplot( 2, 2, 1 );
image( overlay );
axis image;
title( 'Overlay');

subplot( 2, 2, 2 ); 
image( rgbImage1 ); 
axis image;
title('Colour encoded disparity');

subplot( 2, 2, 3 ); 
image( rgbImage2 );
axis image;
title('Cyclicly encoded disparity');

subplot( 2, 2, 4 ); 
image( rgbImage3 );
axis image;
t = sprintf( 'Disparity spread between %5.2f and %5.2f', minDisparity, maxDisparity);
title(t);


figure(2);
image( rgbImageAll ); 
axis image;
title('Colour encoded disparity');
