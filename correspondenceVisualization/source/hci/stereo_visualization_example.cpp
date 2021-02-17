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

#include "hci/stereo_visualization.hpp"

#include "cimg/CImg.h"


int main(int argc, char* argv[])
{
    ::std::cout << "This is an example how stereo visualization can be applied." << ::std::endl;

    //=============
    //Create a constant image that contains a disparity field
    //=============
    const int width           = 300;  //the size of the example disparity field
    const int height          = 200;
    const int range           = 120;  //the maximal value in the example disparity field
    const int disparityOffset = 0;    //modify the range

    ::cimg_library::CImg<stv::data_t> disparity( width, height, 1, 1, 0); 
    ::cimg_library::CImg<bool> valid( width, height, 1, 1, 0);

    for (int x = 0; x < width; x++ )
    {
        for (int y = 0; y < height; y++)
        {
            //assign disparity in [-neg_offset, range-neg_offset]
            disparity( x, y, 0, 0) =  static_cast<stv::data_t>( range * y / static_cast<stv::data_t>(height-1)  - disparityOffset);
            //set left and right border invalid
            valid( x, y, 0, 0) = 
                (   ( x > static_cast<int>( 0.1*static_cast<stv::data_t>(width) ) )
                 && ( x < static_cast<int>( 0.9*static_cast<stv::data_t>(width) ) ) );
            
        }
    }
    //constant gray-image
    ::cimg_library::CImg<unsigned char> image( width, height, 1, 3, 128);

    //=============
    //The visualization part
    //=============
    ::stv::CStereoVisualization visu;

    ::cimg_library::CImg<unsigned char> rgbImage1( width, height, 1, 3, 0);
    visu.calcDisparityEncoding( rgbImage1, disparity, valid );

    //overlay of image and visualization to detect edges
    ::cimg_library::CImg<unsigned char> overlay = ( (image * 0.5f) + (rgbImage1 * 0.5f) ).cut(0,255);
    ::cimg_library::CImgDisplay window0( overlay , "Overlay");
    ::cimg_library::CImgDisplay window1( rgbImage1, "Disparity Encoding");

    ::cimg_library::CImg<unsigned char> rgbImage2( width, height, 1, 3, 0);
    visu.calcCyclicEncoding(  rgbImage2, disparity, valid );
    ::cimg_library::CImgDisplay window2( rgbImage2, "Cyclic Length Encoding");

    stv::data_t minValue = ::stv::getValidMin( disparity, valid);
    stv::data_t maxValue = ::stv::getValidMax( disparity, valid);

    ::cimg_library::CImg<unsigned char> rgbImage3( width, height, 1, 3, 0);
    visu.calcDiffDisparityEncoding( rgbImage3, disparity, valid, minValue, maxValue );
    ::std::cout << "Stretching disparity between " << minValue << " and " << maxValue << ::std::endl;
    ::cimg_library::CImgDisplay window3( rgbImage3, "Stretched Disparity Encoding");

    //=============
    //Done.
    //=============

    ::std::cout << "Press return to end program" << ::std::endl;
    ::std::cin.ignore(1);

    return 0;
}

