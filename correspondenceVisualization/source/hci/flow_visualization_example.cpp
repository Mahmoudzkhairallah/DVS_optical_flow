///////////////////////////////////////////////////////////////////////////////
//
//   This file is part of the HCI-Correspondence Estimation Benchmark.
//
//   More information on this benchmark can be found under:
//       http://hci.iwr.uni-heidelberg.de/Benchmarks/
//
//    Copyright (C) 2011  <Sellent, Lauer>
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//
///////////////////////////////////////////////////////////////////////////////

#ifndef NOMINMAX
    #define NOMINMAX //To be compatible both with windows and linux
#endif

#include <iostream>
#include <iomanip>
#include <algorithm>

#include "hci/flow_visualization.hpp"

#include "cimg/CImg.h"


int main(int argc, char* argv[])
{
    ::std::cout << "This is an example how flow visualization can be applied" << ::std::endl;
    
    //=============
    //Create a constant image that contains a flow field
    //=============
    const int           width  = 300;       //the size of the example flow field
    const int           height = 200;
    const ofv::data_t   range  = 20.0;      //the maximal value in the example flow field

    ::cimg_library::CImg<ofv::data_t> flowU( width, height, 1, 1, 0); 
    ::cimg_library::CImg<ofv::data_t> flowV( width, height, 1, 1, 0);
    ::cimg_library::CImg<bool>        valid( width, height, 1, 1, 0);

    int cx = static_cast<int>( 0.5 * static_cast<ofv::data_t>( width ) + 0.5 );
    int cy = static_cast<int>( 0.5 * static_cast<ofv::data_t>( height ) + 0.5 );
    int r = ::std::min( cx, cy);

    for (int x = 0; x < width; x++ )
    {
        for (int y = 0; y < height; y++)
        {
            flowU( x, y, 0, 0) = static_cast<ofv::data_t>( ( x - cx ) ) / static_cast<ofv::data_t>( r ) * range;
            flowV( x, y, 0, 0) = static_cast<ofv::data_t>( ( y - cy ) ) / static_cast<ofv::data_t>( r ) * range;
            valid( x, y, 0, 0) = ( ( ( x - cx) * ( x - cx) + ( y - cy) * ( y - cy ) ) < r*r );
        }
    }

    //constant gray-image
    ::cimg_library::CImg<unsigned char> image( width, height, 1, 3, 128);

    //=============
    //The visualization part
    //=============
    ::ofv::CFlowVisualization visu;

    ::cimg_library::CImg<unsigned char> rgbImage1( width, height, 1, 3, 0);
    visu.calcDirectionEncoding( rgbImage1, flowU, flowV, valid );

    //overlay of image and visualization to detect edges
    ::cimg_library::CImg<unsigned char> overlay = ( (image * 0.5f) + (rgbImage1 * 0.5f) ).cut(0,255);
    ::cimg_library::CImgDisplay window0( overlay , "Overlay");
    ::cimg_library::CImgDisplay window1( rgbImage1, "Optical Flow Encoding");    

    ::cimg_library::CImg<unsigned char> rgbImage2( width, height, 1, 3, 0);
    visu.calcCyclicEncoding(  rgbImage2, flowU, flowV, valid );
    ::cimg_library::CImgDisplay window2( rgbImage2, "Cyclic Length Encoding");

    ofv::data_t meanU = ::ofv::getValidMean( flowU, valid);
    ofv::data_t meanV = ::ofv::getValidMean( flowV, valid);

    ::cimg_library::CImg<unsigned char> rgbImage3( width, height, 1, 3, 0);
    visu.calcDiffEncoding( rgbImage3, flowU, flowV, valid, meanU, meanV );

    ::std::cout << "Shifting flow field " << ::std::fixed << ::std::setprecision(2)
        << meanU << " px horizontally and " 
        << meanV << " px vertically." << ::std::endl;
    ::cimg_library::CImgDisplay window3( rgbImage3, "Encoding of the adjusted flow");

    //=============
    //Done.
    //=============

    ::std::cout << "Press return to end program" << ::std::endl;
    ::std::cin.ignore(1);

    return 0;
}

