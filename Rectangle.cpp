/*
Passing variables / arrays between cython and cpp
Example from 
http://docs.cython.org/src/userguide/wrapping_CPlusPlus.html

Adapted to include passing of multidimensional arrays

*/

#include "Rectangle.h"

std::vector<ColumnBase* > Rectangle::get_cols()
{
int svrows = 10000;
std::vector<ColumnBase* > cols;
for (int ii=0; ii<svrows; ii++)
{
	if(ii %2 != 0){
		Column<double> * col = new Column<double>(SSTR(ii), 101);
		for(double i =0; i < 10000; i++){
			col->vec.push_back(i);
		}
		
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
	else{
		Column<int32_t> * col = new Column<int32_t>(SSTR(ii), 202);
		for(int i =0; i < 10000; i++){
			col->vec.push_back(i);
		}
		cols.push_back(reinterpret_cast<ColumnBase*>(col));
	}
}        
return cols;
}

