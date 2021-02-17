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

//!@file
//!@brief Implementation for visualization of optical flow
//!@par Synopsis:
//!    This file contains implementation of all functions for the visualization of optical flow

#include <assert.h>

#include <cmath>
#include <algorithm>
#include <limits>

#include "hci/flow_visualization.hpp"


namespace ofv
{
    //!Constant to transform radians from [-pi,pi] into [-1,1]
    const double inversPi = 1.0 / 3.1415926535897932384626433832795;

    //===============
    //estimate mean over valid entries only
    //===============

    data_t getValidMean( 
        const ::cimg_library::CImg<data_t> &f_I_r,
        const ::cimg_library::CImg<bool>   &f_valid_r )
    {
        int counter = 0;
        data_t f_sum = static_cast<data_t>(0.0);

        const int f_w = f_I_r.width();
        const int f_h = f_I_r.height();
        
        for (int x = 0; x < f_w; x++ )
        {
            for (int y = 0; y < f_h; y++)
            {
                if ( true == f_valid_r( x,y,0,0) )
                {
                    counter++;
                    f_sum += f_I_r(x,y,0,0);
                }
            }
        }

        if ( 0 == counter )
        {
            return static_cast<data_t>( 0.0 );
        }
        else
        {
            return ( static_cast<data_t>( static_cast<double>( f_sum) / static_cast<double>( counter ) ) );
        }
    }

    //=========================================================================
    //Visualization helper functions


    //===============
    // compress values greater than threshold to avoid saturation
    //===============
    double CFlowVisualization::capSaturation( double f_x ) const
    {
        if ( f_x > m_saturationThreshold )
        {
            return ( m_saturationThreshold * ( 1.0 + ::std::log( f_x  / m_saturationThreshold ) ) );
        }
        else if ( f_x < - m_saturationThreshold )
        {
            return ( (-1.0) * m_saturationThreshold * ( 1.0 + ::std::log( (-1.0)*f_x / m_saturationThreshold ) ) );
        }
        else
        {
            return f_x;
        }
    }


    //===============
    // look up colour in the colour-map
    //===============
    void CFlowVisualization::getColor(
        unsigned char &f_r_r,
        unsigned char &f_g_r,
        unsigned char &f_b_r,
        double         f_index) const
    {
        // for any value of f_index find a continuous address in [0, N_COLORS - 1[
        
        // get f_index into range [0..1]
        while (f_index < 0.0) f_index += 1.0;
        while (f_index > 1.0) f_index -= 1.0;

        double adr_f = f_index * static_cast<double>( N_COLORS - 2 );

        int adr_i = static_cast<int>( adr_f );

        assert( ((N_COLORS - 2) >= adr_i) || ( 0 <= adr_i)); //overflow or underflow

        // interpolate colour values linearly
        double w = adr_f - static_cast<double>( adr_i );

        // interpolate linearly; round by using +0.5 instead of cutoff during casting
        f_r_r = static_cast<unsigned char>( 0.5 +
                (1.0-w) * static_cast<double>(m_colorMapR_p[ adr_i ])
            +        w  * static_cast<double>(m_colorMapR_p[ adr_i + 1 ]) );

        f_g_r = static_cast<unsigned char>( 0.5 + 
                (1.0-w) * static_cast<data_t>(m_colorMapG_p[ adr_i ]) 
            +        w  * static_cast<data_t>(m_colorMapG_p[ adr_i + 1 ]) );

        f_b_r = static_cast<unsigned char>( 0.5 +
                (1.0-w) * static_cast<double>(m_colorMapB_p[ adr_i ] )
            +        w  * static_cast<double>(m_colorMapB_p[ adr_i + 1 ]) );
    }

    //============================================================================
    //Visualization interfaces


