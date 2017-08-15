/*
Passing variables / arrays between cython and cpp
Example from 
http://docs.cython.org/src/userguide/wrapping_CPlusPlus.html

Adapted to include passing of multidimensional arrays

*/

#include <vector>
#include <map>
#include <string>
#include <iostream>
#include <stdint.h>
#include "Column.cpp"
#include <sstream>
#include <boost/shared_ptr.hpp>

#define SSTR( x ) static_cast< std::ostringstream & >( ( std::ostringstream() << std::dec << x ) ).str()
namespace shapes {
    class Rectangle {
    public:
        int x0, y0, x1, y1;
        Rectangle(int x0, int y0, int x1, int y1);
        ~Rectangle();
        int getLength();
        int getHeight();
        int getArea();
        void move(int dx, int dy);
        double sum_vec(std::vector<double> sv);
        double sum_mat(std::vector< std::vector<double> > sv);
        double sum_mat_ref(const std::vector< std::vector<double> > & sv);
        std::vector< std::vector<double> > ret_mat(std::vector< std::vector<double> > sv);
	std::map< int, std::vector<double> > ret_map(std::map<int, std::vector<double> > & sv);
	std::vector<ColumnBase* > ret_map();
	void tidy(std::vector<ColumnBase* > cols);
    };
}
