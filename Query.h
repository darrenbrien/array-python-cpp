/*
Passing variables / arrays between cython and cpp
Example from 
http://docs.cython.org/src/userguide/wrapping_CPlusPlus.html

Adapted to include passing of multidimensional arrays

*/

#include <vector>
#include <string>
#include <stdint.h>
#include "Column.cpp"
#include <sstream>

#define SSTR( x ) static_cast< std::ostringstream & >( ( std::ostringstream() << std::dec << x ) ).str()
class Query {
    public:
	std::vector<ColumnBase* > get_cols(std::string query);
};
