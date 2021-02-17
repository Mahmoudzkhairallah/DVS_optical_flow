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
//!@brief Header for visualization of stereo disparities
//!@par Synopsis:
//!    This file contains the functions and classes for the visualization of stereo disparities.

#ifndef STEREO_VISUALIZATION_HPP_INCLUDED
#    define STEREO_VISUALIZATION_HPP_INCLUDED

#ifndef NOMINMAX
#   define NOMINMAX //To be compatible both with windows and linux
#endif



#include "cimg/CImg.h"

//!@namespace stv
//!@brief All classes and functions to visualize stereo disparities.
//!@par
//!This namespace contains - apart from the CStereoVisualization class - some useful helper functions and constants.
namespace stv
{
    //!Throughout the visualizations, the given disparity is assumed to be of datatype data_t.
    //!Attention: data_t has to be a floating type!
    typedef float data_t;

    //constants that define the colour mapping
    //!<shift so that zero disparity is blue
    const data_t COLOR_OFFSET = static_cast<data_t>(2.0 / 6.0);
    //!Number of colours in the map
    const int N_COLORS = 128;

    //!From a given image and validity-matrix determine the min of all valid entries.
    data_t getValidMin( 
        const ::cimg_library::CImg<data_t> &f_I_r, 
        const ::cimg_library::CImg<bool>   &f_valid_r );

    //!From a given image and validity-matrix determine the max of all valid entries.
    data_t getValidMax( 
        const ::cimg_library::CImg<data_t> &f_I_r, 
        const ::cimg_library::CImg<bool>   &f_valid_r);

    //=========================================================================
    //! @brief Stereo Visualization
    //!
    //! This class provides the colour map and the functions 
    //! for the visualization of stereo disparity maps as they are used on the webpage @n
    //! http://hci.iwr.uni-heidelberg.de/Benchmarks/
    //========================================================================= 
    class CStereoVisualization
    {
        public:
            //!Default Constructor. Sets the standard parameter and initializes the look-up table
            CStereoVisualization()
            {
                // Initialize member variables with standard values
                m_gamma = 0.95 ;
                m_fullSaturationLength = 130;
                m_cycleLength = 20;

                //create look-up table
                assignColorMap();
            };

            //!Default Destructor
            ~CStereoVisualization()
            {
            };

            //!@class stv::CStereoVisualization
            //!Getter and Setter functions for the visualization parameters are provided.
            //!However, please indicate clearly whenever parameters for the visualizations are changed!

            //!@brief Input disparities are compressed by exponentiation with gamma<=1.
            void setGamma( const double f_gamma )
            {
                m_gamma = f_gamma;
            };
            //!@brief Returns the compression exponent gamma.
            //!Whenever the exponent is modified, the value of gamma should be provided.
            double getGamma()
            {
                return m_gamma;
            };
            //!@brief For the basic non-scaled colour encoding this value is the maximal, uniquely representable disparity.
            void setFullSaturationLength( const int f_fullSaturationLength )
            {
                m_fullSaturationLength = f_fullSaturationLength;
            };
            //!@brief Returns the maximal, uniquely representable disparity.
            //!Whenever this threshold is modified, the value of the threshold should be provided.
            int getFullSaturationLength()
            {
                return m_fullSaturationLength;
            };
            //!@brief CycleLength is the pixel-displacement that fits into one cycle of colours in the cyclic representation.
            void setCycleLength( const int f_cycleLength )
            {
                m_cycleLength = f_cycleLength;
            };
            //!@brief Returns the number of pixels after which the cyclic colour encoding repeats itself.
            //!Whenever this threshold is modified, the value of the threshold should be provided.
            int getCycleLength()
            {
                return m_cycleLength;
            };

            //!@brief Determine a unique colour based on the input disparity and the member fullSaturationLength

