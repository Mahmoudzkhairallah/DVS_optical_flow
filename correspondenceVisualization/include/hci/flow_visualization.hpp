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
//!@brief Header for visualization of optical flow
//!@par Synopsis:
//!    This file contains the functions and classes for the visualization of optical flow.
#ifndef FLOW_VISUALIZATION_HPP_INCLUDED
#    define FLOW_VISUALIZATION_HPP_INCLUDED
#ifndef NOMINMAX
#   define NOMINMAX //To be compatible both with windows and linux
#endif



#include "cimg/CImg.h"

//!@namespace ofv
//!@brief All classes and functions to visualize optical flow fields.
//!@par
//!This namespace contains - apart from the CFlowVisualization class - some useful helper functions and constants.
namespace ofv
{
    //!Throughout the visualizations, the given flow field is assumed to be of datatype data_t.
    //!Attention: data_t has to be a floating type!
    typedef float data_t;

    //constants that define the colour mapping
    //!Shift colour map so that downward motion is yellow.
    const data_t COLOR_OFFSET = static_cast<data_t> (7.0 / 16.0);
    //!Number of colours in the map
    const int N_COLORS = 128;

    //!From a given image and validity-matrix determine the mean of all valid entries.
    data_t getValidMean( 
        const ::cimg_library::CImg<data_t>  &f_I_r,
        const ::cimg_library::CImg<bool>    &f_valid_r );

    //=========================================================================
    //! @brief Optical Flow Visualization
    //!
    //! This class provides the colour map and the functions 
    //! for the visualization of optical flow as they are used on the webpage @n
    //! http://hci.iwr.uni-heidelberg.de/Benchmarks/
    //=========================================================================    
    class CFlowVisualization
    {
        public:
            //!Default Constructor. Sets the standard parameter and initializes the look-up table
            CFlowVisualization()
            {
                // Initialize member variables with standard values
                m_saturationThreshold  = 2.0; 
                m_fullSaturationLength = 20;
                m_cycleLength = 10;

                //create look-up table
                assignColorMap();
            };

            //!Default Destructor
            ~CFlowVisualization()
            {
            };

            //!@class ofv::CFlowVisualization
            //!Getter and Setter functions for the visualization parameters are provided.
            //!However, please indicate clearly whenever parameters for the visualizations are changed!

            //!@brief Components longer than this threshold are compressed to avoid oversaturation in the direction encoding.
            void setSaturationThreshold( const double f_saturationThreshold )
            {
                m_saturationThreshold = f_saturationThreshold;
            };
            //!@brief Returns the threshold for compression in the direction encoding.
            //!Whenever this threshold is modified, the value of the threshold should be provided.
            double getSaturationThreshold()
            {
                return m_saturationThreshold;
            };
            //!@brief At FullSaturationLength the motion is fully saturated in the direction encoding.
            void setFullSaturationLength( const int f_fullSaturationLength )
            {
                m_fullSaturationLength = f_fullSaturationLength;
            };
            //!@brief Returns the length at which the colour of the direction encoding is fully saturated.
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

            //!@brief Determine colour and saturation based on motion direction and length.

            //!Fill an RGB colour image that visualizes the input flow and its validity.
            //!This customary visualization where direction is expressed by the colour and length
            //! by the saturation allows to see directional outliers quickly
            //!@param[in, out] f_rgbImage_r reference to a preallocated RGB-image that receives the determined color values
            //!@param[in] f_flowU_r reference to the horizontal flow component
            //!@param[in] f_flowV_r reference to the vertical flow component
            //!@param[in] f_valid_r reference to the image indicating the validity of the determined flow values
            void calcDirectionEncoding( 
                ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
                const ::cimg_library::CImg<data_t>  &f_flowU_r,
                const ::cimg_library::CImg<data_t>  &f_flowV_r,
                const ::cimg_library::CImg<bool>    &f_valid_r ) const;

            //!@brief Determine cyclic colour values based on the length of the motion.

            //!Fill an RGB colour image that visualizes the input flow and its validity.
            //!This visualization is directionally insensitive but highly sensitive to variations in the length of motion vectors.
            //!It allows to see small length variations within presumely constant regions clearly.
            //!@param[in, out] f_rgbImage_r reference to a preallocated RGB-image that receives the determined color values
            //!@param[in] f_flowU_r reference to the horizontal flow component
            //!@param[in] f_flowV_r reference to the vertical flow component
            //!@param[in] f_valid_r reference to the image indicating the validity of the determined flow values.
            void calcCyclicEncoding( 
                ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
                const ::cimg_library::CImg<data_t>  &f_flowU_r,
                const ::cimg_library::CImg<data_t>  &f_flowV_r,
                const ::cimg_library::CImg<bool>    &f_valid_r ) const;

            //!@brief Determine colour and saturation based on a (mean-)adjusted motion field.

            //!The content of motion field is adjusted horizontally and vertically by the provided amount and than a direction and length 
            //! dependend colour encoding that is filled into an RGB image.
            //!This visualization allows to shift the clearly distinguishable, non-saturated range from (0,0)
            //!to any desired range.
            //!A common variant is to adjust the motion field by the mean of each component.
            //!A function to determine the mean value of all valid flow components is provided with ofv::getValidMean
            //!@param[in, out] f_rgbImage_r reference to a preallocated RGB-image that receives the determined color values
            //!@param[in] f_flowU_r reference to the horizontal flow component
            //!@param[in] f_flowV_r reference to the vertical flow component
            //!@param[in] f_valid_r reference to the image indicating the validity of the determined flow values.
            //!@param[in] diffU the amount by which the horizontal component is adjusted.
            //!@param[in] diffV the amount by which the vertical component is adjusted.
            void calcDiffEncoding( 
                ::cimg_library::CImg<unsigned char> &f_rgbImage_r,
                const ::cimg_library::CImg<data_t>  &f_flowU_r,
                const ::cimg_library::CImg<data_t>  &f_flowV_r,
                const ::cimg_library::CImg<bool>    &f_valid_r,
                const data_t diffU,
                const data_t diffV) const;

        private:
            //copy constructor and assignment operator are semantically impractical and must not be used
            CFlowVisualization(const CFlowVisualization& s){};
            CFlowVisualization operator=( CFlowVisualization ){};

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

            //compress values greater than threshold to avoid saturation
            double capSaturation( double f_x ) const;

            //member variables
            double m_saturationThreshold;
            int m_fullSaturationLength;
            int m_cycleLength;

            //the look-up tables for the colour values are initialized only once by assignColorMap in the constructor
            unsigned char m_colorMapR_p[N_COLORS];
            unsigned char m_colorMapG_p[N_COLORS];
            unsigned char m_colorMapB_p[N_COLORS];

    };

} //close namespace ofv

#endif //FLOW_VISUALIZATION_HPP_INCLUDED