    //===============
    // Create the colour-map
    //===============
    void CFlowVisualization::assignColorMap()
    {
        //shift so that yellow is at the black asphalt for driver-assistance videos
        int offsetColor = static_cast<int>( static_cast<data_t>( N_COLORS ) * COLOR_OFFSET );

        for (int i = 0; i < N_COLORS; i++ )
        {
            int pos = ( i + offsetColor) % N_COLORS;
            
            data_t h = pos/static_cast<data_t>(N_COLORS);
            data_t s = static_cast<data_t>(1.0);
            data_t v = static_cast<data_t>(1.0);

            data_t r, g, b;

            hsv_to_rgb(h, s, v, r, g, b);

            //round values into unsigned char for colour images
            m_colorMapR_p[i] = static_cast<unsigned char>( (255.0 * r ) + 0.5 );
            m_colorMapG_p[i] = static_cast<unsigned char>( (255.0 * g ) + 0.5 );
            m_colorMapB_p[i] = static_cast<unsigned char>( (255.0 * b ) + 0.5 );
        }
    }

    //===============
    // Converts normalized hsv [0:1] triple to normalized rgb [0:1] triple
    //===============
    void  CFlowVisualization::hsv_to_rgb(
        data_t  f_h, data_t  f_s, data_t  f_v,
        data_t& f_r, data_t& f_g, data_t& f_b)
    {
        assert(    0.0 <= f_s && 1.0 >= f_s
               &&  0.0 <= f_v && 1.0 >= f_v );

        // get f_h into range [0..1]
        while (f_h < 0.0) f_h += 1.0;
        while (f_h > 1.0) f_h -= 1.0;

        if( ::std::fabs(f_v) < std::numeric_limits<data_t>::epsilon())
        {
            f_r = f_g = f_b = static_cast<data_t>(0.0);
        }
        else if( ::std::fabs(f_s) < std::numeric_limits<data_t>::epsilon() )
        {
            f_r = f_g = f_b = f_v;
        }
        else
        {
            const data_t hf  = static_cast<data_t>(6.0) * f_h;
            const int    i   = static_cast<int>(::std::floor( hf ));
            const data_t f   = hf - i;
            const data_t vs  = f_v * f_s;

            const data_t pv  = f_v - vs;
            const data_t qv  = f_v - vs * f;
            const data_t tv  = f_v + pv - qv;

            switch( i )
            {
            case 0:
                f_r = f_v;
                f_g = tv;
                f_b = pv;
                break;
            case 1:
                f_r = qv;
                f_g = f_v;
                f_b = pv;
                break;
            case 2:
                f_r = pv;
                f_g = f_v;
                f_b = tv;
                break;
            case 3:
                f_r = pv;
                f_g = qv;
                f_b = f_v;
                break;
            case 4:
                f_r = tv;
                f_g = pv;
                f_b = f_v;
                break;
            case 5:
                f_r = f_v;
                f_g = pv;
                f_b = qv;
                break;
            case 6:
                f_r = f_v;
                f_g = tv;
                f_b = pv;
                break;
            case -1:
                f_r = f_v;
                f_g = pv;
                f_b = qv;
                break;
            default:
                assert(false);
                break;
            }
        }
    }



    //===============
    // Determine colour and saturation based on motion direction and length.
    //===============

