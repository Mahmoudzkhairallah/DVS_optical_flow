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
%Generate test flow field and constant gray-image as test image
%%%%%%%%%%%%%%%%
width  = 300;
height = 200;
[ X, Y ] = meshgrid( ( 0 : width - 1 ), ( 0 : height - 1 ) );

%the maximal value in the example flow field
range = 20; 

cx = round( width * 0.5 );
cy = round( height * 0.5 );
r = min( cx, cy);

u =  range / r * ( X - cx );    %horizontal component of the test flow field
v =  range / r * ( Y - cy );    %vertical component of the test flow field

centerDistance = ( X - cx ).^2 + ( Y - cy ).^2;
%Pixel where test flow field is valid are visualized. Invalid pixels remain black
valid = centerDistance < ( r^2 );


%constant gray-image
%One of the images between which the flow is calculated.
I = uint8( 128 * ones( size( u, 1 ), size( u, 2 ), 1 ) ); 

%%%%%%%%%%%%%%%%
%Determine the visualization
%%%%%%%%%%%%%%%%

%mean values in both components for mean-compensated visualization
meanU = mean( u(valid) );
meanV = mean( v(valid) );
fprintf( 'Mean is %f pixels in horizontal direction and %f pixels in vertical direction!\n', meanU, meanV);

%Determine all visualization and providing all optional arguments
[rgbImage1, rgbImage2, rgbImage3] = flow_visualization( u, v, valid, meanU, meanV );

%Determine only the direction encoding and use default parameter whenever possible
[ rgbImageAll ] = flow_visualization( u, v );


%%%%%%%%%%%%%%%%
%Display the visualization
%%%%%%%%%%%%%%%%
figure

%overlay of image and visualization to evaluate flow fields also on edges
overlay = createOverlayImage( I, rgbImage1 );
subplot( 2, 2, 1 );
image( overlay );
axis image;
title( 'Overlay');

subplot( 2, 2, 2 ); 
image( rgbImage1 ); 
axis image;
title('Optical Flow Encoding');

subplot( 2, 2, 3 ); 
image( rgbImage2 );
axis image;
title('Cyclic Length Encoding');

subplot( 2, 2, 4); 
image( rgbImage3 );
axis image;
t = sprintf( 'Encoding adjusted by (%5.2f, %5.2f)', meanU, meanV);
title(t);


figure
image( rgbImageAll ); 
axis image;
title('Optical Flow Encoding');
