###############################################################################
#
#   This file is part of the HCI-Correspondece Estimation Benchmark.
#
#   More information on this benchmark can be found under:
#       http://hci.iwr.uni-heidelberg.de/Benchmarks/
#
#    Copyright (C) 2011  <Sellent, Lauer>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
###############################################################################

# Makefile for flow and stereo visualization code
CC=g++
CFLAGS=-c -Wall
LDFLAGS=-L/usr/X11R6/lib -lm -lpthread -lX11 
SOURCE_DIR=./source/hci/
EXAMPLE_DIR=./source/hci/
FLOW_EXECUTABLE=flow_visualization
STEREO_EXECUTABLE=stereo_visualization
FLOW_SOURCES=flow_visualization_example.cpp flow_visualization.cpp 
STEREO_SOURCES=stereo_visualization_example.cpp stereo_visualization.cpp 
FLOW_OBJECTS=$(FLOW_SOURCES:.cpp=.o)
STEREO_OBJECTS=$(STEREO_SOURCES:.cpp=.o)
INCLUDE_DIR=./include
TARGET_DIR=./bin/

all: $(FLOW_EXECUTABLE) $(STEREO_EXECUTABLE)

$(FLOW_EXECUTABLE): $(FLOW_OBJECTS)
	$(CC) $(LDFLAGS) $(FLOW_OBJECTS) -o $(TARGET_DIR)$@

$(STEREO_EXECUTABLE): $(STEREO_OBJECTS)
	$(CC) $(LDFLAGS) $(STEREO_OBJECTS) -o $(TARGET_DIR)$@


%.o: $(SOURCE_DIR)%.cpp
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) $< -o $@

%.o: $(EXAMPLE_DIR)%.cpp
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) $< -o $@


clean:
	rm *.o

tidy:
	rm $(TARGET_DIR)$(FLOW_EXECUTABLE) $(TARGET_DIR)$(STEREO_EXECUTABLE) *.o

run_flow:
	./$(TARGET_DIR)$(FLOW_EXECUTABLE)

run_stereo:
	./$(TARGET_DIR)$(STEREO_EXECUTABLE)
