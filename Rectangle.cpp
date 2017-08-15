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

std::map< int, std::vector<double> > Rectangle::ret_map(std::map<int, std::vector<double> > & map)
{
int svrows = 2; 
int svcols = 3;

std::cout << "vector length " << svrows << " , " << svcols << std::endl;

for (int ii=0; ii<svrows; ii++)
{
	std::vector<double> vec;
	for(int j = 0; j < svcols; j++){
		vec.push_back(ii +  j *.3);
	}
	std::cout << "first elem:" << vec[0] << std::endl;
	map[ii] = vec;
}        
return map;

}



std::vector<ColumnBase* > Rectangle::ret_map()
{
int svrows = 10000;

std::vector<ColumnBase* > cols;
for (int ii=0; ii<svrows; ii++)
{
	boost::shared_ptr<ColumnBase> up;
	if(ii %2 == 0){
		Column<double> * col = new Column<double>(SSTR(ii), 101);
		for(int i =0; i < 10000; i++){
			col->vec.push_back(i + .0);
		}
		
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else{
		Column<int> * col = new Column<int>(SSTR(ii), 202);
		for(int i =0; i < 10000; i++){
			col->vec.push_back(i);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
}        
return cols;

}

void Rectangle::tidy(std::vector<ColumnBase*> cols){
        for (size_t i =0; i < cols.size(); i++){
                delete cols[i];
        }
}

