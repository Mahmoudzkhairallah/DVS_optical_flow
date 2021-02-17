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

function [rgbImageAbsolut, rgbImageCyclic, rgbImageDifference] = stereo_visualization( disparity, valid, minDisparity, maxDisparity )
%This file provides the colour map and the visualization of stereo disparity 
%as they are used on the webpage http://hci.iwr.uni-heidelberg.de//Benchmarks/
%IN:    
%      disparity : the horizontal component of the flow field, a (height x width x 1)-matrix
%IN [OPTIONAL]
%          valid : (height x width x 1)-matrix of bool values to indicate that
%                  disparity at this pixel should be visualized; 
%                  default = true( height x width x 1 );
%    minDisparity : a scalar value for stretching the colour encoding
%                   default = 0
%    maxDisparity : a scalar value for stretching the colour encoding
%              default = 0
%OUT:
%    rgbImageDirection : (height x width x 3) uint8 image of the standard disparity encoding
%       rgbImageCyclic : (height x width x 3) uint8 image of the cyclic encoding
%   rgbImageDifference : (height x width x 3) uint8 image of the strechtched disparity encoding
    
    %%%%%%%%%%%%%
    %Check input
    %%%%%%%%%%%%%
    if ~exist( 'valid', 'var' )
        valid = true( size( disparity ) );
        if ~exist( 'minDisparity', 'var' )
            minDisparity = 0;
            if ~exist( 'maxDisparity', 'var' )
                maxDisparity = 130;
            end
        end
    end


    %%%%%%%%%%%%%
    %Constants
    %%%%%%%%%%%%%
    
    nColors = 128;              %Number of colours in the map
    colorOffset = 2.0/6.0;      %shift so that zero disparity is blue
    
    gamma = 0.95;               %use d^gamma with 0<gamma<1 to compress range of disparities
    fullSaturationLength = 130; %At this length the disparity is fully saturated->cut off in colour
    cycleLength = 20;           %how many pixels displacement fit into one cycle of colours

    [ height, width] = size( disparity );
    disparity = disparity( valid );

    %%%%%%%%%%%%%
    %Calculate colour-map once.
    %%%%%%%%%%%%%

    [CM_r, CM_g, CM_b] = createColourmap( );


    %%%%%%%%%%%%%
    % Determine colour and saturation based on disparity in [-inf, inf[
    %%%%%%%%%%%%%
    
    %valid disparity is compressed and clipped between fixed maximal value
    compressed = nonLinearCompression( disparity );
    compressedFullSaturation = nonLinearCompression( fullSaturationLength );
    
    compressed = max( -compressedFullSaturation, min( compressed, compressedFullSaturation ));
    
    [rImg, gImg, bImg] = getColor( compressed/compressedFullSaturation  );
    
    rgbImageAbsolut = uint8( cat( 3, rImg, gImg, bImg ) );
    
    if ( 2 <= nargout )
        %%%%%%%%%%%%%
        % Cyclic colour encoding
        %%%%%%%%%%%%%
        
        modulus = mod( disparity, cycleLength );% in [0, cycleLength[
        [rImg, gImg, bImg] = getColor( modulus/ cycleLength );
        
        rgbImageCyclic = uint8( cat( 3, rImg, gImg, bImg ) );
        
        if (3 == nargout )
    
            %%%%%%%%%%%%%
            % The colour encoding to visualize disparity within limits
            %%%%%%%%%%%%%
            
            compressed = nonLinearCompression( disparity - minDisparity );
            compressedFullSaturation = nonLinearCompression( maxDisparity - minDisparity );
            
            [rImg, gImg, bImg] = getColor( compressed/compressedFullSaturation  );
            
            rgbImageDifference = uint8( cat( 3, rImg, gImg, bImg ) );
            
        end
        
    end

   
    %%%%%%%%%%%%%
    % Nested Functions
    %%%%%%%%%%%%%

    function [ rImg, gImg, bImg] = getColor( index )
        
        %get index into range [0...1]
        while ( min(index(:)) < 0.0 )
            idx = find(index < 0.0);
            index(idx) = index(idx) + 1.0;
        end
        while ( max(index(:)) > 1.0 )
            idx = find(index > 1.0);
            index(idx) = index(idx) - 1.0;
        end
        
        adr_f = 1 + index * ( nColors - 2); % in [1, nColors - 1]
        adr_i = floor( adr_f );
        
        %interpolate linearly
        w = adr_f - adr_i;
        
        rImg = zeros( height, width );
        gImg = zeros( height, width );
        bImg = zeros( height, width );

        % round
        rImg( valid ) = floor(0.5 + ( 1 - w) .* CM_r( adr_i ) + w .* CM_r( adr_i + 1 ) );
        gImg( valid ) = floor(0.5 + ( 1 - w) .* CM_g( adr_i ) + w .* CM_g( adr_i + 1 ) );
        bImg( valid ) = floor(0.5 + ( 1 - w) .* CM_b( adr_i ) + w .* CM_b( adr_i + 1 ) );
    end

    function [ CM_r, CM_g, CM_b]  = createColourmap( )
        %initialize the colourmap
        %As same color-map is used for cyclic coding and disparity, keep it linear.
        HSV = ones( nColors, 3 );
        offsetColor = floor( colorOffset * nColors); %shift so that zero disparity is blue
        pos = mod( offsetColor + (0:nColors-1), nColors );
        HSV(:,1) = 1 - ( (pos+1)/nColors); %invert to have large-disparity = close = warm (red/yellow)
        CM = round(255 * hsv2rgb( HSV ));

        CM_r = CM( :, 1 );
        CM_g = CM( :, 2 );
        CM_b = CM( :, 3 );
    end


    function y = nonLinearCompression( x )
        % non-linear compression to squeeze large values and stretch values for gamma < 1
        y = sign(x).*( abs(x) ).^gamma;
    end

end