    void CFlowVisualization::calcDirectionEncoding( 
        ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
        const ::cimg_library::CImg<data_t>  &f_flowU_r,
        const ::cimg_library::CImg<data_t>  &f_flowV_r,
        const ::cimg_library::CImg<bool>    &f_valid_r ) const
    {
        const double f_maxSaturation = ::ofv::CFlowVisualization::capSaturation( m_fullSaturationLength );
        
        //!Flow smaller than this in both components is displayed as zero
        const double EPS = std::numeric_limits<double>::epsilon();


        const int f_w = f_flowU_r.width();
        const int f_h = f_flowU_r.height();

        for (int y = 0; y < f_h; y++)
        {
            for (int x = 0; x < f_w; x++ )
            {

                //initialize as black
                unsigned char r = 0;
                unsigned char g = 0;
                unsigned char b = 0;
        
                if (   ( true == f_valid_r(x,y,0,0) )
                    && (   ( EPS < ::std::abs( f_flowU_r(x,y,0,0) )  )
                        || ( EPS < ::std::abs( f_flowV_r(x,y,0,0) )  ) 
                       )
                   )
                //valid and non-zeros flow vectors
                {
                    //determine angle of motion vector
                    double radian = inversPi *
                        ::std::atan2( static_cast<double>( f_flowV_r(x,y,0,0) ), static_cast<double>( f_flowU_r(x,y,0,0) ) ); // in [-1,1[
                    //determine colour
                    ::ofv::CFlowVisualization::getColor(r, g, b, 0.5*( radian + 1.0 ) ); // in [0, 1[

                    //determine saturation
                    double saturation = ::ofv::CFlowVisualization::capSaturation( 
                        ::std::sqrt( f_flowU_r(x,y,0,0)*f_flowU_r(x,y,0,0) + f_flowV_r(x,y,0,0)*f_flowV_r(x,y,0,0) ) );
                    //threshold to [0,1]
                    saturation = ::std::min( 1.0, saturation / f_maxSaturation);

                    r = static_cast<unsigned char>( 255.5 - ( saturation * (255.0 - static_cast<double>( r) ) ) );
                    g = static_cast<unsigned char>( 255.5 - ( saturation * (255.0 - static_cast<double>( g) ) ) );
                    b = static_cast<unsigned char>( 255.5 - ( saturation * (255.0 - static_cast<double>( b) ) ) );
                }
                else if ( true == f_valid_r(x,y,0,0) ) // flow which is too small is white
                {
                     r = 255;
                     g = 255;
                     b = 255;
                }
                else //invalid flow stays black
                {
                }

                f_rgbImage_r(x,y,0,0) = r;
                f_rgbImage_r(x,y,0,1) = g;
                f_rgbImage_r(x,y,0,2) = b;
            }
        }
    }

    //===============
    // Cyclic colour encoding
    //===============
    void CFlowVisualization::calcCyclicEncoding( 
        ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
        const ::cimg_library::CImg<data_t>  &f_flowU_r,
        const ::cimg_library::CImg<data_t>  &f_flowV_r,
        const ::cimg_library::CImg<bool>    &f_valid_r ) const
    {
        const int f_w = f_flowU_r.width();
        const int f_h = f_flowU_r.height();
        
        for (int x = 0; x < f_w; x++ )
        {
            for (int y = 0; y < f_h; y++)
            {
                //initialize as black
                unsigned char r = 0;
                unsigned char g = 0;
                unsigned char b = 0;

                if ( true == f_valid_r(x,y,0,0) )
                {
                    //determine colour
                    double length = ::std::sqrt( static_cast<double>( ( f_flowU_r(x,y,0,0)*f_flowU_r(x,y,0,0) ) + ( f_flowV_r(x,y,0,0)*f_flowV_r(x,y,0,0) ) ) );
                    double modulus = ::std::fmod( length, static_cast<double>(m_cycleLength) ); // in [0, CYCLE_LENGTH[

                    ::ofv::CFlowVisualization::getColor( r, g, b, (modulus/ static_cast<double>(m_cycleLength)) );
                }
                else //invalid flow stays black
                {
                }

                f_rgbImage_r(x,y,0,0) = r;
                f_rgbImage_r(x,y,0,1) = g;
                f_rgbImage_r(x,y,0,2) = b;
            }
        }
    }


    //===============
    // Direction encoding of a shifted version of the flow field
    //===============
    void CFlowVisualization::calcDiffEncoding( 
        ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
        const ::cimg_library::CImg<data_t>  &f_flowU_r,
        const ::cimg_library::CImg<data_t>  &f_flowV_r,
        const ::cimg_library::CImg<bool>    &f_valid_r,
        const data_t diffU,
        const data_t diffV) const
    {
        ::cimg_library::CImg<data_t> f_flowUDiff( f_flowU_r - diffU );
        ::cimg_library::CImg<data_t> f_flowVDiff( f_flowV_r - diffV );

        ::ofv::CFlowVisualization::calcDirectionEncoding( f_rgbImage_r, f_flowUDiff, f_flowVDiff, f_valid_r );
    }


} //close namespace ofv

