/*
Passing variables / arrays between cython and cpp
Example from 
http://docs.cython.org/src/userguide/wrapping_CPlusPlus.html

Adapted to include passing of multidimensional arrays

*/

#include "Rectangle.h"

using namespace shapes;

Rectangle::Rectangle(int X0, int Y0, int X1, int Y1)
{
    x0 = X0;
    y0 = Y0;
    x1 = X1;
    y1 = Y1;
}

Rectangle::~Rectangle()
{
}

int Rectangle::getLength()
{
    return (x1 - x0);
}

int Rectangle::getHeight()
{
    return (y1 - y0);
}

int Rectangle::getArea()
{
    return (x1 - x0) * (y1 - y0);
}

void Rectangle::move(int dx, int dy)
{
    x0 += dx;
    y0 += dy;
    x1 += dx;
    y1 += dy;
}

/*
Inputting a 1D vectoror list and returning its sum
*/

double Rectangle::sum_vec(std::vector<double> sv)
{

double tot=0;

int svs = sv.size();
std::cout << "vector length " << svs << std::endl;

for (int ii=0; ii<svs; ii++)
{
        tot = tot + sv.at(ii);
}
        return tot;

}

/*
Inputting a 2D vector or list and returning its sum
*/

double Rectangle::sum_mat(std::vector< std::vector<double> > sv)
{

double tot=0;

int svrows = sv.size();
int svcols = sv[0].size();
std::cout << "vector length " << svrows << " , " << svcols << std::endl;

for (int ii=0; ii<svrows; ii++)
{
        for (int jj=0; jj<svcols; jj++)
        {
                tot = tot + sv.at(ii).at(jj);
        }
}        
return tot;

}

/*
Passing a 2D vector by reference or list and returning its sum
*/

double Rectangle::sum_mat_ref(const std::vector< std::vector<double> > & sv)
{

double tot=0;

int svrows = sv.size();
int svcols = sv[0].size();
std::cout << "vector length " << svrows << " , " << svcols << std::endl;

for (int ii=0; ii<svrows; ii++)
{
        for (int jj=0; jj<svcols; jj++)
        {
                tot = tot + sv.at(ii).at(jj);
        }
}        
return tot;

}

std::map< int, std::vector<double> > Rectangle::ret_map(std::vector< std::vector<double> > sv)
{

std::map<int, std::vector<double> > map;
int svrows = sv.size();
int svcols = sv[0].size();

std::cout << "vector length " << svrows << " , " << svcols << std::endl;

for (int ii=0; ii<svrows; ii++)
{
	std::vector<double> vec;
	for(int j = 0; j < svcols; j++){
		vec.push_back(ii +  j *.3);
	}
	map[ii] = vec;
}        
return map;

}

/*
Inputting a 2D vector, performing a simple operation and returning a new 2D vector
*/
std::vector< std::vector<double> > Rectangle::ret_mat(std::vector< std::vector<double> > sv)
{

int svrows = sv.size();
int svcols = sv[0].size();

std::vector< std::vector<double> > tot;
tot.resize(svrows, std::vector<double> (svcols, -1));


std::cout << "vector length " << svrows << " , " << svcols << std::endl;

for (int ii=0; ii<svrows; ii++)
{
        for (int jj=0; jj<svcols; jj++)
        {
                tot.at(ii).at(jj) = (2*sv.at(ii).at(jj));
        }
}        
return tot;

}


std::map< int, void* > Rectangle::ret_map()
{

int svrows = 2;

std::cout << "vector length " << svrows << " , " << 4 << std::endl;

std::map<int, void* > map;
for (int ii=0; ii<svrows; ii++)
{
	if(ii %2 == 0){
  		std::vector<double> vector; 
		for(int i =0; i < 100; i++){
			vector.push_back(i + .0);
		}
		map[ii] = reinterpret_cast<void*>(&vector[0]);
		std::cout << vector[0] << ' ' << vector[1] << ' ' << vector[2] << ' ' << vector[3] << ' ' << ':' << std::endl;
	}
	else{
  		std::vector<int32_t> vector;
		for(int i =0; i < 100; i++){
			vector.push_back(i);
		}
		void* p = reinterpret_cast<void*>(&vector.front());
		map[ii] = p;
		int32_t *x;
		x = reinterpret_cast<int32_t*>(p); 
		std::cout << vector[0] << ' ' << vector[1] << ' ' << vector[2] << ' ' << vector[3] << ' ' << ':' << std::endl;
		std::cout << x[0] << ' ' << x[1] << ' ' << x[2] << ' ' << x[3] << ' ' << ':' << std::endl;
	}
}        
return map;

}