            //!Fill an RGB colour image that visualizes the input disparity and its validity.
            //!For disparity values between 0 and fullSaturationLength this colour code is unique. 
            //!Outside these limits colour repeat themselves.
            //!Using stv::CStereoVisualization::calcDiffDisparityEncoding() upper and lower limits can be set manually.
            //!This standardised visualization allows to compare different algorithms with different ranges of resulting disparities.
            //!@param[in, out] f_rgbImage_r reference to a preallocated RGB-image that receives the determined colour values
            //!@param[in] f_disparity_r reference to the stereo disparity
            //!@param[in] f_valid_r reference to the image indicating the validity of the determined disparity values.
            void calcDisparityEncoding(
                ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
                const ::cimg_library::CImg<data_t>  &f_disparity_r, 
                const ::cimg_library::CImg<bool>    &f_valid_r ) const;

            //!@brief Determine cyclic colour values based on the length of the disparity.

            //!Fill an RGB colour image that visualizes the input disparity and its validity.
            //!Repeating the available colour cyclically.
            //!This visualization allows to see small vairiations within presumely constant regions clearly.
            //!This visualization allows to compare different algorithms with different ranges of resulting disparities.
            //!@param[in, out] f_rgbImage_r reference to a preallocated RGB-image that receives the determined color values
            //!@param[in] f_disparity_r reference to the stereo disparity
            //!@param[in] f_valid_r reference to the image indicating the validity of the determined disparity values.
            void calcCyclicEncoding( 
                ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
                const ::cimg_library::CImg<data_t>  &f_disparity_r,
                const ::cimg_library::CImg<bool>    &f_valid_r) const;

            //!@brief For disparity between the lower and upper limit determine a unique colour value.

            //!Fill an RGB colour image that visualizes the input disparity and its validity.
            //!For disparity values between lower and upper limit this colour code is unique. 
            //!Outside these limits colour repeat themselves.
            //!Stretching the disparity between the limits allows to fully exploit the colour spectrum.
            //!If the limits are chose to be the min and max of the current disparity field, comparability to other algorithms is not given.
            //!For comparable visualizations see stv::CStereoVisualization::calcDisparityEncoding() where standard-limits are provided.
            //!@param[in, out] f_rgbImage_r reference to a preallocated RGB-image that receives the determined colour values
            //!@param[in] f_disparity_r reference to the stereo disparity
            //!@param[in] f_valid_r reference to the image indicating the validity of the determined disparity values.
            //!@param[in] f_minDisparity the smallest uniquely displayed disparity.
            //!@param[in] f_maxDisparity the larges uniquely displayed disparity.
            void calcDiffDisparityEncoding( 
                ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
                const ::cimg_library::CImg<data_t>  &f_disparity_r,
                const ::cimg_library::CImg<bool>    &f_valid_r,
                const data_t f_minDisparity,
                const data_t f_maxDisparity) const;

        private:
            //copy constructor and assignment operator are semantically impractical and must not be used
            CStereoVisualization(const CStereoVisualization& s){};
            CStereoVisualization operator=( CStereoVisualization ){};

            //initialize the colourmap
            void assignColorMap();

            //Look up the colour.
            //For any value of f_index [0, 1] find a continuous address in [0, N_COLORS - 1[.
            //Index values less 0. or greater 1. are automatically wrapped into [0:1].
            void getColor( 
                unsigned char &f_r_r, 
                unsigned char &f_g_r, 
                unsigned char &f_b_r, 
                double f_index) const;

            //Converts normalized hsv [0:1] triple to normalized rgb [0:1] triple.
            //Hue values less 0. or greater 1. are automatically wrapped into [0:1].
            void hsv_to_rgb(
                data_t  f_h, data_t  f_s, data_t  f_v,
                data_t& f_r, data_t& f_g, data_t& f_b);

            //compress values exponentially to avoid saturation
            double nonLinearCompression( double f_x ) const;

            // member variables
            double m_gamma;             //Input disparities are compressed by exponentiation with gamma<=1.
            int m_fullSaturationLength; //The maximal, uniquely representable disparity
            int m_cycleLength;          //the pixel-displacement that fits into one cycle of colours in the cyclic representation

            //the look-up tables for the colour values are initialized only once by assignColorMap in the constructor
            unsigned char m_colorMapR_p[N_COLORS];
            unsigned char m_colorMapG_p[N_COLORS];
            unsigned char m_colorMapB_p[N_COLORS];

    };

} //close namespace stv

#endif //STEREO_VISUALIZATION_HPP_INCLUDED
