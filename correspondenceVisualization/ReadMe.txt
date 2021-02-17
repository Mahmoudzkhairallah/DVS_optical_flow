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

A MATLAB and a C++ version of our visualization-code is provided.
For motivation and ideas implemented in this code see the file 
correspondence-visualization.pdf provided with these files.

For easier application the visualization tool comes with one example
for flow visualization and one example for stereo visualization.

In MATLAB these examples are script that can be executed from the MATLAB prompt.

The C++ examples can be build under 
- Windows using VisualStudio2010 ( the corresponding sln-files are stored in the build folder).
- Linux using make ( the Makefile is stored in the build folder ).
The implementation uses CImg ( see http://cimg.sourceforge.net/ ) for easier handling
of images and their display. The necessary file CImg.h is provided in the include-folder.